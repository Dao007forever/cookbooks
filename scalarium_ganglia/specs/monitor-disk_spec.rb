require 'minitest/spec'

describe_recipe 'scalarium_ganglia::monitor-disk' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end