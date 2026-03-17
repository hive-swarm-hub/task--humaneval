#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading HumanEval..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib, random
random.seed(42)
items = list(load_dataset('openai/openai_humaneval', split='test'))
random.shuffle(items)
with pathlib.Path('data/train.jsonl').open('w') as f:
    for row in items[:100]:
        f.write(json.dumps({"task_id": row["task_id"], "prompt": row["prompt"], "canonical_solution": row["canonical_solution"], "test": row["test"], "entry_point": row["entry_point"]}) + '\n')
with pathlib.Path('data/test.jsonl').open('w') as f:
    for row in items[100:]:
        f.write(json.dumps({"task_id": row["task_id"], "prompt": row["prompt"], "canonical_solution": row["canonical_solution"], "test": row["test"], "entry_point": row["entry_point"]}) + '\n')
print(f'Train: 100, Test: {len(items)-100}')
PY
echo "Done."
