package 'php5-fpm' do
  options '--force-yes'
end

node[:fpm][:modules].each do |name|
  package "php5-#{name}" do
    options '--force-yes'
  end
end

service 'php5-fpm' do
  supports :restart => true, :reload => true
  action [:enable]
end

template "#{node[:fpm][:config]}/php5-fpm.conf" do
  source 'config.erb'
  notifies :restart, resources(:service => 'php5-fpm'), :immediate
end

template '/etc/logrotate.d/php5-fpm' do
  source 'logrotate.erb'
end

ruby_block "configure-service-status" do
  block do
    node[:nginx][:sites][:services][:templates] |= node[:fpm][:pools].inject(Array.new) do |locations, (name, pool)|
      locations << {
        "name" => "status-php-fpm",
        "args" => {
          "location" => "/#{name}/",
          "backend" => name
        }
      }
    end
  end
  notifies :update, resources(:nginx_site => 'services'), :immediate
end
