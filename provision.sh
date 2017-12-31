#!/usr/bin/env bash
set -e
apt-add-repository ppa:brightbox/ruby-ng
apt-get update --yes
apt-get --yes install software-properties-common
apt-get --yes install ruby2.4
apt-get --yes install ruby2.4-dev
apt-get --yes install g++
gem install bundler
rm -rf ubuntufs
mkdir ubuntufs
cd ubuntufs
wget -q http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/ubuntu-base-16.04-core-amd64.tar.gz
tar xfz ubuntu-base-16.04-core-amd64.tar.gz
rm ubuntu-base-16.04-core-amd64.tar.gz
touch UBUNTU_CONTAINER_ROOT
cd /vagrant
bundle install
