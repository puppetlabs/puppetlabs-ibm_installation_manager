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

To install the Installation Manager as a non-root user, specify that user's name and its home directory, and set the installation_mode to 'nonadministrator'

```puppet
class { 'ibm_installation_manager':
  deploy_source     => true,
  source            => 'http://internal.lan/packages/IM.zip',
  user              => 'iim_user',
  user_home         => '/home/iim_user',
  installation_mode => 'nonadministrator',
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

See REFERENCE.md

## Limitations

This module has only been tested with IBM Installation Manager 1.8.7.

## Known Issues

The installer exits 0 even if it failed. 

```
ERROR: java.lang.IllegalStateException: No metadata found for installed package com.ibm.cic.agent 1.6.2000.20130301_2248.
```

## Dependencies

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* If you want the module to extract the Zip file for you, [puppet/archive](https://forge.puppetlabs.com/puppet/archive).

## Development and Contributing

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a [few guidelines](CONTRIBUTING.md) that we need contributors to follow so that we can have a chance of keeping on top of things. For more information, see our [module contribution guide.](https://docs.puppetlabs.com/forge/contributing.html)

## Contributors

This module was contributed to by [Josh Beard](https://github.com/joshbeard) and [other contributors](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/graphs/contributors).
