def initialize
  @source_dir = Pathname 'src.source'
  fail "Expected to find a source directory at #{@source_dir}" unless @source_dir.directory?

  make_src_bin
  update_shard_targets
end

def make_src_bin
  @entry_files_in_bin = @source_dir.glob('bin/*.cr')
  @entry_files_in_bin.each do |file|
    Target.new file
  end
end

def update_shard_targets
  file = Pathname 'shard.yml'
  data = YAML.load_file file

  data['targets'] = @entry_files_in_bin.map do |entry_file|
    basename = entry_file.basename
    target_name = basename.to_s.delete_suffix('.cr')
    [target_name, { 'main' => "src/bin/#{basename}" }]
  end.to_h

  file.write data.to_yaml
end
