def initialize config_file
  @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
  DSL.new self, (IO.read config_file)
end

attr_accessor :entry, :output, :scope

class DSL
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
end
