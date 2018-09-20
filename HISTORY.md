## 0.5.0
### Summary
This is a small feature release that adds support for IBM Installation Manager 1.8.7 and some new parameters for ibm_pkg

#### Added
- support for IIM 1.8.7 ([MODULES-4738](https://tickets.puppet.com/browse/MODULES-4738))
- `jdk_package_name` and `jdk_package_version` paramters in the ibm_pkg type

#### Fixed
- issue for users with non-standard home directories ([MODULES-7204](https://tickets.puppet.com/browse/MODULES-7204))

## Supported Release [0.4.0]
### Summary
This is a small feature release that makes several small fixes while at the same time updating the module to comply with the set rubocop rules and PDK convert.

#### Added
- The module has been updated to comply with the set Rubocop Rules.
- The module has been updated to work with PDK Convert.
- Migrated from stickler to artifactory.

#### Fixed
- Error message for 'stopprocs' method fixed.
- Reverted to working version of 'stopprocs' method.

## Supported Release [0.3.0]
### Summary
This is a feature release that allows the user to install as non-root.

#### Added
- ability to install the IIM as a non-root user ([FM-6596](https://tickets.puppet.com/browse/FM-6596))
- change to user's home directory when executing imcl commands

#### Removed
- Support for Ubuntu 10.04 and 12.04 but compatibility remains intact.

## Supported Release [0.2.5]
### Summary
This small bugfix release that fixes install command options, and module sync changes.

#### Fixed
- When user is root, use 'installc' as the installation command

#### Maintenance
- Many modulesync changes
- Update parallel_tests
- Mocha version update
- Add locales directory structure

## Supported Release [0.2.4]
### Summary
This small bugfix release that fixes a failure to append install options

#### Fixed
- Fixes a failure to append install options to imcl command

## Supported Release [0.2.3]
### Summary
This small bugfix release that fixes a failure to read the install_file

#### Fixed
- Fixes a failure to read the install file.

## Supported Release [0.2.2]
### Summary
This small bugfix release that fixes an idempotency problem when installing fixpacks

#### Fixed
- Fixes idempotency problem when installing fixpacks

## Supported Release [0.2.1]
### Summary
This small bugfix release that fixes a potential duplicate resource problem.

#### Fixed
- Fixes a possible duplicate resource problem

## Supported Release [0.2.0]
### Summary
This release includes feature to manage ibm packages via `puppet resource` as well as some bugfixes.

#### Added
- Adds ability to list `ibm_pkg` resources via `puppet resource`.

#### Fixed
- Fixes/improves paramater validation in `ibm_pkg` type.
- Complete refactor of `ibm_pkg` provider.
- Adds more testing.
- Cleanup of README.

[0.4.0]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.3.0...0.4.0
[0.3.0]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.2.5...0.3.0
[0.2.5]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.2.4...0.2.5
[0.2.4]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.2.3...0.2.4
[0.2.3]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.2.2...0.2.3
[0.2.2]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.2.1...0.2.2
[0.2.1]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.2.0...0.2.1
[0.2.0]:https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/commits/0.2.0
