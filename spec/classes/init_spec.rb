require 'spec_helper'
describe 'ibm_installation_manager' do

  context 'without passing parameters' do
    it 'should fail' do
      expect { subject }.to raise_error(
        Puppet::Error, /ibm_installation_manager requires a source parameter to be set/
      )
    end
  end

  context 'without deploying source' do
    let(:params) {
      {
      :deploy_source => false,
      }
    }
    it { should contain_class('ibm_installation_manager') }
    it { should contain_exec('Install IBM Installation Manager').with({
      :command => /\/opt\/IBM\/tmp\/installc -acceptLicense -s -log/,
      :creates => '/opt/IBM/InstallationManager/eclipse/tools/imcl',
      :user    => 'root',
      :group   => 'root',
    })}
  end
end
