def self.run
  case ARGV[0]
  when '-v', '--version'
    puts VERSION
  else
    Bgem.run
  end
end
