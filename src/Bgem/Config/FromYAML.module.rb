extend self

def [] config, path_to_config
  yml = YAML.load_file path_to_config

  if outputs = yml['outputs']
    config.outputs = outputs.map do |name, spec|
      case spec
      when String
        path_to_file = spec
        output = Output.new path_to_file
        output.set_entry_from_prefix name
      when Hash
        output = Output.new spec['to']
        output.set_entry_from_prefix name

        scope = spec['inside']
        case scope
        when String
          output.scope = [scope]
        when Array
          output.scope = scope
        end
      end

      output
    end
  else
    fail "A YAML config must define a Hash with the field 'outputs'. #{path_to_config} does not."
  end
end
