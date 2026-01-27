from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Hit:
    path: str
    line_no: int
    line: str


def main() -> int:
    project_root = Path(__file__).resolve().parents[1]
    src_root = project_root / "src"

    needle = 'is not implemented'
    hits: list[Hit] = []

    for path in sorted(src_root.rglob("*.cj")):
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for i, line in enumerate(text.splitlines(), start=1):
            if needle in line:
                hits.append(Hit(path=str(path).replace("\\", "/"), line_no=i, line=line.strip()))

    if not hits:
        return 0

    print(f"Found {len(hits)} placeholder marker lines containing: {needle!r}")
    for h in hits[:200]:
        print(f"{h.path}:{h.line_no}: {h.line}")
    if len(hits) > 200:
        print(f"... ({len(hits) - 200} more)")

    return 1


if __name__ == "__main__":
    raise SystemExit(main())

