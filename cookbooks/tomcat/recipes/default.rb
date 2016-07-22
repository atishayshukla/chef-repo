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
 notifies :run, 'execute[change_group_conf]', :immediately
 notifies :run, 'execute[chmod_conf]', :immediately
 notifies :run, 'execute[owner_change_webapps_work_temp_logs]', :immediately
end

# This will first be created before updating permissions

directory '/opt/tomcat/conf' do
  mode '0070'
end

# Change group tomcat for conf

execute 'change_group_conf' do
  command 'chgrp -R tomcat /opt/tomcat/conf'
  action :nothing
end


# Update Permissions

execute 'chmod_conf' do
  command 'chmod g+r /opt/tomcat/conf/*'
  action :nothing
end

# Then make the tomcat user the owner of the webapps, work, temp, and logs directories:

execute 'owner_change_webapps_work_temp_logs' do
  command 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'
  action :nothing
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  notifies :run, 'execute[daemon-reload]', :immediately
  #notifies :restart, 'service[tomcat]
end

execute 'daemon-reload' do
	command 'systemctl daemon-reload'
	action :nothing
end


service 'tomcat' do
  supports :status => :true, :restart => :true, :reload => :true
  action [:start, :enable]
end
