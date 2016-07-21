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
 notifies :create, 'directory[/opt/tomcat]', :immediately
end

# This should be created only once, only when we change the remote file that is why above one uses notifies
directory '/opt/tomcat' do
  action :nothing 
  notifies :run, 'execute[tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1]', :immediately 
  notifies :run, 'execute[chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/]', :immediately 
end

# TODO: This is not idempotent, this will run everytime not the desired state
execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1' do
  action :nothing
  notifies :create, 'directory[/opt/tomcat/conf]', :immediately
end

directory '/opt/tomcat/conf' do
  mode '0070'
  action :nothing
  notifies :run, 'execute[chgrp -R tomcat /opt/tomcat/conf]', :immediately
  notifies :run, 'execute[chmod g+r /opt/tomcat/conf/*]', :immediately
end

# Change group tomcat for conf

execute 'chgrp -R tomcat /opt/tomcat/conf' do
  action :nothing
end

# Update Permissions

execute 'chmod g+r /opt/tomcat/conf/*' do
  action :nothing
end

# Then make the tomcat user the owner of the webapps, work, temp, and logs directories:

execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/' do
 action :nothing
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

execute 'systemctl daemon-reload' do
  action :nothing
end


service 'tomcat' do
  action [:start, :enable]  
end

  



  






