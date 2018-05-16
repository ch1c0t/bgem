PATHS = {
  'rb' => {
    'module' => Type::Module,
    'class'  => Type::Class,
  },
}

def initialize file = SOURCE_FILE, indent: 0, paths: PATHS
  file, @indent = (Pathname file), indent
  path = file.basename.to_s.split('.').last(2).reverse
  type = paths.dig *path
  @output = type.new file
end

def to_s
  @output.to_s.indent @indent
end
