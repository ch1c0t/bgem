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

def output file
  @config.outputs[0].file = file
end
