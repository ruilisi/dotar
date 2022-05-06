alias intercept-request-hosts="sudo tcpdump -i any -A -vv -s 0 |  grep -e 'Host:'"
host-ip() {
  ip route get 8.8.8.8 | awk '/8.8.8.8/ {print $7}'
}
test-port() {
  nc -z localhost $1
}
