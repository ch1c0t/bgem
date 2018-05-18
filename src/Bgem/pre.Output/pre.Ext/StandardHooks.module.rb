def pre
  pattern = @dir.join "#{__method__}.#{@name}/*.rb"
  concatenate pattern
end

def post
  patterns = ["#{@name}/*.rb", "post.#{@name}/*.rb"].map do |pattern|
    @dir.join pattern
  end

  concatenate *patterns
end

def concatenate *patterns
  Dir[*patterns].sort.map do |file|
    Output.new(file, indent: INDENT).to_s
  end.join "\n\n"
end
