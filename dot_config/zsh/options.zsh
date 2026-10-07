bindkey -e
setopt COMBINING_CHARS INTERACTIVE_COMMENTS EXTENDED_GLOB AUTO_CD CHASE_LINKS
setopt NO_HASH_CMDS NO_HASH_DIRS
unsetopt BEEP

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p -- "${HISTFILE:h}"
HISTSIZE=32768
SAVEHIST=32768
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY

setopt COMPLETE_IN_WORD ALWAYS_TO_END AUTO_LIST LIST_AMBIGUOUS AUTO_MENU
unsetopt MENU_COMPLETE BASH_AUTO_LIST
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' match-hidden-files off
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''
zstyle ':completion:*:-command-:*' ignored-patterns 'omarchy-*'
if [[ -z ${LS_COLORS:-} ]] && (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
fi
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^[[Z' reverse-menu-complete

# Keep the Omarchy Zsh Tab menu, while allowing fzf's ** completion trigger.
zmodload zsh/complist
typeset -gi _omarchy_tab_route_active=0
_omarchy-route-complete-or-expand() {
  emulate -L zsh
  setopt extended_glob
  unsetopt beep

  local trigger="${FZF_COMPLETION_TRIGGER-'**'}"
  if [[ -n $trigger && $LBUFFER == *$trigger && ${+widgets[fzf-completion]} -eq 1 ]]; then
    zle fzf-completion
    return $?
  fi

  if [[ $LASTWIDGET == _omarchy-route-complete-or-expand && $_omarchy_tab_route_active -eq 1 ]]; then
    zle menu-complete
    zle menu-select
    return $?
  fi

  _omarchy_tab_route_active=0
  if [[ -z $RBUFFER && $LBUFFER == omarchy[[:space:]]* && $LBUFFER != *[[:space:]] ]]; then
    local current="${LBUFFER##*[[:space:]]}"
    if [[ -n $current && $current != -* ]]; then
      zstyle ':completion:*' menu yes
      zle menu-complete
      _omarchy_tab_route_active=1
      return $?
    fi
  fi

  zstyle ':completion:*' menu select
  zle expand-or-complete
}
zle -N _omarchy-route-complete-or-expand
_omarchy-bind-tab-completion() { bindkey '^I' _omarchy-route-complete-or-expand; }
_omarchy-bind-tab-completion
bindkey -M menuselect '^[[Z' reverse-menu-complete

# fzf also binds Tab, so restore our widget after it initializes.
autoload -Uz add-zsh-hook
add-zsh-hook precmd _omarchy-bind-tab-completion

if (( $+commands[fzf] && $+commands[fd] )); then
  fzf-file-widget() {
    local selected
    selected=$(fd --color=never --type f --type d 2>/dev/null | fzf --multi --prompt='Files> ') || return
    [[ -n $selected ]] && LBUFFER+="${(q)selected} "
    zle reset-prompt
  }
  zle -N fzf-file-widget
  bindkey '^[^F' fzf-file-widget

  fzf-git-log-widget() {
    git rev-parse --git-dir >/dev/null 2>&1 || return
    local selected
    selected=$(git log --no-show-signature --format='%h %s' | fzf --prompt='Git log> ') || return
    [[ -n $selected ]] && LBUFFER+="${selected%% *} "
    zle reset-prompt
  }
  zle -N fzf-git-log-widget
  bindkey '^[^L' fzf-git-log-widget

  fzf-variables-widget() {
    local selected
    selected=$(print -rl -- ${(k)parameters} | fzf --prompt='Variables> ') || return
    [[ -n $selected ]] && LBUFFER+="\$$selected "
    zle reset-prompt
  }
  zle -N fzf-variables-widget
  bindkey '^[^V' fzf-variables-widget
fi
