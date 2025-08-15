extend self

def [] config, outputs
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
end
