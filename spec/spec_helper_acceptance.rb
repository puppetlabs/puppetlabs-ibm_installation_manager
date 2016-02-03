require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset

  c.before :suite do
    #install module
    puppet_module_install(:source => module_root, :module_name => 'ibm_installation_manager')

    install_pkg_path = "#{module_root}/spec/fixtures/modules/spec_files/files"
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppet-archive'), { :acceptable_exit_codes => [0,1] }

      # scp the ibm installation manager installer
      scp_to host, "#{install_pkg_path}/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip", "/tmp/"
      # scp
      scp_to host, "#{install_pkg_path}/was.repo.8550.liberty.ndtrial.zip", "/tmp/"
      pp = <<-EOS
        package { 'unzip':
          ensure => present,
          before => Archive['/tmp/ndtrial/was.repo.8550.liberty.ndtrial.zip'],
        }

        file { '/tmp/ndtrial':
          ensure => directory,
        }

        archive { '/tmp/ndtrial/was.repo.8550.liberty.ndtrial.zip':
          source       => 'file:///tmp/was.repo.8550.liberty.ndtrial.zip',
          extract      => true,
          extract_path => '/tmp/ndtrial',
          creates      => '/tmp/ndtrial/repository.config',
          require      => File['/tmp/ndtrial'],
        }
      EOS
      apply_manifest_on(host, pp, :catch_failures => true)
    end
  end
end
