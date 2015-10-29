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
def download_and_uncompress(host, urllink, compressed_file, uncompress_to)

  #ERB Template
  installer_url = urllink
  cfilename = compressed_file
  dest_directory = uncompress_to
  directory_path = "#{uncompress_to}/IBM"
  if compressed_file.include? "zip"
    compress_type = 'zip'
  elsif compressed_file.include? "tar.gz"
    compress_type = 'tar.gz'
  else
    fail_test "only zip or tar.gz are is valid compressed file "
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
  if agent.file_exist?("#{installed_directory}/eclipse/launcher") == nil
    fail_test "Launcher has not been found in: #{installed_directory}/eclipse"
  end

  step 'Verify 2/3: IBM Installation Manager License File'
  if agent.file_exist?("#{installed_directory}/license/es/license.txt") == nil
    fail_test "License file has not been found in: #{installed_directory}/license"
  end

  step 'Verify 3/3: IBM Installation Manager Version'
  if agent.file_exist?("#{installed_directory}/properties/version/IBM_Installation_Manager.*") == nil
    fail_test "Version has not been found in: #{installed_directory}/properties/version"
  end
end
