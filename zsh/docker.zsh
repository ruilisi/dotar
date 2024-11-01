function  docker_clean_images {
  docker rmi $(docker images -a --filter=dangling=true -q)
  docker image prune -a
  docker system prune
}
