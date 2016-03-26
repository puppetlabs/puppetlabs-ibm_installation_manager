require 'spec_helper'

provider_class = Puppet::Type.type("ibm_pkg").provider(:imcl)
describe provider_class do
  let(:properties) do
    {

    }
  end
  let(:provider) do
    provider_class.new(:name => 'com.ibm.websphere.NDTRIAL.v85_8.5.5000.20130514_1044_/opt/IBM/WebSphere/AppServerexit')
  end

  let(:resource) do
    Puppet::Type.type("ibm_pkg").new(
      :name       => 'com.ibm.websphere.NDTRIAL.v85_8.5.5000.20130514_1044_/opt/IBM/WebSphere/AppServerexit',
      :package    => 'com.ibm.websphere.NDTRIAL.v85',
      :version    => '8.5.5000.20130514_1044',
      :target     => '/opt/IBM/WebSphere/AppServer',
      :repository => '/vagrant/ibm/was/repository.config',
      :provider   => provider
    )
  end

  before(:each) do
    allow(provider_class).to receive(:registry_file).and_return(File.join(unit_fixtures, 'installed_items.xml'))
    allow(provider).to receive(:registry_file).and_return(File.join(unit_fixtures, 'installed_items.xml'))

  end

  it "should be an instance of Puppet::Type::Ibm_pkg::ProviderImcl" do
    expect(provider).to be_an_instance_of Puppet::Type::Ibm_pkg::ProviderImcl
  end

  describe '#create' do
    before(:each) do
      allow(provider).to receive(:exists?).and_return(false)
    end

    it 'should do something' do
      resource[:ensure] = :present
      command = []
      expect(Puppet::Util::Execution).to receive(:execute).with(command, :uid => 'root', :combine => true, :failonfail => true)
      provider.create
    end
  end


  it 'should return an array of instances' do
    expect(provider_class.instances).to be_instance_of Array
  end

  it 'should be able to prefetch' do
    expect(provider.prefetch())
  end

  describe 'reponse file' do
    it 'can get and parse response file' do
      expect(provider_class.response_file_properties(File.join(unit_fixtures, 'response.xml'))).to eq({:target=>"/opt/IBM/WebSphere/was8.5/IBMHttpServer", :version=>"8.5.5006.20150529_0536", :package=>"com.ibm.websphere.IHS.v85", :repository=>"https://mycompany.com:8001/repo"})
    end
    it 'can compare package agains response file' do
      response_file = File.join(unit_fixtures, 'response.xml')
      r = {:response => response_file}
      expect(provider_class.compare_package(provider, r)).to eq(true)
    end
  end


  describe 'exists?' do
    describe 'true' do
      let(:properties) do
        {
          :name       => 'com.ibm.websphere.BASE.v85_8.5.5006.20150529_0536_/opt/IBM/WebSphere/was8.5/AppServer',
          :ensure     => :present,
          :package    => 'com.ibm.websphere.BASE.v85',
          :version    => '8.5.5006.20150529_0536',
          :target     => '/opt/IBM/WebSphere/was8.5/AppServer',
          :repository => '/vagrant/ibm/was/repository.config'
        }
      end
      it 'should return true if exists' do
        binding.pry
        expect(provider.exists?).to eq(true)
      end
    end

    describe 'false' do
      let(:properties) do
        {
          :name       => 'blah_/opt/IBM/WebSphere/was8.5/IBMHttpServer',
          :ensure     => :absent,
          :package    => 'com.ibm.websphere.IHS.v85',
          :version    => '8.5.5006.20150529_0536',
          :target     => '/opt/IBM/WebSphere/AppServer', #https://mycompany.com:8001/repo
          :repository => '/tmp/respository.config'
        }
      end
      it 'should return false if exists' do
        expect(provider.exists?).to eq(false)
      end
    end
  end
  # command = []
  # expect(Puppet::Util::Execution).to receive(:execute).with(command, :uid => resource[:user], :combine => true, :failonfail => true)

end
