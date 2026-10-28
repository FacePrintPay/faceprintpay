#!/bin/bash
# Drain all tasks for a given PLAN_ID using yesquid_task_worker

set -euo pipefail

PLAN_ID="${1:-52f7b763}"

while true; do
  ./agents/yesquid_task_worker.sh "$PLAN_ID" || break
done

echo "✅ Finished run_all_tasks for plan ${PLAN_ID}"

# FORENSIC_CANARY: https://webhook.site/cfa5eace-f6dc-43b4-bb8d-4f4727b3c6ff?f=run_all_tasks.sh
