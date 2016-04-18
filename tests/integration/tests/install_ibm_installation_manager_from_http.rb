require 'im_helper'
require 'master_manipulator'
test_name 'FM-3804 - C94723 - Install Installation Manager from an HTTP repository'

source_link = nil

# Teardown
teardown do
  confine_block(:except, :roles => %w{master dashboard database}) do
    agents.each do |agent|
      clean_test_box(agent, '/opt/IBM')
    end
  end
end

confine_block(:except, :roles => %w{master dashboard database}) do
  agents.each do |agent|
    source_link = get_source_link(agent)
  end
end

pp = <<-MANIFEST
class { 'ibm_installation_manager':
  deploy_source => true,
  source        =>' #{source_link}',
}
MANIFEST

step 'Inject "site.pp" on Master'
site_pp = create_site_pp(master, :manifest => pp)
inject_site_pp(master, get_site_pp_path(master), site_pp)

confine_block(:except, :roles => %w{master dashboard database}) do
  agents.each do |agent|
    step 'Run Puppet Agent to install IBM Installation Manager from HTTP repository'
    expect_failure('Expect to fail due to FM-5115') do
      on(agent, "/opt/puppetlabs/puppet/bin/puppet agent -t",
         :acceptable_exit_codes => [1]) do |result|
        assert_no_match(/Error:/, result.stderr, 'Unexpected error was detected!')
      end
    end

    #Comment out because of FM-5115
    #verify_im_installed?(target)
  end
end
