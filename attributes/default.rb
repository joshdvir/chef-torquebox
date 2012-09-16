# -*- encoding : utf-8 -*-

default[:torquebox][:version] = "2.1.1"
default[:torquebox][:url] = "http://torquebox.org/release/org/torquebox/torquebox-dist/#{node[:torquebox][:version]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip"
default[:torquebox][:base] = "/opt/torquebox"
default[:torquebox][:prefix] = "/opt/torquebox/torquebox-#{node[:torquebox][:version]}"
default[:torquebox][:current] = "/opt/torquebox/current"
default[:torquebox][:user] = "torquebox"
default[:torquebox][:group] = "torquebox"


default[:torquebox][:backstage][:user] = "change"
default[:torquebox][:backstage][:password] = "me"
default[:torquebox][:backstage][:gitrepo] = "git://github.com/torquebox/backstage.git"
default[:torquebox][:backstage][:home] = "/var/www/backstage"
default[:torquebox][:backstage][:auth] = true

