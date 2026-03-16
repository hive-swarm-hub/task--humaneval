#!/usr/bin/env bash
set -euo pipefail

DATA="data/test.jsonl"
if [ ! -f "$DATA" ]; then
    echo "ERROR: $DATA not found. Run: bash prepare.sh" >&2
    exit 1
fi

python3 eval/judge.py "$DATA"
