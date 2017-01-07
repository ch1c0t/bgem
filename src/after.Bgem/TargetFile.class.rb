def initialize path = 'output.rb', scope = nil
  @path = Pathname path
  @scope = eval scope if scope
end

def write string
  @path.dirname.mkpath

  if @scope
    @scope.reverse_each do |head_of_constant_definition|
      string = "#{head_of_constant_definition}\n#{string.indent INDENT}\nend"
    end
  end

  @path.write string
end
