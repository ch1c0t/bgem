require "../tmux"

all_sessions = Tmux.sessions
current_session = all_sessions.first

sessions_to_close, other_sessions = all_sessions.partition do |session|
  session.basename == current_session.basename
end

if session_to_enter = other_sessions[0]?
  session_to_enter.enter
end

sessions_to_close.reverse.each &.close
