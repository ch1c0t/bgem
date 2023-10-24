def initialize type, dir
  @type, @dir = type, dir
  @constant = Output::Ext.const_get @type.upcase
end

def define_macros
  files = @dir.glob '*.rb'

  files.each do |file|
    n = file.basename.to_s.split('.').first
    constant = @constant; k = Class.new { include constant }
    to_s = "define_method :to_s do\n#{file.read}\nend"
    k.instance_eval to_s
    constant.const_set n.capitalize, k
  end
end
