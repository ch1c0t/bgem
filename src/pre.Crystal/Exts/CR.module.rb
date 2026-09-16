include Bgem::Output::Ext::Common
include Bgem::Output::Ext::StandardHooks

include ExtHelpers::Preamble
include ExtHelpers::RequiringPart

def self.default
  'module'
end

attr_reader :head

def to_s
  code = "#{head}#{body}end"
  code.prepend preamble if preamble
  code.prepend requiring_part if requiring_part
  code
end

def body
  code = @code.indent INDENT
  code.prepend "#{pre}\n\n" unless pre.empty?
  code.concat "\n#{post}\n" unless post.empty?
  code
end
