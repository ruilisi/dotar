yell() { echo "$0: $*" >&2; }

die() { yell "$*"; exit 111; }

try() { "$@" || die "cannot $*"; }

list-large-files() {
  LIST=`du $1`
  echo $LIST | grep '^[0-9.]*K.' | sort -n
  echo $LIST | grep '^[0-9.]*M.' | sort -n
  echo $LIST | grep '^[0-9.]*G.' | sort -n
}
