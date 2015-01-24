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

Puppet::Type.type(:ibm_impkg).provide(:imcl) do

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
      raise Puppet::Error, "Ibm_impkg[#{resource[:package]}]: #{imcl} not found."
    end

    unless File.exists?(resource[:repository])
      raise Puppet::Error, "Ibm_impkg[#{resource[:package]}]: #{resource[:repository]} not found."
    end

    if resource[:response]
      command = "#{imcl} input #{resource[:response]}"
    else
      command = "#{imcl} #{command}"
    end

    command += " #{resource[:options]}" if resource[:options]

    Puppet.debug("Executing #{command}")
    result = Puppet::Util::Execution.execute(command, :uid => resource[:user], :combine => true)
    Puppet.debug(result)

    if result =~ /ERROR/
      raise Puppet::Error, "Failed: #{result}"
    end

    unless result =~ /Installed/
      raise Puppet::Error, "Failed? #{result}"
    end
  end

  def create
    install = 'install ' + resource[:package] + '_' + resource[:version]
    install += ' -repositories ' + resource[:repository] + ' -installationDirectory '
    install += resource[:target] + ' -acceptLicense'

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
      Puppet.debug("#{resource[:package]}: Current: #{version} Specified: #{resource[:version]}")
      compare = Puppet::Util::Package.versioncmp(resource[:version], version.to_s)
      Puppet.debug("versioncmp: #{compare}")
      if compare <= 0
        Puppet.debug("Version: #{version.to_s} <= #{resource[:version]}")
        true
      end
    end
    if path and package and id and version
      Puppet.debug("Ibm_impkg[#{resource[:package]}]: "\
         + "#{id} version #{resource[:version]} appears to exist at #{path}"
      )
      true
    else
      false
    end
  end

  def destroy
    remove = 'uninstall ' + resource[:package] + '_' + resource[:version]
    remove += ' -s -installationDirectory ' + resource[:target]

    imcl(remove)
  end

end
