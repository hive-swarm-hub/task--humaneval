"""Evaluate agent.py on HumanEval. Runs generated code against test cases."""

import json
import subprocess
import sys
import tempfile
import textwrap


def check_solution(prompt: str, completion: str, test: str, entry_point: str) -> bool:
    """Run the completed function against the test cases."""
    # build the full program: prompt (signature) + completion + tests
    full_code = prompt + completion + "\n\n" + test + f"\n\ncheck({entry_point})\n"

    with tempfile.NamedTemporaryFile(mode="w", suffix=".py", delete=False) as f:
        f.write(full_code)
        f.flush()
        try:
            result = subprocess.run(
                ["python3", f.name],
                capture_output=True, text=True, timeout=10,
            )
            return result.returncode == 0
        except subprocess.TimeoutExpired:
            return False
        except Exception:
            return False


def main():
    data_path = sys.argv[1]
    with open(data_path) as f:
        problems = [json.loads(line) for line in f]

    total = len(problems)
    correct = 0

    print(f"Evaluating {total} problems...", file=sys.stderr)

    for item in problems:
        # get completion from agent
        try:
            result = subprocess.run(
                ["python3", "agent.py"],
                input=json.dumps(item), capture_output=True, text=True, timeout=60,
            )
            completion = result.stdout
        except (subprocess.TimeoutExpired, Exception):
            completion = "    pass\n"

        if check_solution(item["prompt"], completion, item["test"], item["entry_point"]):
            correct += 1

    accuracy = correct / total
    print("---")
    print(f"pass_at_1:        {accuracy:.6f}")
    print(f"correct:          {correct}")
    print(f"total:            {total}")


if __name__ == "__main__":
    main()
