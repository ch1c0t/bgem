def hook hook_name, default: false
  define_method hook_name do
    directory = @dir + "#{hook_name}.#{@name}"

    if default
      default_directory = @dir + @name
      directory = default_directory unless directory.directory?
    end

    concatenate sorted_files_in directory
  end
end
