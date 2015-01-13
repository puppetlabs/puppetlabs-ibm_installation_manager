##
## Sane defaults
##
class ibm_installation_manager::params {
  $timestamp  = chomp(generate('/bin/date', '+%Y%d%m_%H%M%S'))
  $source_dir = '/opt/IBM/tmp'
  $base_dir   = '/opt/IBM'
  $options    = "-acceptLicense -s -log /tmp/IM_install.${timestamp}.log.xml"
  $user       = 'root'
  $group      = 'root'
}
