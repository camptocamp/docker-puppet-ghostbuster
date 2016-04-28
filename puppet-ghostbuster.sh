#!/bin/sh

cd /var/lib/git
git clone $1
cd $2
git checkout $3
bundle install
bundle exec puppet-ghostbuster -s http://puppetdb:8080
