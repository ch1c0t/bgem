def initialize
  @source_dir = SourceDir.new Pathname 'src.source'
  @entry_files_in_bin = @source_dir.entry_files_in_bin

  make_src_bin
  update_shard_targets
  make_src
end

def make_src_bin
  @entry_files_in_bin.each do |file|
    Target.new(file).compile
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

def make_src
  @source_dir.entry_files.each(&:compile)
end
