def initialize(@options : Options)
end

def return_selected
  {:enter, @options["second"]}
end
