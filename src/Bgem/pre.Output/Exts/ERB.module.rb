def initialize **kwargs
  @file_extension = kwargs[:file_extension]
  @type = kwargs[:type]
  @name = kwargs[:name]
  @dir = kwargs[:dir]
  @code = kwargs[:code]
end

attr_reader :dir, :type, :name, :code

def ext
  @file_extension
end
