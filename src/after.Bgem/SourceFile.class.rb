def initialize file = SOURCE_FILE, indent: 0
  @file, @indent = (Pathname file), indent
  @source = @file.read
  head, @type, _rb = @file.basename.to_s.split '.'
  @constant, _colon, @ancestor = head.partition ':'
end

def to_s
  "#{head}#{source}end".indent @indent
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
      pattern = @file.dirname.join "#{__method__}.#{@constant}/*.rb"
      Dir[pattern].sort.map do |file|
        self.class.new(file, indent: INDENT).to_s
      end.join "\n\n"
    end
  end

  [:pre, :before].each { |name| define_appendix name }

  def after
    patterns = ["#{@constant}/*.rb", "after.#{@constant}/*.rb"].map do |pattern|
      @file.dirname.join pattern
    end

    Dir[*patterns].sort.map do |file|
      self.class.new(file, indent: INDENT).to_s
    end.join "\n\n"
  end
