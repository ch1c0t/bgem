def initialize **kwargs
  @file_extension = kwargs[:file_extension]
  @type = kwargs[:type]
  @name = kwargs[:name]
  @dir = kwargs[:dir]
  @code = kwargs[:code]

  setup
end

attr_reader :file_extension, :type, :name, :dir, :code

def ext
  file_extension
end

def setup
end
