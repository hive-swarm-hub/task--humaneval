#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading HumanEval..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)
items = list(load_dataset('openai/openai_humaneval', split='test'))
random.shuffle(items)

dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in items[:100]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'canonical_solution': row['canonical_solution'], 'test': row['test'], 'entry_point': row['entry_point']}) + '
')

test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in items[100:]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'canonical_solution': row['canonical_solution'], 'test': row['test'], 'entry_point': row['entry_point']}) + '
')

print(f'Dev:  100 problems -> {dev_out}')
print(f'Test: {len(items)-100} problems -> {test_out}')
"
echo "Done."
