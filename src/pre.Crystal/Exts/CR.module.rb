include Bgem::Output::Ext::Common
include Bgem::Output::Ext::StandardHooks

def self.default
  'module'
end

attr_reader :head

def to_s
  code = "#{head}#{body}end"
  code.prepend requiring_part if requiring_part
  code
end

def body
  code = @code.indent INDENT
  code.prepend "#{pre}\n\n" unless pre.empty?
  code.concat "\n#{post}\n" unless post.empty?
  code
end

def requiring_part
  @requiring_part ||= begin
                        file = dir.join "#{name}.require"
                        if file.file?
                          file.readlines.map do |line|
                            'require ' + '"' + line.chomp + '"'
                          end.join("\n").concat("\n\n")
                        end
                      end
end
