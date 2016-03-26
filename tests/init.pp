# ibm_pkg { 'com.ibm.websphere.BASE':
#   ensure     => 'present',
#   package    => 'com.ibm.websphere.BASE.v85',
#   version    => '8.5.5006.20150529_0536',
#   target     => '/opt/IBM/WebSphere/was8.5/AppServer',
#   repository => '/vagrant/ibm/was/repository.config',
# }
# ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
#   ensure   => 'present',
#   response => '/etc/puppet/modules/puppetlabs-ibm_installation_manager/spec/fixtures/unit/response_was85.xml',
# }
$ibm_install_manager_source_url = '/etc/puppet/modules/ibm_installation_manager/files/ibm_iim.zip'
$iim_install_directory = '/opt/IBM/WebSphere/was8.5/product'
$iim_source_dir        = '/opt/IBM/tmp/InstallationManager'
#$iim_source_dir         = '/tmp/'
class { 'ibm_installation_manager':
  deploy_source => true,
  source     => $ibm_install_manager_source_url,
  source_dir => $iim_source_dir,
  target     => $iim_install_directory,
}
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure     => 'present',
  package    => 'com.ibm.websphere.NDTRIAL.v85',
  version    => '8.5.5000.20130514_1044',
  target     => '/opt/IBM/WebSphere/AppServer',
  repository => '/opt/IBM/repository.config',
}