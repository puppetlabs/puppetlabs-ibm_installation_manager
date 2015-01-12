# == Class: installation_manager
#
# Manages the installation of IBM Install Manager
#
# === Parameters
#
# [*deploy_source*]
#   Specifies whether this module should deploy the source or not. If set to
#   false, the InstallationManager installer is assumed to be already available
#   at $tmp_dir
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
  $deploy_source = true,
  $group         = $installation_manager::params::group,
  $options       = $installation_manager::params::options,
  $source        = undef,
  $tmp_dir       = $installation_manager::params::tmp_dir,
  $user          = $installation_manager::params::user,
) {

  validate_absolute_path($tmp_dir)
  validate_string($options)
  validate_string($user)
  validate_string($group)

  file { "${tmp_dir}/InstallationManager":
    ensure => 'directory',
  }

  if $deploy_source {
    if $source {
      staging::deploy { 'ibm_im.zip':
        source  => $source,
        target  => "${tmp_dir}/IBM_IM",
        creates => "${tmp_dir}/IBM_IM/tools/imcl",
        require => File["${tmp_dir}/IBM_IM"],
        before  => Exec['Install IBM Installation Manager'],
      }
    }
    else {
      fail("${module_name} requires a source parameter to be set.")
    }
  }

  exec { 'Install IBM Installation Manager':
    command => "${tmp_dir}/IBM_IM/installc ${options}",
    creates => "${base_dir}/InstallationManager/eclipse/tools/imcl",
    user    => $user,
    group   => $group,
  }

}
