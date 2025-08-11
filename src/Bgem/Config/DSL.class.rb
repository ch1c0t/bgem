def initialize config, code
  @config = config
  instance_eval code
end

def entry file
  @config.outputs[0].entry = file
end

def inside *headers
  @config.outputs[0].scope = headers
end

def output file_or_type = :ruby, &block
  if block_given?
    p 'from output block'
    instance_eval &block
  else
    case file_or_type
    when String
      path_to_file = file_or_type
      @config.outputs[0].file = path_to_file
    end
  end
end

def from name, file
  first_output = @config.outputs[0]

  if first_output.file.nil?
    new_output = Output.new file
    new_output.set_entry_from_prefix name
    @config.outputs << new_output
  else
    first_output.set_entry_from_prefix name
    first_output.file = file
  end
end
