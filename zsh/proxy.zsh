set_proxy() {
  export http_proxy=http://127.0.0.1:8668;export https_proxy=http://127.0.0.1:8668;
}
set_vagrant_proxy() {
  export http_proxy=http://127.0.0.1:9119;export https_proxy=http://127.0.0.1:9119;
}
set_ss_proxy() {
  export https_proxy=socks5://127.0.0.1:1080/
  export http_proxy=socks5://127.0.0.1:1080/
}
unset_proxy() {
  unset http_proxy
  unset https_proxy
  unset ftp_proxy
  unset no_proxy
}
