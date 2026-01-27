# commons-lang4cj API 参考

本文档说明当前版本对外暴露的模块与入口类型，并给出源码入口位置，避免在文档中重复粘贴方法签名导致与实现漂移。

## 快速开始

### 依赖引入

```toml
[dependencies]
  commons_lang4cj = { git = "https://github.com/mumu-xsy/commons-lang4cj.git" }
```

### 导入方式

推荐按包导入需要的模块：

```cangjie
import commons_lang4cj.utils.*
import commons_lang4cj.text.*
import commons_lang4cj.time.*
```

也可以直接导入根导出（聚合导出，适合 demo/脚本）：

```cangjie
import commons_lang4cj.*
```

## 模块总览

| 模块 | 主要类型（示例） | 源码入口 | 测试入口 |
|---|---|---|---|
| utils | StringUtils / ArrayUtils / ObjectUtils / NumberUtils / ValidateUtils | `src/utils/` | `src/test/utils/` |
| builder | EqualsBuilder / HashCodeBuilder / ToStringBuilder / CompareToBuilder | `src/builder/` | `src/test/builder/` |
| mutable | MutableInt / MutableLong / MutableDouble / MutableObject | `src/mutable/` | `src/test/mutable/` |
| time | StopWatch / DateUtils / DateFormatUtils / DurationFormatUtils | `src/time/` | `src/test/time/` |
| math | Fraction / IEEE754rUtils | `src/math/` | `src/test/math/` |
| text | WordUtils / StrSubstitutor / StrTokenizer / StringEscapeUtils | `src/text/` | `src/test/text/` |
| text.translate | CharSequenceTranslator / UnicodeEscaper / NumericEntityEscaper | `src/text/translate/` | `src/test/text/` |
| concurrent | Memoizer / CircuitBreaker / BackgroundInitializer / LazyInitializer | `src/concurrent/` | `src/test/concurrent/` |
| random | RandomStringUtils / RandomUtils | `src/random/` | `src/test/random/` |
| tuple | Pair / Triple | `src/tuple/` | `src/test/tuple/` |
| range | Range / NumberRange / CharRange | `src/range/` | `src/test/range/` |
| enums | EnumUtils | `src/enums/` | `src/test/enums/` |
| reflect | ClassUtils / InheritanceUtils | `src/reflect/` | `src/test/reflect/` |
| system | SystemUtils / RuntimeEnvironment / ThreadUtils | `src/system/` | `src/test/system/` |
| function | TriFunction / TriConsumer / Failable* 系列 | `src/function/` | `src/test/function/` |
| stream | Streams / LangCollectors / IntStreams | `src/stream/` | `src/test/stream/` |
| util | IterableStringTokenizer 等 | `src/util/` | （随模块测试覆盖） |

## 行为与差异说明

- API 以“可在仓颉语义下正确实现”为前提，尽量做到类型安全与 Option-safe（不依赖 JVM 的 null/反射/序列化语义）。
- 对标 Lang3 的整体迁移与缺口，请参考：
  - `doc/migration_gap_report.md`
  - `doc/lang3_migration_matrix.md`
  - `doc/lang3_support_policy.md`
