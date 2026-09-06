def head
  if subclass?
    "struct #{@name} < #{@parent}\n"
  else
    "struct #{@name}\n"
  end
end
