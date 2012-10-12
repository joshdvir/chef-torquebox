# -*- encoding : utf-8 -*-

package 'git-core'

directory "/var/www/" do
  recursive true
  owner node[:torquebox][:user]
  group node[:torquebox][:group]
end

git node[:torquebox][:backstage][:home] do
  repository node[:torquebox][:backstage][:gitrepo]
  revision "HEAD"
  destination node[:torquebox][:backstage][:home]
  action :sync
  user node[:torquebox][:user]
  group node[:torquebox][:group]
end

execute "bundle install" do
  command "jruby -S bundle install"
  cwd node[:torquebox][:backstage][:home]
  user node[:torquebox][:user]
  group node[:torquebox][:group]
  environment ({
    'TORQUEBOX_HOME'=> node[:torquebox][:current],
    'JBOSS_HOME'=> "#{node[:torquebox][:current]}/jboss",
    'JRUBY_HOME'=> "#{node[:torquebox][:current]}jruby",
    'PATH' => "#{ENV['PATH']}:#{node[:torquebox][:current]}/jruby/bin"
  })
end

execute "backstage deploy" do
  command "bundle exec bin/backstage deploy --secure=#{node[:torquebox][:backstage][:user]}:#{node[:torquebox][:backstage][:password]}" if node[:torquebox][:backstage][:auth]
  command "bundle exec bin/backstage deploy" unless node[:torquebox][:backstage][:auth]
  cwd node[:torquebox][:backstage][:home]
  user node[:torquebox][:user]
  group node[:torquebox][:group]
  environment ({
    'TORQUEBOX_HOME'=> node[:torquebox][:current],
    'JBOSS_HOME'=> "#{node[:torquebox][:current]}/jboss",
    'JRUBY_HOME'=> "#{node[:torquebox][:current]}jruby",
    'PATH' => "#{ENV['PATH']}:#{node[:torquebox][:current]}/jruby/bin"
  })
end
