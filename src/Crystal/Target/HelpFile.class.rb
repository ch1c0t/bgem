attr_reader :message, :entry_file
def initialize entry_file
  @entry_file = entry_file
  @message = if path_to_help_message.file?
    path_to_help_message.read
  else
    "A help message for #{entry_file.basename_without_ext}."
  end
end

def path_to_help_message
  @path_to_help_message ||= entry_file.path_to_related_files.join 'help'
end

def code
  <<~HELP
    HELP_MESSAGE = <<-S
    #{message.chomp}
    S

    def print_help
      puts HELP_MESSAGE
    end
  HELP
end

def target_file
  @target_file ||= entry_file.target_path.join 'print_help.cr'
end

def compile
  target_file.write code
end
