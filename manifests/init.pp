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
#   Defaults to false.
#
# [*source*]
#   Source to the compressed archive from IBM. Required if 'deploy_source' is
#   true.
#
# [*target*]
#   Full path to install to.  Defaults to /opt/IBM/InstallationManager
#
# [*source_dir*]
#   Location to the InstallationManager installation directory - either from
#   the extracted archive or a manually extracted archive.  The 'installc'
#   tool should be inside this directory.
#
# [*options*]
#   Installation options to pass to the installer.
#   Defaults to: -acceptLicense -sP -log /tmp/IM_install.${date}.log.xml \
#     -installationDirectory ${target}
#
# [*user*]
#   User to run the installer as.  Defaults to 'root'
#
# [*group*]
#   Group to run the installer as.  Defaults to 'root'
#
# [*timeout*]
#   A timeout for the exec resource that installs IBM Installation Manager.
#   Installing it can take a while.  The default is '900'.
#   If you encounter issues where the exec has exceeded timeout, you may need
#   to increase this.
#
# === Examples
#
# class { 'installation_manager':
#   source     => '/mnt/IBM/IM.zip',
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
  $deploy_source = false,
  $source        = undef,
  $target        = '/opt/IBM/InstallationManager',
  $source_dir    = '/opt/IBM/tmp/InstallationManager',
  $user          = 'root',
  $group         = 'root',
  $options       = undef,
  $timeout       = '900',
) {

  validate_bool($deploy_source)
  validate_absolute_path($source_dir)
  validate_absolute_path($target)
  validate_string($options)
  validate_string($user)
  validate_string($group)

  $timestamp  = chomp(generate('/bin/date', '+%Y%d%m_%H%M%S'))

  if !$options {
    $_options = "-acceptLicense -s -log /tmp/IM_install.${timestamp}.log.xml -installationDirectory ${target}"
  } else {
    $_options = $options
  }

  if $deploy_source {

    exec { "mkdir -p ${source_dir}":
      creates => $source_dir,
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }

    file { $source_dir:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }
    if $source {
      staging::deploy { 'ibm_im.zip':
        source  => $source,
        target  => $source_dir,
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
    command => "${source_dir}/installc ${_options}",
    creates => "${target}/eclipse/tools/imcl",
    cwd     => $source_dir,
    user    => $user,
    timeout => $timeout,
  }

}
