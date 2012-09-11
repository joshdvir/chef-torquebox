# -*- encoding : utf-8 -*-

version = node[:torquebox][:version]
prefix = node[:torquebox][:prefix]
current = node[:torquebox][:current]

package "unzip"
package "upstart"
include_recipe "java"


user node[:torquebox][:user] do
  comment node[:torquebox][:user]
  system true
  shell "/bin/bash"
end

directory node[:torquebox][:base] do
  owner "torquebox"
  group "torquebox"
  mode "0755"
  action :create
end

remote_file "#{node[:torquebox][:base]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip" do
  source node[:torquebox][:url]
  action :create_if_missing
  mode "0644"
  owner 'torquebox'
  group 'torquebox'
  not_if{ File.exists?(prefix) }
end

execute "unzip torquebox" do
  cwd node[:torquebox][:base]
  command "unzip torquebox-dist-#{node[:torquebox][:version]}-bin.zip -d #{node[:torquebox][:base]}"
  creates node[:torquebox][:prefix]
  user 'torquebox'
  group 'torquebox'
  action :run
end

file "#{node[:torquebox][:base]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip" do
  action :delete
  only_if{ File.exists?("#{node[:torquebox][:base]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip") }
end

link current do
  to prefix
  owner 'torquebox'
  group 'torquebox'
end

template "/etc/profile.d/torquebox.sh" do
  mode "755"
  source "torquebox.erb"
end

execute "copy upstart" do
  command "cp #{node[:torquebox][:current]}/share/init/torquebox.conf /etc/init/ | sudo sed -i '1 i start on runlevel [2345]' /etc/init/torquebox.conf | sudo sed -i 's/\\/opt\\/torquebox/\\/opt\\/torquebox\\/current/g' /etc/init/torquebox.conf"
  creates "/etc/init/torquebox.conf"
  user 'root'
  group 'root'
  action :run
end

