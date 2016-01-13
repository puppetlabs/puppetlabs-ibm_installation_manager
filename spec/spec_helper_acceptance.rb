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
      on host, puppet('module','install','nanliu-staging'), { :acceptable_exit_codes => [0,1] }

      pp = <<-EOS
        package { 'unzip':
          ensure => present,
        }
      EOS
      apply_manifest_on(host, pp, :catch_failures => true)

      # scp the ibm installation manager installer
      scp_to host, "#{install_pkg_path}/agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip", "/tmp/"
      # scp and unzip ibm java7 installer
      %w(part1 part2 part3).each do |part|
        scp_to host, "#{install_pkg_path}/was.repo.8550.ndtrial_#{part}.zip", "/tmp/"
        on host, "/usr/bin/unzip /tmp/was.repo.8550.ndtrial_#{part}.zip -d /tmp/ndtrial/"
      end
    end
  end
end
