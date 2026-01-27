from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class JavaType:
    package: str
    name: str
    rel_path: str

    @property
    def fqcn(self) -> str:
        return f"{self.package}.{self.name}"

    @property
    def group(self) -> str:
        prefix = "org.apache.commons.lang3"
        if self.package == prefix:
            return ""
        if self.package.startswith(prefix + "."):
            return self.package[len(prefix) + 1 :]
        return self.package


@dataclass(frozen=True)
class CjType:
    package: str
    name: str
    rel_path: str

    @property
    def fqcn(self) -> str:
        return f"{self.package}.{self.name}"


JAVA_PUBLIC_TYPE_RE = re.compile(
    r"^\s*public\s+(?:final\s+|abstract\s+)?(?:sealed\s+)?(?:non-sealed\s+)?"
    r"(class|interface|enum)\s+([A-Za-z_][A-Za-z0-9_]*)\b",
    re.MULTILINE,
)
JAVA_PACKAGE_RE = re.compile(r"^\s*package\s+([a-zA-Z0-9_.]+)\s*;", re.MULTILINE)

CJ_PACKAGE_RE = re.compile(r"^\s*package\s+([a-zA-Z0-9_.]+)\s*$", re.MULTILINE)
CJ_PUBLIC_TYPE_RE = re.compile(
    r"^\s*public\s+(?:open\s+)?(?:abstract\s+)?(class|interface|enum|struct)\s+([A-Za-z_][A-Za-z0-9_]*)\b",
    re.MULTILINE,
)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def collect_java_types(java_root: Path) -> list[JavaType]:
    types: list[JavaType] = []
    for path in sorted(java_root.rglob("*.java")):
        if path.name == "package-info.java":
            continue
        text = read_text(path)
        pkg_m = JAVA_PACKAGE_RE.search(text)
        if not pkg_m:
            continue
        type_m = JAVA_PUBLIC_TYPE_RE.search(text)
        if not type_m:
            continue
        pkg = pkg_m.group(1)
        name = type_m.group(2)
        types.append(JavaType(package=pkg, name=name, rel_path=str(path).replace("\\", "/")))
    return types


def collect_cj_types(cj_root: Path) -> list[CjType]:
    types: list[CjType] = []
    for path in sorted(cj_root.rglob("*.cj")):
        text = read_text(path)
        pkg_m = CJ_PACKAGE_RE.search(text)
        if not pkg_m:
            continue
        pkg = pkg_m.group(1)
        for m in CJ_PUBLIC_TYPE_RE.finditer(text):
            name = m.group(2)
            types.append(CjType(package=pkg, name=name, rel_path=str(path).replace("\\", "/")))
    return types


def choose_best_cj(java_type: JavaType, candidates: list[CjType]) -> CjType | None:
    if not candidates:
        return None
    group = java_type.group
    group_head = group.split(".", 1)[0] if group else ""

    def score(cj: CjType) -> tuple[int, int, str]:
        s = 0
        if group_head:
            if cj.package.endswith("." + group_head):
                s += 20
            elif ("." + group_head + ".") in (cj.package + "."):
                s += 10
        if cj.package.endswith(".utils") and group == "":
            s += 8
        if cj.package.endswith(".range") and java_type.name.endswith("Range"):
            s += 8
        return (s, -len(cj.package), cj.fqcn)

    return sorted(candidates, key=score, reverse=True)[0]


def status_for(java_type: JavaType, cj_match: CjType | None) -> str:
    not_supported = {"ClassLoaderUtils", "ClassPathUtils", "SerializationUtils"}
    if java_type.name in not_supported:
        return "⛔"
    if cj_match is not None:
        try:
            text = Path(cj_match.rel_path).read_text(encoding="utf-8", errors="replace")
        except OSError:
            return "🟡"
        if "is not implemented" in text:
            return "🟡"
        return "✅"
    return "🟡"


