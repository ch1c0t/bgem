include CR

def head
  "lib #{@name}\n"
end

def body
  code = @code
  code = @code.prepend("#{structs}\n") if structs
  code = @code.prepend("#{constants}\n") if constants
  @body ||= code.indent INDENT
end

def constants_file
  @constants_file ||= dir.join "#{@name}/constants.cr"
end

def constants
  @constants ||= begin
    if constants_file.file?
      string = constants_file.read
      string.ending_with_newline
    end
  end
end

def struct_files
  @struct_files ||= dir.glob "#{@name}/structs/*.cr"
end

def structs
  @structs ||= begin
    unless struct_files.empty?
      struct_files.map do |file|
        name = file.sub_ext('').basename
        content = file.read.indent INDENT
        "struct #{name}\n#{content.ending_with_newline}end"
      end.join("\n\n") + "\n"
    end
  end
end
