def initialize(@name : String)
end

def enter
  puts "Entering a session: #{@name}"
end

def restart
  puts "Restarting a session: #{@name}"
end

def to_s
  @name
end
