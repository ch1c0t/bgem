Exts.constants.each do |symbol|
  exts = Bgem::Output::Exts
  (exts.send :remove_const, symbol) if exts.const_defined? symbol
  exts.const_set symbol, (Exts.const_get symbol)
end

extend self

def make
  Project.new
  exit
end
