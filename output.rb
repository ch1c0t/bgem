module Bgem
  module Preamble
    preamble
  end

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
  CONFIG_FILE = "#{Dir.pwd}/bgem/config.rb"
  
  class << self
    def run config_file = CONFIG_FILE
      config = Config.new config_file
      target = TargetFile.new config.output, config.scope
      target.write SourceFile.new(config.entry).to_s
      target
    end
  end

  class Config
    def initialize config_file
      @entry, @output, @scope = SOURCE_FILE, 'output.rb', nil
      DSL.new self, config_file
    end
    
    attr_accessor :entry, :output, :scope
    
    class DSL
      def initialize config, file
        @config = config
        instance_eval IO.read file
      end
    
      def entry file
        @config.entry = file
      end
    
      def output file
        @config.output = file
      end
    
      def inside *array_of_strings
        @config.scope = array_of_strings
      end
    end
  end

  class SourceFile
    def initialize file = SOURCE_FILE, indent: 0
      @file, @indent = (Pathname file), indent
      @source = @file.read
      head, @type, _rb = @file.basename.to_s.split '.'
      @constant, _colon, @ancestor = head.partition ':'
    end
    
    def to_s
      "#{head}#{source}end".indent @indent
    end
    
    private
      def head
        if @ancestor.empty?
          "#{@type} #{@constant}\n"
        else
          "#{@type} #{@constant} < #{@ancestor}\n"
        end
      end
    
      def source
        source = @source.indent INDENT
        source.prepend "#{before}\n\n" unless before.empty?
        source.concat "\n#{after}\n" unless after.empty?
        source
      end
    
      def self.concatenate_source_files *symbols
        symbols.each do |symbol|
          define_method symbol do
            pattern =  @file.dirname.join "#{__method__}.#{@constant}/*.rb"
            Dir[pattern].sort.map do |file|
              self.class.new(file, indent: INDENT).to_s
            end.join "\n\n"
          end
        end
      end
    
      concatenate_source_files :before, :after
  end

  class TargetFile
    def initialize path = 'output.rb', scope
      @path = Pathname path
      @scope = scope
    end
    
    def write string
      @path.dirname.mkpath
    
      if @scope
        @scope.each do |head_of_constant_definition|
          string = "#{head_of_constant_definition}\n#{string.indent INDENT}\nend"
        end
      end
    
      @path.write "#{string}\n"
    end
    
    def file
      @path
    end
  end
end
