require 'spec_helper'

describe 'tomcat::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  	describe command('curl http://localhost:8080') do
  		its(:stdout) { should match /Tomcat/ }
  	end

  	describe package('java-1.7.0-openjdk-devel') do
  	  	it { should be_installed }
  	end

  	describe group('tomcat') do
  		it { should exist }
  	end

  	describe user('tomcat') do
  		it { should exist }
  		it { should belong_to_group 'tomcat'}
  		it { should have_home_directory '/opt/tomcat'}
  	end
# There is no directory in unix so use file and check for be directory
  	describe file('/opt/tomcat') do
  		it { should exist }
  		it { should be_directory }
  	end

  	# Test that conf directory now exists and mode is correct

  	describe file('/opt/tomcat/conf') do
  		it { should exist }
  		it { should be_directory }
  		it { should be_mode 70 }

  	end

  	# Test for the ownership of webapp directory log directory
  	# sudo chown -R tomcat webapps/ work/ temp/ logs/

 	['webapps', 'work', 'temp', 'logs'].each do |path|
	  	describe file("/opt/tomcat/#{path}") do 
	  		it { should exist }
	  		it { should be_owned_by 'tomcat' }
	  	end
	end
  	
end
