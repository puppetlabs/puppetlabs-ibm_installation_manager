require 'spec_helper_acceptance'

describe 'ibm_installation_manager::ibm_pkg' do
  context 'installs package' do
    it 'should install package' do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source => true,
          source        => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
          target        => '/opt/IBM/InstallationManager',
        }
        ibm_pkg { 'Websphere0':
          ensure        => 'present',
          package       => 'com.ibm.websphere.liberty.NDTRIAL.v85',
          version       => '8.5.5000.20130514_1313',
          repository    => "/tmp/ndtrial/repository.config",
          target        => '/opt/IBM/WebSphere0/AppServer',
          package_owner => 'root',
          package_group => 'root',
          user          => 'root',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/var/ibm/InstallationManager/installed.xml') do
      it { should be_file }
      it { should contain '/opt/IBM/WebSphere0/AppServer' }
    end
  end

  context 'installs package with non-root user' do
    context 'with manage_user and manage_group' do
      it do
        pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source     => true,
          source            => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
          manage_user       => true,
          manage_group      => true,
          user              => 'webadmin',
          group             => 'webadmins',
          user_home         => '/home/webadmin',
          installation_mode => 'nonadministrator',
        }
        ibm_pkg { 'Websphere0':
          ensure        => 'present',
          package       => 'com.ibm.websphere.liberty.NDTRIAL.v85',
          version       => '8.5.5000.20130514_1313',
          repository    => "/tmp/ndtrial/repository.config",
          target        => '/home/webadmin/IBM/WebSphere0/AppServer',
          user          => 'webadmin',
          package_owner => 'webadmin',
          package_group => 'webadmins',
        }
        EOS
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file('/home/webadmin/var/ibm/InstallationManager/installed.xml') do
        it { should be_file }
      end

      describe file('/home/webadmin/IBM/WebSphere0/AppServer') do
        it { should be_directory }
      end
    end

    context 'wihout manage_user with manage_group' do
      it do
        pp = <<-EOS
        user { 'webadmin':
          ensure     => present,
          gid        => 'webadmins',
          managehome => true,
          home       => '/home/webadmin',
        }
        class { 'ibm_installation_manager':
          deploy_source     => true,
          source            => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
          user              => 'webadmin',
          user_home         => '/home/webadmin',
          manage_group      => true,
          group             => 'webadmins',
          installation_mode => 'nonadministrator',
        }
        ibm_pkg { 'Websphere0':
          ensure        => 'present',
          package       => 'com.ibm.websphere.liberty.NDTRIAL.v85',
          version       => '8.5.5000.20130514_1313',
          repository    => "/tmp/ndtrial/repository.config",
          target        => '/home/webadmin/IBM/WebSphere0/AppServer',
          user          => 'webadmin',
          package_owner => 'webadmin',
          package_group => 'webadmins',
        }
        EOS
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file('/home/webadmin/var/ibm/InstallationManager/installed.xml') do
        it { should be_file }
      end

      describe file('/home/webadmin/IBM/WebSphere0/AppServer') do
        it { should be_directory }
      end
    end
  end

  context 'installs package with manage user' do
    it 'should install package with user' do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source => true,
          source        => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
          target        => '/opt/IBM/InstallationManager',
        }
        group { 'webadmins':
          ensure => 'present',
        }
        user { 'webadmin':
          ensure => 'present',
          gid    => 'webadmins',
        }
        ibm_pkg { 'Websphere1':
          ensure        => 'present',
          package       => 'com.ibm.websphere.liberty.NDTRIAL.v85',
          version       => '8.5.5000.20130514_1313',
          repository    => "/tmp/ndtrial/repository.config",
          target        => '/opt/IBM/WebSphere1/AppServer',
          package_owner => 'webadmin',
          package_group => 'webadmins',
          require       => User['webadmin'],
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/var/ibm/InstallationManager/installed.xml') do
      it { should be_file }
      it { should contain '/opt/IBM/WebSphere1/AppServer' }
    end

    describe file('/opt/IBM/WebSphere1/AppServer') do
      it { should be_directory }
      it { should be_owned_by 'webadmin' }
      it { should be_grouped_into 'webadmins' }
    end
  end

  context 'installs package without manage user' do
    it 'should install package with user' do
      pp = <<-EOS
        class { 'ibm_installation_manager':
          deploy_source => true,
          source        => '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip',
          target        => '/opt/IBM/InstallationManager',
        }
        group { 'webadmins':
          ensure => 'present',
        }
        user { 'webadmin':
          ensure => 'present',
          gid    => 'webadmins',
        }
        ibm_pkg { 'Websphere2':
          ensure           => 'present',
          package          => 'com.ibm.websphere.liberty.NDTRIAL.v85',
          version          => '8.5.5000.20130514_1313',
          repository       => "/tmp/ndtrial/repository.config",
          target           => '/opt/IBM/WebSphere2/AppServer',
          manage_ownership => 'false',
          package_owner    => 'webadmin',
          package_group    => 'webadmins',
          require          => User['webadmin'],
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/var/ibm/InstallationManager/installed.xml') do
      it { should be_file }
      it { should contain '/opt/IBM/WebSphere2/AppServer' }
    end

    describe file('/opt/IBM/WebSphere2/AppServer') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end
end
