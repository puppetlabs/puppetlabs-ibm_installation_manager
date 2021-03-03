# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v3.0.0](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/tree/v3.0.0) (2021-03-03)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/v2.2.1...v3.0.0)

### Changed

- pdksync - \(MAINT\) Remove RHEL 5 family support [\#176](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/176) ([sanfrancrisko](https://github.com/sanfrancrisko))
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [\#172](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/172) ([carabasdaniel](https://github.com/carabasdaniel))

### Added

- pdksync - \(feat\) Add support for Puppet 7 [\#166](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/166) ([daianamezdrea](https://github.com/daianamezdrea))

## [v2.2.1](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/tree/v2.2.1) (2020-11-16)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/v2.2.0...v2.2.1)

### Fixed

- \(IAC-990\) - Removal of inappropriate terminology [\#160](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/160) ([david22swan](https://github.com/david22swan))

## [v2.2.0](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/tree/v2.2.0) (2020-06-26)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/v2.1.0...v2.2.0)

### Added

- Make installation of unzip optional [\#141](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/141) ([haloflightleader](https://github.com/haloflightleader))

## [v2.1.0](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/tree/v2.1.0) (2019-12-09)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/v2.0.0...v2.1.0)

### Added

- \(FM-8675\) - Addition of Support for CentOS8 [\#136](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/136) ([david22swan](https://github.com/david22swan))
- \(FM-8027\) Add RedHat 8 support [\#124](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/124) ([eimlav](https://github.com/eimlav))

### Fixed

- Timestamp retrieval function now Puppet native [\#134](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/134) ([bryanjbelanger](https://github.com/bryanjbelanger))

## [v2.0.0](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/tree/v2.0.0) (2019-05-14)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/1.0.0...v2.0.0)

### Changed

- pdksync - \(MODULES-8444\) - Raise lower Puppet bound [\#117](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/117) ([david22swan](https://github.com/david22swan))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/tree/1.0.0) (2019-02-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.6.0...1.0.0)

### Changed

- \(FM-7710\) - Remove Scientific 5 testing/support for IBM Installation Manager [\#105](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/105) ([david22swan](https://github.com/david22swan))

### Fixed

- pdksync - \(FM-7655\) Fix rubygems-update for ruby \< 2.3 [\#102](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/102) ([tphoney](https://github.com/tphoney))

## [0.6.0](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/tree/0.6.0) (2018-09-27)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/compare/0.5.0...0.6.0)

### Added

- pdksync - \(MODULES-6805\) metadata.json shows support for puppet 6 [\#95](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/95) ([tphoney](https://github.com/tphoney))
- pdksync - \(MODULES-7658\) use beaker4 in puppet-module-gems [\#92](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/92) ([tphoney](https://github.com/tphoney))
- \(FM-7260\) - Addition of support for ubuntu 18.04 [\#85](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/85) ([david22swan](https://github.com/david22swan))

### Fixed

- \(MODULES-7640\) - Update README Limitations section [\#87](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/87) ([eimlav](https://github.com/eimlav))
- \(maint\) - Removal of support for deprecated OS debian 6 and 7 [\#86](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/86) ([david22swan](https://github.com/david22swan))
- Add Ubuntu 16 to metadata support as it's tested [\#84](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/84) ([HelenCampbell](https://github.com/HelenCampbell))
- MODULES-7308 Services must be stopped when uninstl [\#83](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/83) ([mafriedel](https://github.com/mafriedel))
- MODULES-7301 MODULES-7302  [\#82](https://github.com/puppetlabs/puppetlabs-ibm_installation_manager/pull/82) ([mafriedel](https://github.com/mafriedel))

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
