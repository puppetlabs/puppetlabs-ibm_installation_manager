#
class ibm_installation_manager (
  $deploy_source     = false,
  $source            = undef,
  $source_dir        = undef,
  $target            = undef,
  $user              = 'root',
  $user_home         = undef,
  $manage_user       = false,
  $group             = 'root',
  $options           = undef,
  $timeout           = '900',
  $installation_mode = 'administrator',
) {

  validate_bool($deploy_source)
  validate_string($options, $user, $group)
  validate_integer($timeout)

  if $deploy_source and ! $source {
    fail("${module_name} requires a source parameter to be set.")
  }

  $timestamp = chomp(generate('/bin/date', '+%Y%d%m_%H%M%S'))

  if $installation_mode == 'administrator' {
    if $user != 'root' {
      warning("You have set installation_mode to administrator, make sure ${user} has admin permissions.")
    }

    $installc = 'installc'
    $t = '/opt/IBM/InstallationManager'
    $sd = '/opt/IBM/tmp/InstallationManager'
    $_options = "-acceptLicense -s -log /tmp/IM_install.${timestamp}.log.xml"

  } else {
    if $installation_mode != 'nonadministrator' and $installation_mode != 'group' {
      fail ("Designated installation_mode '${installation_mode}' not supported.")
    }

    if !$user or !$user_home or $user == 'root' {
      fail("You have set installation_mode to ${installation_mode}. This requires a user and user_home to be set and user should not be 'root'.")
    }

    $_options = "-acceptLicense -accessRights nonAdmin -s -log /tmp/IM_install.${timestamp}.log.xml"

    if $manage_user {
      group { $group:
        ensure => present,
      }
      user { $user:
        ensure     => present,
        gid        => $group,
        managehome => true,
        home       => $user_home,
      }
    }

    if $installation_mode == 'nonadministrator' {
      $installc = 'userinstc'
      $t        = "${user_home}/IBM/InstallationManager"
      $sd       = "${user_home}/IBM/tmp/InstallationManager"

    } elsif $installation_mode == 'group' {
        $installc = 'groupinstc'
        $t        = "${user_home}/IBM/InstallationManager_Group"
        $sd       = "${user_home}/IBM/tmp/InstallationManager"
    }
  }

  if $target {
    $_target = $target
    } else {
      $_target = $t
    }

    if $source_dir {
      $_source_dir = $source_dir
    } else {
      $_source_dir = $sd
    }

  if $deploy_source {
    exec { "mkdir -p ${_source_dir}":
      creates => $_source_dir,
      path    => '/bin:/usr/bin:/sbin:/usr/sbin'
    }

    file { $_source_dir:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }

    package { 'unzip':
      ensure => present,
      before => Archive["${_source_dir}/ibm-agent_installer.zip"],
    }

    archive { "${_source_dir}/ibm-agent_installer.zip":
      extract      => true,
      extract_path => $_source_dir,
      source       => $source,
      creates      => "${_source_dir}/tools/imcl",
      user         => $user,
      group        => $group,
      require      => File[$_source_dir],
      before       => Exec['Install IBM Installation Manager'],
    }
  }

  $config_opt = "-configuration ${_source_dir}/configuration"
  $install_opt = "-installationDirectory ${_target}"

  if $options {
    $final_opt = $options
  } else {
    if $installation_mode != 'administrator' {
      $final_opt = "${_options} ${config_opt} ${install_opt}"
    } else {
      $final_opt = "${_options} ${install_opt}"
    }
  }

  if $user_home {
    file { $_target:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
      mode   => '0755',
    }
  }

  $final_cmd = "${_source_dir}/${installc} ${final_opt}"

  exec { 'Install IBM Installation Manager':
    command => $final_cmd,
    creates => "${_target}/eclipse/tools/imcl",
    cwd     => $_source_dir,
    user    => $user,
    timeout => $timeout,
  }
}
