autoload colors; colors;

function secure_source () {
  if [ -e $1 ]; then
    source $1
  fi
}
pp() { ps aux | grep "$1\|USER" | grep -v "grep" }
function getIP () {
  echo $(grep $1 ~/.ssh/config -A 1 | tail -1 | tr -s ' ' | cut -d ' ' -f 3)
}

function getServerName () {
  echo $(grep $1 ~/.ssh/config -B 1 | head -1 | tr -s ' ' | cut -d ' ' -f 3)
}

function ssh_exec_by_file () {
  ssh -t $1 "bash -s" -- < $2
}

function post {
  curl -H "Content-Type: application/json" -X POST -d $1 $2
}
function search_installed_packages {
  dpkg --get-selections | grep $1
}
function delete_except_latest {
  total=`ll | wc -l`
  num_to_delete=$((total-$1))
  ls -t | tail -n $num_to_delete | xargs rm
}
function strip_color() {
  sed "s,$(printf '\033')\\[[0-9;]*[a-zA-Z],,g"
}
function docker_rm_all() {
  docker rm -f `docker ps --no-trunc -aq`
}
function git-change-module-remote() {
  git config --file=.gitmodules submodule.$1.url $2
  git config --file=.gitmodules submodule.$1.branch $3
  git submodule sync
  git submodule update --init --recursive --remote
}
function markdown-preview() {
  cat $1 | instant-markdown-d > /dev/null 2>&1
}
function cmd_exists() {
  $* &> /dev/null
  if [[ $? == 0 ]]; then
    echo Y
  else
    echo N
  fi
}
function qshell_upload() {
  qshell_setup
  bucket=assets
  while getopts "b:f:k:t" o; do
    case "${o}" in
      b)
        bucket=${OPTARG}
        ;;
      f)
        filepath=${OPTARG}
        ;;
      k)
        key=${OPTARG}
        ;;
      t)
        timestamp=true
        ;;
      *)
        echo "Usage: qshell_upload [-b BUCKET] -f FILEPATH [-k KEY] [-t]"
        return
        ;;
    esac
  done
  if [[ $key == '' ]]; then
    key=$(basename $filepath)
  fi
  if [[ $timestamp == 'true' ]];then
    key=`date +%Y%m%dT%H%M%S`_${key}
  fi
  qshell rput $bucket $key $filepath
}

function gitr() {
  for dir in `ls`; do
    if [[ -d "$dir" && -d "$dir/.git" ]]; then
      pushd .
      echo "$fg[green]$(basename $dir)$reset_color"
      cd $dir
      git $*
      popd
    fi
  done
}

function gitcopy() {
  n=1
  while getopts "c:n:t" o; do
    case "${o}" in
      c)
        commit=${OPTARG}
        ;;
      n)
        n=${OPTARG}
        ;;
      *)
        usage
        ;;
    esac
  done
  prefix=`git remote get-url origin | sed -E 's/git@github.com:/https:\/\/github.com\//g' | sed -E 's/(.*)\.git/\1/'`
  project_name=`echo $prefix | sed -E 's/.*\/(.*)/\1/'`
  commits=`git log $commit -n $n --stat --pretty="
* [$project_name]($prefix/commit/%H) %an: **%s**" | sed 's/^[^*]/> /'`
  echo $commits
  which pbcopy &> /dev/null
  if [[ $? == '0' ]]; then
    echo $commits | pbcopy
  fi
}
function stern {
  finalopts=()
  while [[ $@ != "" ]] do
    case $1 in
      --context=*)
        KCONTEXT="${i#*=}"
        shift
        ;;
      *)
        finalopts+=($1)
        shift
        ;;
    esac
  done
  echo "stern $finalopts --kubeconfig=$HOME/.kube/${KCONTEXT}_config"
  command stern $finalopts -t --since 10m --kubeconfig=$HOME/.kube/${KCONTEXT}_config
}

function rgm {
  args=("${(@s/,/)1}")
  regex=${(j:.*\n.*:)args}
  echo "Rip Search with $regex..."
  rg -U $regex
}

function git_tag_delete() {
  git tag -d $1; git push --delete origin $1
}

function git_tag_add() {
  git tag -a $1 -m "$1"
  gpc --tags
}

function dc {
  if [ -e ./docker-compose-dev.yml ]; then
    docker_file_path=./docker-compose-dev.yml
  elif [ -e ./docker-compose.yml ]; then
    docker_file_path=./docker-compose.yml
  fi
  docker-compose -f $docker_file_path $@
}
unalias gc 2>/dev/null
unalias gcm 2>/dev/null
function gc {
  while true;do
    for user email in ${(kv)GIT_USERS}; do
      printf "%-20s" $user
      echo $email
    done
    echo $fg[green]'Please input github username listed above(let admin add if not existed):'$reset_color
    read user
    email=$GIT_USERS[$user]
    if [[ "$email" != "" ]]; then
      break
    fi
    echo $fg[red]'Invalid option...'$reset_color
  done
  (git commit --author="$user <$email>" --verbose $*) || return
}

function gcm {
  (gc --message $*) || return
}
