# -*- encoding : utf-8 -*-

%w{ unzip upstart openjdk-6-jdk }.each do |p|
  package p
end


user node[:torquebox][:user] do
  comment node[:torquebox][:user]
  system true
  shell "/bin/bash"
end

directory node[:torquebox][:base] do
  owner node[:torquebox][:user]
  group node[:torquebox][:group]
  mode "0755"
  action :create
end

remote_file "#{node[:torquebox][:base]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip" do
  source node[:torquebox][:url]
  action :create_if_missing
  mode "0644"
  owner node[:torquebox][:user]
  group node[:torquebox][:group]
  not_if{ File.exists?(node[:torquebox][:prefix]) }
end

execute "unzip torquebox" do
  cwd node[:torquebox][:base]
  command "unzip torquebox-dist-#{node[:torquebox][:version]}-bin.zip -d #{node[:torquebox][:base]}"
  creates node[:torquebox][:prefix]
  user node[:torquebox][:user]
  group node[:torquebox][:group]
  action :run
end

file "#{node[:torquebox][:base]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip" do
  action :delete
  only_if{ File.exists?("#{node[:torquebox][:base]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip") }
end

link node[:torquebox][:current] do
  to node[:torquebox][:prefix]
  owner node[:torquebox][:user]
  group node[:torquebox][:group]
end

template "/etc/profile.d/torquebox.sh" do
  mode "755"
  source "torquebox.erb"
end

template "/etc/init/torquebox.conf" do
  source "torquebox_upstart.erb"
  owner 'root'
  group 'root'
end

service "torquebox" do
  action :start
  start_command "start torquebox"
end

