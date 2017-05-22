## Release 0.2.5
### Summary
This small bugfix release that fixes install command options, and module sync changes.

#### Bugfixes
- When user is root, use 'installc' as the installation command

#### Maintenance
- Many modulesync changes
- Update parallel_tests
- Mocha version update
- Add locales directory structure

## Release 0.2.4
### Summary
This small bugfix release that fixes a failure to append install options

#### Bugfixes
- Fixes a failure to append install options to imcl command

## Release 0.2.3
### Summary
This small bugfix release that fixes a failure to read the install_file

#### Bugfixes
- Fixes a failure to read the install file.

## Release 0.2.2
### Summary
This small bugfix release that fixes an idempotency problem when installing fixpacks

#### Bugfixes
- Fixes idempotency problem when installing fixpacks

## Release 0.2.1
### Summary
This small bugfix release that fixes a potential duplicate resource problem.

#### Bugfixes
- Fixes a possible duplicate resource problem

## Release 0.2.0
### Summary
This release includes feature to manage ibm packages via `puppet resource` as well as some bugfixes.

#### Features
- Adds ability to list `ibm_pkg` resources via `puppet resource`.

#### Bugfixes / Improvements
- Fixes/improves paramater validation in `ibm_pkg` type.
- Complete refactor of `ibm_pkg` provider.
- Adds more testing.
- Cleanup of README.
