require 'spec_helper'

describe Puppet::Type.type(:ibm_pkg).provider(:imcl) do
  let(:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl) }

  describe '#find_user_home' do
    let(:testuser) do
      Puppet::Type.type(:user).new(name: 'testuser', provider: :useradd)
    end

    it 'and_return the user home' do
      allow(testuser.provider).to receive(:home).and_return('/blah/foo/testuser')
      allow(Puppet::Type.type(:user)).to receive(:instances).and_return([testuser])
      expect(provider.find_user_home('testuser')).to eq '/blah/foo/testuser'
    end

    it 'fails if there are no users' do
      allow(Puppet::Type.type(:user).instances).to receive(:find).and_return(nil)
      expect { provider.find_user_home('testuser') }.to raise_error RuntimeError, %r{Could not find home directory}
    end

    it 'fails if user home is empty' do
      allow(testuser.provider).to receive(:home).and_return('')
      allow(Puppet::Type.type(:user)).to receive(:instances).and_return([testuser])
      expect { provider.find_user_home('testuser') }.to raise_error RuntimeError, %r{Could not find home directory}
    end
  end

  describe '#installed_file' do
    context 'nonadministrator' do
      let(:nonroot_path) { '/home/webadmin/var/ibm/InstallationManager/installed.xml' }

      context 'user happy path' do
        it 'and_return the nonadministrator path' do
          allow(Puppet::Type.type(:ibm_pkg).provider(:imcl)).to receive(:find_user_home).with('webadmin').and_return '/home/webadmin'
          allow(File).to receive(:exist?).with('/home/webadmin/var/ibm/').and_return true
          allow(File).to receive(:exist?).with(nonroot_path).and_return true
          allow(Find).to receive(:find).with('/home/webadmin/var/ibm/').and_yield(nonroot_path)
          allow(File).to receive(:file?).with(nonroot_path).and_return true

          expect(provider.installed_file('webadmin')).to eq nonroot_path
        end
      end

      context 'user does not have installed.xml' do
        it 'raises an error' do
          allow(Puppet::Type.type(:ibm_pkg).provider(:imcl)).to receive(:find_user_home).with('webadmin').and_return '/home/webadmin'
          allow(File).to receive(:exist?).with('/home/webadmin/var/ibm/').and_return false
          allow(File).to receive(:exist?).with(nonroot_path).and_return false
          allow(Find).to receive(:find).with('/home/webadmin/var/ibm/').and_yield(nil)
          allow(File).to receive(:file?).with(nil).and_return false

          expect { provider.installed_file('webadmin') }.to raise_error RuntimeError, %r{Could not find installed.xml}
        end
      end
    end
    context 'administrator' do
      let(:root_path) { '/var/ibm/InstallationManager/installed.xml' }

      it 'and_return the administrator path' do
        allow(File).to receive(:exist?).with('/var/ibm/').and_return true
        allow(File).to receive(:exist?).with('/var/ibm/').and_return true
        allow(Find).to receive(:find).with('/var/ibm/').and_yield(root_path).and_yield('/var/ibm/InstallationManager/installed.xml')
        allow(File).to receive(:file?).with(root_path).and_return true

        expect(provider.installed_file('root')).to eq root_path
      end
    end
  end
end
