#!/bin/bash

# Init
SCRIPT_PATH=$(pwd)
BASENAME_CMD="basename ${SCRIPT_PATH}"
SCRIPT_BASE_PATH=`eval ${BASENAME_CMD}`

if [ $SCRIPT_BASE_PATH = "test_run_scripts" ]; then
  cd ../../
fi

# Work-around for RE-5005
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

export pe_dist_dir="http://pe-releases.puppetlabs.lan/2015.3.3"
export GEM_SOURCE=http://rubygems.delivery.puppetlabs.net
export BEAKER_VERSION=2.39.0

bundle install --without build development test --path .bundle/gems

bundle exec beaker \
  --preserve-host onfail \
  --config tests/integration/nodesets/aix-71.yml \
  --debug \
  --pre-suite tests/integration/pre-suite \
  --tests tests/integration/tests \
  --keyfile ~/.ssh/id_rsa-acceptance \
  --load-path tests/lib
