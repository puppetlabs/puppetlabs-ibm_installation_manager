# == Class: installation_manager
#
# Manages the installation of IBM Install Manager
#
# === Parameters
#
# [*deploy_source*]
#   Specifies whether this module should deploy the source or not. If set to
#   false, the InstallationManager installer is assumed to be already available
#   at $source_dir
#
# [*source*]
#   Source to the compressed archive from IBM. Required.
#
# [*source_dir*]
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
#   source_dir => '/opt/IBM',
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
class ibm_installation_manager (
  $deploy_source = true,
  $base_dir      = $installation_manager::params::base_dir,
  $source_dir    = $installation_manager::params::source_dir,
  $group         = $installation_manager::params::group,
  $options       = $installation_manager::params::options,
  $source        = undef,
  $user          = $installation_manager::params::user,
) inherits ibm_installation_manager::params {

  validate_bool($deploy_source)
  validate_absolute_path($source_dir)
  validate_string($options)
  validate_string($user)
  validate_string($group)

  file { $source_dir:
    ensure => 'directory',
  }

  if $deploy_source {
    if $source {
      staging::deploy { 'ibm_im.zip':
        source  => $source,
        target  => "${source_dir}",
        creates => "${source_dir}/tools/imcl",
        require => File[$source_dir],
        before  => Exec['Install IBM Installation Manager'],
      }
    }
    else {
      fail("${module_name} requires a source parameter to be set.")
    }
  }

  exec { 'Install IBM Installation Manager':
    command => "${source_dir}/installc ${options}",
    creates => "${base_dir}/InstallationManager/eclipse/tools/imcl",
    user    => $user,
    group   => $group,
  }

}
