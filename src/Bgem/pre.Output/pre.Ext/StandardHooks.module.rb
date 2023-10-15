extend DSL

hook :post, default: true
hook :pre

def concatenate files
  files.map do |file|
    Output.new(file, indent: INDENT).to_s
  end.join "\n\n"
end

def file_extensions
  constants = Bgem::Output::Ext.constants
  constants.delete :StandardHooks
  constants.map &:downcase
end

def sorted_files_in directory
  patterns = file_extensions.map do |ext|
    directory.join "*.#{ext}"
  end

  Dir[*patterns].sort
end
