module Bgem
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
    def initialize config_file
      @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
      DSL.new self, (IO.read config_file)
    end
    
    attr_accessor :entry, :output, :scope
    
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
  end

  class Output
    class Ext
      module StandardHooks
        EXTs = [
          'rb',
          'erb',
        ]
        
        def pre
          patterns = EXTs.flat_map do |ext|
            ["pre.#{@name}/*.#{ext}"].map do |pattern|
              @dir.join pattern
            end
          end
        
          concatenate *patterns
        end
        
        def post
          patterns = EXTs.flat_map do |ext|
            ["#{@name}/*.#{ext}", "post.#{@name}/*.#{ext}"].map do |pattern|
              @dir.join pattern
            end
          end
        
          concatenate *patterns
        end
        
        def concatenate *patterns
          Dir[*patterns].sort.map do |file|
            Output.new(file, indent: INDENT).to_s
          end.join "\n\n"
        end
      end
    
    
      class ERB
        def initialize dir:, source:, chain:
          @source = source
          @name = chain.first
        end
        
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
                  #{@source}TEMPLATE
        
                require 'erb'
                renderer = ERB.new template
                renderer.result env
              end
            end
          S
        end
      end
    
      module RB
        def self.new dir:, source:, chain:
          name, type = chain
          type ||= 'module'
          constant = type.capitalize
        
          if self.const_defined? constant
            type = self.const_get constant
          else
            fail "Don't know what to do with '#{type}'. #{self}::#{constant} is not defined."
          end
        
          type.new dir: dir, source: source, name: name
        end
        
        def initialize dir:, source:, name:
          @dir, @source, @name = dir, source, name
          setup
        end
        
        def to_s
          "#{head}#{source}end"
        end
        
        private
          def setup
          end
        
          include StandardHooks
        
          def source
            source = @source.indent INDENT
            source.prepend "#{pre}\n\n" unless pre.empty?
            source.concat "\n#{post}\n" unless post.empty?
            source
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
    
      *chain, last = file.basename.to_s.split '.'
      ext = last.upcase
      source = file.read
      dir = file.dirname
    
      if Ext.const_defined? ext
        e = Ext.const_get ext
      else
        fail "Don't know what to do with #{file}. Bgem::Output::Ext::#{ext} is not defined."
      end
    
      @output = e.new dir: dir, source: source, chain: chain
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
