# commons-lang4cj 对标 Lang3 的支持策略

本文档解释：当 Apache Commons Lang3 的能力与仓颉（Cangjie）语言/标准库/运行时语义不一致时，`commons-lang4cj` 如何决定“支持 / 子集支持 / 不支持”。

## 基本原则

- 以“仓颉支持”为前提：只承诺能在 CJ 语义下正确实现、并能用单测锁定行为的能力。
- 避免误导：对无法对齐的能力，要么不提供，要么显式标注为不支持（并抛出清晰异常），同时在迁移矩阵里记录原因。
- 先补基础设施：优先迁移纯算法/纯数据转换/与平台弱耦合的工具类，使后续迁移更顺。

## 明确不支持（默认）

以下能力与 JVM/Java 生态强绑定或风险过高，默认不支持：

- Java 原生序列化语义：`SerializationUtils/SerializationException`\n  - 原因：依赖 `Serializable`、对象图、`readObject/writeObject`、`serialVersionUID`、类加载等 JVM 机制。\n  - 处理：迁移矩阵标为“不支持”；如未来要提供 CJ 侧序列化帮助工具，会以“非 Java 兼容”的新语义独立说明。
- classpath 与类加载扫描：`ClassPathUtils/ClassLoaderUtils`\n  - 原因：classpath、类加载器与资源定位语义与 CJ 运行时不等价。\n  - 处理：默认不支持或仅提供极小子集（例如纯字符串拼接类名/路径的工具）。
- 依赖 Java Stream 生态：`stream/*`（`Streams/LangCollectors/IntStreams`）\n  - 原因：Java Stream/Collector 生态在 CJ 中不存在 1:1 等价。\n  - 处理：优先以 CJ 原生集合能力替代；如确有需求，仅提供“工具子集”（例如对数组/列表的简单收集器）。

## 子集支持（按能力裁剪）

以下能力在 CJ 中存在部分等价实现，但很难 1:1 对齐 Java 行为，采用“能力子集”策略：

- 反射相关：`reflect/*` 与 builder 的 `Reflection*` 系列\n  - 主要限制来自 `std.reflect`：只能访问 public 成员，且不支持函数类型/元组/enum 的反射等。\n  - 策略：优先实现“类名/继承关系/公开成员访问”的常用子集；其余 API 明确抛出异常或不提供。\n
- 并发相关：`concurrent/*`\n  - 策略：按 CJ 并发原语与调度能力逐步补齐；无法对齐的取消/超时/异常封装语义会在文档中明确差异。

## 验收方式

- 迁移矩阵（[lang3_migration_matrix.md](./lang3_migration_matrix.md)）必须对每个原项目类型给出状态与原因。\n- 所有“已实现/子集支持”的能力必须有单测覆盖关键边界。\n- 每批次迁移后必须通过 `cjpm test` 全量测试。

