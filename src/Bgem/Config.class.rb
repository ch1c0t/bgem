attr_accessor :outputs
def initialize config_file
  @outputs = [Output.new]
  DSL.new self, (IO.read config_file)

  @dir = Pathname File.dirname config_file
  define_macros
end

def define_macros
  Bgem::Output::Ext.file_extensions.map do |type|
    dir = @dir + type.to_s
    MacroDir.new(type, dir) if dir.directory?
  end.compact.each do |macro_dir|
    macro_dir.define_macros
  end
end
