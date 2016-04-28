#!/bin/sh

export REF=$1
export REPO_NAME=$2
export REPO_CLONE_URL=$3

cd /var/lib/git
test -d $REPO_NAME || git clone $REPO_CLONE_URL
cd $REPO_NAME
git fetch
git checkout $(cut -d/ -f3 <<<"${REF}")

puppet-ghostbuster -s http://puppetdb:8080
