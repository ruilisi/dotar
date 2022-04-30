alias intercept_request_hosts="sudo tcpdump -i any -A -vv -s 0 |  grep -e 'Host:'"

test_port() {
  nc -z localhost $1
}
