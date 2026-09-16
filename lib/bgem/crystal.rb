module Bgem
  module Crystal
    module ExtHelpers
    
      module RequiringPart
        def requiring_part
          @requiring_part ||= begin
                                file = dir.join "#{name}.require"
                                if file.file?
                                  file.readlines.map do |line|
                                    'require ' + '"' + line.chomp + '"'
                                  end.join("\n").concat("\n\n")
                                end
                              end
        end
      end
    end
  
    module Exts
    
      module CR
        include Bgem::Output::Ext::Common
        include Bgem::Output::Ext::StandardHooks
        include ExtHelpers::RequiringPart
        
        def self.default
          'module'
        end
        
        attr_reader :head
        
        def to_s
          code = "#{head}#{body}end"
          code.prepend requiring_part if requiring_part
          code
        end
        
        def body
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
      
        class AbstractClass < Class
          include CR
          
          def head
            if subclass?
              "abstract class #{@name} < #{@parent}\n"
            else
              "abstract class #{@name}\n"
            end
          end
        end
      
        class AbstractStruct
          include CR
          
          def head
            "abstract struct #{@name}\n"
          end
        end
      
        class Lib
          include CR
          
          def head
            "lib #{@name}\n"
          end
        end
      
        class Module
          include CR
          
          def head
            "module #{@name}\n"
          end
        end
      
        class Struct < Class
          def head
            if subclass?
              "struct #{@name} < #{@parent}\n"
            else
              "struct #{@name}\n"
            end
          end
        end
      end
    
      module ERB
        include Bgem::Output::Ext::Common
      
        class Default
          include ERB
          
          class Context
            def env
              binding
            end
          end
          
          def to_s
            require 'erb'
          
            env = Context.new.env
            params.each do |name, value|
              env.local_variable_set name, value
            end
          
            renderer = ::ERB.new code
            code = renderer.result env
          
            crystal code
          end
          
          def crystal code
            type = 'module' if type == 'default'
            cr = Bgem::Output::Ext.new file_extension: 'cr', type: type, name: name, dir: dir, code: code, params: params
            cr.to_s
          end
        end
      end
    end
  
    module NameHelpers
      def name_in_pascal_case
        path = @path || @entry_file
        @name_in_pascal_case ||= path.basename.to_s.split('.')[0]
      end
      
      def name_in_snake_case
        @name_in_snake_case ||= begin
          name = name_in_pascal_case
          name = name.include?(':') ? name.split(':')[0] : name
          name.to_snake_case
        end
      end
    end
  
    Exts.constants.each do |symbol|
      exts = Bgem::Output::Exts
      (exts.send :remove_const, symbol) if exts.const_defined? symbol
      exts.const_set symbol, (Exts.const_get symbol)
    end
    
    extend self
    
    def make
      Project.new
      exit
    end
  
    class Macro
      def initialize entry_file
        @entry_file = Pathname entry_file
      end
      
      include NameHelpers
      
      def process lines
        code = nil
      
        lines.map! do |line|
          if line.include? "#{name_in_pascal_case}("
            code = create_code_for_line line
            line.sub /\s*\(.*?\)/, ''
          else
            line
          end
        end
      
        [lines, code]
      end
      
      def create_code_for_line line
        in_parens = line[/\(.*?\)/][1...-1]
        params = { in_parens: in_parens }
        Output.new(@entry_file, params: params).to_s
      end
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
          Target.new(file).compile
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
        Pathname('src').mkpath
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
          
          include NameHelpers
          
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
      def initialize entry_file
        @entry_file = EntryFile.new entry_file
        @help_file = HelpFile.new @entry_file
      end
      
      def compile
        @entry_file.compile
        @help_file.compile
      end
    
      class EntryFile
        module Helpers
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
            head = <<~S
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
          
            cr_files = path_to_related_files.glob '*.cr'
            unless cr_files.empty?
              content_of_related_cr_files = cr_files.map(&:read).join "\n\n"
              head = head + "\n#{content_of_related_cr_files}"
            end
          
            head
          end
        end
      
        module MacroExpansions
          def src_macros
            @src_macros ||= Dir['src.macros/*.erb', 'lib/*/src.macros/*.erb']
          end
          
          def macros
            @macros ||= src_macros.map { |file| Macro.new file }
          end
          
          def apply_macros
            macros.each do |macro|
              @lines, code = macro.process lines
              target_path.join("#{macro.name_in_snake_case}.cr").write code if code
            end
          end
        end
      
        attr_reader :path_to_file, 
          :lines,
          :basename,
          :basename_without_ext,
          :path_to_related_files
        def initialize path_to_file
          @path_to_file = path_to_file
          @lines = path_to_file.readlines
          @basename = path_to_file.basename
          @basename_without_ext = basename.to_s.delete_suffix '.cr'
          @path_to_related_files = path_to_file.dirname.join basename_without_ext
        end
        
        include Helpers
        include MacroExpansions
        
        def body
          lines.join
        end
        
        def compile
          target_path.mkpath
          apply_macros
          target_file.write <<~S.chomp
            #{preamble}
            #{body}
          S
        end
      end
    
      class HelpFile
        attr_reader :message, :entry_file
        def initialize entry_file
          @entry_file = entry_file
          @message = if path_to_help_message.file?
            path_to_help_message.read
          else
            "A help message for #{entry_file.basename_without_ext}."
          end
        end
        
        def path_to_help_message
          @path_to_help_message ||= entry_file.path_to_related_files.join 'help'
        end
        
        def code
          <<~HELP
            HELP_MESSAGE = <<-S
            #{message.chomp}
            S
        
            def print_help
              puts HELP_MESSAGE
            end
          HELP
        end
        
        def target_file
          @target_file ||= entry_file.target_path.join 'print_help.cr'
        end
        
        def compile
          target_file.write code
        end
      end
    end
  end
end
