#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    # In Test also we can make the variable at one place

    let(:version) { '2.8.9' }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'updates the package repository' do
      expect(chef_run).to run_execute('apt-get update')
    end

    it 'installs the necessary packages' do 
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'retrives the application from source' do
      expect(chef_run).to create_remote_file('/tmp/redis-#{version}.tar.gz')
    end

    it 'unzips the application' do
      # expect(chef_run).to run_execute('tar xzf /tmp/redis-#{version}.tar.gz')
      # This expectation is going to fail as in recipe
      # This action does nothing so we will look in below how to implement it
      resource = chef_run.remote_file('/tmp/redis-#{version}.tar.gz')
      expect(resource).to notify('execute[tar xzf redis-#{version}.tar.gz]').to(:run).immediately
      # This is how notify works
    end

    it 'builds and installs the application' do
      resource = chef_run.execute('tar xzf redis-#{version}.tar.gz')
      expect(resource).to notify('execute[make && make install]').to(:run).immediately
    end

    it 'installs the server' do
      resource = chef_run.execute('make && make install')
      expect(resource).to notify('execute[echo -n | ./install_server.sh]').to(:run).immediately
    end

    it 'starts the service' do
      expect(chef_run).to start_service('redis_6379')
    end

  end
end
