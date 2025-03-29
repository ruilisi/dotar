set_proxy() {
  port=${1:-8668}
  export http_proxy=http://127.0.0.1:$port;export https_proxy=http://127.0.0.1:$port;
}
set_ss_proxy() {
  port=${1:-1080}
  export https_proxy=socks5://127.0.0.1:${port}
  export http_proxy=socks5://127.0.0.1:${port}
}
unset_proxy() {
  unset http_proxy https_proxy ftp_proxy no_proxy
}
