def src_macros
  @src_macros ||= Pathname 'src.macros'
end

def macros
  @macros ||= src_macros.glob('*.erb').map { |file| Macro.new file }
end

def apply_macros
  macros.each do |macro|
    @lines, code = macro.process lines
    target_path.join("#{macro.name_in_snake_case}.cr").write code if code
  end
end
