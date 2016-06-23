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
  desc 'Provides ibm package manager support'

  commands :kill => 'kill'
  commands :chown => 'chown'
  confine  :exists => '/var/ibm/InstallationManager/installed.xml'
  # presumbly this could work on windows but we have some hard coded paths which
  # breaks these things on windows where the paths are different.
  confine  :true => Facter.value(:kernel) != 'windows'

  mk_resource_methods

  # returns the path to the command
  # this is required because it is unlikely that the system would have this in the path
  def imcl_command_path
    unless @imcl_command_path
      if resource[:imcl_path]
        @imcl_command_path = resource[:imcl_path]
      else
        installed = File.open(self.installed_file)
        doc = REXML::Document.new(installed)
        path = XPath.first(doc, '//installInfo/location[@id="IBM Installation Manager"]/@path').value
        installed.close
        @imcl_command_path = File.join(path, 'tools','imcl')
      end
    end
    # ensure the execution bit is set
    fail("#{@imcl_command_path} file does not exist") unless File.exists?(@imcl_command_path)
    fail("#{@imcl_command_path} is not executible, use chmod") unless File.open(@imcl_command_path) {|f| f.stat.executable?}
    @imcl_command_path
  end

  # returns a file handle by opening the install file
  # easier to mock when extracted to method like this
  def installed_file
    '/var/ibm/InstallationManager/installed.xml'
  end

  # returns a file handle by opening the registry file
  # easier to mock when extracted to method like this
  def self.registry_file
    '/var/ibm/InstallationManager/installRegistry.xml'
  end

  def imcl(cmd_options)
    command = "#{imcl_command_path} #{cmd_options}"
    Puppet::Util::Execution.execute(command, :uid => resource[:user], :combine => true, :failonfail => true)
  end

  def getps
    case Facter.value(:operatingsystem)
      when 'OpenWrt'
        'ps www'
      when 'FreeBSD', 'NetBSD', 'OpenBSD', 'Darwin', 'DragonFly'
        'ps auxwww'
      else
        'ps -ef'
    end
  end

  ## The bulk of this is from puppet/lib/puppet/provider/service/base
  ## IBM requires that all services be stopped prior to installing software
  ## to the target. They won't do it for you, and there's not really a clear
  ## way to say "stop everything that matters".  So for now, we're just
  ## going to search the process table for anything that matches our target
  ## directory and kill it.  We've got to come up with something better for
  ## this.
  def stopprocs
    ps = getps
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
        output = kill(pids, :combine => true, :failonfail => false)
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

  # returns target, version and package by reading the response file
  def self.response_file_properties(response_file)
    fail("Cannot open response file #{response_file}") unless File.exists?(response_file)
    resp = {}
    debug("Reading the response file at : #{response_file}")
    begin
      File.open(response_file) do |file|
        doc = REXML::Document.new(file)
        resp[:repository] = XPath.first(doc, '//agent-input/server/repository').attributes['location']
        resp[:target] = XPath.first(doc, '//agent-input/profile').attributes['installLocation']
        resp[:version] = XPath.first(doc, '//agent-input/install/offering').attributes['version']
        resp[:package] = XPath.first(doc, '//agent-input/install/offering').attributes['id']
      end
    rescue  Errno::ENOENT => e
      fail(e.message)
    end
    resp
  end

  def create
    if resource[:response]
      cmd_options = "input #{resource[:response]}"
    else
      cmd_options =  "install #{resource[:package]}_#{resource[:version]}"
      cmd_options << " -repositories #{resource[:repository]} -installationDirectory #{resource[:target]}"
    end
    cmd_options << " -acceptLicense"
    cmd_options << " #{resource[:options]}" if resource[:options]

    stopprocs  # stop related processes before we install
    imcl(cmd_options)
    # change owner

    if resource.manage_ownership? and File.exists?(resource[:target])
      FileUtils.chown_R(resource[:package_owner], resource[:package_group], resource[:target])
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    cmd_options = "uninstall #{resource[:package]}_#{resource[:version]} -s -installationDirectory #{resource[:target]}"
    imcl(cmd_options)
  end

  # returns boolean true if the package and resource are the same
  # if a reponse file is given it returns true if the attributes
  # in the response file are the same
  def self.compare_package(package, resource)
      value = (package.target == resource[:target] && package.version == resource[:version] && package.package == resource[:package])
  end

  ## If the name matches, we consider the package to exist.
  ## The combination of id (package name), version, and path is what makes
  ## it unique.  You can have the same package/version installed to a
  ## different path. By prefetching here our exists? method becomes simple since
  def self.prefetch(resources)
    packages = instances
    if packages
      resources.keys.each do |name|
        if resources[name][:response]
          props = response_file_properties(resources[name][:response])
          # pre populate the things that were missing when the response file was parsed
          resources[name][:target] = props[:target]
          resources[name][:version] = props[:version]
          resources[name][:package] = props[:package]
        end
        if provider = packages.find {|package| compare_package(package, resources[name]) }
          resources[name].provider = provider
        end
      end
    end
  end

  def self.installed_packages
    ## Determine if the specified package has been installed to the specified
    ## location by parsing IBM IM's "installed.xml" file.
    ## I *think* this is a pretty safe bet.  This seems to be a pretty hard-
    ## coded path for it on Linux and AIX.
    registry = File.open(self.registry_file)
    doc = REXML::Document.new(registry)
    packages = []
    doc.elements.each("/installRegistry/profile") do |item|
      product_name = item.attributes["id"]   # IBM Installation Manager
      path         = XPath.first(item, 'property[@name="installLocation"]/@value').value # /opt/Apps/WebSphere/was8.5/product/eclipse
      XPath.each(item, "offering") do |offering|
        id           = offering.attributes['id']  # com.ibm.cic.agent
        XPath.each(offering, "version") do |package|
          version      = package.attributes['value'] # 1.6.2000.20130301_2248
          repository   = package.attributes['repoInfo'].split(',')[0].split('=')[1]
          packages << {
            :product_name => product_name,
            :path         => path,
            :package_id   => id,
            :version      => version,
            :repository   => repository
          }
        end
      end
    end
    registry.close
    packages
  end

  def self.instances
    # get a list of installed packages
    installed_packages.collect do |package|
      hash = {
        :ensure     => :present,
        :package    => package[:package_id],
        :name       => "#{package[:path]}:#{package[:package_id]}:#{package[:version]}",
        :version    => package[:version],
        :target     => package[:path],
        :repository => package[:repository]
      }
      new(hash)
    end
  end
end
