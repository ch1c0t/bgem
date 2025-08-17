module Bgem
  module Crystal
    module Exts
    
      module CR
        include Bgem::Output::Ext::Common
        include Bgem::Output::Ext::StandardHooks
        
        def self.default
          'module'
        end
        
        attr_reader :head
        
        def to_s
          "#{head}#{body}end"
        end
        
        def body
          wrap code
        end
        
        def wrap code
          code = @code.indent INDENT
          code.prepend "#{pre}\n\n" unless pre.empty?
          code.concat "\n#{post}\n" unless post.empty?
          code
        end
      
        class Class
          include CR
          
          def setup
            @name, _colon, @parent = @name.partition ':'
          end
          
          def head
            if subclass?
              "class #{@name} < #{@parent}\n"
            else
              "class #{@name}\n"
            end
          end
          
          def subclass?
            not @parent.empty?
          end
        end
      
        class Module
          include CR
          
          def head
            "module #{@name}\n"
          end
        end
      end
    end
  
    Exts.constants.each do |symbol|
      Bgem::Output::Exts.const_set symbol, (Exts.const_get symbol)
    end
    
    extend self
    
    def make
      Project.new
      exit
    end
  
    class Project
      def initialize
        @source_dir = SourceDir.new Pathname 'src.source'
        @entry_files_in_bin = @source_dir.entry_files_in_bin
      
        make_src_bin
        update_shard_targets
        make_src
      end
      
      def make_src_bin
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
      
      def make_src
        @source_dir.entry_files.each(&:compile)
      end
    
      class SourceDir
        attr_reader :path
        def initialize path
          fail "#{path} is not a directory" unless path.directory?
          @path = path
        end
        
        def entry_files_in_bin
          path.glob 'bin/*.cr'
        end
        
        def entry_files
          @entry_files ||= path.glob('*.cr').map do |file|
            EntryFile.new file
          end
        end
      
        class EntryFile
          attr_reader :path
          def initialize path
            @path = path
          end
          
          def name_in_pascal_case
            @name_in_pascal_case ||= path.basename.to_s.split('.')[0]
          end
          
          def name_in_snake_case
            @name_in_snake_case ||= name_in_pascal_case
              .split(/([A-Z][a-z]+)/)
              .delete_if(&:empty?)
              .map(&:downcase)
              .join('_')
          end
          
          def target_file
            @target_file ||= Pathname "src/#{name_in_snake_case}.cr"
          end
          
          def output
            @output ||= Bgem::Output.new path
          end
          
          def compile
            target_file.write output.to_s
          end
        end
      end
    end
  
    class Target
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
    end
  end
end
