require 'im_helper'
require 'master_manipulator'
test_name 'FM-3804 - C94724 - Install Installation Manager from extracted source'

extracted_source = '/tmp'
source_link = nil

# Teardown
teardown do
  confine_block(:except, :roles => %w{master dashboard database}) do
    agents.each do |agent|
      clean_test_box(agent, "/opt/IBM #{extracted_source}/*")
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
  source_dir => '#{extracted_source}',
}
MANIFEST

step 'Inject "site.pp" on Master'
site_pp = create_site_pp(master, :manifest => pp)
inject_site_pp(master, get_site_pp_path(master), site_pp)

step 'Run Puppet Agent to install IBM Installation Manager from extracted source'
confine_block(:except, :roles => %w{master dashboard database}) do
  agents.each do |agent|
    download_and_uncompress(agent, source_link, extracted_source)

    sleep(20)
    on(agent, "/opt/puppetlabs/puppet/bin/puppet agent -t",
       :acceptable_exit_codes => [0,2]) do |result|
      assert_no_match(/Error:/, result.stderr, 'Unexpected error was detected!')
    end
    verify_im_installed?("/opt/IBM/InstallationManager")
  end
end
