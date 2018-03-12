require 'spec_helper'

describe Puppet::Type.type(:ibm_pkg).provider(:imcl) do
  describe '#installed_file' do
    let(:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl) }

    context 'nonadministrator' do
      let(:nonroot_path) { '/home/webadmin/var/ibm/InstallationManager/installed.xml' }

      context 'user happy path' do
        it 'returns the nonadministrator path' do
          File.stubs(:exist?).with('/home/webadmin/var/ibm/').returns true
          File.stubs(:exist?).with(nonroot_path).returns true
          Find.stubs(:find).with('/home/webadmin/var/ibm/').yields(nonroot_path)
          File.stubs(:file?).with(nonroot_path).returns true

          expect(provider.installed_file('webadmin')).to eq nonroot_path
        end
      end

      context 'user does not have installed.xml' do
        it 'raises an error' do
          File.stubs(:exist?).with('/home/webadmin/var/ibm/').returns false
          File.stubs(:exist?).with(nonroot_path).returns false
          Find.stubs(:find).with('/home/webadmin/var/ibm/').yields(nil)
          File.stubs(:file?).with(nil).returns false

          expect { provider.installed_file('webadmin') }.to raise_error RuntimeError, 'No installed.xml found.'
        end
      end
    end
    context 'administrator' do
      let(:root_path) { '/var/ibm/InstallationManager/installed.xml' }

      it 'returns the administrator path' do
        File.stubs(:exist?).with('/var/ibm/').returns true
        File.stubs(:exist?).with('/var/ibm/').returns true
        Find.stubs(:find).with('/var/ibm/').yields(root_path).yields('/var/ibm/InstallationManager/installed.xml')
        File.stubs(:file?).with(root_path).returns true

        expect(provider.installed_file('root')).to eq root_path
      end
    end
  end
end
