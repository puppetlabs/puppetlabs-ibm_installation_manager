#!/bin/bash

# Init
SCRIPT_PATH=$(pwd)
BASENAME_CMD="basename ${SCRIPT_PATH}"
SCRIPT_BASE_PATH=`eval ${BASENAME_CMD}`

if [ $SCRIPT_BASE_PATH = "test_run_scripts" ]; then
  cd ../../
fi

export pe_dist_dir="https://artifactory.delivery.puppetlabs.net/artifactory/generic_enterprise__local/archives/releases/2015.3.3"
export GEM_SOURCE=https://artifactory.delivery.puppetlabs.net/artifactory/api/gems/rubygems/

bundle install --without build development test --path .bundle/gems

bundle exec beaker \
  --preserve-host onfail \
  --config tests/integration/nodesets/aix-71.yml \
  --debug \
  --pre-suite tests/integration/pre-suite \
  --tests tests/integration/tests \
  --keyfile ~/.ssh/id_rsa-acceptance \
  --load-path tests/lib
