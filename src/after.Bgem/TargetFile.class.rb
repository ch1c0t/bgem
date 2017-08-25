def initialize path = 'output.rb', scope
  @path = Pathname path
  @scope = scope
end

def write string
  @path.dirname.mkpath

  if @scope
    @scope.each do |header|
      string = "#{header}\n#{string.indent INDENT}\nend"
    end
  end

  @path.write "#{string}\n"
end

def file
  @path
end
