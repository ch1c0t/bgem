require 'pathname'

using Module.new {
  refine String do
    def indent number
      lines.map { |line| "#{' '*number}#{line}" }.join
    end
  end
}

INDENT = 2
SOURCE_FILE = Dir['src/*.rb'][0]
