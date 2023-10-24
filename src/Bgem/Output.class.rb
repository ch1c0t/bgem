def initialize file = SOURCE_FILE, indent: 0
  file, @indent = (Pathname file), indent

  parts = file.basename.to_s.split '.'

  case parts.size
  when 3
    name, type, file_extension = parts
  when 2
    name, file_extension = parts
  else
    fail "#{file} has more than two dots in its name."
  end

  if Ext.const_defined? file_extension.upcase
    @output = Ext.new file_extension: file_extension, type: type, name: name, dir: file.dirname, code: file.read
  else
    fail "Don't know what to do with #{file}. Bgem::Output::Ext::#{file_extension.upcase} is not defined."
  end
end

def to_s
  @output.to_s.indent @indent
end
