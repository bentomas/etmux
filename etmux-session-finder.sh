#!/usr/bin/env zsh

# from https://github.com/siadat/session-finder

set -e

file_sessions() {
  local socket
  local sessions
  local paths
  local etmux_path
  local files

  if [ -z $EASY_TMUX_PATH ]; then
    etmux_path=~/.etmux-sessions
  else
    etmux_path=$EASY_TMUX_PATH
  fi

  paths=(`echo $etmux_path | tr ":" "\n"`)
  for x in $paths; do
    if [ -d "$x" ]; then
      cd $x
      ls -1 $x
    fi
  done
}

active_sessions() {
  tmux ls -F '#{session_attached} #{?session_last_attached,,0}#{session_last_attached} #{session_name}' 2> /dev/null | sort -r | perl -pe 's/^[0-9]+ [0-9]+ //'
}

sessions() {
  sessions=("${(@f)$(active_sessions)}")
  files=("${(@f)$(file_sessions)}")

  for s in $sessions; do
    files=("${(@)files:#$s}")
  done

  if [ "$TMUX" ]; then
    current=$sessions[1]
    sessions=("${(@)sessions:#$current}")
  fi

  for s in $sessions; do
   echo "✓ $s"
  done
  for f in $files; do
   echo "  $f"
  done
}

prompt="find/create session> "

fzf_out=$(sessions | fzf --print-query --prompt="$prompt" || true)
line_count=$(echo "$fzf_out" | wc -l)
session_name=$(echo "$fzf_out" | tail -n1)
command=$(echo "$session_name" | awk '{ print $1 }')

if [ "$session_name" ]; then
 etmux ${session_name:2}
fi
