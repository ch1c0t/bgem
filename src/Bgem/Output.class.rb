def initialize file = SOURCE_FILE, indent: 0
  file, @indent = (Pathname file), indent

  *chain, last = file.basename.to_s.split '.'
  name = last.upcase
  source = file.read
  dir = file.dirname

  if Ext.const_defined? name
    ext = Ext.const_get name
  else
    fail "Don't know what to do with #{file}. Bgem::Output::Ext::#{name} is not defined."
  end

  @output = ext.new dir: dir, source: source, chain: chain
end

def to_s
  @output.to_s.indent @indent
end
