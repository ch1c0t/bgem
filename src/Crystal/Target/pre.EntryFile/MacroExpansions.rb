def src_macros
  @src_macros ||= Dir['src.macros/*.erb', 'lib/*/src.macros/*.erb']
end

def macros
  @macros ||= src_macros.map { |file| Macro.new file }
end

def apply_macros
  macros.each do |macro|
    @lines, code = macro.process lines
    target_path.join("#{macro.name_in_snake_case}.cr").write code if code
  end
end
