#
# Type for interfacing with IBM's Installation Manager.  See the 'imcl'
# provider for more detailed notes.
#
# Basically, we could almost make a package provider for this instead, but we
# need to be able to support all sorts of scenarios that I'm not sure the
# package resource supports.  We can install the same version multiple times
# on a system, for instance, but to different paths.  The source is also
# tricky.  The source is a massive download from IBM that's extracted in a
# certain way.  It includes a 'repository.config' file that the
# Installation Manager tool parses for details on what software is available
# to be installed.
#
require 'pathname'

Puppet::Type.newtype(:ibm_pkg) do


  validate do
    unless self[:response]
      fail("target is required when a response file is not provided") if self[:target].nil?
      fail("package is required when a response file is not provided") if self[:package].nil?
      fail("version is required when a response file is not provided") if self[:version].nil?
      fail("repository is required when a response file is not provided") if self[:repository].nil?
    end
  end

  ensurable do
    desc "Manage the existence of an IBM package"

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

  end

  newparam(:name) do
    ## We don't really care about this - we can install the same package
    ## multiple times as long as it's in a separate path.  The path can also
    ## have different packages installed *to* it.
    isnamevar
  end

  newparam(:imcl_path) do
    desc "The full path to the IBM Installation Manager location
    This is optional. The provider will attempt to locate imcl by
    parsing /var/ibm/InstallationManager/installed.xml.  If, for
    some reason, it cannot be discovered or if you need to
    provide a specific path, you may do so with this parameter."
    validate do |value|
      if value
        unless Pathname.new(value).absolute?
          raise ArgumentError, "imcl_path must be an absolute path: #{value}"
        end
      end
    end
  end

  newparam(:target) do
    desc "The full path to install the specified package to.
    Corresponds to the 'imcl' option '-installationDirectory'"
    validate do |value|
      unless Pathname.new(value).absolute?
        raise ArgumentError, "target must be an absolute path: #{value}"
      end
    end
  end

  newparam(:package) do
    desc "The IBM package name. Example: com.ibm.websphere.IBMJAVA.v71
    This is the first part of the traditional IBM full package name,
    before the first underscore."

    ## How to best validate this? Are package names consistent?
  end

  newparam(:version) do
    desc "The version of the package. Example: 7.1.2000.20141116_0823
    This is the second part of the traditional IBM full package name,
    after the first underscore."

    ## How to best validate this?  Is the versioning consistent?
  end

  newparam(:repository) do
    desc "The full path to the 'repository.config' file for installing this
    package"
    validate do |value|
      unless Pathname.new(value).absolute?
        raise ArgumentError, "repository must be an absolute path: #{value}"
      end
    end
  end

  newparam(:options) do
    desc "Any custom options to pass to the 'imcl' tool for installing the
    package"
  end

  newparam(:response) do
    desc "Full path to an optional response file to use. The user is
    responsible for ensuring this file is present."
    validate do |value|
      if value
        unless Pathname.new(value).absolute?
          raise ArgumentError, "response must be an absolute path: #{value}"
        end
      end
    end
  end

  newparam(:user) do
    desc "The user to run the 'imcl' command as. Defaults to 'root'"
    defaultto 'root'

    validate do |value|
      unless value =~ /^[0-9A-Za-z_-]+$/
        fail("Invalid user #{value}")
      end
    end

  end

end
