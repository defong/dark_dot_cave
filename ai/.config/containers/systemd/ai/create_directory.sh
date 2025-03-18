#!/bin/bash

set -e

create_directory() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo "Directory $1 created"
  else
    echo "Directory $1 already exists"
  fi
}

replace_home_directory() {
  echo "${1//%h/$HOME}"
}

main() {
  if [ -z "$1" ]; then
    echo "Error: Directory path not provided"
    exit 1
  fi
  DIR=$(replace_home_directory "$1")
  create_directory "$DIR"
}

main "$@"
