# -*- encoding : utf-8 -*-

package 'git-core'

directory "/var/www/" do
  recursive true
end

git node[:torquebox][:backstage][:home] do
  repository node[:torquebox][:backstage][:gitrepo]
  revision "HEAD"
  destination node[:torquebox][:backstage][:home]
  action :sync
end

template "#{node[:torquebox][:backstage][:home]}/config/auth.yml" do
  source "auth.yml.erb"
end

execute "bundle install" do
  command "jruby -S bundle install"
  cwd node[:torquebox][:backstage][:home]
  not_if "jruby -S bundle check"
end

torquebox_application "backstage" do
  action :deploy
  path node[:torquebox][:backstage][:home]
end
