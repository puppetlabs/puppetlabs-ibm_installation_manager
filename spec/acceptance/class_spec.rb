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
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/opt/IBM/InstallationManager/eclipse/tools/imcl') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_executable }
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
        }
      EOS
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/home/webadmin/IBM/InstallationManager/eclipse/tools/imcl') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'webadmin' }
      it { is_expected.to be_executable }
    end

    ['/home/webadmin/', '/home/webadmin/var'].each do |path|
      describe file(path) do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'webadmin' }
      end
    end
  end

  context 'group mode' do
    it do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source     => true,
          installation_mode => 'group',
          manage_user       => true,
          manage_group      => true,
          user              => 'webadmin',
          group             => 'webadmins',
          user_home         => '/home/webadmin',
          source            => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
        }
      EOS
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/home/webadmin/IBM/InstallationManager_Group/eclipse/tools/imcl') do
      it { is_expected.to be_file }
      it { is_expected.to be_grouped_into 'webadmins' }
      it { is_expected.to be_executable }
    end
  end
end
