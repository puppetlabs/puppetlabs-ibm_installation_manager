require 'spec_helper'

describe Puppet::Type.type(:ibm_pkg).provider(:imcl) do
  describe '#installed_xml_paths' do
    let (:provider) { Puppet::Type.type(:ibm_pkg).provider(:imcl) }

    context 'nonadministrator' do
      let (:nonroot_path) { '/home/webadmin/var/ibm/InstallationManager/installed.xml' }

      it 'returns the nonadministrator path' do
        Dir.stubs(:glob).with('/home/*/var/ibm/').returns(nonroot_path)
        File.stubs(:exist?).with(nonroot_path).returns true
        File.stubs(:exist?).with('/var/ibm/').returns true
        Find.stubs(:find).with('/var/ibm/', nonroot_path).yields(nonroot_path).yields('/var/')

        arr = provider.installed_xml_paths

        expect(arr.length).to eq 1
        expect(arr).to include(nonroot_path)
      end
    end
    context 'administrator' do
      let (:root_path) { '/var/ibm/InstallationManager/installed.xml' }

      it 'returns the administrator path' do
        Dir.stubs(:glob).with('/home/*/var/ibm/').returns('/home/webadmin/var/ibm/InstallationManager/installed.xml')
        File.stubs(:exist?).with('/home/webadmin/var/ibm/InstallationManager/installed.xml').returns true
        File.stubs(:exist?).with('/var/ibm/').returns true
        Find.stubs(:find).with('/var/ibm/','/home/webadmin/var/ibm/InstallationManager/installed.xml').yields(root_path).yields('/var/ibm/InstallationManager/blah.xml')

        arr = provider.installed_xml_paths

        expect(arr.length).to eq 1
        expect(arr).to include(root_path)
      end
    end
  end
end
