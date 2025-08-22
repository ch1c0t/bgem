def initialize entry_file
  @entry_file = EntryFile.new entry_file
  @help_file = HelpFile.new @entry_file
end

def compile
  @entry_file.compile
  @help_file.compile
end
