require 'spec_helper'

describe Puppet::Type.type(:ibm_pkg).provider(:imcl) do
  let(:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl) }

  describe '#find_user_home' do
    let(:testuser) do
      Puppet::Type.type(:user).new(name: 'testuser', provider: :useradd)
    end

    it 'returns the user home' do
      testuser.provider.stubs(:home).returns('/blah/foo/testuser')
      Puppet::Type.type(:user).stubs(:instances).returns([testuser])
      expect(provider.find_user_home('testuser')).to eq "/blah/foo/testuser"
    end

    it 'fails if there are no users' do
      Puppet::Type.type(:user).instances.stubs(:find).returns(nil)
      expect{ provider.find_user_home('testuser')}.to raise_error RuntimeError, /Could not find home directory/
    end

    it 'fails if user home is empty' do
      testuser.provider.stubs(:home).returns('')
      Puppet::Type.type(:user).stubs(:instances).returns([testuser])
      expect{ provider.find_user_home('testuser')}.to raise_error RuntimeError, /Could not find home directory/
    end
  end

  describe '#installed_file' do
    context 'nonadministrator' do
      let(:nonroot_path) { '/home/webadmin/var/ibm/InstallationManager/installed.xml' }

      context 'user happy path' do
        it 'returns the nonadministrator path' do
          Puppet::Type.type(:ibm_pkg).provider(:imcl).stubs(:find_user_home).with('webadmin').returns '/home/webadmin'
          File.stubs(:exist?).with('/home/webadmin/var/ibm/').returns true
          File.stubs(:exist?).with(nonroot_path).returns true
          Find.stubs(:find).with('/home/webadmin/var/ibm/').yields(nonroot_path)
          File.stubs(:file?).with(nonroot_path).returns true

          expect(provider.installed_file('webadmin')).to eq nonroot_path
        end
      end

      context 'user does not have installed.xml' do
        it 'raises an error' do
          Puppet::Type.type(:ibm_pkg).provider(:imcl).stubs(:find_user_home).with('webadmin').returns '/home/webadmin'
          File.stubs(:exist?).with('/home/webadmin/var/ibm/').returns false
          File.stubs(:exist?).with(nonroot_path).returns false
          Find.stubs(:find).with('/home/webadmin/var/ibm/').yields(nil)
          File.stubs(:file?).with(nil).returns false

          expect { provider.installed_file('webadmin') }.to raise_error RuntimeError, /Could not find installed.xml/
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
