def hook hook_name, default: false
  define_method hook_name do
    directory = @dir + "#{hook_name}.#{@name}"

    if default
      default_directory = @dir + @name
      directory = default_directory unless directory.directory?
    end

    patterns = file_extensions.map do |ext|
      directory.join "*.#{ext}"
    end

    concatenate *patterns
  end
end
