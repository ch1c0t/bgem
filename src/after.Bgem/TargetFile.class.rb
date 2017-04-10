def initialize path = 'output.rb', scope
  @path = Pathname path
  @scope = scope
end

def write string
  @path.dirname.mkpath

  if @scope
    @scope.each do |head_of_constant_definition|
      string = "#{head_of_constant_definition}\n#{string.indent INDENT}\nend"
    end
  end

  @path.write "#{string}\n"
end

def file
  @path
end
