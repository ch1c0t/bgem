attr_accessor :entry, :output, :scope
def initialize config_file
  @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
  DSL.new self, (IO.read config_file)
end
