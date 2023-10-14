EXTs = [
  'rb',
  'erb',
]

def hook hook_name, default: false
  define_method hook_name do
    stubs = ["#{hook_name}.#{@name}/*."]

    if default
      stubs << "#{@name}/*."
    end

    patterns = EXTs.flat_map do |ext|
      stubs.map do |string|
        @dir.join (string + ext)
      end
    end

    concatenate *patterns
  end
end
