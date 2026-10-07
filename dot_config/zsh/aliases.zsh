# File browsing. Avoid aliases to programs absent on a fresh Arch installation.
if (( $+commands[eza] )); then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

if (( $+commands[fzf] )); then
  if [[ $TERM == 'xterm-kitty' ]] && (( $+commands[kitty] && $+commands[file] && $+commands[bat] )); then
    alias ff="fzf --preview 'case \$(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'"
  elif (( $+commands[bat] )); then
    alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
  else
    alias ff='fzf'
  fi
fi

if (( $+commands[zoxide] )); then
  alias cd='zd'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# These match current Omarchy Bash definitions; commands are optional on WSL.
(( $+commands[opencode] )) && alias c='opencode --auto'
(( $+commands[opencode] )) && alias cc='opencode --auto -c'
(( $+commands[claude] )) && alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode auto'
(( $+commands[codex] )) && alias cy='codex --approve-for-me'
(( $+commands[docker] )) && alias d='docker'
(( $+commands[docker] )) && alias dc='docker compose'
(( $+commands[lazygit] )) && alias lg='lazygit'
(( $+commands[tmux] )) && alias t='tmux attach || tmux new -s Work'
if (( $+commands[tmux] )); then
  alias ic='tdl c'
  alias ix='tdl cx'
  alias icx='tdl c cx'
fi

alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
