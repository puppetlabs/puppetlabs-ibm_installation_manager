require 'spec_helper'

describe Puppet::Type.type(:ibm_pkg) do
  let(:properties) do
    {
      :name       => '/opt/IBM/WebSphere/AppServer',
      :ensure     => 'present',
      :package    => 'com.ibm.websphere.NDTRIAL.v85',
      :version    => '8.5.5000.20130514_1044',
      :target     => '/opt/IBM/WebSphere/AppServer',
      :repository => '/vagrant/ibm/was/repository.config',
    }
  end

  let(:name) do
    '/opt/IBM/WebSphere/AppServer'
  end

  let(:type_instance) do
    Puppet::Type.type(:ibm_pkg).new(properties)
  end

  describe :name do
    it 'should have a name parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:name)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => [],
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :imcl_path do
    it 'should have a imcl_path parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:imcl_path)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :imcl_path  => '../../',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :imcl_path  => '/opt/IBM/WebSphere/AppServer/imcl',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :target do
    it 'should have a target parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:target)).to eq(:property)
    end
    describe 'invalid' do

      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '../../',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :package do
    it 'should have a package parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:package)).to eq(:property)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 0,
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :version do
    it 'should have a version parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:version)).to eq(:property)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => 0,
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :repository do
    it 'should have a repository parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:repository)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '../../../',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :options do
    it 'should have a options parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:options)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :options    => true,
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :options    => 'wsadmin',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :response do
    it 'should have a response parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:response)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :response   => '../../../',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :response   => '/opt/www/reponse.xml',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :user do
    it 'should have a user parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:user)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :user       => true,
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :user       => 'wsadmin',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :manage_ownership do
    it 'should have a manage_ownership parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:manage_ownership)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :manage_ownership => 'empty',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      [true, false, 'true', 'false', 'yes', 'no'].each do |v|
        let(:properties) do
          {
            :name       => '/opt/IBM/WebSphere/AppServer',
            :ensure     => 'present',
            :package    => 'com.ibm.websphere.NDTRIAL.v85',
            :manage_ownership => v,
            :version    => '8.5.5000.20130514_1044',
            :target     => '/opt/IBM/WebSphere/AppServer',
            :repository => '/vagrant/ibm/was/repository.config',
          }
        end
        it 'should validate and pass if valid value' do
          expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
        end
      end
    end
  end

  describe :package_owner do
    it 'should have a package_owner parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:package_owner)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :package_owner => true,
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :package_owner => 'wsadmin',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :package_group do
    it 'should have a package_group parameter' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:package_group)).to eq(:param)
    end
    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :package_group => true,
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :package_group => 'wsadmin',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  describe :ensure do
    it 'should have a ensure property' do
      expect(Puppet::Type.type(:ibm_pkg).attrtype(:ensure)).to eq(:property)
    end

    describe 'invalid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'blah',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should raise ArgumentError if not valid value' do
        expect{ type_instance}.to raise_error(Puppet::ResourceError)
      end
    end
    describe 'valid' do
      let(:properties) do
        {
          :name       => '/opt/IBM/WebSphere/AppServer',
          :ensure     => 'present',
          :package    => 'com.ibm.websphere.NDTRIAL.v85',
          :version    => '8.5.5000.20130514_1044',
          :target     => '/opt/IBM/WebSphere/AppServer',
          :repository => '/vagrant/ibm/was/repository.config',
        }
      end
      it 'should validate and pass if valid value' do
        expect(type_instance).to be_instance_of Puppet::Type::Ibm_pkg
      end
    end
  end

  # describe 'method validate' do
  #   it { expect(type_instance.validate('blah')).to eq('blah') }
  # end
  #
  # describe 'method manage_ownership?' do
  #   it { expect(type_instance.manage_ownership?('blah')).to eq('blah') }
  # end
end
