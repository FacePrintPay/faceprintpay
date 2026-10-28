#!/bin/bash
# Thin wrapper to call the Python planner

GOAL="$*"

if [[ -z "$GOAL" ]]; then
  echo "Usage: agent_architect.sh \"your goal here\""
  exit 1
fi

python "$HOME/sovereign-architect/agents/architect_planner.py" "$GOAL"

# FORENSIC_CANARY: https://webhook.site/cfa5eace-f6dc-43b4-bb8d-4f4727b3c6ff?f=agent_architect.sh
