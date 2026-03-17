#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading HumanEval..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib
ds = load_dataset('openai/openai_humaneval', split='test')
out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in ds:
        f.write(json.dumps({"task_id": row["task_id"], "prompt": row["prompt"], "canonical_solution": row["canonical_solution"], "test": row["test"], "entry_point": row["entry_point"]}) + '\n')
print(f'Wrote {len(ds)} problems to {out}')
PY
echo "Done."
