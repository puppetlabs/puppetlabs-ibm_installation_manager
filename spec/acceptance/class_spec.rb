# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'ibm_installation_manager' do
  context 'default/administrator mode' do
    it do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source => true,
          source        => '/tmp/agent.installer.linux.gtk.x86_64_1.9.1004.20201109_1718.zip',
          target        => '/opt/IBM/InstallationManager',
        }
      EOS
      apply_manifest(pp, catch_failures: true)

      expect(file('/opt/IBM/InstallationManager/eclipse/tools/imcl')).to be_file
      expect(file('/opt/IBM/InstallationManager/eclipse/tools/imcl')).to be_owned_by 'root'
      expect(file('/opt/IBM/InstallationManager/eclipse/tools/imcl')).to be_executable
    end
  end

  context 'nonadministrator mode' do
    it do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source     => true,
          installation_mode => 'nonadministrator',
          manage_user       => true,
          user              => 'webadmin',
          user_home         => '/home/webadmin',
          source            => '/tmp/agent.installer.linux.gtk.x86_64_1.9.1004.20201109_1718.zip',
        }
      EOS
      apply_manifest(pp, catch_failures: true)

      expect(file('/home/webadmin/IBM/InstallationManager/eclipse/tools/imcl')).to be_file
      expect(file('/home/webadmin/IBM/InstallationManager/eclipse/tools/imcl')).to be_owned_by 'webadmin'
      expect(file('/home/webadmin/IBM/InstallationManager/eclipse/tools/imcl')).to be_executable

      ['/home/webadmin/', '/home/webadmin/var'].each do |path|
        expect(file(path)).to be_directory
        expect(file(path)).to be_owned_by 'webadmin'
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
          source            => '/tmp/agent.installer.linux.gtk.x86_64_1.9.1004.20201109_1718.zip',
        }
      EOS
      apply_manifest(pp, catch_failures: true)

      expect(file('/home/webadmin/IBM/InstallationManager_Group/eclipse/tools/imcl')).to be_file
      expect(file('/home/webadmin/IBM/InstallationManager_Group/eclipse/tools/imcl')).to be_grouped_into 'webadmins'
      expect(file('/home/webadmin/IBM/InstallationManager_Group/eclipse/tools/imcl')).to be_executable
    end
  end
end
