include CR

def head
  if subclass?
    "abstract class #{@name} < #{@parent}\n"
  else
    "abstract class #{@name}\n"
  end
end
