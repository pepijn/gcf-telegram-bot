#!/usr/bin/env bash

set -euxo pipefail

function_name="$1"
project_id="$2"
artifact_dir="$3"

./bin/deploy_cf_base.sh "$function_name" \
  --source "$artifact_dir/artifact" \
  --service-account "$function_name@$project_id.iam.gserviceaccount.com" \
  --trigger-topic "cloud-builds" \
  --entry-point TelegramBot
