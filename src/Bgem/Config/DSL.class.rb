def initialize config, code
  @config = config
  instance_eval code
end

def entry file
  @config.entry = file
end

def output file
  @config.output = file
end

def inside *headers
  @config.scope = headers
end
