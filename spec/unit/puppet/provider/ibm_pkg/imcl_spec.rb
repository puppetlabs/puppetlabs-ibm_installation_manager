require 'spec_helper'

describe Puppet::Type.type(:ibm_pkg).provider(:imcl) do
  describe '#installed_file' do
    context 'non-root user with user and user_home provided' do
      let(:resource) do
        Puppet::Type::Ibm_pkg.new(
          name: 'foo',
          user: 'webadmin',
          user_home: '/home/webadmin',
        )
      end
      let(:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl).new(resource) }

      it 'returns the non-root path' do
        expect(provider.installed_file).to eq('/home/webadmin/var/ibm/InstallationManager/installed.xml')
      end
    end
    context 'non-root user with only user parameter provided' do
      let(:resource) do
        Puppet::Type::Ibm_pkg.new(
          name: 'foo',
          user: 'webadmin',
        )
      end
      let(:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl).new(resource) }

      it 'will error out if user_home is not passed.' do
        expect { provider.installed_file }.to raise_error(ArgumentError, %r{user_home is not specified})
      end
    end
    context 'root user' do
      let(:resource) { Puppet::Type::Ibm_pkg.new(name: 'foo') }
      let(:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl).new(resource) }

      it 'returns the root path' do
        expect(provider.installed_file).to eq('/var/ibm/InstallationManager/installed.xml')
      end
    end
  end
end
