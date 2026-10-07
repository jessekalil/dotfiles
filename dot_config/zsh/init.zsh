# Shell-native integrations. Starship is required before activating this config.
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  print -u2 'Install starship before activating this Zsh configuration.'
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[try] )); then
  eval "$(try init ~/Work/tries)"
fi

_zsh_completions="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
fpath=("$_zsh_completions" $fpath)
autoload -Uz compinit
compinit -i
unset _zsh_completions

if (( $+commands[fzf] )); then
  [[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
  [[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
fi

# Inline history suggestions, accepted with the right arrow or End.
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  # A fresh machine has little Zsh history; suggest completions until it grows.
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Highlighting should see all previously defined editing widgets.
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
