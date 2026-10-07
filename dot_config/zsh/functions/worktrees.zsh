ga() {
  [[ -n $1 ]] || { print -u2 'Usage: ga <branch name>'; return 1; }
  local branch=$1 base=${PWD:t} wt_path="../${PWD:t}--${1}"
  git worktree add -b "$branch" "$wt_path" || return
  mise trust "$wt_path" || return
  builtin cd "$wt_path"
}

gd() {
  gum confirm 'Remove worktree and branch?' || return
  local cwd=$PWD worktree=${PWD:t} root branch
  root=${worktree%%--*}
  branch=${worktree#*--}
  [[ $root != $worktree ]] || return 1
  builtin cd "../$root" || return
  git worktree remove "$cwd" --force || return
  git branch -D "$branch"
}
