require 'spec_helper'
describe 'ibm_installation_manager' do

  context 'defaults' do
    context 'administrator' do
      it { should contain_class('ibm_installation_manager') }
      it { should contain_exec('Install IBM Installation Manager').with({
        :command => /\/opt\/IBM\/tmp\/InstallationManager\/installc -acceptLicense -s -log.*-installationDirectory \/opt\/IBM\/InstallationManager/,
        :creates => '/opt/IBM/InstallationManager/eclipse/tools/imcl',
        :user    => 'root',
        :timeout => '900',
    })}
    end

    context 'nonadministrator' do
      let(:params) {
        {
          installation_mode: 'nonadministrator',
          user: 'webadmin',
          user_home: '/home/webadmin'
        }
      }
      it { should contain_class('ibm_installation_manager') }
      it { should contain_file('/home/webadmin').with({
        :owner => 'webadmin',
        :recurse => true
      })}
      it { should contain_exec('Install IBM Installation Manager').with({
        :command => /\/home\/webadmin\/IBM\/tmp\/InstallationManager\/userinstc -acceptLicense -accessRights nonAdmin -s -log.*-installationDirectory \/home\/webadmin\/IBM\/InstallationManager/,
        :creates => '/home/webadmin/IBM/InstallationManager/eclipse/tools/imcl',
        :user    => 'webadmin',
        :timeout => '900',
      })}
    end

    context 'group' do
      let(:params) {
        {
          installation_mode: 'group',
          user: 'webadmin',
          user_home: '/home/webadmin'
        }
      }
      it { should contain_class('ibm_installation_manager') }
      it { should contain_file('/home/webadmin').with({
        :owner => 'webadmin',
        :recurse => true
      })}
      it { should contain_exec('Install IBM Installation Manager').with({
        :command => /\/home\/webadmin\/IBM\/tmp\/InstallationManager\/groupinstc -acceptLicense -accessRights nonAdmin -s -log.*-installationDirectory \/home\/webadmin\/IBM\/InstallationManager_Group/,
        :creates => '/home/webadmin/IBM/InstallationManager_Group/eclipse/tools/imcl',
        :user    => 'webadmin',
        :timeout => '900',
      })}
    end
  end

  context 'custom parameters' do
    let(:params) {
      {
        :target     => '/opt/myorg/InstallationManager',
        :source_dir => '/opt/myorg/tmp/InstallationManager',
        :timeout    => '1200',
      }
    }
    it { should contain_exec('Install IBM Installation Manager').with({
      :command => /\/opt\/myorg\/tmp\/InstallationManager\/installc -acceptLicense -s -log.*-installationDirectory \/opt\/myorg\/InstallationManager/,
      :creates => '/opt/myorg/InstallationManager/eclipse/tools/imcl',
      :user    => 'root',
      :timeout => '1200',
    })}
  end

  describe 'expect failure when' do
    context 'invalid mode' do
      let(:params) {
        {
          installation_mode: 'foo',
          user: 'bax',
          user_home: 'qux/bar'
        }
      }

      it { is_expected.to raise_error RuntimeError, /installation_mode foo not supported/}
    end
    context 'non-administrator mode' do
      let(:params) { { installation_mode: 'nonadministrator' } }

      describe 'user not specified' do
        it { is_expected.to raise_error RuntimeError, /requires a user/ }
      end

      describe 'user_home not specified' do
        let(:params) do
          super().merge({ user: 'webadmin' })
        end
        it { is_expected.to raise_error RuntimeError, /user_home/ }
      end
    end
  end

end
