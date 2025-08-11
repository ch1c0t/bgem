def initialize output
  @file = Pathname output.file
  @scope = output.scope
end

attr_reader :file

def [] string
  file.dirname.mkpath

  if @scope
    @scope.each do |header|
      string = "#{header}\n#{string.indent INDENT}\nend"
    end
  end

  file.write "#{string}\n"
end
