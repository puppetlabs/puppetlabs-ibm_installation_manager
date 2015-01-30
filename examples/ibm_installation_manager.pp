# Example of installing Installation Manager to the default location of
# '/opt/IBM/InstallationManager'. In this example, we've downloaded and
# extracted the Installation Manager packages (installer) to '/vagrant/ibm/IM'
class { 'ibm_installation_manager':
  source_dir => '/vagrant/ibm/IM',
}

# Example of providing a zip source and a custom install location
# This will retrieve the zip file from /mnt/IBM and extract it to
# /opt/IBM/tmp/InstallationManager.  Installation Manager will then be
# installed to '/opt/myorg/InstallationManager'
class { 'ibm_installation_manager':
  source     => '/mnt/IBM/im.zip',
  source_dir => '/opt/IBM/tmp/InstallationManager',
  target     => '/opt/myorg/InstallationManager',
}
