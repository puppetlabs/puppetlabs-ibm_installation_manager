require 'erb'
# Download a compressed file from http repository and uncompress it
#
# ==== Attributes
#
# * +hosts+ - The target host where the compressed file is downloaded and uncompressed.
# * +urllink+ - The http link to where the compressed file is located .
# * +compressed_file+ - The name of the compressed file.
# * +uncompress_to+ - The target directory on the host where all files/directories are uncompressed to.
#
# ==== Returns
#
# +nil+
#
# ==== Raises
#
# +Minitest::Assertion+ - Failed to download and/or uncompress.
#
# ==== Examples
#
# download_and_uncompress('agent'
#                  'http://int-resources.ops.puppetlabs.net/QA_resources/ibm_websphere/',
#                  'was.repo.8550.ihs.ilan_part1.zip',
#                  '"/ibminstallers/ibm/ndtrial"',)
def download_and_uncompress(host, source_link, uncompress_to)

  #ERB Template
  installer_url = source_link
  dest_directory = uncompress_to
  directory_path = "#{uncompress_to}/IBM"

  #getting compress type
  if source_link.include? 'zip'
    compress_type = 'zip'
  elsif source_link.include? 'tar.gz'
    compress_type = 'tar.gz'
  else
    fail_test 'Only zip or tar.gz are is valid compressed file'
  end

  #getting group:
  if (host['platform'] =~ /aix/)
    user_group = 'system'
  elsif (host['platform'] =~ /linux/)
    user_group = 'root'
  end

  local_files_root_path = ENV['FILES'] || "tests/files"
  manifest_template     = File.join(local_files_root_path, 'download_uncompress_manifest.erb')
  manifest_erb          = ERB.new(File.read(manifest_template)).result(binding)

  on(host, puppet('apply'), :stdin => manifest_erb, :exceptable_exit_codes => [0,2]) do |result|
    assert_no_match(/Error/, result.output, 'Failed to download and/or uncompress')
  end
end

# Verify if IBM Installation Manager is installed
#
# ==== Attributes
#
# * +installed_directory+ - The directory where IBM Installation Manager is installed
# By default, the directory is /opt/IBM. This can be configured by 'target' attribute
# in 'ibm_installation_manager' class
# Since IM a UI tool, the verification is only checking if the launcher, license file,
# and the version file are in the right locations.
#
# ==== Returns
#
# +nil+
#
# ==== Raises
#
# fail_test messages
#
# ==== Examples
#
# verify_im_installed?(custom_location)
def verify_im_installed?(installed_directory)
  step "Verify IBM Installation Manager is installed into directory: #{installed_directory}"
  step 'Verify 1/3: IBM Installation Manager Launcher'
  if agent.file_exist?("#{installed_directory}/eclipse/launcher") == false
    fail_test "Launcher has not been found in: #{installed_directory}/eclipse"
  end

  step 'Verify 2/3: IBM Installation Manager License File'
  if agent.file_exist?("#{installed_directory}/license/es/license.txt") == false
    fail_test "License file has not been found in: #{installed_directory}/license"
  end

  step 'Verify 3/3: IBM Installation Manager Version'
  if agent.file_exist?("#{installed_directory}/properties/version/IBM_Installation_Manager.*") == false
    fail_test "Version has not been found in: #{installed_directory}/properties/version"
  end
end

# Get the source links for the IBM Installation manager installer
# either for Linux or AIX agent
#
# ==== Attributes
#
# ==== Returns
#
# +The links to IBM Installation Manager installer or nil+
#
# ==== Raises
#
# +none+
#
# ==== Examples
#
# get_resource_link
def get_source_link(host)
  if (host['platform'] =~ /aix/)
    return 'http://int-resources.ops.puppetlabs.net/QA_resources/ibm_websphere/agent.installer.aix.gtk.ppc_1.8.4000.20151125_0201.zip'
  elsif (host['platform'] =~ /linux/)
    return 'http://int-resources.ops.puppetlabs.net/QA_resources/ibm_websphere/agent.installer.linux.gtk.x86_64_1.8.3000.20150606_0047.zip'
  end
end

# uninstall IBM Installation Manager and clean the box
# either for Linux or AIX agent
#
# ==== Attributes
#
# * +host+ - The target host where IBM Installation Manager needs to be uninstalled.
# * +remove_directories+ - The directories need to be deleted from the host.
# ==== Returns
#
# The test box should be cleaned after each test
#
# ==== Raises
#
# +none+
#
# ==== Examples
#
# clean_test_box(agent, '/opt/IBM')
def clean_test_box(host, remove_directories=nil)
  on(host, '/var/ibm/InstallationManager/uninstall/uninstallc',
     :acceptable_exit_codes => [0,127]) do |result|
    assert_no_match(/Error/, result.stderr, 'Failed to uninstall IBM Installation Manager')
  end
  if remove_directories
    on(host, "rm -rf #{remove_directories}", :acceptable_exit_codes => [0,127])
  end
end
