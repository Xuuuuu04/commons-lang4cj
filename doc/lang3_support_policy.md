# commons-lang4cj 对标 Lang3 的支持策略

本文档解释：当 Apache Commons Lang3 的能力与仓颉（Cangjie）语言/标准库/运行时语义不一致时，`commons-lang4cj` 如何决定“支持 / 不支持”，以及如何在代码与文档中呈现差异。

## 基本原则

- 以“仓颉可正确实现”为前提：只承诺能在 CJ 语义下正确实现、并能用单测锁定行为的能力。
- 避免误导：对无法对齐的能力，明确标注为不支持（并抛出清晰异常或不提供该能力），同时在迁移矩阵里记录原因。
- 优先迁移平台弱耦合的能力：纯算法/纯数据转换/字符串与集合工具优先，便于后续扩展。

## 明确不支持（默认）

以下能力与 JVM/Java 生态强绑定或风险过高，默认不支持（迁移矩阵会标为 ⛔）：

- Java 原生序列化语义：`SerializationUtils` / `SerializationException`
  - 原因：依赖 `Serializable`、对象图、`readObject/writeObject`、`serialVersionUID`、类加载等 JVM 机制。
  - 处理：在仓颉侧不提供“Java 兼容序列化”。若未来提供 CJ 序列化帮助工具，将以新的语义与独立 API 说明。
- classpath 与类加载扫描：`ClassPathUtils` / `ClassLoaderUtils`
  - 原因：classpath、类加载器与资源定位语义与 CJ 运行时不等价。
  - 处理：不提供对标实现，避免给出“看似可用但语义不一致”的 API。

## 语义对齐策略

- 命名对标但实现以 CJ 为准：同名类型尽量保持“意图一致”，但实现细节以 CJ 语言特性与标准库能力为边界。
- 可验证优先：只要能写出明确的单测与边界条件，就能纳入支持范围；否则宁可不支持也不做模糊实现。

## 验收方式

- 迁移矩阵（`doc/lang3_migration_matrix.md`）对每个原项目类型给出状态。
- “已实现”的能力必须有单测覆盖关键边界。
- 每次修改后必须通过 `cjpm test` 全量测试。
