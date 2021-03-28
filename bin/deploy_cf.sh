#!/usr/bin/env bash

set -euxo pipefail

function main() {
  local function_name="$1"
  local project_id="$2"

  gcloud functions deploy --region europe-west2 --runtime java11 --source /workspace/artifact/ "$function_name" \
    --service-account "telegram-bot@$project_id.iam.gserviceaccount.com" \
    --trigger-topic "cloud-builds" \
    --entry-point TelegramBot
}

main "$@"
