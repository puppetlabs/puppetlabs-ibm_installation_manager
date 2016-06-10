require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Determine install zip files location
  # Defaults to a Puppet Labs internal repository, to run this externally
  # you must specify a directory on the host or url with the necessary files:
  #  - agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip
  #  - was.repo.8550.liberty.ndtrial.zip
  # are located.
  # To specify a directory you can use:
  #     "file:///directory/of/the/zips"
  # To specify a url:
  #     "http://path.of/zip_files"
  #
  INSTALL_FILE_PATH = ENV['IBM_INSTALL_SOURCE'] || 'http://int-resources.ops.puppetlabs.net/modules/ibm_installation_manager/'

  # Configure all nodes in nodeset
  c.before :suite do
    #install module
    puppet_module_install(:source => module_root, :module_name => 'ibm_installation_manager')

    install_pkg_path = "#{module_root}/spec/fixtures/modules/spec_files/files"
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppet-archive'), { :acceptable_exit_codes => [0,1] }

      # Retrieve the install files for tests.
      pp = <<-EOS
        archive { '/tmp/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip':
          source       => "#{INSTALL_FILE_PATH}/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip",
          extract      => false,
          extract_path => '/tmp',
        }

        package { 'unzip':
          ensure => present,
          before => Archive['/tmp/ndtrial/was.repo.8550.liberty.ndtrial.zip'],
        }

        file { '/tmp/ndtrial':
          ensure => directory,
        }

        archive { '/tmp/ndtrial/was.repo.8550.liberty.ndtrial.zip':
          source       => "#{INSTALL_FILE_PATH}/was.repo.8550.liberty.ndtrial.zip",
          extract      => true,
          extract_path => '/tmp/ndtrial',
          creates      => '/tmp/ndtrial/repository.config',
        }
      EOS
      apply_manifest_on(host, pp, :catch_failures => true)
    end
  end
end
