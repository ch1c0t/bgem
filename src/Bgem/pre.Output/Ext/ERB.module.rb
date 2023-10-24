def self.new dir:, source:, chain:
  name, type = chain
  type ||= 'default'
  constant_name = type.capitalize

  if self.const_defined? constant_name
    constant = self.const_get constant_name
  else
    fail "Don't know what to do with '#{type}'. #{self}::#{constant_name} is not defined."
  end

  constant.new dir: dir, code: source, name: name, type: type
end

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
