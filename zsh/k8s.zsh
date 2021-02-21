NAMESPACE=default
RUNNING_POD=""
LEFT_ARGS=""
KCONTEXT=""
VERBOSE=false
SRC=""
DST=""

# aliases
alias k="kubectl"
alias kpg="kubectl get pods | grep"
alias ksg="kubectl get service | grep"
alias k_get_pods_sort_by_time="k get pods --sort-by=.metadata.creationTimestamp"

function getpod {
  RAN=true
  function usage ()
  {
    echo "Usage :  $0 [options] [--]
    Options:
    -K            kubectl context
    -R            Not randomly select pod
    -d            Destination
    -s            Source
    -n NAMESPACE
    -p PROJECT
    -v            Verbose
    -h            Display this message"
  }
  while getopts ":hvs:d:K:Rp:" opt
  do
    case $opt in
    R) RAN=false          ;;
    s) SRC=$OPTARG        ;;
    d) DST=$OPTARG        ;;
    n) NAMESPACE=$OPTARG  ;;
    p) PROJECT=$OPTARG    ;;
    K) KCONTEXT=$OPTARG   ;;
    v) VERBOSE=true       ;;
    h) usage; return 0    ;;
    *) echo -e "\n  Option does not exist: $OPTARG\n"
       usage; return 1    ;;
    esac
  done
  shift $(($OPTIND-1))

  RUNNING_POD_INDEX=-1
  while true; do
    echo "kubectl -n $NAMESPACE get pods | grep $PROJECT"
    ALL_PODS=$(kubectl -n $NAMESPACE get pods | grep "$PROJECT")
    echo $fg[green]"All Pods:"$reset_color
    echo $ALL_PODS
    if  [[ ${#ALL_PODS[@]} == 0 ]]; then
      echo $fg[red]"Pod not found for $PROJECT"$reset_color
      break
    fi
    RUNNING_PODS=($(echo $ALL_PODS | egrep "$PROJECT.* ?[1-9]/[0-9]? *Running" | awk '{print $1}'))
    if [[ `echo $ALL_PODS | wc -l | trim` != ${#RUNNING_PODS[@]} ]]; then
      sleep 2
      echo $fg[red]'Pods are not ready, wait...'$reset_color
      continue
    fi
    if [[ ${#RUNNING_PODS[@]} == 0 ]]; then
      echo "Pod not found for $PROJECT"
      break
    fi
    RUNNING_POD_INDEX=$(($RANDOM % ${#RUNNING_PODS[@]} + 1))
    [[ $RAN == 'true' ]] && break
    if [ ${#RUNNING_PODS[@]} -gt 1 ];then
      echo $fg[green]'Running Pods:'$reset_color
      INDEX=1
      for i in $RUNNING_PODS;do
        echo "[$INDEX] $i"
        let INDEX=${INDEX}+1
      done
      echo $fg[green]'Select option of pod to execute:'$reset_color
      while true;do
        read RUNNING_POD_INDEX
        if [[ $RUNNING_POD_INDEX -gt 0 && $RUNNING_POD_INDEX -le ${#RUNNING_PODS[@]} ]];then
          break
        else
          echo 'invalid option...'
        fi
      done
      break
    fi
  done
  RUNNING_POD=$RUNNING_PODS[$RUNNING_POD_INDEX]
  LEFT_ARGS=$@
}

function kexec {
  getpod $@
  if [[ $RUNNING_POD != "" ]]; then
    echo "kubectl -it -n $NAMESPACE exec $RUNNING_POD -- /bin/sh -c $LEFT_ARGS"
    kubectl -it -n $NAMESPACE exec $RUNNING_POD -- /bin/sh -c $LEFT_ARGS
  fi
}

function cmd {
  if $VERBOSE; then
    echo "Running: $fg[green]$1$reset_color"
  fi
  eval $1
}
function kcp {
  getpod $@
  if [[ $RUNNING_POD != "" ]]; then
    cmd "kubectl -n $NAMESPACE cp $RUNNING_POD:$SRC $DST"
  fi
}

function klogs {
  finalopts=()
  while [[ $@ != "" ]] do
    case $1 in
      --context=*)
        KCONTEXT="${i#*=}"
        shift
        ;;
      -p)
        PROJECT="$2"
        shift; shift
        ;;
      -i)
        INSTANCE="$2"
        shift; shift
        ;;
      *)
        finalopts+=($1)
        shift
        ;;
    esac
  done

  if [[ "$PROJECT" != "" ]]; then
    kubectl logs -f deployment/$PROJECT --all-containers=true --since=5s --pod-running-timeout=2s $finalopts
  elif  [[ "$INSTANCE" != "" ]]; then
    while true; do
      kubectl logs -f --max-log-requests=10 -l app.kubernetes.io/instance=$INSTANCE 1>&0
      echo "Waiting..."
      sleep 2
    done
  fi
}
function k_delete_evicted {
  k delete pod `k get pods | grep Evicted | awk '{print $1}'`
}
function k_get_instance {
  k get pods -o jsonpath="{.items[*].metadata.labels['app\.kubernetes\.io\/instance']}" | tr " " "\n" | uniq
}
function kubectl() {
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
        shift
        ;;
      --)
        finalopts+=("$@")
        break
        ;;
      *)
        finalopts+=($1)
        shift
        ;;
    esac
  done
  [[ $DEBUG == "true" ]] && echo "kubectl --kubeconfig=$HOME/.kube/${KCONTEXT}_config $finalopts"
  command kubectl --kubeconfig=$HOME/.kube/${KCONTEXT}_config $finalopts
}
function k_force_delete_pod () {
  k delete pod $1 --grace-period=0 --force
}
function k_get_containers_of_pod {
  k get pods $1 -o jsonpath='{.spec.containers[*].name}*'
}
function set_k8s_context_core {
  C=$1
  if [[ "$C" == "" ]]; then
    echo "Select your context:"
    ls ~/.kube/*_config | xargs -n 1 basename | sed s/_config//g
    read C
  fi
  export KCONTEXT=$C
}
