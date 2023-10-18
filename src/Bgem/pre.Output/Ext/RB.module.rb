def self.new dir:, source:, chain:
  name, type = chain
  type ||= 'module'
  constant_name = type.capitalize

  if self.const_defined? constant_name
    constant = self.const_get constant_name
  else
    fail "Don't know what to do with '#{type}'. #{self}::#{constant_name} is not defined."
  end

  constant.new dir: dir, code: source, name: name, type: type
end

def initialize dir:, code:, name:, type:
  @dir, @code, @name, @type = dir, code, name, type
  setup
end

attr_reader :head, :type, :name, :code

def to_s
  "#{head}#{body}end"
end

def ext
  'rb'
end

def setup
end

include StandardHooks

def body
  wrap code
end

def wrap code
  code = @code.indent INDENT
  code.prepend "#{pre}\n\n" unless pre.empty?
  code.concat "\n#{post}\n" unless post.empty?
  code
end
