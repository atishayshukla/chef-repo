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

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'updates the package repository' do
      expect { chef_run }. to run_execute('apt-get update')
    end

    it 'installs the necessary packages'

    it 'retrives the application from source'

    it 'unzips the application'

    it 'builds and installs the application'

    it 'installs the server'

    it 'starts the service'

  end
end
