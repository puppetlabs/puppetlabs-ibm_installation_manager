class installation_manager::params {
  $timestamp  = generate('/bin/date', '+%Y%d%m_%H:%M:%S')
  $source_dir = '/opt/IBM/tmp'
  $base_dir   = '/opt/IBM'
  $options    = "–acceptLicense -sP –log /tmp/IM_install.${timestamp}.log.xml"
  $user       = 'root'
  $group      = 'root'
}
