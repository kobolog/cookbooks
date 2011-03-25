attr_reader :config, :symlink, :prototype

def initialize(new_resource, run_context)
  super(new_resource, run_context)

  @config = "#{node[:nginx][:dirs][:config]}/sites-available/#{new_resource.name}.conf"
  @symlink = "#{node[:nginx][:dirs][:config]}/sites-enabled/#{new_resource.name}.conf"
  @prototype = node[:nginx][:sites].fetch(new_resource.name)
end

action :update do
    log "[nginx] Prototype for '#{new_resource.name}' is #{prototype.inspect}" do
      level :debug
    end

    template config do
        mode "0644"
        source "site.conf.erb"
        variables(
          :sitename => new_resource.name,
          :prototype => prototype
        )
      
        notifies :reload, resources(:service => 'nginx')
    end
end

action :enable do
    log "[nginx] Site '#{new_resource.name}' is active"
    
    action_update

    link symlink do
        to config
        action :create

        not_if do ::File.symlink? symlink end
        notifies :reload, resources(:service => 'nginx')
    end
    
    nginx_tracker "#{node[:nginx][:dirs][:config]}/sites-enabled" do
      action :track
      file symlink
    end
end

action :disable do
    log "[nginx] Site '#{new_resource.name}' is inactive"

    link symlink do
      to config
      action :delete

      only_if do ::File.symlink? symlink end
      notifies :reload, resources(:service => 'nginx')
    end
end
