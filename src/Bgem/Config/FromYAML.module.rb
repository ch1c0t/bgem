extend self

def [] config, path_to_config
  yml = YAML.load_file path_to_config

  if outputs = yml['outputs']
    config.outputs = outputs.map do |name, path_to_file|
      output = Output.new path_to_file
      output.set_entry_from_prefix name
      output
    end
  else
    fail "A YAML config must define a Hash with the field 'outputs'. #{path_to_config} does not."
  end
end
