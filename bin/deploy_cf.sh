#!/usr/bin/env bash

set -euxo pipefail

function main() {
  local project_id="$1"

  gcloud functions deploy --region europe-west2 --runtime java11 --source /workspace/artifact/ "$@" \
    --service-account "telegram-bot@$project_id.iam.gserviceaccount.com" \
    --trigger-topic "cloud-builds" \
    --entry-point TelegramBot
}

main "telegram-bot"

