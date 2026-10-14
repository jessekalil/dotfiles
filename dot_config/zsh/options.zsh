bindkey -v
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
bindkey '^[[1;5C' forward-word
bindkey '^[[Z' reverse-menu-complete

# Load menu support for Zsh's regular completion menu.
zmodload zsh/complist
# Preserve ordinary completion as fzf-completion's fallback; fzf binds Tab
# after this file is loaded and handles the ** trigger itself.
bindkey -M viins '^I' expand-or-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

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
