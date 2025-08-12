attr_accessor :file, :entry, :scope
def initialize(file = nil, entry = nil, scope = nil)
  @file = file

  @potential_entries = Dir['src/*.rb']
  @entry ||= @potential_entries[0]

  @scope = scope
end

def set_entry_from_prefix name
  @entry = @potential_entries.find do |file|
    basename = File.basename file
    basename.start_with? "#{name}."
  end
end
