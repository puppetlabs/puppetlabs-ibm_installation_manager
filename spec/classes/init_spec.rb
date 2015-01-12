require 'spec_helper'
describe 'ibm_installation_manager' do

  context 'with defaults for all parameters' do
    it { should contain_class('ibm_installation_manager') }
  end
end
