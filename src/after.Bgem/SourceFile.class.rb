INDENT = 2

def initialize file, indent: 0
  @file, @indent = (Pathname file), indent
  @source = @file.read
  @constant, @type, _rb = @file.basename.to_s.split '.'
end

def to_s
  "#{@type} #{@constant}\n#{source}end".indent @indent
end

private
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
        Pathname.glob(pattern).map do |file|
          self.class.new(file, indent: INDENT).to_s
        end.join "\n\n"
      end
    end
  end

  concatenate_source_files :before, :after
