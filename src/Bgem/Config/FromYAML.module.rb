extend self

def [] config, path_to_config
  yml = YAML.load_file path_to_config

  if outputs = yml['outputs']
    ParseOutputs[config, outputs]
  end

  if target = yml['make']
    case target
    when 'crystal.app'
      require 'bgem/crystal'
      Bgem::Crystal.make
    end
  end
end
