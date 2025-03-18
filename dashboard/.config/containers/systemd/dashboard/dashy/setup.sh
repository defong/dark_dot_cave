#!/bin/bash

set -e



copy_config() {
  cp ~/.config/containers/systemd/dashboard/dashy/config.yml ~/.container/dashboard/dashy/
}


main() {
  ~/.config/containers/systemd/dashboard/create_directory.sh ~/.container/dashboard/dashy
  copy_config
}

main "$@"
