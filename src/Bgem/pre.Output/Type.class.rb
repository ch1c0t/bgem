def initialize file
  @name, _type, _rb = file.basename.to_s.split '.'
  @source, @dirname = file.read, file.dirname
  setup
end

def to_s
  "#{head}#{source}end"
end

private
  def setup
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
      pattern = @dirname.join "#{__method__}.#{@name}/*.rb"
      concatenate pattern
    end
  end

  [:pre, :before].each { |name| define_appendix name }

  def after
    patterns = ["#{@name}/*.rb", "after.#{@name}/*.rb"].map do |pattern|
      @dirname.join pattern
    end

    concatenate *patterns
  end

  def concatenate *patterns
    Dir[*patterns].sort.map do |file|
      Output.new(file, indent: INDENT).to_s
    end.join "\n\n"
  end
