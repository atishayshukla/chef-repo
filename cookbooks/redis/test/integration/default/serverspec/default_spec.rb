require 'spec_helper'

describe 'redis::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  
  describe service('redis_6379') do
    it { should be_running }
  end
end
