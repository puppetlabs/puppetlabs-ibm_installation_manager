$ibm_base_dir     = '/opt/IBM'

class { 'ibm_installation_manager':
  deploy_source => false,
  source_dir    => '/vagrant/ibm/IM',
  base_dir      => $ibm_base_dir,
}
