class installation_manager::params {
  $timestamp = generate('/bin/date', '+%Y%d%m_%H:%M:%S')
  $tmp_dir   = '/opt/IBM'
  $options   = "–acceptLicense -sP –log /tmp/IM_install.${timestamp}.log.xml"
  $user      = 'root'
  $group     = 'root'
}
