package 'php5-fpm' do
  options '--force-yes'
  version '5.3.2-3'
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
  source 'config-5.3.2.erb'
  notifies :restart, resources(:service => 'php5-fpm'), :immediate
end

template '/etc/logrotate.d/php5-fpm' do
  source 'logrotate.erb'
end

