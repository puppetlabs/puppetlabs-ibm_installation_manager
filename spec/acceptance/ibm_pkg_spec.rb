require 'spec_helper_acceptance'

describe 'ibm_installation_manager::ibm_pkg' do
  context 'with valid parameters' do
    it 'installs package' do
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
      apply_manifest(pp, catch_failures: true)

      expect(file('/var/ibm/InstallationManager/installed.xml')).to be_file
      expect(file('/var/ibm/InstallationManager/installed.xml')).to contain '/opt/IBM/WebSphere0/AppServer'
    end
  end

  context 'with non-root user, manage_user and manage_group' do
    context 'installs package' do
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
        apply_manifest(pp, catch_failures: true)

        expect(file('/home/webadmin/var/ibm/InstallationManager/installed.xml')).to be_file
        expect(file('/home/webadmin/IBM/WebSphere0/AppServer')).to be_directory
      end
    end

    context 'without manage_user with manage_group' do
      it 'installs package' do
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
        apply_manifest(pp, catch_failures: true)

        expect(file('/home/webadmin/var/ibm/InstallationManager/installed.xml')).to be_file
        expect(file('/home/webadmin/IBM/WebSphere0/AppServer')).to be_directory
      end
    end
  end

  context 'with manage user' do
    it 'installs package' do
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
      apply_manifest(pp, catch_failures: true)

      expect(file('/var/ibm/InstallationManager/installed.xml')).to be_file
      expect(file('/var/ibm/InstallationManager/installed.xml')).to contain '/opt/IBM/WebSphere1/AppServer'

      expect(file('/opt/IBM/WebSphere1/AppServer')).to be_directory
      expect(file('/opt/IBM/WebSphere1/AppServer')).to be_owned_by 'webadmin'
      expect(file('/opt/IBM/WebSphere1/AppServer')).to be_grouped_into 'webadmins'
    end
  end

  context 'without manage user' do
    it 'installs package' do
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
      apply_manifest(pp, catch_failures: true)

      expect(file('/var/ibm/InstallationManager/installed.xml')).to be_file
      expect(file('/var/ibm/InstallationManager/installed.xml')).to contain '/opt/IBM/WebSphere2/AppServer'

      expect(file('/opt/IBM/WebSphere2/AppServer')).to be_directory
      expect(file('/opt/IBM/WebSphere2/AppServer')).to be_owned_by 'root'
      expect(file('/opt/IBM/WebSphere2/AppServer')).to be_grouped_into 'root'
    end
  end
end
