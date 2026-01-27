from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class JavaTopLevel:
    package: str
    kind: str
    name: str
    path: Path

    @property
    def group(self) -> str:
        prefix = "org.apache.commons.lang3"
        if self.package == prefix:
            return ""
        if self.package.startswith(prefix + "."):
            return self.package[len(prefix) + 1 :]
        return self.package


JAVA_PACKAGE_RE = re.compile(r"^\s*package\s+([a-zA-Z0-9_.]+)\s*;", re.MULTILINE)
JAVA_PUBLIC_TOP_RE = re.compile(
    r"^\s*public\s+(?:final\s+|abstract\s+)?(?:sealed\s+)?(?:non-sealed\s+)?"
    r"(class|interface|enum)\s+([A-Za-z_][A-Za-z0-9_]*)\b",
    re.MULTILINE,
)
JAVA_PUBLIC_INTERFACE_HEAD_RE = re.compile(
    r"^\s*public\s+interface\s+([A-Za-z_][A-Za-z0-9_]*)(?:\s*<([^>{}]*)>)?",
    re.MULTILINE,
)
JAVA_ABSTRACT_METHOD_RE = re.compile(
    r"^\s*(?:public\s+)?(?!default\b)(?!static\b)([A-Za-z0-9_<>\[\].?]+)\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)\s*;",
    re.MULTILINE,
)

CJ_PACKAGE_RE = re.compile(r"^\s*package\s+([a-zA-Z0-9_.]+)\s*$", re.MULTILINE)
CJ_PUBLIC_TYPE_RE = re.compile(
    r"^\s*public\s+(?:open\s+)?(?:abstract\s+)?(class|interface|enum|struct)\s+([A-Za-z_][A-Za-z0-9_]*)\b",
    re.MULTILINE,
)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def collect_java(java_root: Path) -> list[JavaTopLevel]:
    out: list[JavaTopLevel] = []
    for p in sorted(java_root.rglob("*.java")):
        if p.name == "package-info.java":
            continue
        t = read_text(p)
        pm = JAVA_PACKAGE_RE.search(t)
        tm = JAVA_PUBLIC_TOP_RE.search(t)
        if not pm or not tm:
            continue
        out.append(JavaTopLevel(package=pm.group(1), kind=tm.group(1), name=tm.group(2), path=p))
    return out


def collect_cj_types(cj_root: Path) -> set[tuple[str, str]]:
    out: set[tuple[str, str]] = set()
    for p in sorted(cj_root.rglob("*.cj")):
        t = read_text(p)
        pm = CJ_PACKAGE_RE.search(t)
        if not pm:
            continue
        pkg = pm.group(1)
        for m in CJ_PUBLIC_TYPE_RE.finditer(t):
            out.add((pkg, m.group(2)))
    return out


def collect_cj_names(cj_root: Path) -> set[str]:
    names: set[str] = set()
    for pkg, name in collect_cj_types(cj_root):
        names.add(name)
    return names


def camel_to_snake(name: str) -> str:
    s1 = re.sub(r"(.)([A-Z][a-z]+)", r"\1_\2", name)
    s2 = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", s1)
    return s2.lower()


def map_root_target(name: str) -> str:
    if name.endswith("Range"):
        return "range"
    if name in {"SystemProperties", "RuntimeEnvironment", "ThreadUtils"}:
        return "system"
    if name in {"JavaVersion", "LocaleUtils", "Conversion", "Validate", "Functions"}:
        return "utils"
    if name in {"ClassLoaderUtils", "ClassPathUtils", "AnnotationUtils"}:
        return "reflect"
    if name in {"CachedRandomBits"}:
        return "random"
    if name in {"Streams"}:
        return "stream"
    return "utils"


def cj_package_for(java: JavaTopLevel) -> str:
    if java.group == "":
        return f"commons_lang4cj.{map_root_target(java.name)}"
    return f"commons_lang4cj.{java.group}"


def cj_path_for(project_root: Path, java: JavaTopLevel) -> Path:
    if java.group == "":
        group = map_root_target(java.name)
    else:
        group = java.group.replace(".", "/")
    return project_root / "src" / group / f"{camel_to_snake(java.name)}.cj"


