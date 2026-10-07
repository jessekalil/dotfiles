# Omarchy's environment bootstrap is useful on Omarchy, but unavailable on WSL.
if [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
  source /usr/share/omarchy/default/bash/env-bootstrap
fi

# Respect explicit user/application choices, then pick a local editor.
if [[ -z ${EDITOR:-} ]]; then
  if (( $+commands[omarchy-launch-editor] )); then
    export EDITOR='omarchy-launch-editor --inline'
  else
    export EDITOR=nvim
  fi
fi
export SUDO_EDITOR="$EDITOR"

if [[ -z ${BROWSER:-} ]] && (( $+commands[omarchy-launch-browser] )); then
  export BROWSER=omarchy-launch-browser
fi

export BAT_THEME=ansi
export MANROFFOPT=-c
if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Do not add an existing directory a second time (bootstrap may have done so).
typeset -U path
path+=("$HOME/.local/bin")

# Activate tools before aliases check which commands are available.
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

# Support the standalone installer when OpenCode is not managed by mise.
if (( ! $+commands[opencode] )) && [[ -x $HOME/.opencode/bin/opencode ]]; then
  path+=("$HOME/.opencode/bin")
fi
