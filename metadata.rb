# -*- encoding : utf-8 -*-
maintainer       "Shuky Dvir"
maintainer_email "shuky@tooveo.com"
license          "Apache 2.0"
description      "Installs/Configures torquebox"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"

%w{ java git }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end

