require 'spec_helper'
describe 'ibm_installation_manager' do

  context 'defaults' do
    it { should contain_class('ibm_installation_manager') }
    it { should contain_exec('Install IBM Installation Manager').with({
      :command => /\/opt\/IBM\/tmp\/InstallationManager\/installc -acceptLicense -s -log.*-installationDirectory \/opt\/IBM\/InstallationManager/,
      :creates => '/opt/IBM/InstallationManager/eclipse/tools/imcl',
      :user    => 'root',
      :group   => 'root',
    })}
  end

  context 'custom parameters' do
    let(:params) {
      {
        :target     => '/opt/myorg/InstallationManager',
        :source_dir => '/opt/myorg/tmp/InstallationManager',
      }
    }
    it { should contain_exec('Install IBM Installation Manager').with({
      :command => /\/opt\/myorg\/tmp\/InstallationManager\/installc -acceptLicense -s -log.*-installationDirectory \/opt\/myorg\/InstallationManager/,
      :creates => '/opt/myorg/InstallationManager/eclipse/tools/imcl',
      :user    => 'root',
      :group   => 'root',
    })}
  end

end
