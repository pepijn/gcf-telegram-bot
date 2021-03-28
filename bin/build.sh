#!/usr/bin/env bash

set -euxo pipefail

function main() {
  local git_revision="$1"
  export JAVA_HOME="$2"
  local artifact_dir="$3"

  export PATH="$JAVA_HOME/bin:$PATH"
  javac --class-path "$(clojure -Spath)" -d target src/java/*
  clojure -X:depstar uberjar :jar "target/function.jar"
  cd target
  jq --null-input --arg revision "$git_revision" '{"revision": $revision}' > metadata.json
  zip -r ../target/function.jar ./*.class metadata.json

  mkdir -p "$artifact_dir/artifact"
  cp function.jar "$artifact_dir/artifact"
}

main "$@"
