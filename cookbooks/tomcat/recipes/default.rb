#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# execute "java-1.7.0-openjdk-devel"

package 'java-1.7.0-openjdk-devel' do
  action :install
end

group 'tomcat' do
  action :create
end

user 'random' do
  action :create
  comment 'tomcat User'
  home '/opt/tomcat'
  shell '/bin/nologin'
  group 'tomcat'
  manage_home false
end



