def self.new file
  type = file.basename.to_s.split('.')[-2]

  type = case type
  when 'module'
    Module
  when 'class'
    Class
  else
    fail "Don't know what to do with #{type}"
  end

  type.new file
end

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

  include StandardHooks

  def source
    source = @source.indent INDENT
    source.prepend "#{pre}\n\n" unless pre.empty?
    source.prepend "#{before}\n\n" unless before.empty?
    source.concat "\n#{after}\n" unless after.empty?
    source
  end
