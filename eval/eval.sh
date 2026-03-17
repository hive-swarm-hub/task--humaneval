#!/usr/bin/env bash
# Usage:
#   bash eval/eval.sh              — train set (for experimentation)
#   bash eval/eval.sh --test       — test set (for submission only)
#   bash eval/eval.sh --ids 0,3,5  — specific indices (for debugging)
set -euo pipefail

DATA="data/train.jsonl"
IDS=""
while [ $# -gt 0 ]; do
    case "$1" in
        --test) DATA="data/test.jsonl"; shift ;;
        --ids) IDS="$2"; shift 2 ;;
        --ids=*) IDS="${1#--ids=}"; shift ;;
        *) shift ;;
    esac
done

if [ ! -f "$DATA" ]; then
    echo "ERROR: $DATA not found. Run: bash prepare.sh" >&2
    exit 1
fi

echo "Evaluating from $DATA..." >&2

if [ -n "$IDS" ]; then
    python3 eval/run_all.py "$DATA" --ids "$IDS"
else
    python3 eval/run_all.py "$DATA"
fi
