def setup
  @name, _colon, @parent = @name.partition ':'
end

def head
  if subclass?
    "class #{@name} < #{@parent}\n"
  else
    "class #{@name}\n"
  end
end

def subclass?
  not @parent.empty?
end
