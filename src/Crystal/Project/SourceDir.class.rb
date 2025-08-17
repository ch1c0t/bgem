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
