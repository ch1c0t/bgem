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
