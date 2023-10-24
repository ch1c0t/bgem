def self.default
  'module'
end

def initialize file_extension:, type:, name:, dir:, code:
  @file_extension, @type, @name, @dir, @code = file_extension, type, name, dir, code
  setup
end

attr_reader :head, :type, :name, :code

def to_s
  "#{head}#{body}end"
end

def ext
  @file_extension
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
