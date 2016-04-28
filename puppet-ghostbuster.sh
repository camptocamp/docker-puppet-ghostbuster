#!/bin/sh

cd /var/lib/git
test -d $2 || git clone $1
cd $2
git fetch
git checkout $3
puppet-ghostbuster -s http://puppetdb:8080
