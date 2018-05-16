class File
  def initialize file
    head, @type, _rb = file.basename.to_s.split '.'
    @source, @dirname = file.read, file.dirname
    @constant, _colon, @ancestor = head.partition ':'
  end

  attr_reader :constant

  def to_s
    "#{head}#{source}end"
  end

  private
    def head
      if @ancestor.empty?
        "#{@type} #{@constant}\n"
      else
        "#{@type} #{@constant} < #{@ancestor}\n"
      end
    end

    def source
      source = @source.indent INDENT
      source.prepend "#{pre}\n\n" unless pre.empty?
      source.prepend "#{before}\n\n" unless before.empty?
      source.concat "\n#{after}\n" unless after.empty?
      source
    end

    def self.define_appendix name
      define_method name do
        pattern = @dirname.join "#{__method__}.#{@constant}/*.rb"
        concatenate pattern
      end
    end

    [:pre, :before].each { |name| define_appendix name }

    def after
      patterns = ["#{@constant}/*.rb", "after.#{@constant}/*.rb"].map do |pattern|
        @dirname.join pattern
      end

      concatenate *patterns
    end

    def concatenate *patterns
      Dir[*patterns].sort.map do |file|
        Output.new(file, indent: INDENT).to_s
      end.join "\n\n"
    end

  class Module < self
  end

  class Class < self
  end
end

PATHS = {
  'rb' => {
    'module' => File::Module,
    'class'  => File::Class,
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
