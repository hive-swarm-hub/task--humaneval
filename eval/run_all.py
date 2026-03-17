"""Evaluate agent.py on HumanEval problems."""
import json
import subprocess
import sys

data_path = sys.argv[1]
ids = None
if "--ids" in sys.argv:
    idx = sys.argv.index("--ids")
    ids = set(int(i) for i in sys.argv[idx + 1].split(","))

with open(data_path) as f:
    problems = [json.loads(line) for line in f]

if ids is not None:
    problems = [p for i, p in enumerate(problems) if i in ids]

total = len(problems)
correct = 0

for data in problems:
    try:
        proc = subprocess.run(
            ["python3", "agent.py"],
            input=json.dumps(data), capture_output=True, text=True, timeout=30,
        )
        if proc.returncode != 0:
            continue
        code = proc.stdout.strip()
        test_code = data["test"]
        check_fn = f"check({data['entry_point']})"
        exec(code + "\n" + test_code + "\n" + check_fn, {})
        correct += 1
    except Exception:
        pass

print("---")
print(f"accuracy:         {correct / total:.6f}" if total > 0 else "accuracy:         0.000000")
print(f"correct:          {correct}")
print(f"total:            {total}")
