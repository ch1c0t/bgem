path = ARGV[0]? || Dir.current

require "../tmux"
Tmux::Project.create_and_enter path
