#!/usr/bin/env bash
set -e
apt-add-repository ppa:brightbox/ruby-ng
apt-get update --yes
apt-get --yes install software-properties-common
apt-get --yes install ruby2.4
apt-get --yes install ruby2.4-dev
apt-get --yes install g++
gem install bundler
cd /vagrant
bundle install
