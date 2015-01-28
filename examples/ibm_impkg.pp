# com.ibm.websphere.NDTRIAL.v85_8.5.5000.20130514_1044
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure     => 'present',
  package    => 'com.ibm.websphere.NDTRIAL.v85',
  version    => '8.5.5000.20130514_1044',
  target     => '/opt/IBM/beard/WebSphere85/AppServer',
  repository => '/vagrant/ibm/was/repository.config',
}
