require 'pathname'

class String
  def indent number
    lines.map { |line| "#{' '*number}#{line}" }.join
  end
end

require 'bgem/cli'
require 'bgem/target_file'
require 'bgem/source_file'
