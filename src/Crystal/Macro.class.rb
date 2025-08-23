def initialize entry_file
  @entry_file = Pathname entry_file
end

include NameHelpers

def process lines
  code = nil

  lines.map! do |line|
    if line.include? "#{name_in_pascal_case}("
      code = create_code_for_line line
      line.sub /\s*\(.*?\)/, ''
    else
      line
    end
  end

  [lines, code]
end

def create_code_for_line line
  in_parens = line[/\(.*?\)/][1...-1]
  params = { in_parens: in_parens }
  Output.new(@entry_file, params: params).to_s
end
