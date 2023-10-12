EXTs = [
  'rb',
  'erb',
]

def pre
  patterns = EXTs.flat_map do |ext|
    ["pre.#{@name}/*.#{ext}"].map do |pattern|
      @dir.join pattern
    end
  end

  concatenate *patterns
end

def post
  patterns = EXTs.flat_map do |ext|
    ["#{@name}/*.#{ext}", "post.#{@name}/*.#{ext}"].map do |pattern|
      @dir.join pattern
    end
  end

  concatenate *patterns
end

def concatenate *patterns
  Dir[*patterns].sort.map do |file|
    Output.new(file, indent: INDENT).to_s
  end.join "\n\n"
end
