def initialize entry_file
  @src_bin = Pathname 'src/bin'
  @src_bin.mkpath

  `cp #{entry_file} #{@src_bin}`
end
