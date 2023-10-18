attr_accessor :entry, :output, :scope
def initialize config_file
  @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
  DSL.new self, (IO.read config_file)

  @dir = Pathname File.dirname config_file
  define_macros
end

def define_macros
  rb_directory = @dir + 'rb'

  if rb_directory.directory?
    files = rb_directory.glob '*.rb'

    files.each do |file|
      n = file.basename.to_s.split('.').first
      k = Class.new { include Output::Ext::RB }
      to_s = "define_method :to_s do\n#{file.read}\nend"
      k.instance_eval to_s
      Output::Ext::RB.const_set n.capitalize, k
    end
  end
end
