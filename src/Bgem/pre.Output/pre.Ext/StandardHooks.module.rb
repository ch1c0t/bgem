extend DSL

hook :post, default: true
hook :pre

def concatenate *patterns
  Dir[*patterns].sort.map do |file|
    Output.new(file, indent: INDENT).to_s
  end.join "\n\n"
end
