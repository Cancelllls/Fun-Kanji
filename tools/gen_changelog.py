#!/usr/bin/env python3
"""Generate changelog for a release from git commit log since last tag.

Usage:
  python3 tools/gen_changelog.py <version>     # CI: generate for release
  python3 tools/gen_changelog.py               # print from git log (dry run)
"""
import subprocess, sys

def _git_log_since_tag():
    """Collect commit messages since the last git tag."""
    try:
        last_tag = (
            subprocess.check_output(
                ["git", "describe", "--tags", "--abbrev=0"],
                stderr=subprocess.DEVNULL,
            )
            .decode()
            .strip()
        )
        log = subprocess.check_output(
            ["git", "log", f"{last_tag}..HEAD", "--pretty=format:%s"],
            stderr=subprocess.DEVNULL,
        ).decode().strip()
    except subprocess.CalledProcessError:
        log = (
            subprocess.check_output(
                ["git", "log", "--pretty=format:%s"],
                stderr=subprocess.DEVNULL,
            )
            .decode()
            .strip()
        )
    return [line.strip() for line in log.split("\n") if line.strip()]


def _classify_commits(messages: list[str]) -> tuple[list[str], list[str], list[str]]:
    """Split into feat, fix, and other buckets."""
    feat, fix, other = [], [], []
    for msg in messages:
        if msg.startswith("Merge ") or msg.startswith("[skip ci]"):
            continue
        lower = msg.lower()
        if lower.startswith("feat") or lower.startswith("add"):
            feat.append(msg)
        elif lower.startswith("fix") or lower.startswith("bug"):
            fix.append(msg)
        elif lower.startswith("perf") or lower.startswith("refactor"):
            other.append(msg)
        else:
            other.append(msg)
    return feat, fix, other


def gen_changelog(version: str) -> str:
    messages = _git_log_since_tag()
    if not messages:
        return f"## Fun Kanji v{version}\n\n- Incremental release & UI improvements."

    feat, fix, other = _classify_commits(messages)
    lines = [f"## 🌸 Fun Kanji v{version}\n"]

    if feat:
        lines.append(f"### ✨ Added ({len(feat)})")
        for m in feat:
            lines.append(f"- {m}")
        lines.append("")

    if fix:
        lines.append(f"### 🐛 Fixed ({len(fix)})")
        for m in fix:
            lines.append(f"- {m}")
        lines.append("")

    if other:
        lines.append(f"### 🛠️ Maintenance & Refactor ({len(other)})")
        for m in other:
            lines.append(f"- {m}")
        lines.append("")

    return "\n".join(lines)


def main():
    version = sys.argv[1] if len(sys.argv) > 1 else "1.0.0"
    print(gen_changelog(version))


if __name__ == "__main__":
    main()
