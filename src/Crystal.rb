Exts.constants.each do |symbol|
  Bgem::Output::Exts.const_set symbol, (Exts.const_get symbol)
end

extend self

def make
  Project.new
  exit
end
