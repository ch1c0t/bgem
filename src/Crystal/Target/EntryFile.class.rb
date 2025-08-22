attr_reader :path_to_file, 
  :lines,
  :basename,
  :basename_without_ext,
  :path_to_related_files
def initialize path_to_file
  @path_to_file = path_to_file
  @lines = path_to_file.readlines
  @basename = path_to_file.basename
  @basename_without_ext = basename.to_s.delete_suffix '.cr'
  @path_to_related_files = path_to_file.dirname.join basename_without_ext
end

include Helpers
include MacroExpansions

def body
  lines.join
end

def compile
  target_path.mkpath
  apply_macros
  target_file.write <<~S.chomp
    #{preamble}
    #{body}
  S
end
