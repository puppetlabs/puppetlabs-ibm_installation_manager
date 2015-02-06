# Provider for installing and querying packages with IBM Installation
# Manager.  This could almost be a provider for the package resource, but I'm
# not sure how.  We need to be able to support multiple installations of the
# exact same package of the exact same version but in different locations.
#
# This could also use some work.  I'm obviously lacking in Ruby experience and
# familiarity with the Puppet development APIs.
#
# Right now, this is pretty basic - we can check the existence of a package
# and install/uninstall it.  We don't support updating here.  Updating is
# less than trivial.  Updates are done by the user downloading the massive
# IBM package and extracting it in the right way.  For things like WebSphere,
# several services need to be stopped prior to updating.
#
# Version numbers are also weird.  We're using Puppet's 'versioncmp' here,
# which appears to work for IBM's scheme.  Basically, if the specified version
# or a higher version is installed, we consider the resource to be satisfied.
# Specifically, if the specified path has the specified version or greater
# installed, we're satisfied.
#
# IBM Installation Manager keeps an XML file at
# /var/ibm/InstallationManager/installed.xml that includes all the installed
# packages, their locations, "fixpacks", and other useful information. This
# appears to be *much* more useful than the 'imcl' tool, which doesn't return
# terribly useful information (and it's slower).
#
# We attempt to make an educated guess for the location of 'imcl' by parsing
# that XML file.  Otherwise, the user can explicitly provide that via the
# 'imcl_path' parameter.
#
# A user can provide a 'response file' for installation, which will include
# pretty much *all* the information for installing - paths, versions,
# repositories, etc.  Otherwise, they can provide values for the other
# parameters.  Finally, they can provide their own arbitrary options.
#
require 'rexml/document'
include REXML

Puppet::Type.type(:ibm_pkg).provide(:imcl) do

  commands :kill => 'kill'

  def imcl(command)

    registry = '/var/ibm/InstallationManager/installed.xml'

    xml_data = File.open(registry)

    doc = REXML::Document.new(xml_data)

    unless resource[:imcl_path]
      path = XPath.first(doc, '//installInfo/location[@id="IBM Installation Manager"]/@path')

      imcl = path.to_s + '/tools/imcl'

      unless imcl
        raise Puppet::Error, "Could not discover path to imcl"
      end
    else
      imcl = resource[:imcl_path]
    end

    unless File.exists?(imcl)
      raise Puppet::Error, "Ibm_pkg[#{resource[:package]}]: #{imcl} not found."
    end

    unless resource[:response]
      unless File.exists?(resource[:repository])
        raise Puppet::Error, "Ibm_pkg[#{resource[:package]}]: #{resource[:repository]} not found."
      end
    end

    if resource[:response]
      command = "#{imcl} input #{resource[:response]}"
    else
      command = "#{imcl} #{command}"
    end

    command += " #{resource[:options]}" if resource[:options]

    self.debug "Executing #{command}"
    result = Puppet::Util::Execution.execute(command, :uid => resource[:user], :combine => true)
    self.debug result

    if result =~ /ERROR/
      raise Puppet::Error, "Failed: #{result}"
    end

    unless result =~ /(Installed|Updated)/
      raise Puppet::Error, "Failed? #{result}"
    end
  end

  ## The bulk of this is from puppet/lib/puppet/provider/service/base
  ## IBM requires that all services be stopped prior to installing software
  ## to the target. They won't do it for you, and there's not really a clear
  ## way to say "stop everything that matters".  So for now, we're just
  ## going to search the process table for anything that matches our target
  ## directory and kill it.  We've got to come up with something better for
  ## this.  Fucking IBM.
  def stopprocs
    ps = Facter.value :ps
    regex = Regexp.new(resource[:target])
    self.debug "Executing '#{ps}' to find processes that match #{resource[:target]}"
    pid = []
    IO.popen(ps) { |table|
      table.each_line { |line|
        if regex.match(line)
          self.debug "Process matched: #{line}"
          ary = line.sub(/^\s+/, '').split(/\s+/)
          pid << ary[1]
        end
      }
    }

    ## If a PID matches, attempt to kill it.
    unless pid.empty?
      pids = ''
      pid.each do |thepid|
        pids += "#{thepid} "
      end
      begin
        self.debug "Attempting to kill PID #{pids}"
        command = "/bin/kill #{pids}"
        output = Puppet::Util::Execution.execute(command, :combine => true, :failonfail => false)
      rescue Puppet::ExecutionFailure
        err = <<-EOF
        Could not kill #{self.name}, PID #{thepid}.
        In order to install/upgrade to specified target: #{resource[:target]},
        all related processes need to be stopped.
        Output of 'kill #{thepid}': #{output}
        EOF

        @resource.fail Puppet::Error, err, $!
      end
    end

  end

  def create
    unless resource[:response]
      install = 'install ' + resource[:package] + '_' + resource[:version]
      install += ' -repositories ' + resource[:repository] + ' -installationDirectory '
      install += resource[:target] + ' -acceptLicense'
    else
      install = nil
    end

    stopprocs

    imcl(install)
  end

  def exists?
    ## Determine if the specified package has been installed to the specified
    ## location by parsing IBM IM's "installed.xml" file.
    ## I *think* this is a pretty safe bet.  This seems to be a pretty hard-
    ## coded path for it on Linux and AIX.
    registry = '/var/ibm/InstallationManager/installed.xml'

    xml_data = File.open(registry)

    doc = REXML::Document.new(xml_data)

    product = XPath.first(doc, "//installInfo/location[@path='#{resource[:target]}']")
    path    = XPath.first(product, "@path") if product
    package = XPath.first(product, "package[@id='#{resource[:package]}']") if product
    id      = XPath.first(package, "@id") if package
    #version = XPath.first(package, "@version='#{resource[:version]}'") if package
    version = XPath.first(package, "@version") if package

    ## If everything matches, we consider the package to exist.
    ## The combination of id (package name), version, and path is what makes
    ## it unique.  You can have the same package/version installed to a
    ## different path.
    if version
      self.debug "#{resource[:package]}: Current: #{version} Specified: #{resource[:version]}"
      compare = Puppet::Util::Package.versioncmp(version.to_s, resource[:version])
      self.debug "versioncmp: #{compare}"
      if compare >= 0
        self.debug "Version: #{version.to_s} >= #{resource[:version]}; Satisfied"
        return true
      else
        return false
      end
    end

#    if path and package and id and version
#      self.debug "Ibm_pkg[#{resource[:package]}]: "\
#         + "#{id} version #{resource[:version]} appears to exist at #{path}"
#      )
#      true
#    else
#      false
#    end
  end

  def destroy
    remove = 'uninstall ' + resource[:package] + '_' + resource[:version]
    remove += ' -s -installationDirectory ' + resource[:target]

    imcl(remove)
  end

end
