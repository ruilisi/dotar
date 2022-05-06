random-hex() {
  openssl rand -hex $(expr $1 / 2)
}

random-string() {
    cat /dev/urandom |  LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

contains() {
  local n=$#
  local value=$@[n]
  for ((i=1;i < $#;i++)) {
    if [[ $@[i] == ${value} ]]; then
      echo "yes"
      return 0
    fi
  }
  echo "no"
  return 1
}
