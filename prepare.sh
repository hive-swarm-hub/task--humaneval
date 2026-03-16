#!/usr/bin/env bash
# Download HumanEval dataset. Run once.
set -euo pipefail

mkdir -p data

echo "Downloading HumanEval..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)
ds = load_dataset('openai/openai_humaneval', split='test')
samples = list(ds)
random.shuffle(samples)
samples = samples[:50]

out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in samples:
        f.write(json.dumps({
            'task_id': row['task_id'],
            'prompt': row['prompt'],
            'canonical_solution': row['canonical_solution'],
            'test': row['test'],
            'entry_point': row['entry_point'],
        }) + '\n')

print(f'Wrote {len(samples)} problems to {out}')
"

echo "Done. $(wc -l < data/test.jsonl) problems in data/test.jsonl"
