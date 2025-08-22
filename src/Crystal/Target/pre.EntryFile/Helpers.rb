def target_file
  @target_file ||= Pathname "src/bin/#{basename}"
end

def target_path
  @target_path ||= Pathname "src/bin/#{basename_without_ext}"
end

def shard_version
  YAML.load_file('shard.yml')['version']
end

def preamble
  <<~S
    require "./#{basename_without_ext}/*"

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
end
