module Bgem
  module CLI
    def self.run
      case ARGV[0]
      when '-v', '--version'
        puts VERSION
      else
        Bgem.run
      end
    end
  end

  VERSION = '0.1.1'
  
  require 'pathname'
  require 'string/indent'
  
  INDENT = 2
  SOURCE_FILE = Dir['src/*.rb'][0]
  CONFIG_FILE = "#{Dir.pwd}/bgem/config.rb"
  
  class << self
    def run config_file = CONFIG_FILE
      config = Config.new config_file
      write = Write.new config
      write[Output.new(config.entry).to_s]
      write
    end
  end

  class Config
    attr_accessor :entry, :output, :scope
    def initialize config_file
      @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
      DSL.new self, (IO.read config_file)
    
      @dir = Pathname File.dirname config_file
      define_macros
    end
    
    def define_macros
      Output::Ext.file_extensions.map do |type|
        dir = @dir + type.to_s
        MacroDir.new(type, dir) if dir.directory?
      end.compact.each do |macro_dir|
        macro_dir.define_macros
      end
    end
  
    class DSL
      def initialize config, code
        @config = config
        instance_eval code
      end
      
      def entry file
        @config.entry = file
      end
      
      def output file
        @config.output = file
      end
      
      def inside *headers
        @config.scope = headers
      end
    end
  
    class MacroDir
      def initialize type, dir
        @type, @dir = type, dir
        @constant = Output::Exts.const_get @type.upcase
      end
      
      def define_macros
        files = @dir.glob '*.rb'
      
        files.each do |file|
          n = file.basename.to_s.split('.').first
          constant = @constant; k = Class.new { include constant }
          to_s = "define_method :to_s do\n#{file.read}\nend"
          k.instance_eval to_s
          constant.const_set n.capitalize, k
        end
      end
    end
  end

  class Output
    class Ext
      module StandardHooks
        module DSL
          def hook hook_name, default: false
            define_method hook_name do
              directory = @dir + "#{hook_name}.#{@name}"
          
              if default
                default_directory = @dir + @name
                directory = default_directory unless directory.directory?
              end
          
              concatenate sorted_files_in directory
            end
          end
        end
      
        module Helpers
          def concatenate files
            files.map do |file|
              Output.new(file, indent: INDENT).to_s
            end.join "\n\n"
          end
          
          def sorted_files_in directory
            patterns = Ext.file_extensions.map do |ext|
              directory.join "*.#{ext}"
            end
          
            files = Dir[*patterns]
            order_file = directory.join 'order'
          
            if order_file.exist?
              sort_with_order_file order_file, files
            else
              files.sort
            end
          end
          
          def sort_with_order_file order_file, files
            order = order_file.readlines.map &:chomp
          
            files_ordered_to_be_first = order.inject([]) do |array, name|
              files_starting_with_name = files.select do |file|
                basename = File.basename file
                basename.start_with? "#{name}."
              end
              array += files_starting_with_name
            end
          
            other_files = files - files_ordered_to_be_first
            files_ordered_to_be_first += other_files.sort
          end
        end
      
        extend DSL
        include Helpers
        
        hook :post, default: true
        hook :pre
      end
    
      def self.file_extensions
        Exts.constants.map &:downcase
      end
      
      def self.new file_extension:, type:, name:, dir:, code:
        parent_constant = Exts.const_get file_extension.upcase
      
        type ||= if parent_constant.respond_to? :default
                   parent_constant.default
                 else
                   'default'
                 end
        constant_name = type.capitalize
      
        if parent_constant.const_defined? constant_name
          child_constant = parent_constant.const_get constant_name
        else
          fail "Don't know what to do with '#{type}'. #{parent_constant}::#{constant_name} is not defined."
        end
      
        child_constant.new file_extension: file_extension, type: type, name: name, dir: dir, code: code
      end
    
      module Common
        def initialize **kwargs
          @file_extension = kwargs[:file_extension]
          @type = kwargs[:type]
          @name = kwargs[:name]
          @dir = kwargs[:dir]
          @code = kwargs[:code]
        
          setup
        end
        
        attr_reader :file_extension, :type, :name, :dir, :code
        
        def ext
          file_extension
        end
        
        def setup
        end
      end
    end
  
    module Exts
    
      module ERB
        include Ext::Common
      
        class Default
          include ERB
          
          def to_s
            <<~S
              module #{@name}
                class Context
                  def env
                    binding
                  end
                end
          
                def self.[] params
                  env = Context.new.env
                  params.each do |name, value|
                    env.local_variable_set name, value
                  end
          
                  template = <<~TEMPLATE
                    #{@code}TEMPLATE
          
                  require 'erb'
                  renderer = ERB.new template
                  renderer.result env
                end
              end
            S
          end
        end
      end
    
      module RB
        include Ext::Common
        include Ext::StandardHooks
        
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
          include RB
          
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
          include RB
          
          def head
            "module #{@name}\n"
          end
        end
      end
    end
  
    def initialize file = SOURCE_FILE, indent: 0
      file, @indent = (Pathname file), indent
    
      parts = file.basename.to_s.split '.'
    
      case parts.size
      when 3
        name, type, file_extension = parts
      when 2
        name, file_extension = parts
      else
        fail "#{file} has more than two dots in its name."
      end
    
      if Exts.const_defined? file_extension.upcase
        @output = Ext.new file_extension: file_extension, type: type, name: name, dir: file.dirname, code: file.read
      else
        fail "Don't know what to do with #{file}. Bgem::Output::Exts::#{file_extension.upcase} is not defined."
      end
    end
    
    def to_s
      @output.to_s.indent @indent
    end
  end

  class Write
    def initialize config
      @file = Pathname config.output
      @scope = config.scope
    end
    
    attr_reader :file
    
    def [] string
      file.dirname.mkpath
    
      if @scope
        @scope.each do |header|
          string = "#{header}\n#{string.indent INDENT}\nend"
        end
      end
    
      file.write "#{string}\n"
    end
  end
end
