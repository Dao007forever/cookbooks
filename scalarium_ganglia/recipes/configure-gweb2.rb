instances = []

node[:scalarium][:roles].each do |role_name, role_config|
  role_config[:instances].each do |instance_name, instance_config|
    unless instances.include?(instance_name)
      instances << instance_name
    end
  end
end

instances.each do |instance_name|
  template "#{node[:ganglia][:datadir]}/conf/host_#{instance_name}.json" do
    source 'host_view_json.erb'
    mode '0644'
  end
end