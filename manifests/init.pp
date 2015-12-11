#
class ibm_installation_manager (
  $deploy_source         = false,
  $source                = undef,
  $target                = '/opt/IBM/InstallationManager',
  $source_dir            = '/opt/IBM/tmp/InstallationManager',
  $user                  = 'root',
  $group                 = 'root',
  $options               = '',
  $timeout               = 900,
) {

  validate_absolute_path($source_dir, $target)
  validate_string($user, $group, $options)
  validate_integer($timeout)
  validate_bool($deploy_source)

  if $deploy_source == true and $source == undef {
    fail("${module_name} requires a source parameter to be set.")
  }

  $timestamp  = chomp(generate('/bin/date', '+%Y%d%m_%H%M%S'))

  if $options != '' {
    $_options = $options
  } else {
    $_options = "-acceptLicense -s -log /tmp/IM_install.${timestamp}.log.xml -installationDirectory ${target}"
  }

  if $deploy_source == true {
    exec { "mkdir -p ${source_dir}":
      creates => $source_dir,
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }

    package { 'unzip':
      ensure => present,
      before => Archive[$source],
    }

    file { $source_dir:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }

    archive { $source:
      extract      => true,
      extract_path => $source_dir,
      creates      => "${source_dir}/tools/imcl",
      require      => File[$source_dir],
      before       => Exec['Install IBM Installation Manager'],
    }
  }
  # lets ensure we can execute the installc file
  exec{"/bin/chmod -R 2750 ${source_dir}":
    before  => Exec['Install IBM Installation Manager'],
    creates => "${target}/eclipse/tools/imcl"
  }
  exec { 'Install IBM Installation Manager':
    command => "${source_dir}/installc ${_options}",
    creates => "${target}/eclipse/tools/imcl",
    cwd     => $source_dir,
    user    => $user,
    timeout => $timeout,
  }
}
