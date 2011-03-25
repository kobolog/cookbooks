@@tracked = Hash.new do |hash, key|
  Chef::Log.info "[tracker] Initializing tracker for '#{key}/'"
  hash[key] = Array.new
end

action :track do
  Chef::Log.debug "[tracker] Tracking '#{new_resource.file}'"
  @@tracked[new_resource.path] += [new_resource.file]
end

action :cleanup do
  orphans = ::Dir.glob(::File.join(new_resource.path, '*')) - @@tracked[new_resource.path]
  orphans.each do |file|
    Chef::Log.info("[tracker] - Removing orphaned file '#{file}'")
    ::File.unlink file
  end
end
