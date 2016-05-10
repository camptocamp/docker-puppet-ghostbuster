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

  find . -type f -exec puppet-lint --only-checks ghostbuster_classes,ghostbuster_defines,ghostbuster_files,ghostbuster_templates --log-format '{"title":"[GhostBuster] %{message}","content":"%{fullpath}"}' {} \+ | ruby -e 'puts "[#{$stdin.readlines.join(",").gsub("\n", "")}]"' | gh-create-issues
fi
