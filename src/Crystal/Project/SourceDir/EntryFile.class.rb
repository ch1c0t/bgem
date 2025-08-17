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
