def requiring_part
  @requiring_part ||= begin
                        file = dir.join "#{name}.require"
                        if file.file?
                          file.readlines.map do |line|
                            'require ' + '"' + line.chomp + '"'
                          end.join("\n").concat("\n\n")
                        end
                      end
end
