require 'spec_helper_acceptance'

describe 'ibm_pkg should install package' do
  it do
    pp = <<-EOS
      class { 'ibm_installation_manager':
        deploy_source => true,
        source        => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
        target        => '/opt/IBM/InstallationManager',
      }
      ibm_pkg { 'Websphere85':
        ensure        => 'present',
        package       => 'com.ibm.websphere.NDTRIAL.v85',
        version       => '8.5.5000.20130514_1044',
        repository    => "/tmp/ndtrial/repository.config",
        target        => '/opt/IBM/WebSphere85/AppServer',
        package_owner => 'root',
        package_group => 'root',
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
  end
end
