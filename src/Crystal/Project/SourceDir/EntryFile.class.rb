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
