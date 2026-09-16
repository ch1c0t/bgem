def preamble_file
  @preamble_file ||= dir.join "#{name}.preamble"
end

def preamble
  @preamble ||= begin
    if preamble_file.file?
      string = preamble_file.read
      string.end_with?("\n") ? string : "#{string}\n"
    end
  end
end
