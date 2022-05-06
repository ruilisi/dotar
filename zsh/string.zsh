random-hex() {
  openssl rand -hex $(expr $1 / 2)
}

random-string() {
    cat /dev/urandom |  LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}
