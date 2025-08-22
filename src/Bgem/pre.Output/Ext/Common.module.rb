def initialize **kwargs
  @file_extension = kwargs[:file_extension]
  @type = kwargs[:type]
  @name = kwargs[:name]
  @dir = kwargs[:dir]
  @code = kwargs[:code]
  @params = kwargs[:params]

  setup
end

attr_reader :file_extension, :type, :name, :dir, :code, :params

def ext
  file_extension
end

def setup
end
