require "find"
require "../tmux"

_current_session, *other_project_sessions = Tmux::Project.sessions

options = other_project_sessions.map(&.name).join('\n')
key, session_name = Find.in options

case key
when :enter
  Tmux.switch_to session_name
when {:alt, 'r'}
  session = other_project_sessions.find do |session|
    session.name == session_name
  end

  if session
    session.restart
  end
end