def render_matrix(java_types: list[JavaType], cj_types: list[CjType]) -> str:
    cj_by_name: dict[str, list[CjType]] = {}
    for t in cj_types:
        cj_by_name.setdefault(t.name, []).append(t)

    groups: dict[str, list[JavaType]] = {}
    for jt in java_types:
        groups.setdefault(jt.group, []).append(jt)
    for g in groups:
        groups[g].sort(key=lambda x: x.name)

    lines: list[str] = []
    lines.append("# Apache Commons Lang3 迁移矩阵（以仓库内原项目为准）")
    lines.append("")
    lines.append("本矩阵以仓库内 Java 源码树 `commons-lang/src/main/java/org/apache/commons/lang3/**` 为“原项目事实来源”，用于追踪在 `commons-lang4cj` 中的迁移状态。")
    lines.append("")
    lines.append("状态说明：")
    lines.append("")
    lines.append("- ✅ 已实现：已有 CJ 实现与单测")
    lines.append("- 🟡 计划中：尚未实现（后续批次会补齐）")
    lines.append("- ⚠️ 子集：只实现 CJ 可支持的能力子集（会标注差异并用单测锁定）")
    lines.append("- ⛔ 不支持：与 JVM/Java 生态强绑定，CJ 无等价语义或风险过高")
    lines.append("")

    def section_title(group: str) -> str:
        if group == "":
            return "## 根包 org.apache.commons.lang3"
        return f"## 子包 {group}"

    for group in [""] + sorted([g for g in groups.keys() if g != ""]):
        lines.append(section_title(group))
        lines.append("")
        for jt in groups[group]:
            cj_match = choose_best_cj(jt, cj_by_name.get(jt.name, []))
            st = status_for(jt, cj_match)
            if cj_match is None:
                lines.append(f"- {st} {jt.name}")
            else:
                lines.append(f"- {st} {jt.name} → `{cj_match.fqcn}`")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def render_gap_section(java_types: list[JavaType], cj_types: list[CjType]) -> str:
    cj_by_name: dict[str, list[CjType]] = {}
    for t in cj_types:
        cj_by_name.setdefault(t.name, []).append(t)

    rows: list[tuple[JavaType, str]] = []
    for jt in java_types:
        cj_match = choose_best_cj(jt, cj_by_name.get(jt.name, []))
        rows.append((jt, status_for(jt, cj_match)))

    total = len(rows)
    done = sum(1 for _, s in rows if s == "✅")
    planned = sum(1 for _, s in rows if s == "🟡")
    subset = sum(1 for _, s in rows if s == "⚠️")
    unsupported = sum(1 for _, s in rows if s == "⛔")

    by_group: dict[str, dict[str, int]] = {}
    for jt, s in rows:
        g = jt.group or "(root)"
        by_group.setdefault(g, {"✅": 0, "🟡": 0, "⚠️": 0, "⛔": 0})[s] += 1

    missing = [(jt, s) for jt, s in rows if s in ("🟡", "⚠️", "⛔")]
    missing.sort(key=lambda x: (x[0].group, x[1], x[0].name))

    lines: list[str] = []
    lines.append("<!-- AUTO-GENERATED:LANG3-GAPS:BEGIN -->")
    lines.append("")
    lines.append("## 按 Lang3 原项目对标的缺口（自动生成）")
    lines.append("")
    lines.append(f"- 总计类型数：{total}")
    lines.append(f"- ✅ 已实现：{done}")
    lines.append(f"- 🟡 计划中：{planned}")
    lines.append(f"- ⚠️ 子集：{subset}")
    lines.append(f"- ⛔ 不支持：{unsupported}")
    lines.append("")
    lines.append("### 按包统计")
    lines.append("")
    lines.append("| 包 | ✅ | 🟡 | ⚠️ | ⛔ |")
    lines.append("|---|---:|---:|---:|---:|")
    for g in sorted(by_group.keys()):
        c = by_group[g]
        lines.append(f"| {g} | {c['✅']} | {c['🟡']} | {c['⚠️']} | {c['⛔']} |")
    lines.append("")
    lines.append("### 明细（非 ✅）")
    lines.append("")
    for jt, s in missing:
        prefix = jt.group or "root"
        lines.append(f"- {s} {prefix}.{jt.name}")
    lines.append("")
    lines.append("<!-- AUTO-GENERATED:LANG3-GAPS:END -->")
    lines.append("")
    return "\n".join(lines)


def upsert_gap_report(project_root: Path, java_types: list[JavaType], cj_types: list[CjType]) -> None:
    gap_path = project_root / "doc" / "migration_gap_report.md"
    text = gap_path.read_text(encoding="utf-8", errors="replace")
    section = render_gap_section(java_types, cj_types)

    begin = "<!-- AUTO-GENERATED:LANG3-GAPS:BEGIN -->"
    end = "<!-- AUTO-GENERATED:LANG3-GAPS:END -->"
    if begin in text and end in text:
        head, rest = text.split(begin, 1)
        _, tail = rest.split(end, 1)
        merged = head.rstrip() + "\n\n" + section + tail.lstrip()
    else:
        merged = text.rstrip() + "\n\n" + section
    gap_path.write_text(merged, encoding="utf-8")


def main() -> int:
    script_path = Path(__file__).resolve()
    project_root = script_path.parents[1]
    repo_root = script_path.parents[2]

    java_root = repo_root / "commons-lang" / "src" / "main" / "java" / "org" / "apache" / "commons" / "lang3"
    cj_src_root = project_root / "src"
    doc_root = project_root / "doc"

    java_types = collect_java_types(java_root)
    cj_types = collect_cj_types(cj_src_root)

    out = render_matrix(java_types, cj_types)
    (doc_root / "lang3_migration_matrix.md").write_text(out, encoding="utf-8")
    upsert_gap_report(project_root, java_types, cj_types)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

