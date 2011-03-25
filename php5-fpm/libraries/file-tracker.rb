class FileTracker
    @tracked = Hash.new { |hash, key| hash[key] = Array.new }

    def self.track(file)
        path = File.dirname(file)

        if path == "."
            Chef::Log.warn("[FileTracker] - Ignoring #{file}. Paths must be absolute!")
            return
        end
        
        @tracked[path] += [file]
    end
    
    def self.cleanup()
        @tracked.each_pair do |directory, files|
            orphans = Dir.glob(File.join(directory, "*")) - files
            orphans.each do |file|
                Chef::Log.info("[FileTracker] - Removing oprhaned file: #{file}")
                File.unlink(file)
            end
        end
    end
end

