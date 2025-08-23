require "../tmux"

_current_session, *other_project_sessions = Tmux::Project.sessions
key, session = Find(Tmux::Session).in other_project_sessions

case key
when :enter
  session.enter
when {:alt, 'r'}
  session.restart
end
