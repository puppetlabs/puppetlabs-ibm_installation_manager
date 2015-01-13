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
8. [Authors](#authors)

## Overview

Manages the installation of
[IBM Installation Manager](http://www-947.ibm.com/support/entry/portal/product/rational/ibm_installation_manager?productContext=-57272472)

## Module Description

This module will install the IBM Installation Manager.  Optionally, it can
deploy the installation from a source such as HTTP or a local file path.

## Setup

### What ibm_installation_manager affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Beginning with ibm_installation_manager

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Example usage for installing Installation Manager from a source archive from
an HTTP repository:

```puppet
class { 'ibm_installation_manager':
  source => 'http://internal.lan/packages/IM.zip',
}
```

Example usage for installing Installation Manager from an existing path on
the filesystem.  As in, an already extracted archive from IBM:

```puppet
class { 'ibm_installation_manager':
  deploy_source => false,
  source_dir    => '/path/to/installation/IM'
}
```

Example usage for installing to a custom location:

```puppet
class { 'ibm_installation_manager':
  source   => 'http://internal.lan/packages/IM.zip',
  base_dir => '/opt/myorg/IBM',
  options  => '-acceptLicense -s -installationDirectory /opt/myorg/IBM',
}
```

## Reference

### Class: ibm_installation_manager

#### Parameters

##### deploy_source

Specifies whether this module should be responsible for deploying the source
package for Installation Manager.  Valid values are `true` and `false`.
Defaults to `true`

##### source

Required if `deploy_source` is true.  If `deploy_source` is true, a source
should be specified here.  This can be an absolute path to the source or an
HTTP address.  This expects a compressed archive from IBM.

##### source_dir

Absolute path to the directory to deploy the installer to and run out of.
Defaults to `/opt/IBM/tmp`

##### base_dir

Absolute path to the _base_ location that IBM Installation Manager will be
installed to.  Defaults to `/opt/IBM`

##### user

The user to run the installation as.  Defaults to `root`

##### group

The group to run the installation as.  Defaults to `root`

##### options

Options to pass to the installer.  Defaults to `-acceptLicense -s -log
/tmp/IM_install.${timestamp}.log.xml`

## Limitations

Tested with RHEL 6 x86_64 and IBM Installation Manager 1.8.1 and 1.6.x

## Development and Contributing

If you're masochistic enough to use this software and feel up for it, I'd
greatly appreciate contributions.

You can download trials of IBM's software from their website.

## Dependencies

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [nanliu/staging](https://forge.puppetlabs.com/nanliu/staging)

## Authors

Josh Beard <beard@puppetlabs.com>
