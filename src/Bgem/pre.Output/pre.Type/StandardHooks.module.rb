def self.define_appendix name
  define_method name do
    pattern = @dirname.join "#{__method__}.#{@name}/*.rb"
    concatenate pattern
  end
end

[:pre, :before].each { |name| define_appendix name }

def after
  patterns = ["#{@name}/*.rb", "after.#{@name}/*.rb"].map do |pattern|
    @dirname.join pattern
  end

  concatenate *patterns
end

def concatenate *patterns
  Dir[*patterns].sort.map do |file|
    Output.new(file, indent: INDENT).to_s
  end.join "\n\n"
end
