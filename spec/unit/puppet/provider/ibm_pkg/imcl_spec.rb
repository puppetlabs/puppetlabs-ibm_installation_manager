require 'spec_helper'

describe Puppet::Type.type(:ibm_pkg).provider(:imcl) do

  describe '#installed_file' do
    context 'non-root user' do
      let (:resource) do
        Puppet::Type::Ibm_pkg.new({
                                    name: 'foo',
                                    user: 'webadmin'
                                  })
      end
      let (:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl).new(resource) }
      it 'returns the non-root path' do
        expect(provider.installed_file).to eq('/home/webadmin/var/ibm/InstallationManager/installed.xml')
      end
    end
    context 'root user' do
      let (:resource) do
        Puppet::Type::Ibm_pkg.new({
                                    name: 'foo'
                                  })
      end
      let (:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl).new(resource) }
      it 'returns the root path' do
        expect(provider.installed_file).to eq('/var/ibm/InstallationManager/installed.xml')
      end
    end
  end
end
