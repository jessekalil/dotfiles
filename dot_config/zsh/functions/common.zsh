compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress='tar -xzf'

if (( $+commands[fzf] )); then
  eff() {
    local file
    file=$(eval 'ff') || return
    [[ -n $file ]] || return 1
    local -a editor=(${(z)EDITOR})
    "${editor[@]}" "$file"
  }

  sff() {
    (( $# )) || { print -u2 'Usage: sff <destination>'; return 1; }
    local file
    file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | fzf) || return
    [[ -n $file ]] && scp "$file" "$1"
  }
fi

if (( $+commands[zoxide] )); then
  zd() {
    if (( $# == 0 )); then
      builtin cd ~
    elif [[ -d $1 ]]; then
      builtin cd "$1"
    elif ! z "$@"; then
      print -u2 'Error: Directory not found'
      return 1
    else
      printf '\U000F17A9 '
      pwd
    fi
  }
fi

open() {
  (( $+commands[xdg-open] )) || { print -u2 'xdg-open is not installed'; return 1; }
  xdg-open "$@" >/dev/null 2>&1 &!
}

n() {
  if (( $# == 0 )); then
    command nvim .
  else
    command nvim "$@"
  fi
}

y() {
  (( $+commands[yazi] )) || { print -u2 'yazi is not installed'; return 1; }
  local tmp cwd
  tmp=$(mktemp -t yazi-cwd.XXXXXX) || return
  command yazi "$@" --cwd-file="$tmp"
  local status=$?
  if cwd=$(command cat -- "$tmp") && [[ -n $cwd && $cwd != $PWD ]]; then
    builtin cd -- "$cwd" || status=$?
  fi
  command rm -f -- "$tmp"
  return $status
}

p() {
  if [[ -f bun.lock || -f bun.lockb ]]; then
    command bun "$@"
  elif [[ -f pnpm-lock.yaml ]]; then
    command pnpm "$@"
  elif [[ -f yarn.lock ]]; then
    command yarn "$@"
  elif [[ -f package-lock.json ]]; then
    command npm "$@"
  else
    command pnpm "$@"
  fi
}
