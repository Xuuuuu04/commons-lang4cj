# commons-lang4cj

Apache Commons Lang3 的仓颉（Cangjie）移植版本：在 CJ 语义下提供常用的字符串/集合/对象/并发/日期等工具能力，API 以类型安全与 Option-safe 为原则。

<p align="center">
  <img alt="" src="https://img.shields.io/badge/release-v1.2.0-brightgreen" style="display: inline-block;" />
  <img alt="" src="https://img.shields.io/badge/cjc-v1.0.4-brightgreen" style="display: inline-block;" />
  <img alt="" src="https://img.shields.io/badge/license-Apache--2.0-blue" style="display: inline-block;" />
</p>

## 状态

- 目标模块（以 `doc/feature_api.md` 为准）：已实现并有单测覆盖，`cjpm test` 全量通过
- 对标 Lang3（仓库内原项目事实来源）：**已实现 222/226，明确不支持 4 个**（与 JVM 强绑定）
  - 详情见 `doc/migration_gap_report.md` 与 `doc/lang3_migration_matrix.md`

## 安装

在你的 `cjpm.toml` 中添加依赖：

```toml
[dependencies]
  commons_lang4cj = { git = "https://github.com/mumu-xsy/commons-lang4cj.git" }
```

## 使用

```cangjie
import commons_lang4cj.utils.*

main() {
    let s = "  hello  "
    println(StringUtils.trim(s))          // "hello"
    println(StringUtils.isBlank("   "))   // true
}
```

## 构建与测试

```shell
cjpm update
cjpm build
cjpm test
```

## 文档

- API 模块总览：`doc/feature_api.md`
- 对标缺口报告：`doc/migration_gap_report.md`
- 迁移矩阵：`doc/lang3_migration_matrix.md`
- 支持策略：`doc/lang3_support_policy.md`

## 目录结构

```text
.
├── doc/                 # 文档
├── examples/            # 示例代码
├── src/                 # 源码与测试
│   ├── utils/ builder/ mutable/ time/ math/ text/ concurrent/ ...
│   └── test/            # 单元测试（与包同层组织）
├── tools/               # 辅助脚本（生成/检查/迁移矩阵等）
├── cjpm.toml
├── CHANGELOG.md
└── LICENSE
```


## 开发进度（截至 2026-02-07）
- 已完成可公开仓库基线整理：补齐许可证、清理敏感与内部说明文件。
- 当前版本可构建/可运行，后续迭代以 issue 与提交记录持续公开追踪。
