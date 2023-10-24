attr_accessor :entry, :output, :scope
def initialize config_file
  @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
  DSL.new self, (IO.read config_file)

  @dir = Pathname File.dirname config_file
  define_macros
end

def define_macros
  Output::Ext.types.map do |type|
    dir = @dir + type.to_s
    MacroDir.new(type, dir) if dir.directory?
  end.compact.each do |macro_dir|
    macro_dir.define_macros
  end
end
