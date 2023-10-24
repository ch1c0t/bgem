def self.default
  'module'
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
