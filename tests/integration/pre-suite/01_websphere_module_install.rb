test_name 'FM-3804 - C94728 - Plug-in Sync Module from Master with Prerequisites Satisfied on Agent'

#Currently the puppetlabs-ibm_installation_manager is not ready for testing, so using joshbeard-ibm_installation_manager
# instead.
on(master, puppet('module install joshbeard-ibm_installation_manager'))

on(master, puppet('module install nanliu-staging -v 1.0.3'))
on(master, puppet('module install puppetlabs-stdlib'))
on(master, puppet('module install puppetlabs-concat'))

step 'Install dsestero/download_uncompress module on the agent'
confine_block(:except, :roles => %w{master dashboard database}) do
  agents.each do |agent|
    on(agent, puppet('module install dsestero-download_uncompress'))
  end
end

# When the module puppetlabs-ibm_installation_manager is ready for testing. The below lines of code will be uncommented.

# step 'Install ibm_installation_manager Module Dependencies'
# on(master, puppet('module install puppetlabs-stdlib'))
# on(master, puppet('module install puppetlabs-concat'))
# step 'Install ibm_installation_manager Module'
# proj_root = File.expand_path(File.join(File.dirname(__FILE__), '../../../'))
# staging = { :module_name => 'puppetlabs-ibm_installation_manager' }
# local = { :module_name => 'ibm_installation_manager', :source => proj_root, :target_module_path => master['distmoduledir'] }
#
# # in CI install from staging forge, otherwise from local
# install_dev_puppet_module_on(master, options[:forge_host] ? staging : local)
