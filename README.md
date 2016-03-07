# ibm_installation_manager

[![Build Status](https://img.shields.io/travis/puppetlabs/puppetlabs-ibm_installation_manager.svg?style=flat-square)](https://travis-ci.org/puppetlabs/puppetlabs-ibm_installation_manager)

#### Table of Contents


1. [Module Description](#module-description)
2. [Setup - The basics of getting started with ibm_installation_manager](#setup)
    * [Beginning with ibm_installation_manager](#beginning-with-ibm_installation_manager)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Installing Installation Manager](#installing-installation-manager)
    * [Installing software packages](#installing-software-packages)
4. [Reference - Classes and Parameters](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Dependencies](#dependencies)
7. [Development and Contributing](#development-and-contributing)
8. [Authors](#authors)

## Module Description

This module installs the [IBM Installation Manager](http://www-947.ibm.com/support/entry/portal/product/rational/ibm_installation_manager?productContext=-57272472). Optionally, it can deploy the installation from a source such as HTTP or a local file path.

This module can also manage the installation of software from IBM packages (for example, WebSphere, IHS).

## Usage

### Installing Installation Manager

To install Installation Manager from an HTTP repository source archive:

```puppet
class { 'ibm_installation_manager':
  deploy_source => true,
  source        => 'http://internal.lan/packages/IM.zip',
}
```

If you've already extracted the archive, install Installation Manager from the existing path:

```puppet
class { 'ibm_installation_manager':
  source_dir => '/path/to/installation/IM'
}
```

To install Installation Manager to a custom location, specify the target location:

```puppet
class { 'ibm_installation_manager':
  source => 'http://internal.lan/packages/IM.zip',
  target => '/opt/myorg/IBM',
}
```

### Installing software packages

To install software with IBM Installation Manager, use the `ibm_pkg` type. This type includes the `imcl` provider, which uses the Installation Manager's `imcl` command-line tool to handle installation.

This provider installs the specified version _or greater_ is installed. This is partly due to the nature of how IBM software
is deployed (by a downloaded/extracted archive).

To install a package from an extracted source:

```puppet
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure     => 'present',
  package    => 'com.ibm.websphere.NDTRIAL.v85',
  version    => '8.5.5000.20130514_1044',
  target     => '/opt/IBM/WebSphere85',
  repository => '/vagrant/ibm/websphere/repository.config',
}
```

The above code installs a WebSphere 8.5 package from an extracted source at `/vagrant/ibm/websphere/` to `/opt/IBM/WebSphere85`

You can also provide the package source and other parameters in a custom response file:

```puppet
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure   => 'present',
  response => '/mnt/resources/was_response_file.xml',
}
```

## Reference

### Class

* [`ibm_installation_manager`](#class-ibm_installation_manager)

### Type

* [`ibm_pkg`](#ibm_pkg)

### Class: ibm_installation_manager

#### Parameters

##### deploy_source

Specifies whether this module should be responsible for deploying the source
package for Installation Manager. Valid values are `true` and `false`.
Defaults to `false`

##### source

**Required** if `deploy_source` is true. Specifies the source. This can be either an absolute path to the source or an HTTP address. This expects a compressed archive from IBM (zip).

##### source_dir

Specifies the absolute path to the directory to deploy the installer from. (This is the directory containing the `installc` binary.) If you extracted the archive yourself, point this parameter to the extracted archive. Defaults to `/opt/IBM/tmp`. 

##### target

Specifies the absolute path to the base location where you want to install IBM Installation Manager. Defaults to `/opt/IBM/InstallationManager`.

##### user

Specifies the user to run the installation as. Defaults to `root`. Note that installing
as a different user might cause undefined behavior. Consult IBM's documentation for
details. 

Note that installing as a user other than `root` might result in undefined behavior. Consult IBM's documentation for details. Installations by a non-root user won't share installation data with the rest of the system.

##### group

Specifies the group to run the installation as. Defaults to `root`. 

Note that installing as a user other than `root` might result in undefined behavior. Consult IBM's documentation for details. Installations by a non-root user won't share installation data with the rest of the system.

##### options

Specifies options to pass to the installer. Defaults to `-acceptLicense -s -log/tmp/IM_install.${timestamp}.log.xml -installationDirectory ${target}`.

##### timeout

Specifies the timeout for the installation, in seconds. Defaults to 900. Installation Manager can take a long time to install, so if you have issues with Puppet timing out before the installation is complete, you might need to increase this parameter.

### Type: ibm_pkg

This type installs software with IBM Installation Manager. The `ibm_pkg` type includes an `imcl` provider, which uses the Installation Manager's `imcl` command-line tool to
handle installation.

This resource does not upgrade packages, but installs the specified version _or
greater_.

#### Parameters

##### ensure

Valid values are `present` and `absent`. Defaults to `present`.

Specifies the presence of the specified package.

##### name

Defaults to the resource title. This parameter is used only for identifying the resource
within Puppet; it is not the actual name of the IBM package.

##### imcl_path

**Optional.** Specifies the absolute path to the `imcl` command-line tool for IBM Installation Manager. By default, this tries to discover the correct location by parsing `/var/ibm/InstallationManager/installed.xml` on the system. IBM's default location is `/opt/IBM/InstallationManager/eclipse/tools/imcl`.

##### target

**Required**, or optional with a response file. Specifies the absolute path to the directory in which to install the specified package. This maps to the `imcl` argument `-installationDirectory`.

##### package

**Required**, or optional with a response file. Specifies the IBM package name, for example, `com.ibm.websphere.IBMJAVA.v71`.
This is the first part of the traditional IBM full package name, **before** the first underscore.

##### version

**Required**, or optional with a response file. Specifies the IBM version of the package, for example, `7.1.2000.20141116_0823`. This is the second part of the traditional IBM full package name, after the first underscore.

##### repository

**Required**, or optional with a response file. Specifies the full path to the `repository.config` file for installing this package. The `repository.config` file is provided when you download and extract a package from IBM.

##### options

**Optional**. Specifies any custom options to pass to the `imcl` tool for installing the package.

##### response

Specifies the absolute path to a response file for installing the package. If you're using a response file, you can include the `package`, `version`, `target`, and `repository` values either in the response file or as the parameters listed for this type. Valid value is an absolute path. Defaults to undef.

##### user

Specifies the user to run the `imcl` command as. This user must have the necessary permissions for reading/writing to the needed resources. Defaults to `root`. 

Note that installing as a user other than `root` might result in undefined behavior. Consult IBM's documentation for details. Installations by a non-root user won't share installation data with the rest of the system.

## Limitations

Tested with RHEL 6 x86_64 and IBM Installation Manager 1.8.1 and 1.6.x

## Known Issues

The installer exits 0 even if it failed. 

```
ERROR: java.lang.IllegalStateException: No metadata found for installed package com.ibm.cic.agent 1.6.2000.20130301_2248.
```

## Dependencies

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* If you want the module to extract the Zip file for you, [nanliu/staging](https://forge.puppetlabs.com/nanliu/staging).

## Development and Contributing

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. For more information, see our [module contribution guide.](https://docs.puppetlabs.com/forge/contributing.html)

To download trials of IBM Installation Manager, visit IBM's [download page](https://www14.software.ibm.com/webapp/iwm/web/reg/download.do?source=swerpws-wasnd85&S_PKG=500026211&S_TACT=109J87BW&lang=en_US&cp=UTF-8). You must have an account to download trials from IBM.

## Contributors

This module was contributed to by [Josh Beard](https://github.com/joshbeard) and [other contributors](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/graphs/contributors).
