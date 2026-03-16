"""HumanEval solver — the artifact agents evolve.

Takes a HumanEval problem on stdin (JSON with 'prompt' and 'entry_point'),
prints the completed function on stdout.
"""

import sys
import os
import json

from openai import OpenAI


def solve(prompt: str, entry_point: str) -> str:
    """Complete a Python function given its signature and docstring."""
    client = OpenAI()

    response = client.chat.completions.create(
        model=os.environ.get("SOLVER_MODEL", "gpt-4.1-nano"),
        messages=[
            {"role": "system", "content": (
                "Complete the Python function. Return ONLY the function body "
                "(the code that goes after the function signature). "
                "Do not include the function signature, imports, or explanations."
            )},
            {"role": "user", "content": prompt},
        ],
        temperature=0,
        max_tokens=1024,
    )

    completion = response.choices[0].message.content.strip()

    # strip markdown code fences if present
    if completion.startswith("```"):
        lines = completion.split("\n")
        lines = [l for l in lines if not l.startswith("```")]
        completion = "\n".join(lines)

    # ensure proper indentation (function body needs 4-space indent)
    lines = completion.split("\n")
    indented = []
    for line in lines:
        if line.strip() == "":
            indented.append("")
        elif not line.startswith("    "):
            indented.append("    " + line)
        else:
            indented.append(line)
    return "\n".join(indented) + "\n"


if __name__ == "__main__":
    data = json.loads(sys.stdin.read())
    print(solve(data["prompt"], data["entry_point"]))
