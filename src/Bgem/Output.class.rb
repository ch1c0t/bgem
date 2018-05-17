def initialize file = SOURCE_FILE, indent: 0
  file, @indent = (Pathname file), indent
  name = file.basename.to_s.split('.').last.upcase

  if Ext.const_defined? name
    ext = Ext.const_get name
  else
    fail "Don't know what to do with #{file}. Bgem::Output::Ext::#{name} is not defined."
  end

  @output = ext.new file
end

def to_s
  @output.to_s.indent @indent
end
