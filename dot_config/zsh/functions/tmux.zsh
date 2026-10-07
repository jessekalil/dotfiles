tdl() {
  [[ -n $1 ]] || { print -u2 'Usage: tdl <ai> [second_ai]'; return 1; }
  [[ -n $TMUX ]] || { print -u2 'You must start tmux to use tdl.'; return 1; }

  local editor_pane=$TMUX_PANE ai_pane ai2_pane ai=$1 ai2=$2
  tmux rename-window -t "$editor_pane" "${PWD:t}"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$PWD"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$PWD" -P -F '#{pane_id}') || return

  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$PWD" -P -F '#{pane_id}') || return
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi
  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"
}

tds() {
  [[ -z $1 ]] || { print -u2 'Usage: tds'; return 1; }
  [[ -n $TMUX ]] || { print -u2 'You must start tmux to use tds.'; return 1; }

  local editor_pane=$TMUX_PANE terminal_pane diff_pane opencode_pane
  tmux rename-window -t "$editor_pane" "${PWD:t}"
  terminal_pane=$(tmux split-window -v -p 50 -t "$editor_pane" -c "$PWD" -P -F '#{pane_id}') || return
  diff_pane=$(tmux split-window -h -p 50 -t "$editor_pane" -c "$PWD" -P -F '#{pane_id}') || return
  opencode_pane=$(tmux split-window -h -p 50 -t "$terminal_pane" -c "$PWD" -P -F '#{pane_id}') || return

  tmux send-keys -t "$editor_pane" -l 'nvim .'
  tmux send-keys -t "$editor_pane" C-m
  tmux send-keys -t "$diff_pane" -l 'hunk diff --watch'
  tmux send-keys -t "$diff_pane" C-m
  tmux send-keys -t "$opencode_pane" -l 'opencode'
  tmux send-keys -t "$opencode_pane" C-m
  tmux select-pane -t "$editor_pane"
}

tdlm() {
  [[ -n $1 ]] || { print -u2 'Usage: tdlm <ai> [second_ai]'; return 1; }
  [[ -n $TMUX ]] || { print -u2 'You must start tmux to use tdlm.'; return 1; }

  local ai=$1 ai2=$2 base_dir=$PWD dir dirpath pane_id command_line
  local first=1
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    dirpath=${dir%/}
    command_line="tdl ${(q)ai}"
    [[ -n $ai2 ]] && command_line+=" ${(q)ai2}"
    if (( first )); then
      tmux send-keys -t "$TMUX_PANE" "cd ${(q)dirpath} && $command_line" C-m
      first=0
    else
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}') || return
      tmux send-keys -t "$pane_id" "$command_line" C-m
    fi
  done
}

tsl() {
  [[ -n $1 && -n $2 ]] || { print -u2 'Usage: tsl <pane_count> <command>'; return 1; }
  [[ -n $TMUX ]] || { print -u2 'You must start tmux to use tsl.'; return 1; }

  local count=$1 cmd=$2 new_pane pane
  local -a panes=("$TMUX_PANE")
  tmux rename-window -t "$TMUX_PANE" "${PWD:t}"
  while (( ${#panes} < count )); do
    new_pane=$(tmux split-window -h -t "${panes[-1]}" -c "$PWD" -P -F '#{pane_id}') || return
    panes+=("$new_pane")
    tmux select-layout -t "${panes[1]}" tiled
  done
  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" "$cmd" C-m
  done
  tmux select-pane -t "${panes[1]}"
}
