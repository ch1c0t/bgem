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

  files = Dir[*patterns]
  order_file = directory.join 'order'

  if order_file.exist?
    sort_with_order_file order_file, files
  else
    files.sort
  end
end

def sort_with_order_file order_file, files
  order = order_file.readlines.map &:chomp

  files_ordered_to_be_first = order.inject([]) do |array, name|
    files_starting_with_name = files.select do |file|
      basename = File.basename file
      basename.start_with? "#{name}."
    end
    array += files_starting_with_name
  end

  other_files = files - files_ordered_to_be_first
  files_ordered_to_be_first += other_files.sort
end
