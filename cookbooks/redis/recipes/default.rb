#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Translated Instructions From:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis
#
# Attempt to make resources idempotent

execute "apt-get update" do
  command "apt-get update"
  ignore_failure true
  not_if do ::File.exists?('/var/lib/apt/periodic/update-success-stamp') end  # This will make it idempotent
end

package "build-essential"

package "tcl8.5"

# version_number = '2.8.9' This works but not the right place move to attribute

version_number = node['redis']['version_number']

# download http://download.redis.io/releases/redis-2.8.9.tar.gz
remote_file "/tmp/redis-#{version_number}.tar.gz" do
  source "http://download.redis.io/releases/redis-#{version_number}.tar.gz"
  notifies :run, "execute[tar xzf redis-#{version_number}.tar.gz]", :immediately
end

# unzip the archive
execute "tar xzf redis-#{version_number}.tar.gz" do
  cwd "/tmp"
  action :nothing
  notifies :run, "execute[make && make install]", :immediately
end

# Configure the application: make and make install
execute "make && make install" do
  cwd "/tmp/redis-#{version_number}"
  action :nothing
  notifies :run, "execute[echo -n | ./install_server.sh]", :immediately
end

# Install the Server
execute "echo -n | ./install_server.sh" do
  cwd "/tmp/redis-#{version_number}/utils"
  action :nothing
end

service "redis_6379" do
  action [ :start ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end
