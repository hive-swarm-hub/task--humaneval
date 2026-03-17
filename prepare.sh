#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading HumanEval..."
python3 -c "
from datasets import load_dataset
import json, pathlib

ds = load_dataset('openai/openai_humaneval', split='test')
ds = ds.shuffle(seed=42)
items = list(ds)

dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in items[:131]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'canonical_solution': row['canonical_solution'], 'test': row['test'], 'entry_point': row['entry_point']}) + '\n')

test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in items[131:]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'canonical_solution': row['canonical_solution'], 'test': row['test'], 'entry_point': row['entry_point']}) + '\n')

print(f'Dev:  131 problems -> {dev_out}')
print(f'Test: 33 problems -> {test_out}')
"
echo "Done."
