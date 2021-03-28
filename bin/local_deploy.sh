#!/usr/bin/env bash

set -euxo pipefail

# Shellcheck itself
shellcheck "$0"

cd "$(dirname "$(realpath "$0")")/.."

function main() {
  ./bin/test.sh

  local tmp_dir
  tmp_dir="$(gmktemp --directory)"

  ./bin/build.sh "dev-SNAPSHOT" \
    ~/Library/Java/JavaVirtualMachines/adopt-openjdk-11.0.10/Contents/Home \
    "$tmp_dir"

  ./bin/deploy_cf.sh "telegram-bot" \
    "$PROJECT_ID" \
    "$tmp_dir"

  terminal-notifier -sound default -message "Deployment of Cloud Function completed"
  rm -rf "$tmp_dir"
}

main
