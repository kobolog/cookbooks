module Erubis
  class NoTemplateError < IOError; end

  class Context
    def include_template(name, args)

			path = File.join @node[:nginx][:dirs][:templates], "#{name}.erb"
			if File.exists? path
				Chef::Log.debug "[nginx] Including template #{name} with #{args.inspect}"

        source = File.open(path) { |file| Eruby.new file.read }
        context = Context.new self
        context[:args] = args

        return source.evaluate context
			else
				path = File.join @node[:nginx][:dirs][:custom_templates], "#{name}.erb"

        raise NoTemplateError,
          "Unable to locate '#{name}' template" unless File.exists? path

        Chef::Log.debug "[nginx] Including custom template #{name} with #{args.inspect}"

        source = File.open(path) { |file| Eruby.new file.read }
        context = Context.new self
        context[:args] = args

        return source.evaluate context
			end

    end
    
    def parse_command(command, args)
      begin
        include_template command, (args or {})
      rescue NoTemplateError
        "#{command} #{args};"
      end
    end
  end
end
