def initialize file = SOURCE_FILE, indent: 0
  file, @indent = (Pathname file), indent

  *chain, file_extension = file.basename.to_s.split '.'

  if Ext.const_defined? file_extension.upcase
    @output = Ext.new file_extension: file_extension, dir: file.dirname, code: file.read, chain: chain
  else
    fail "Don't know what to do with #{file}. Bgem::Output::Ext::#{file_extension.upcase} is not defined."
  end
end

def to_s
  @output.to_s.indent @indent
end
