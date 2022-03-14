# Makes git auto completion faster favouring for local completions
__git_files () {
    _wanted files expl 'local files' _files
}
alias gfR='gf origin master; gwR origin/master'
alias gpb='git push origin "$(git-branch-current 2> /dev/null):build"'
alias gitUserRallet="git config user.name rallets;git config user.email rallet@rallets.com"
alias gfs="gs;gfr;gsp"
git_rebase_to_origin() {
  BRANCH=${1:-master}
  DIRTY=false
  git fetch origin
  [[ -n $(git status -s) ]] && DIRTY=true
  $DIRTY && echo "Git is dirty"
  $DIRTY && (git add .; git stash)
  git rebase origin/$BRANCH
  $DIRTY && (git stash pop; git reset HEAD)
}
git_rm_tag_of_remote() {
  TAG=$1
  REMOTE=${2:-origin}
  git tag -d $TAG
  git push --delete $REMOTE $TAG
}
git_log_history='git log -p --'
