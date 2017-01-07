require 'pathname'

class ::String
  def indent number
    lines.map { |line| "#{' '*number}#{line}" }.join
  end
end
