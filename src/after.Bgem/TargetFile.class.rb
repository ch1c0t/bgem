def initialize path = 'output.rb', scope = nil
  @path = Pathname path
  @scope = case scope
           when Array
             scope
           when String
             eval scope
           end
end

def write string
  @path.dirname.mkpath

  if @scope
    @scope.reverse_each do |head_of_constant_definition|
      string = "#{head_of_constant_definition}\n#{string.indent INDENT}\nend"
    end
  end

  @path.write "#{string}\n"
end

def file
  @path
end
