autoload colors; colors;

function secure_source () {
  if [ -e $1 ]; then
    source $1
  fi
}
function contains() {
  local n=$#
  local value=${!n}
  for ((i=1;i < $#;i++)) {
    if [ "${!i}" == "${value}" ]; then
      echo "y"
      return 0
    fi
  }
  echo "n"
  return 1
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

function cp_container() {
  sourceName=$1
  targetName=$2
  cp $sourceName $targetName -r
  cd $targetName
  mv ${sourceName}.scss ${targetName}.scss
  mv ${sourceName}.js ${targetName}.js
  cd ..
}
function set_proxy() {
  export http_proxy=http://127.0.0.1:8668;export https_proxy=http://127.0.0.1:8668;
}
function set_vagrant_proxy() {
  export http_proxy=http://127.0.0.1:9119;export https_proxy=http://127.0.0.1:9119;
}
function set_ss_proxy() {
  export https_proxy=socks5://127.0.0.1:1080/
  export http_proxy=socks5://127.0.0.1:1080/
}
function unset_proxy() {
  unset all_proxy
  unset http_proxy
  unset https_proxy
}
function post {
  curl -H "Content-Type: application/json" -X POST -d $1 $2
}
function git-set-remote {
  git remote rm origin
  git remote rm upstream
  git remote add origin $1
  git remote add upstream $1
}
function search_installed_packages {
  dpkg --get-selections | grep $1
}
function delete_packages {
  sudo apt remove `_search_installed_packages $1 | cut -f 1 | tr "\n" " "`
}
function gem_source_to_taobao {
  gem source -r https://rubygems.org/
  gem source -a https://ruby.taobao.org
}

function set_anonymous {
  git filter-branch --env-filter '
  if [ "$GIT_AUTHOR_NAME" = "ralletstellar" ]; then \
    export GIT_AUTHOR_NAME="Anonymous" GIT_AUTHOR_EMAIL="anonymous@anonymous.com"; \
  fi
  '
}
function genAndroidKeystore {
  keytool -genkey -v -keystore /tmp/.keystore -alias rallets -keyalg RSA -keysize 2048 -validity 10000
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
# Replace replaces non-regex pattern recursively
# Example: Replace 'ctx.Status(400)' "ctx.Status(http.StatusBadRequest)"
function Replace () {
  CMD=$0
  function usage ()
  {
    echo "Usage :  $CMD [options] [--]
      Options:
      -f            File regex pattern
      -s            Source pattern
      -d            Destination pattern
      -r            Remove line
      --regex       Match pattern with regex
      --seperator=  Seperator, # by default
      -h            Display this message"
  }
  FILE_REGEX='.*'
  SRC=""
  DST=""
  SEP=";"
  DEBUG=false
  REMOVE=false
  REGEX=false
  while getopts ":rhf:s:d:-:" opt
    do
      case "${opt}" in
        -)
        echo $OPTART
        case "${OPTARG}" in
          debug)
            DEBUG=true
            ;;
          regex)
            REGEX=true
            ;;
          seperator=*)
            val=${OPTARG#*=}
            SEP=$val
            ;;
          *)
            echo "Unknown option --${OPTARG}"
            ;;
        esac;;
      f) FILE_REGEX=$OPTARG ;;
      r) REMOVE=true        ;;
      s) SRC=$OPTARG        ;;
      d) DST=$OPTARG        ;;
      h) usage; return 0    ;;
      *) echo -e "\n  option does not exist : $OPTARG\n";
         usage; return 1    ;;
    esac
  done
  SEARCH_CMD="ag `$REGEX || echo -Q` \"$SRC\" -l -G \"$FILE_REGEX\""
  MATCHED_FILES=`eval "$SEARCH_CMD"`
  echo "Replace in current files:$fg[green]\n$MATCHED_FILES$reset_color"
  if $REMOVE; then
    SED_CMD=\\${SEP}$SRC${SEP}d
  else
    SED_CMD=s${SEP}$SRC${SEP}$DST${SEP}g
  fi
  if [[ "$(uname)" == "Darwin" ]]; then
    echo $MATCHED_FILES | xargs sed -i '' "${SED_CMD}"
  elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo $MATCHED_FILES | xargs sed -i ${SED_CMD}
  fi
}
function git-change-module-remote() {
  git config --file=.gitmodules submodule.$1.url $2
  git config --file=.gitmodules submodule.$1.branch $3
  git submodule sync
  git submodule update --init --recursive --remote
}
function replace() {
  ag -l -G $1 | xargs sed -ri.bak -e "s/$2/$3/g"
}
function markdown-preview() {
  cat $1 | instant-markdown-d > /dev/null 2>&1
}
function swap() {
  if [ $# -ne 2 ]; then
    echo "Usage: swap file1 file2"
  else
    local TMPFILE=$(mktemp)
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
  fi
}
function cmd_exists() {
  $* &> /dev/null
  if [[ $? == 0 ]]; then
    echo Y
  else
    echo N
  fi
}
function qshell_setup() {
  if [[ $(cmd_exists qshell) == 'N' ]]; then
    curl https://raw.githubusercontent.com/paiyou-network/scripts/master/install-qshell.sh | bash
  fi
  ~/Projects/paiyou-hub/bin/setup-qshell-account.sh
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
function helm() {
  DEBUG=false
  finalopts=()
  while [[ $@ != "" ]] do
    case $1 in
      --context=*)
        KCONTEXT="${i#*=}"
        shift
        ;;
      --debug)
        DEBUG=true
        finalopts+=($1)
        shift
        ;;
      *)
        finalopts+=($1)
        shift
        ;;
    esac
  done
  [[ $DEBUG == "true" ]] && echo "helm $finalopts --kubeconfig=$HOME/.kube/${KCONTEXT}_config"
  command helm $finalopts --kubeconfig=$HOME/.kube/${KCONTEXT}_config
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
function get_ip_of_ssh_hostname {
  ssh -G $1 | awk '/^hostname / { print $2  }'
}
unalias gc 2>/dev/null
unalias gcm 2>/dev/null
function gc {
  while true;do
    users=($GIT_USERS)
    for ((i=1; i<=${#users[@]}; i++)) do
      echo "$i | $users[$i]"
    done
    echo 'please input your number or name:'
    read input
    for ((i=1; i<=${#users[@]}; i++)) do
      if [[ $input == $users[$i] ]];then
        name=$input
        index=$i
        break 2
      elif [[ "$input" =~ '^[0-9]+$' ]];then
        if [[ $input -gt 0 && $input -le ${#users[@]} ]];then
          name=$users[$input]
          index=$input
          break 2
        fi
      fi
    done
    echo 'invalid option...'
  done
  emails=($GIT_EMAILS)
  git config user.name $name
  git config user.email $emails[$index]
  (git commit --verbose $*) || return
  (git commit --amend --author="$name <$emails[$index]>") || return
}
function gcm {
  (gc --message $*) || return
}

function random_hex {
  openssl rand -hex $(expr $1 / 2)
}
