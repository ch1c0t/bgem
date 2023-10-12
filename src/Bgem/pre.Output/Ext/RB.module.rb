def self.new dir:, source:, chain:
  name, type = chain
  type ||= 'module'
  constant = type.capitalize

  if self.const_defined? constant
    type = self.const_get constant
  else
    fail "Don't know what to do with '#{type}'. #{self}::#{constant} is not defined."
  end

  type.new dir: dir, source: source, name: name
end

def initialize dir:, source:, name:
  @dir, @source, @name = dir, source, name
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
    source.concat "\n#{post}\n" unless post.empty?
    source
  end
