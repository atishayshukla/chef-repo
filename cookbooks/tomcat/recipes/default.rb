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
 notifies :run, 'execute[untar_apache_tomcat]', :immediately
end

directory '/opt/tomcat' do
  action :create
end

# TODO: This is not idempotent, this will run everytime not the desired state
execute 'untar_apache_tomcat' do
 command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
 action :nothing
end

# Change group tomcat for conf

execute 'chgrp -R tomcat /opt/tomcat/conf'

# Update Permissions

directory '/opt/tomcat/conf' do
  mode '0070'
end

execute 'chmod g+r /opt/tomcat/conf/*'

# Then make the tomcat user the owner of the webapps, work, temp, and logs directories:

execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  #notifies :run, 'execute[systemctl daemon-reload]', :immediately
  #notifies :restart, 'service[tomcat]
end

execute 'systemctl daemon-reload'


service 'tomcat' do
  action [:start, :enable]
end
