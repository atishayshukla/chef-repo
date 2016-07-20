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

user 'tomcat' do
 action :create
 comment 'tomcat User'
 home '/opt/tomcat'
 shell '/bin/nologin'
 group 'tomcat'
 manage_home false
end

remote_file 'apache-tomcat-8.0.36.tar.gz' do
 source 'http://mirror.fibergrid.in/apache/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
end

directory '/opt/tomcat' do
  action :create
end

execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  






