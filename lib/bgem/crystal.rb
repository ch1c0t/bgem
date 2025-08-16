module Bgem
  module Crystal
    extend self
    
    def make
      Project.new
      exit
    end
  
    class Project
      def initialize
        @source_dir = Pathname 'src.source'
        fail "Expected to find a source directory at #{@source_dir}" unless @source_dir.directory?
      
        make_src_bin
        update_shard_targets
      end
      
      def make_src_bin
        @entry_files_in_bin = @source_dir.glob('bin/*.cr')
        @entry_files_in_bin.each do |file|
          Target.new file
        end
      end
      
      def update_shard_targets
        file = Pathname 'shard.yml'
        data = YAML.load_file file
      
        data['targets'] = @entry_files_in_bin.map do |entry_file|
          basename = entry_file.basename
          target_name = basename.to_s.delete_suffix('.cr')
          [target_name, { 'main' => "src/bin/#{basename}" }]
        end.to_h
      
        file.write data.to_yaml
      end
    end
  
    class Target
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
      
        help_file = path.join 'print_help.cr'
        help_message = <<~HELP
          HELP_MESSAGE = <<-S
          A help message for puts.
          S
      
          def print_help
            puts HELP_MESSAGE
          end
        HELP
      
        help_file.write help_message
      end
    end
  end
end
