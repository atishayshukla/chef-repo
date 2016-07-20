require 'spec_helper'

describe 'tomcat::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  	describe command('curl http://localhost:8080') do
  		its(:stdout) { should match /Tomcat/ }
  	end
end
