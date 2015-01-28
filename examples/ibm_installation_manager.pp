# Example of installing Installation Manager to '/opt/IBM'. In this example,
# We've downloaded and extracted the Installation Manager packages (installer)
# to '/vagrant/ibm/IM'
class { 'ibm_installation_manager':
  deploy_source => false,
  source_dir    => '/vagrant/ibm/IM',
  base_dir      => '/opt/IBM',
}
