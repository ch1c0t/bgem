def initialize config_file
  @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
  DSL.new self, config_file
end

attr_accessor :entry, :output, :scope

class DSL
  def initialize config, file
    @config = config
    instance_eval IO.read file
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
