def name_in_pascal_case
  path = @path || @entry_file
  @name_in_pascal_case ||= path.basename.to_s.split('.')[0]
end

def name_in_snake_case
  @name_in_snake_case ||= name_in_pascal_case
    .split(/([A-Z][a-z]+)/)
    .delete_if(&:empty?)
    .map(&:downcase)
    .join('_')
end
