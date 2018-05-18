def self.new dir:, source:, chain:
  unless chain.size == 2
    fail "#{chain}' size should be 2"
  end

  name, type = chain
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
    source.prepend "#{before}\n\n" unless before.empty?
    source.concat "\n#{after}\n" unless after.empty?
    source
  end
