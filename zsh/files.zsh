swap() {
  if [ $# -ne 2 ]; then
    echo "Usage: swap file1 file2"
  else
    local TMPFILE=$(mktemp)
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
  fi
}

# Replace replaces non-regex pattern recursively
# Example: Replace 'ctx.Status(400)' "ctx.Status(http.StatusBadRequest)"
Replace () {
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
    echo "xargs sed -i '' \"${SED_CMD}\""
    echo $MATCHED_FILES | xargs sed -i '' "${SED_CMD}"
  elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo $MATCHED_FILES | xargs sed -i ${SED_CMD}
  fi
}
