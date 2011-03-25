default[:nginx][:user] = "www-data"

default[:nginx][:dirs] = {
    :config => "/etc/nginx",
    :logs => "/var/log/nginx",
    :templates => "/opt/chef/nginx/templates",
    :custom_templates => "/opt/chef/nginx/custom_templates",
    :maintainance => "/opt/chef/nginx/maintainance"
}

default[:nginx][:mode] = "maintainance"

default[:nginx][:server][:workers] = {
    :processes => cpu[:total],
    :connections => 1024
}

default[:nginx][:server][:gzip] = {
    :enabled => true,
    :disable_for => "MSIE [1-6]\\.(?!.*SV1)",
    :http_version => "1.0",
    :compression_level => 2,
    :mime_types => [
        "text/plain",
        "text/css",
        "application/x-javascript",
        "text/xml",
        "application/xml",
        "application/xml+rss",
        "text/javascript"
    ]
}

default[:nginx][:server][:settings] = {
    :sendfile => "on",
    :tcp_nopush => "on",
    :tcp_nodelay => "on",
    :keepalive_timeout => 60,
    :server_names_hash_max_size => 2048,
    :server_names_hash_bucket_size => 128,
    :client_max_body_size => "30M",
    :client_body_timeout => 10
}

default[:nginx][:sites] = {
  :services => {
    :modes => [ "production", "testing", "maintainance" ],
    :listen => ["127.0.0.1:80"],
    :names => ["localhost"],
    :templates => [
      { :name => "status-nginx" }
    ]
  },
  
  :alternatives => {
    :modes => [ "production" ],
    :listen => ["*:80"],
    :names => [
      node[:fqdn],
      node[:ipaddress]
    ],
    :templates => [
      { :name => "location-deny-all" }
    ]
  },
  
  :dummy => {
     :modes => [ "maintainance" ],
     :listen => ["80 default"],
     :names => ["_"],
     :templates => [
       {
         :name => "location-root",
         :args => { :root => node[:nginx][:dirs][:maintainance] }
       }
     ]
   }
}
