test_name 'FM-3804 - C94728 - Plug-in Sync Module from Master with Prerequisites Satisfied on Agent'

step 'install IBM_Installation_Manager dependencies:'
%w(puppet-archive puppetlabs-stdlib puppetlabs-concat).each do |dep|
  on(master, puppet("module install #{dep}"))
end

step 'Install dsestero/download_uncompress module on the agent'
confine_block(:except, :roles => %w{master dashboard database}) do
  agents.each do |agent|
    on(agent, '/opt/puppetlabs/puppet/bin/puppet module install dsestero-download_uncompress')
  end
end

step 'Install ibm_installation_manager Module'
proj_root = File.expand_path(File.join(File.dirname(__FILE__), '../../../'))
staging = {:module_name => 'puppetlabs-ibm_installation_manager'}
local = {:module_name => 'ibm_installation_manager', :source => proj_root,
          :target_module_path => '/etc/puppetlabs/code/environments/production/modules'}

# in CI install from staging forge, otherwise from local
install_dev_puppet_module_on(master, options[:forge_host] ? staging : local)
