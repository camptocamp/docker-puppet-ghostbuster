#!/bin/bash

export REF=$1
export REPO_NAME=$2
export REPO_CLONE_URL=$3
export REPO_OWNER=$4

branch=$(cut -d/ -f3 <<<"${REF}")
if echo "${BRANCHES}" | grep -q $branch ; then
  cd /var/lib/git
  test -d $REPO_NAME || git clone $REPO_CLONE_URL
  cd $REPO_NAME
  git fetch
  git checkout origin/$branch

  HIERA_YAML_PATH=/var/lib/git/$REPO_NAME/hiera.yaml find . -type f -exec puppet-lint --only-checks ghostbuster_classes,ghostbuster_defines,ghostbuster_facts,ghostbuster_files,ghostbuster_functions,ghostbuster_hiera_files,ghostbuster_templates,ghostbuster_types --log-format '{"title":"[GhostBuster] %{message}","content":"%{fullpath}"}' {} \+ | gh-create-issues.sh
fi
