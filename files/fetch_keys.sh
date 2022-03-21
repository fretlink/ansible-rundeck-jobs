#!/usr/bin/env bash

set -euo pipefail

BASE_URL="$1"
TOKEN="$2"
BASE_PATH="$3"

list_path_rec() {
  path="$1"
  result=$(curl -ks "$BASE_URL/storage/$path?authtoken=$TOKEN")

  case "$(echo "$result" | jq -r .type)" in
    "file") echo "$result" | jq -r .path | sed -e "s@^$BASE_PATH/@@"
      ;;
    "directory")
      echo "$result" | jq -r ".resources[]|.path" | while read p; do list_path_rec "$p"; done
      ;;
  esac
}

list_path_rec "$BASE_PATH"
