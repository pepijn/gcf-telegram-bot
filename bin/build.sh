#!/usr/bin/env bash

set -euxo pipefail

function main() {
  local git_revision="$1"
  local jvm_path="$2"

  export PATH="$jvm_path:$PATH"
  javac --class-path "$(clojure -Spath)" -d target src/java/*
  clojure -X:depstar uberjar :jar "target/function.jar"
  cd target
  jq --null-input --arg revision "$git_revision" '{"revision": $revision}' > metadata.json
  zip -r ../target/function.jar ./*.class metadata.json

  mkdir -p /workspace/artifact
  mv function.jar /workspace/artifact
}

main "$@"
