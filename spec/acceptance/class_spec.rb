require 'spec_helper_acceptance'

describe 'should install ibm software' do
  context 'default/administrator mode' do
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
  ## IIM module is expected to:
  ## - unzip the source into dir owned by the user
  ## - execute imcl command as the user
  ## - install IIM as user into the user's home
  ## - install IIM as user into writable dirs owned by the user

  context 'nonadministrator mode' do
    it do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source     => true,
          installation_mode => 'nonadministrator',
          manage_user       => true,
          user              => 'webadmin',
          user_home         => '/home/webadmin',
          source            => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
          target            => '/home/webadmin/IBM/InstallationManager',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'group mode' do
    it do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source     => true,
          installation_mode => 'group',
          manage_user       => true,
          user              => 'webadmin',
          user_home         => '/home/webadmin',
          source            => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
          target            => '/home/webadmin/IBM/InstallationManager',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
