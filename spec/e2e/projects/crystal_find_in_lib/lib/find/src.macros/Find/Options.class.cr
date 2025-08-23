def self.from(array : Array(Value))
  lines = array.map &.to_s
  hash = Hash.zip lines, array
  Options.new hash
end

@hash : Hash(String, Value)
def initialize(@hash)
end

def as_lines
  @hash.keys
end

def [](key)
  @hash[key]
end
