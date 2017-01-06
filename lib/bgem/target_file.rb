module Bgem
  class TargetFile
    def initialize path
      @path = Pathname path
    end

    def write string
      @path.dirname.mkpath
      @path.write string
    end
  end
end
