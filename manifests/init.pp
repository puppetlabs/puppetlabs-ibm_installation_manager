# == Class: installation_manager
#
# Manages the installation of IBM Install Manager
#
# === Parameters
#
# [*source*]
#   Source to the compressed archive from IBM. Required.
#
# [*tmp_dir*]
#   Location to extract the InstallationManager archive
#
# [*options*]
#   Installation options to pass to the installer.
#   Defaults to: -acceptLicense -sP -log /tmp/IM_install.${date}.log.xml
#
# [*user*]
#   User to run the installer as.  Defaults to 'root'
#
# [*group*]
#   Group to run the installer as.  Defaults to 'root'
#
# === Variables
#
#
# === Examples
#
# class { 'installation_manager':
#   source  => '/mnt/IBM/IM.zip',
#   tmp_dir => '/opt/IBM',
# }
#
# === Authors
#
# Author Name <beard@puppetlabs.com>
#
# === Copyright
#
# Copyright 2015 Puppet Labs, Inc, unless otherwise noted.
#
class installation_manager (
  $source,
  $tmp_dir = $installation_manager::params::tmp_dir,
  $options = $installation_manager::params::options,
  $user    = $installation_manager::params::user,
  $group   = $installation_manager::params::group,
) {

  validate_absolute_path($tmp_dir)
  validate_string($options)
  validate_string($user)
  validate_string($group)

  file { "${tmp_dir}/InstallationManager":
    ensure => 'directory',
  }

  staging::deploy { 'ibm_im.zip':
    source  => $source,
    target  => "${tmp_dir}/IBM_IM",
    creates => "${tmp_dir}/IBM_IM/tools/imcl",
    require => File["${tmp_dir}/IBM_IM"],
  }

  exec { 'Install IBM Installation Manager':
    command => "${tmp_dir}/IBM_IM/installc ${options}",
    creates => "${base_dir}/InstallationManager/eclipse/tools/imcl",
    user    => $user,
    group   => $group,
    require => Staging::Deploy['ibm_im.zip'],
  }

}
