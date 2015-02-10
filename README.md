# ibm_installation_manager

[![Build Status](https://img.shields.io/travis/joshbeard/puppet-ibm_installation_manager.svg?style=flat-square)](https://travis-ci.org/joshbeard/puppet-ibm_installation_manager)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with ibm_installation_manager](#setup)
    * [What ibm_installation_manager affects](#what-ibm_installation_manager-affects)
    * [Beginning with ibm_installation_manager](#beginning-with-ibm_installation_manager)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - Classes and Parameters](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Dependencies](#dependencies)
8. [Development and Contributing](#development-and-contributing)
9. [Authors](#authors)

## Overview

Manages the installation of
[IBM Installation Manager](http://www-947.ibm.com/support/entry/portal/product/rational/ibm_installation_manager?productContext=-57272472)
(yo dawg?)

## Module Description

This module will install the IBM Installation Manager.  Optionally, it can
deploy the installation from a source such as HTTP or a local file path.

A type and provider is also included that can be used to manage the
installation of IBM software from IBM packages (e.g. WebSphere, IHS).

## Usage

Example usage for installing Installation Manager from a source archive from
an HTTP repository:

```puppet
class { 'ibm_installation_manager':
  deploy_source => true,
  source        => 'http://internal.lan/packages/IM.zip',
}
```

Example usage for installing Installation Manager from an existing path on
the filesystem.  As in, an already extracted archive from IBM:

```puppet
class { 'ibm_installation_manager':
  source_dir => '/path/to/installation/IM'
}
```

Example usage for installing to a custom location:

```puppet
class { 'ibm_installation_manager':
  source => 'http://internal.lan/packages/IM.zip',
  target => '/opt/myorg/IBM',
}
```

Example of using the included `ibm_pkg` type.  This will install a
WebSphere 8.5 package from an extracted source at `/vagrant/ibm/websphere/` to
`/opt/IBM/WebSphere85`

```puppet
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure     => 'present',
  package    => 'com.ibm.websphere.NDTRIAL.v85',
  version    => '8.5.5000.20130514_1044',
  target     => '/opt/IBM/WebSphere85',
  repository => '/vagrant/ibm/websphere/repository.config',
}
```

Example of using the included `ibm_pkg` type with a custom response file.

```puppet
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure   => 'present',
  response => '/mnt/resources/was_response_file.xml',
}
```

## Reference

### Class: ibm_installation_manager

#### Parameters

##### deploy_source

Specifies whether this module should be responsible for deploying the source
package for Installation Manager.  Valid values are `true` and `false`.
Defaults to `false`

##### source

Required if `deploy_source` is true.  If `deploy_source` is true, a source
should be specified here.  This can be an absolute path to the source or an
HTTP address.  This expects a compressed archive from IBM (zip).

##### source_dir

Absolute path to the directory to deploy the installer to and/or run out of.
Basically, where is the `installc` binary?
Defaults to `/opt/IBM/tmp`.  If you extracted the archive yourself, you should
point this parameter to that location.

##### target

Absolute path to the _base_ location that IBM Installation Manager will be
installed to.  Defaults to `/opt/IBM/InstallationManager`

##### user

The user to run the installation as.  Defaults to `root`. Note that installing
as a different user will have weird affects.  Consult IBM's documentation for
details.  Basically, it'll be a self-contained installation, and that might
be undesirable.

##### group

The group to run the installation as.  Defaults to `root`. Note that installing
as a different user will have weird affects.  Consult IBM's documentation for
details.  Basically, it'll be a self-contained installation, and that might
be undesirable.

##### options

Options to pass to the installer.  Defaults to `-acceptLicense -s -log
/tmp/IM_install.${timestamp}.log.xml -installationDirectory ${target}`

##### timeout

A timeout for the installation.  Basically, how long should we wait for
Installation Manager to install, in seconds?  It can take a while.  Puppet's
default is 300, which can easily be exceeded by Installation Manager.  The
module's default is 900.  You may need to increase this if you run into issues
where Puppet gives up (exeeded timeout) before the installation has completed.

### Type: ibm_pkg

A custom type called `ibm_pkg` is provided that can be used to install
software with IBM Installation Manager.  By default, this includes an `imcl`
provider, which uses the Installation Manager's `imcl` command-line tool to
handle installation.

The resource does not currently handle upgrading packages in the traditional
sense.  Basically, the provider will make sure that the specified version _or
greater_ is installed.  This is partly due to the nature of how IBM software
is deployed (by a downloaded/extracted archive).

#### Parameters

##### ensure

Valid values are `present` and `absent`.  Defaults to `present`

Specifies the presence of the specified package.

##### name

Defaults to the resource title.  This is only used for identifying the resource
within Puppet, not the actual name of the IBM package.

##### imcl_path

This is optional.  This should be the absolute path to the `imcl` command-line
tool for IBM Installation Manager.  By default, this will attempt to be
discovered by parsin `/var/ibm/InstallationManager/installed.xml` on the
system.  IBM's default location is
`/opt/IBM/InstallationManager/eclipse/tools/imcl`

##### target

The absolute path to the directory that you want to install the specified
package to.  This maps to the `imcl` argument `-installationDirectory`.
If you're using a response file, this is optional.  Otherwise, it is required.

##### package

The IBM package name.  For example: `com.ibm.websphere.IBMJAVA.v71`.
This is the _first_ part of the traditional IBM full package name - _before_
the first underscore. If you're installing with a response file, this
parameter is optional.  Otherwise, it is required.

##### version

The IBM version of the package.  For example: `7.1.2000.20141116_0823`. This
is the _second_ part of the traditional IBM full package name - _after_ the
first underscore. If you're installing with a response file, this parameter
is optional.  Otherwise, it is required.

##### repository

The full path to the `repository.config` file for installing this package.
When downloading and extracting a package from IBM, a `repository.config` file
is provided.  The value of this parameter should point to that.  If you're
installing with a response file, this parameter is optional.  Otherwise, it
is required.

##### options

Any custom options to pass to the `imcl` tool for installing the package. This
is optional.

##### response

The absolute path to a response file to use for installing the package. If
you're using a response file, the `package`, `version`, `target`, and
`repository` parameters are optional.  However, ensure that your response file
includes the needed values for these options.  You can also mix and match.
This simply passes a response file to the `imcl` tool.

##### user

The user to run the `imcl` command as.  Defaults to `root`.  Basically, what
user are we installing this as?  Ensure that this user has the necessary
permissions for reading/writing to all the needed resources.

Note that installing as a different user will have weird affects.  Consult
IBM's documentation for details.  Basically, it'll be a self-contained
installation, and that might be undesirable.  It won't share installation
data with the rest of the system.  You probably want to install as root.

## Limitations

Tested with RHEL 6 x86_64 and IBM Installation Manager 1.8.1 and 1.6.x

Tested on AIX 6.1 and 7.1

## Caveats

The installer will exit 0 even if it failed.  Not a lot we can _reasonably_ do
about that.

    ERROR: java.lang.IllegalStateException: No metadata found for installed
    package com.ibm.cic.agent 1.6.2000.20130301_2248.

This likely means there's a stale `/var/ibm` stuck around.

## Dependencies

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)

If you want the module to extract the Zip file for you:

* [nanliu/staging](https://forge.puppetlabs.com/nanliu/staging)

You only need _nanliu/staging_ if you want the module to extract the source
for you.

## Development and Contributing

If you're masochistic enough to use this software and feel up for it, I'd
greatly appreciate contributions.

You can download trials of IBM's software from their website.

Visit [https://www14.software.ibm.com/webapp/iwm/web/reg/download.do?source=swerpws-wasnd85&S_PKG=500026211&S_TACT=109J87BW&lang=en_US&cp=UTF-8](https://www14.software.ibm.com/webapp/iwm/web/reg/download.do?source=swerpws-wasnd85&S_PKG=500026211&S_TACT=109J87BW&lang=en_US&cp=UTF-8)

You'll need an account there - IBM doesn't make it easy to try their stuff.

Once there, look for the __"IBM Installation Manager"__ section and find the
appropriate package for your platform.  Probably something like
`agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip` for a standard
Linux box.  It says PPC, but it appears to be x86_64.) It also says "gtk",
but you don't actually need X11 or GTK to use the thing (and this module
doesn't).

I'm particuarily interested in help with the custom types/providers. Someone
with more Ruby experience and familiarity with Puppet's type/provider API
would be a huge help.

## Authors

Josh Beard <beard@puppetlabs.com>
