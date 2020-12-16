# frozen_string_literal: true

require 'spec_helper'
describe 'ibm_installation_manager' do
  context 'defaults' do
    context 'administrator' do
      it { is_expected.to contain_class('ibm_installation_manager') }
      it {
        is_expected.to contain_exec('Install IBM Installation Manager').with(command: %r{/opt/IBM/tmp/InstallationManager/installc -acceptLicense -s -log.*-installationDirectory /opt/IBM/InstallationManager}, # rubocop:disable Layout/LineLength
                                                                             creates: '/opt/IBM/InstallationManager/eclipse/tools/imcl',
                                                                             user: 'root',
                                                                             timeout: '900')
      }
    end

    context 'nonadministrator' do
      let(:params) do
        {
          installation_mode: 'nonadministrator',
          user: 'webadmin',
          user_home: '/home/webadmin',
        }
      end

      it { is_expected.to contain_class('ibm_installation_manager') }
      it {
        is_expected.to contain_exec('Install IBM Installation Manager').with(command: %r{/home/webadmin/IBM/tmp/InstallationManager/userinstc -acceptLicense -accessRights nonAdmin -s -log.*-installationDirectory /home/webadmin/IBM/InstallationManager}, # rubocop:disable Layout/LineLength
                                                                             creates: '/home/webadmin/IBM/InstallationManager/eclipse/tools/imcl',
                                                                             user: 'webadmin',
                                                                             timeout: '900')
      }
    end

    context 'group' do
      let(:params) do
        {
          installation_mode: 'group',
          user: 'webadmin',
          user_home: '/home/webadmin',
        }
      end

      it { is_expected.to contain_class('ibm_installation_manager') }
      it {
        is_expected.to contain_exec('Install IBM Installation Manager').with(command: %r{/home/webadmin/IBM/tmp/InstallationManager/groupinstc -acceptLicense -accessRights group -s -log.*-installationDirectory /home/webadmin/IBM/InstallationManager_Group}, # rubocop:disable Layout/LineLength
                                                                             creates: '/home/webadmin/IBM/InstallationManager_Group/eclipse/tools/imcl',
                                                                             user: 'webadmin',
                                                                             timeout: '900')
      }
    end
  end

  context 'custom parameters' do
    let(:params) do
      {
        target: '/opt/myorg/InstallationManager',
        source_dir: '/opt/myorg/tmp/InstallationManager',
        timeout: '1200',
      }
    end

    it {
      is_expected.to contain_exec('Install IBM Installation Manager').with(command: %r{/opt/myorg/tmp/InstallationManager/installc -acceptLicense -s -log.*-installationDirectory /opt/myorg/InstallationManager}, # rubocop:disable Layout/LineLength
                                                                           creates: '/opt/myorg/InstallationManager/eclipse/tools/imcl',
                                                                           user: 'root',
                                                                           timeout: '1200')
    }
  end

  context 'install_unzip_package = true' do
    let(:params) do
      {
        install_unzip_package: true,
        deploy_source: true,
        source: '/opt/IBM/tmp/InstallationManager/ibm-agent_installer.zip',
      }
    end

    describe 'install_unzip_package set to true' do
      it { is_expected.to contain_package('unzip').with(ensure: 'present') }
    end
  end

  context 'install_unzip_package = false' do
    let(:params) do
      {
        install_unzip_package: false,
        deploy_source: true,
        source: '/opt/IBM/tmp/InstallationManager/ibm-agent_installer.zip',
      }
    end

    describe 'install_unzip_package set to false' do
      it { is_expected.not_to contain_package('unzip') }
    end
  end

  context 'deploy source = true' do
    let(:params) do
      {
        deploy_source: true,
      }
    end

    describe 'with a source' do
      let(:params) { super().merge(source: '/opt/IBM/tmp/InstallationManager/ibm-agent_installer.zip') }

      it { is_expected.to contain_archive('/opt/IBM/tmp/InstallationManager/ibm-agent_installer.zip') }
    end

    describe 'without a source' do
      it { is_expected.to raise_error Puppet::PreformattedError, %r{source parameter to be set} }
    end
  end

  context 'deploy source = false' do
    let(:params) do
      {
        deploy_source: false,
        source: '/opt/IBM/tmp/InstallationManager/ibm-agent_installer.zip',
      }
    end

    describe 'with a source' do
      it { is_expected.not_to contain_archive('/opt/IBM/tmp/InstallationManager/ibm-agent_installer.zip') }
    end
  end

  describe 'expect failure when' do
    context 'invalid mode' do
      let(:params) do
        {
          installation_mode: 'foo',
          user: 'bax',
          user_home: 'qux/bar',
        }
      end

      it { is_expected.to raise_error Puppet::PreformattedError, %r{installation_mode 'foo' not supported} }
    end
    context 'non-administrator mode' do
      let(:params) { { installation_mode: 'nonadministrator' } }

      describe 'user not specified' do
        it { is_expected.to raise_error RuntimeError, %r{requires a user} }
      end

      describe 'user_home not specified' do
        let(:params) do
          super().merge(user: 'webadmin')
        end

        it { is_expected.to raise_error RuntimeError, %r{user_home} }
      end
    end
  end
end
