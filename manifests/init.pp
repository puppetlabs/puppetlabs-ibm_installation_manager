# ibm_installation_manager
#
# @summary
#  Init class for installing the IBM Installation Manager.
#
# @param deploy_source
#  Specifies whether this module should be responsible for deploying the source package for Installation Manager. Valid values are `true` and `false`. Defaults to `false`
#
# @param source
#  **Required** if `deploy_source` is true. Specifies the source. This can be either an absolute path to the source or an HTTP address. This expects a compressed archive from IBM (zip).
#
# @param source_dir
#  Specifies the absolute path to the directory to deploy the installer from. (This is the directory containing the `installc` binary.) If you extracted the archive yourself, point this parameter to the extracted archive. Defaults to `/opt/IBM/tmp`.
#
# @param target
#  Specifies the absolute path to the base location where you want to install IBM Installation Manager. Defaults to `/opt/IBM/InstallationManager`.
#
# @param manage_user
#  Whether or not to manage the user that will be installing the IBM IM. Default: `false`.
#
# @param user
#  Specifies the user to run the installation as. Defaults to `root`. Note that installing as a different user might cause undefined behavior. Consult IBM's documentation for details.
#  Note that installing as a user other than `root` might result in undefined behavior. Consult IBM's documentation for details. Installations by a non-root user won't share installation data with the rest of the system.
#
# @param user_home
#  Specifies the home directory for the specified user. Required if you're installing in a mode other than 'administrator'.
#
# @param manage_group
#  When in 'group' mode, whether or not to manage the group that will be installing the IBM IM. Default: `false`.
#
# @param group
#  Specifies the group to run the installation as. Defaults to `root`.
#  Note that installing as a user other than `root` might result in undefined behavior. Consult IBM's documentation for details. Installations by a non-root user won't share installation data with the rest of the system.
#
# @param options
#  Specifies options to pass to the installer.
#  Default: - administrator mode: `-acceptLicense -s -log/tmp/IM_install.${timestamp}.log.xml -installationDirectory ${target}`. - nonadministrator/group mode: `-acceptLicense -accessRights nonAdmin -s -log /tmp/IM_install.${timestamp}.log.xml`
#
# @param timeout
#  Specifies the timeout for the installation, in seconds. Defaults to 900. Installation Manager can take a long time to install, so if you have issues with Puppet timing out before the installation is complete, you might need to increase this parameter.
#
# @param installation_mode
#  Specifies which 'installation mode' you want to use to install the IBM Installation Manager. Values: 'administrator', 'nonadministrator', 'group'. Default: 'administrator'
#
class ibm_installation_manager (
  $deploy_source     = false,
  $source            = undef,
  $source_dir        = undef,
  $target            = undef,
  $manage_user       = false,
  $user              = 'root',
  $user_home         = undef,
  $manage_group      = false,
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
      user { $user:
        ensure     => present,
        managehome => true,
        home       => $user_home,
      }
    }

    if $installation_mode == 'nonadministrator' {
      $installc = 'userinstc'
      $t        = "${user_home}/IBM/InstallationManager"
      $sd       = "${user_home}/IBM/tmp/InstallationManager"
    } elsif $installation_mode == 'group' {
      if $manage_group {
        group { $group:
          ensure => present,
        }
      }
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
      user    => $user,
      group   => $group,
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
