# commons-lang4cj 迁移缺口报告

本文档用于快速回答“还有什么没迁移完成？”以及给出下一步迁移方向。

## 结论（基于当前仓库源码与单测）

- 以 [feature_api.md](./feature_api.md) 列出的“当前提供的模块”为目标清单：已全部具备对应实现与测试用例。
- 以源码中“简化实现/占位实现/未实现/TODO”等关键词为信号：当前不再存在明确的占位实现。
- 当前仓库不包含 SerializationUtils（序列化工具）；如需对标 Apache Commons Lang 的序列化能力，需要另行规划实现范围。
- 若以仓库内 Java 原项目 `commons-lang` 为完整对标目标，请以迁移矩阵 [lang3_migration_matrix.md](./lang3_migration_matrix.md) 跟踪剩余缺口与优先级。

## 目标模块清单对照（feature_api.md）

| 模块 | feature_api.md 列出的 API | 代码位置 | 测试位置 | 状态 |
|---|---|---|---|---|
| utils | StringUtils / Strings / CharSequenceUtils / ArrayUtils / ArrayFill / ArraySorter / ObjectUtils / NumberUtils / BooleanUtils / CharUtils / ValidateUtils / CharEncoding / Charsets / CharSet / CharSetUtils / RegExUtils / BitField / AppendableJoiner | `src/utils/*.cj` | `src/test/utils/*.cj` | OK |
| builder | Builder / EqualsBuilder / HashCodeBuilder / ToStringBuilder / CompareToBuilder | `src/builder/*.cj` | `src/test/builder/*.cj` | OK |
| mutable | MutableInt / MutableLong / MutableDouble / MutableFloat / MutableByte / MutableShort / MutableBoolean / MutableObject | `src/mutable/*.cj` | `src/test/mutable/*.cj` | OK |
| time | StopWatch / DateFormatUtils / DurationFormatUtils / DateUtils | `src/time/*.cj` | `src/test/time/*.cj` | OK |
| math | Fraction / IEEE754rUtils | `src/math/*.cj` | `src/test/math/*.cj` | OK |
| text | WordUtils / StrSubstitutor / StrTokenizer / StringEscapeUtils / LevenshteinDistance | `src/text/**/*.cj` | `src/test/text/*.cj` | OK |
| concurrent | Memoizer / CircuitBreaker / BackgroundInitializer / LazyInitializer | `src/concurrent/*.cj` | `src/test/concurrent/*.cj` | OK |
| random | RandomStringUtils / RandomUtils | `src/random/*.cj` | `src/test/random/*.cj` | OK |
| tuple | Pair / Triple | `src/tuple/*.cj` | `src/test/tuple/*.cj` | OK |
| range | Range / NumberRange / CharRange | `src/range/*.cj` | `src/test/range/*.cj` | OK |
| enums | EnumUtils | `src/enums/*.cj` | `src/test/enums/*.cj` | OK |
| reflect | ClassUtils / InheritanceUtils | `src/reflect/*.cj` | `src/test/reflect/*.cj` | OK |
| system | SystemUtils | `src/system/*.cj` | `src/test/system/*.cj` | OK |
| function | TriFunction / TriConsumer / ToBooleanBiFunction | `src/function/*.cj` | `src/test/function/*.cj` | OK |

## 说明：如果要继续扩展迁移范围

如果你的目标是“对标仓库内 Java 原项目（Apache Commons Lang3）并尽量全量迁移”，请以以下文档为准：

- 迁移矩阵：`lang3_migration_matrix.md`
- 支持策略与边界：`lang3_support_policy.md`
