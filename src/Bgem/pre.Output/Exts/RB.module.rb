include Ext::Common
include Ext::StandardHooks

def self.default
  'module'
end

attr_reader :head

def to_s
  "#{head}#{body}end"
end

def body
  wrap code
end

def wrap code
  code = @code.indent INDENT
  code.prepend "#{pre}\n\n" unless pre.empty?
  code.concat "\n#{post}\n" unless post.empty?
  code
end
