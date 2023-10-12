def initialize file = SOURCE_FILE, indent: 0
  file, @indent = (Pathname file), indent

  *chain, last = file.basename.to_s.split '.'
  ext = last.upcase
  source = file.read
  dir = file.dirname

  if Ext.const_defined? ext
    e = Ext.const_get ext
  else
    fail "Don't know what to do with #{file}. Bgem::Output::Ext::#{ext} is not defined."
  end

  @output = e.new dir: dir, source: source, chain: chain
end

def to_s
  @output.to_s.indent @indent
end
