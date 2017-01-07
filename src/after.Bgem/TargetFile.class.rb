def initialize path
  @path = Pathname path
end

def write string
  @path.dirname.mkpath
  @path.write string
end
