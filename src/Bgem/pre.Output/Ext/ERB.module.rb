def initialize **kwargs
  @dir = kwargs[:dir]
  @code = kwargs[:code]
  @name = kwargs[:name]
  @type = kwargs[:type]
end

attr_reader :dir, :type, :name, :code

def ext
  'erb'
end
