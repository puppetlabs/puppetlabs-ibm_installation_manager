# Example of installing WebSphere 8.5 from the IBM package using the included
# 'ibm_pkg' type.
#
# IBM calls this: com.ibm.websphere.NDTRIAL.v85_8.5.5000.20130514_1044
#
# The package name is the first part *before* the underscore.
# The package version is the second part *after* the underscore.
#
# In this example, we want to install to /opt/IBM/WebSphere/AppServer and
# our package from IBM has been downloaded and extracted to
# /vagrant/ibm/was/
#
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure     => 'present',
  package    => 'com.ibm.websphere.NDTRIAL.v85',
  version    => '8.5.5000.20130514_1044',
  target     => '/opt/IBM/WebSphere/AppServer',
  repository => '/vagrant/ibm/was/repository.config',
}

# Example of doing the same thing with a response file.
#
# In this case, our response file includes all the information we need - the
# package name, the version, the repository location, and the target.
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure     => 'present',
  response   => '/opt/myorg/was/response/response_85.xml',
}


# Example of using a response file but also custom options to pass to 'imcl'
ibm_pkg { 'com.ibm.websphere.NDTRIAL.v85':
  ensure   => 'present',
  response => '/opt/myorg/was/response/response_85.xml',
  options  => '-installationDirectory /opt/myorg/WebSphere/AppServer',
}
