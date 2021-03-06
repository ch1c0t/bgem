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
    source.prepend "#{before}\n\n" unless before.empty?
    source.concat "\n#{after}\n" unless after.empty?
    source
  end

  def self.concatenate_source_files *symbols
    symbols.each do |symbol|
      define_method symbol do
        pattern =  @file.dirname.join "#{__method__}.#{@constant}/*.rb"
        Dir[pattern].sort.map do |file|
          self.class.new(file, indent: INDENT).to_s
        end.join "\n\n"
      end
    end
  end

  concatenate_source_files :before, :after
