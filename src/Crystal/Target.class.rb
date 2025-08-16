class ::Pathname
  def binpath
    @binpath ||= dirname.join basename.to_s.delete_suffix '.cr'
  end

  def help_file
    binpath.join 'help'
  end
end

attr_reader :entry_file, :basename, :dirname
def initialize entry_file
  @src_bin = Pathname 'src/bin'
  @src_bin.mkpath

  @entry_file = entry_file
  @basename = entry_file.basename
  @dirname = basename.to_s.delete_suffix '.cr'

  make_target_file
  make_help_file
end

def shard_version
  YAML.load_file('shard.yml')['version']
end

def make_target_file
  main_body = entry_file.read
  preamble = <<~S
    require "./#{dirname}/*"

    VERSION = "#{shard_version}"

    case ARGV.size
    when 1
      case ARGV[0]
      when "-v", "version", "--version"
        puts VERSION
        exit
      when "-h", "help", "--help"
        print_help
        exit
      end
    end
  S

  target_file = @src_bin.join basename
  target_file.write <<~S.chomp
    #{preamble}
    #{main_body}
  S
end

def make_help_file
  path = @src_bin.join(dirname)
  path.mkpath

  file = path.join 'print_help.cr'
  file.write source_to_print_help
end

def source_to_print_help
  message = if entry_file.help_file.file?
    entry_file.help_file.read
  else
    "A help message for #{dirname}."
  end

  <<~HELP
    HELP_MESSAGE = <<-S
    #{message.chomp}
    S

    def print_help
      puts HELP_MESSAGE
    end
  HELP
end
