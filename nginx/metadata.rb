maintainer          "Andrey Sibiryov"
maintainer_email    "me@kobology.ru"
license             "Apache 2.0"
description         "Installs and configures Nginx web server"
# long_description    IO.read(File.join(File.dirname(__FILE__), 'README.textile'))
version             "0.5.1"

%w{ ubuntu debian }.each do |os|
    supports os
end

attribute "nginx/user",
    :display_name => "Nginx user",
    :description => "User nginx will run as",
    :default => "www-data"

grouping "nginx/dirs",
    :title => "Nginx paths",
    :description => "Configure Nginx directory locations"

attribute "nginx/dirs/config",
    :display_name => "Nginx configuration directory",
    :description => "Location for Nginx configuration files",
    :default => "/etc/nginx"

attribute "nginx/dirs/logs",
    :display_name => "Nginx logging directory",
    :description => "Location for Nginx logs",
    :default => "/var/log/nginx"

attribute "nginx/dirs/includes",
    :display_name => "Nginx includes directory",
    :description => "Location for Nginx includes",
    :default => "/opt/chef/nginx/includes"

grouping "nginx/gzip",
    :title => "GZip options",
    :description => "Configure GZip options"

attribute "nginx/gzip/disable",
    :display_name => "Disable for Gzip browsers",
    :description => "Whether gzip is disabled for specified UAs",
    :default => "on",
    :choice => ["on", "off"]

attribute "nginx/gzip/http-version",
    :display_name => "Nginx Gzip HTTP Version",
    :description => "Version of HTTP Gzip",
    :default => "1.0",
    :choice => ["1.0", "1.1"]

attribute "nginx/gzip/compression-level",
    :display_name => "Nginx Gzip Compression Level",
    :description => "Amount of compression to use",
    :default => "2",
    :choice => ('1'..'9').to_a

attribute "nginx/gzip/mime-types",
    :display_name => "Nginx Gzip Types",
    :description => "Supported MIME-types for gzip",
    :type => "array",
    :default => ["text/plain", "text/html", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript"]

grouping "nginx/worker",
    :title => "Nginx worker options",
    :description => "Configure Nginx worker options"

attribute "nginx/worker/processes",
    :display_name => "Nginx Worker Processes",
    :description => "Number of worker processes",
    :default => "4",
    :choice => ('1'..'40').to_a

attribute "nginx/worker/connections",
  :display_name => "Nginx Worker Connections",
  :description => "Number of connections per worker",
  :default => "1024"

grouping "nginx/server",
    :title => "Server options",
    :description => "Configure Nginx server options"
    
attribute "nginx/sites",
    :title => "Virtual hosts",
    :description => "Virtual hosts",
    :type => "array"
