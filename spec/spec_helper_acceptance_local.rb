# frozen_string_literal: true

require 'puppet_litmus'
require 'singleton'

class Helper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  _module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

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
  INSTALL_FILE_PATH = ENV['IBM_INSTALL_SOURCE'] || 'https://artifactory.delivery.puppetlabs.net/artifactory/list/generic/module_ci_resources/modules/ibm_installation_manager'

  # Configure all nodes in nodeset
  c.before :suite do
    # Retrieve the install files for tests.
    pp = <<-EOS
      archive { '/tmp/agent.installer.linux.gtk.x86_64_1.8.7000.20170706_2137.zip':
        source       => "#{INSTALL_FILE_PATH}/agent.installer.linux.gtk.x86_64_1.8.7000.20170706_2137.zip",
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
    Helper.instance.apply_manifest(pp)
  end
end