def map_java_type_name(type_name: str, generics: set[str]) -> str:
    t = type_name.strip()
    t = re.sub(r"<.*>", "", t)
    t = t.replace("[]", "")
    if t in generics:
        return t
    return {
        "void": "Unit",
        "boolean": "Bool",
        "byte": "Int8",
        "short": "Int16",
        "int": "Int32",
        "long": "Int64",
        "float": "Float32",
        "double": "Float64",
        "char": "Rune",
        "String": "String",
    }.get(t, "Any")


def parse_interface_signature(java_text: str) -> tuple[list[str], tuple[str, str, list[tuple[str, str]]] | None]:
    head = JAVA_PUBLIC_INTERFACE_HEAD_RE.search(java_text)
    generics: list[str] = []
    generic_set: set[str] = set()
    if head and head.group(2):
        raw = head.group(2)
        parts = [p.strip() for p in raw.split(",") if p.strip()]
        for part in parts:
            name = part.split()[0]
            name = name.split("extends", 1)[0].strip()
            name = name.split("&", 1)[0].strip()
            if name:
                generics.append(name)
                generic_set.add(name)

    m = JAVA_ABSTRACT_METHOD_RE.search(java_text)
    if not m:
        return generics, None
    ret_raw, meth, params_raw = m.group(1), m.group(2), m.group(3).strip()
    params: list[tuple[str, str]] = []
    if params_raw:
        for idx, p in enumerate([x.strip() for x in params_raw.split(",") if x.strip()]):
            p = p.replace("final ", "").strip()
            pieces = p.split()
            if len(pieces) >= 2:
                ty = map_java_type_name(pieces[0], generic_set)
                nm = pieces[-1]
            else:
                ty = "Any"
                nm = f"p{idx}"
            params.append((nm, ty))
    ret = map_java_type_name(ret_raw, generic_set)
    return generics, (meth, ret, params)


def render_stub(java: JavaTopLevel, cj_pkg: str) -> str:
    base = [f"package {cj_pkg}", ""]

    if java.kind == "interface" and cj_pkg.endswith(".function"):
        generics, sig = parse_interface_signature(read_text(java.path))
        generic_part = f"<{', '.join(generics)}>" if generics else ""
        if sig is None:
            return "\n".join(base + [f"public interface {java.name}{generic_part} {{", "}"]) + "\n"
        meth, ret, params = sig
        params_s = ", ".join(f"{n}: {t}" for n, t in params)
        return "\n".join(
            base
            + [
                f"public interface {java.name}{generic_part} {{",
                f"    func {meth}({params_s}): {ret}",
                "}",
            ]
        ) + "\n"

    if java.kind == "interface":
        return "\n".join(base + [f"public interface {java.name} {{", "}"]) + "\n"

    if java.kind == "enum":
        return "\n".join(base + [f"public enum {java.name} {{", "    | UNKNOWN", "}"]) + "\n"

    if java.kind == "class" and java.name.endswith("Exception"):
        return "\n".join(
            base
            + [
                "import commons_lang4cj.exception.*",
                "",
                f"public class {java.name} <: Exception {{",
                "    public init(message: String) {",
                "        super(message)",
                "    }",
                "}",
            ]
        ) + "\n"

    return "\n".join(
        base
        + [
            "import commons_lang4cj.exception.*",
            "",
            f"public class {java.name} {{",
            "    public init() {",
            f"        throw NotImplementedException(\"{java.name} is not implemented\")",
            "    }",
            "}",
        ]
    ) + "\n"


def main() -> int:
    script_path = Path(__file__).resolve()
    project_root = script_path.parents[1]
    repo_root = script_path.parents[2]

    java_root = repo_root / "commons-lang" / "src" / "main" / "java" / "org" / "apache" / "commons" / "lang3"
    cj_root = project_root / "src"

    java_types = collect_java(java_root)
    existing = collect_cj_types(cj_root)
    existing_names = collect_cj_names(cj_root)

    created = 0
    for jt in java_types:
        cj_pkg = cj_package_for(jt)
        out_path = cj_path_for(project_root, jt)

        if (cj_pkg, jt.name) in existing or jt.name in existing_names:
            continue

        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(render_stub(jt, cj_pkg), encoding="utf-8")
        created += 1

    print(f"generated {created} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

