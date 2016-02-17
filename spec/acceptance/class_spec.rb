require 'spec_helper_acceptance'

describe 'should install ibm software' do
  it do
    pp = <<-EOS
      class { 'ibm_installation_manager':
        deploy_source => true,
        source        => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
        target        => '/opt/IBM/InstallationManager',
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end
end
