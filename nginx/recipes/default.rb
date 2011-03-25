package "nginx" do
    options "--force-yes"
end

# Remove useless default site installed by the package
# TODO: Kill it in the package itself
link "#{node[:nginx][:dirs][:config]}/sites-enabled/default" do
    action :delete
end

service "nginx" do
    supports :status => true, :restart => true, :reload => true
    action [:enable]
end

template "#{node[:nginx][:dirs][:config]}/nginx.conf" do
    mode "0644"
    source "nginx.conf.erb"
    notifies :restart, resources(:service => "nginx"), :immediate
end

# Fetch the templates
remote_directory node[:nginx][:dirs][:templates] do
  source "templates"
  mode "0700"
  files_mode "0600"
end

# Fetch custom templates
remote_directory node[:nginx][:dirs][:custom_templates] do
  source "custom_templates"
  mode "0700"
  files_mode "0600"
end

remote_directory node[:nginx][:dirs][:maintainance] do
  source "maintainance"
  mode "0755"
  files_mode "0644"
end

log "[nginx] Active nginx mode is '#{node[:nginx][:mode]}'" do
  level :info  
end

node[:nginx][:sites].each do |name, data|
  nginx_site name do
    action (data[:modes].include? node[:nginx][:mode]) ? :enable : :disable
  end
end

nginx_tracker "#{node[:nginx][:dirs][:config]}/sites-enabled" do
  action :cleanup
end
