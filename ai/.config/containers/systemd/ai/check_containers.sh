#!/bin/bash

set -e

send_notification() {
  if ! command -v notify-send &> /dev/null; then
    echo "notify-send is not installed or not available. Skipping notification."
    return
  fi

  local icon="$1"
  local urgency="$2"
  local title="$3"
  local message="$4"
  /usr/bin/notify-send --icon="$icon" --urgency="$urgency" --expire-time=5000 "$title" "$message"
}

validate_input() {
  if [[ -z "$1" ]]; then
    send_notification "dialog-error" "critical" "🚨 Podman: Missing Pod Name" "No pod name provided.\nUsage: ./script.sh <pod_name>"
  fi
  if ! [[ "$1" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    send_notification "dialog-error" "critical" "🚨 Podman: Invalid Pod Name" "Invalid pod name '$1'. Only letters, numbers, underscores, and hyphens are allowed."
  fi
}

get_pod_id() {
  podman pod ps --filter name="$1" -q
}

get_containers() {
  podman ps --filter pod="$1" --format '{{.Names}}'
}

check_containers_status() {
  local containers="$1"
  local running_containers=""
  local failed_containers=""

  for container in $containers; do
    local state
    state=$(podman inspect --format '{{.State.Status}}' "$container")
    if [[ "$state" == "running" ]]; then
      running_containers+="$container\n"
    else
      failed_containers+="$container\n"
    fi
  done

  printf "%s\n%s" "$running_containers" "$failed_containers"
}

send_pod_status_notification() {
  local pod_name="$1"
  local running_containers="$2"
  local failed_containers="$3"

  if [[ -n "$failed_containers" && -n "$running_containers" ]]; then
    send_notification "dialog-warning" "critical" "⚠️ Podman: Mixed Container Status" \
      "Pod '$pod_name' is up, but the following containers are not running:\n$failed_containers\n\nThe following containers are running:\n$running_containers"
  elif [[ -n "$failed_containers" ]]; then
    send_notification "dialog-error" "critical" "❌ Podman: Containers Not Running" \
      "Pod '$pod_name' is up, but these containers are not running:\n$failed_containers"
  else
    send_notification "dialog-information" "low" "✅ Podman: Pod is Up" \
      "Pod '$pod_name' is up, and all containers are running:\n$running_containers"
  fi
}

main() {
  validate_input "$1"
  local pod_name="$1"
  local pod_id
  pod_id=$(get_pod_id "$pod_name")

  if [[ -z "$pod_id" ]]; then
    send_notification "dialog-error" "critical" "❌ Podman: Pod Not Found" "No running pod named '$pod_name' was found."
  fi

  local containers
  containers=$(get_containers "$pod_id")

  local status_output
  status_output=$(check_containers_status "$containers")

  local running_containers
  local failed_containers
  read -r running_containers failed_containers <<< "$status_output"

  send_pod_status_notification "$pod_name" "$running_containers" "$failed_containers"
}

main "$@"
