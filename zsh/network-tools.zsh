alias intercept_request_hosts="sudo tcpdump -i any -A -vv -s 0 |  grep -e 'Host:'"
host_ip() {
  ip route get 8.8.8.8 | awk '/8.8.8.8/ {print $7}'
}
test_port() {
  nc -z localhost $1
}
