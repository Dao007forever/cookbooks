require 'minitest/spec'

describe_recipe 'deploy::web' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'directories' do
    it 'should create deployment directory' do
      node[:deploy].each do |app, deploy|
        directory("#{deploy[:deploy_to]}").must_exist.with(:mode, "775").and(:user, deploy[:user]).and(:group, deploy[:group])
        directory("#{deploy[:deploy_to]}/shared").must_exist.with(:mode, "770").and(:user, deploy[:user]).and(:group, deploy[:group])
        %w{log config system pids scripts sockets}.each do |dir_name|
          directory("#{deploy[:deploy_to]}/shared/#{dir_name}").must_exist.with(:mode, "770").and(:user, deploy[:user]).and(:group, deploy[:group])
        end
      end
    end

    it 'should delete cached copy if toggled on' do
      node[:deploy].each do |app, deploy|
        if deploy[:delete_cached_copy]
          directory("#{deploy[:deploy_to]}/shared/cached-copy").wont_exist
        end
      end
    end
  end

  describe 'files' do
    it 'should create a logrotate with the required contents' do
      node[:deploy].each do |app, deploy|
        file("/etc/logrotate.d/scalarium_app_#{app}").must_exist.with(:mode, '644').and(:owner, 'root').and(:group, 'root')
        file("/etc/logrotate.d/scalarium_app_#{app}").must_include "#{deploy[:deploy_to]}/shared/log"
      end
    end
  end
end