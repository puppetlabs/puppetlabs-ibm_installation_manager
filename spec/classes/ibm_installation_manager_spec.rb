require 'spec_helper'
require 'shared_contexts'

describe 'ibm_installation_manager' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  
  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:deploy_source => false,
      #:source => ,
      #:target => "/opt/IBM/InstallationManager",
      :source_dir => "/opt/IBM/tmp/InstallationManager",
      #:user => "root",
      #:group => "root",
      #:options => '-installationDirectory /opt/myorg/WebSphere/AppServer',
      #:timeout => "900",
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_exec('Install IBM Installation Manager')
      .with(
        'command' => /\/opt\/IBM\/tmp\/InstallationManager\/installc -acceptLicense -s -log.*-installationDirectory \/opt\/IBM\/InstallationManager/,
        'creates' => '/opt/IBM/InstallationManager/eclipse/tools/imcl',
        'cwd'     => '/opt/IBM/tmp/InstallationManager',
        'timeout' => '900',
        'user'    => 'root'
      )
  end
  it do
    is_expected.to_not contain_exec('mkdir -p /opt/IBM/tmp/InstallationManager')
  end
  it do
    is_expected.to_not contain_staging__deploy('ibm_im.zip')
  end
  describe 'with options' do
    let(:params) do
      {
        #:deploy_source => false,
        #:source => ,
        #:target => "/opt/IBM/InstallationManager",
        :source_dir => "/opt/IBM/tmp/InstallationManager",
        #:user => "root",
        #:group => "root",
        :options => '-installationDirectory /opt/myorg/WebSphere/AppServer',
        #:timeout => "900",
      }
    end
    it do
      is_expected.to contain_exec('Install IBM Installation Manager')
           .with(
             'command' => '/opt/IBM/tmp/InstallationManager/installc -installationDirectory /opt/myorg/WebSphere/AppServer',
             'creates' => '/opt/IBM/InstallationManager/eclipse/tools/imcl',
             'cwd'     => '/opt/IBM/tmp/InstallationManager',
             'timeout' => '900',
             'user'    => 'root'
           )
    end

  end
  describe 'deploy source' do
    let(:params) do
      {
        :deploy_source => true,
        :source => '/mnt/tmp/source',
        #:target => "/opt/IBM/InstallationManager",
        :source_dir => "/opt/IBM/tmp/InstallationManager",
        #:user => "root",
        #:group => "root",
        :options => '-installationDirectory /opt/myorg/WebSphere/AppServer',
        #:timeout => "900",
      }
    end
    it do
      is_expected.to contain_exec('mkdir -p /opt/IBM/tmp/InstallationManager')
                       .with(
                         'creates' => '/opt/IBM/tmp/InstallationManager',
                         'path'    => '/bin:/usr/bin:/sbin:/usr/sbin'
                       )
    end
    it do
      is_expected.to contain_file('/opt/IBM/tmp/InstallationManager')
                       .with(
                         'ensure' => 'directory',
                         'group'  => 'root',
                         'owner'  => 'root'
                       )
    end
    it do
      is_expected.to contain_staging__deploy('ibm_im.zip')
                       .with(
                         'before'  => 'Exec[Install IBM Installation Manager]',
                         'creates' => '/opt/IBM/tmp/InstallationManager/tools/imcl',
                         'require' => 'File[/opt/IBM/tmp/InstallationManager]',
                         'source'  => '/mnt/tmp/source',
                         'target'  => '/opt/IBM/tmp/InstallationManager'
                       )
    end
  end



end
