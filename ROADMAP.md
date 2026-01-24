# Commons Lang for Cangjie (commons-lang4cj) 开发路线图

> **状态**: Phase 1 (基础建设) 已完成，进入 Phase 2 (核心增强)。

本项目旨在将 Java 生态中久经考验的 `Apache Commons Lang 3` 核心库移植到仓颉语言，并针对仓颉特性（如结构体、泛型、Option）进行优化。

## 🔍 现状分析 (Current Status)

目前已完成基础模块的移植，单元测试覆盖率较高，核心功能可用。

### 已完成模块 (Completed)

| 模块 | 包含组件 | 状态 |
| :--- | :--- | :--- |
| **Builder** | `CompareToBuilder`, `EqualsBuilder`, `HashCodeBuilder`, `ToStringBuilder` | ✅ 稳定 |
| **Utils (Core)** | `StringUtils`, `ArrayUtils`, `BooleanUtils`, `CharUtils`, `NumberUtils`, `ObjectUtils`, `ValidateUtils` | ✅ 稳定 |
| **Math** | `Fraction`, `IEEE754rUtils` | ✅ 稳定 |
| **Mutable** | `MutableInt`, `MutableLong`, `MutableObject`, etc. | ✅ 稳定 |
| **Range** | `Range`, `NumberRange`, `CharRange` | ✅ 稳定 |
| **Text** | `StrTokenizer`, `StringEscapeUtils` | ✅ 稳定 |
| **Time** | `StopWatch`, `DateFormatUtils`, `DurationFormatUtils` | ✅ 稳定 |
| **Tuple** | `Pair`, `Triple` | ✅ 稳定 |
| **Exception** | `ExceptionUtils` | ✅ 稳定 |

---

## 🚀 进阶路线图 (Phase 2 Roadmap)

基于 Apache Commons Lang 3 的完整功能图谱，我们识别出以下缺失的关键模块。

### 1. 核心增强 (Core Enhancements) [P0]

- [ ] **SystemUtils**
    - **目标**: 提供操作系统、仓颉运行时版本、用户目录等环境信息。
    - **参考**: `std.env`, `std.os`
- [ ] **RandomStringUtils**
    - **目标**: 生成随机字母、数字、ASCII 字符串。
    - **参考**: `std.random`
- [ ] **EnumUtils**
    - **目标**: 枚举操作工具（通过名称获取枚举、检查枚举存在性）。
    - **难点**: 仓颉枚举的反射能力需要验证。
- [ ] **ClassUtils / TypeUtils**
    - **目标**: 简化的类型操作工具（类名简写、包名获取、继承关系判断）。
    - **参考**: `std.reflect.TypeInfo`

### 2. 文本处理增强 (Text Enhancements) [P1]

- [ ] **WordUtils**
    - **目标**: 单词首字母大写、换行包装 (Wrap)、缩写。
- [ ] **StrSubstitutor**
    - **目标**: 字符串模板变量替换 (e.g., "Hello ${name}").
    - **价值**: 非常实用的配置处理工具。
- [ ] **SimilarityScore**
    - **目标**: 字符串相似度算法 (Levenshtein Distance, Jaro-Winkler, etc.)。

### 3. 时间与日期 (Time Extensions) [P1]

- [ ] **DateUtils**
    - **目标**: 日期的加减操作 (addDays, addMonths)、截断 (truncate)、四舍五入 (round)。
    - **现状**: 目前只有 `DateFormatUtils`，缺乏日期计算逻辑。

### 4. 反射与高级构建器 (Reflection & Advanced Builders) [P2]

- [ ] **ReflectionToStringBuilder**
    - **目标**: 通过反射自动生成 ToString。
    - **难点**: 需要评估仓颉反射对私有字段的访问权限。
- [ ] **DiffBuilder**
    - **目标**: 计算两个对象的差异并生成报告。

### 5. 并发与事件 (Concurrency & Events) [P3]

- [ ] **CircuitBreaker** (熔断器)
- [ ] **ConcurrentUtils** (并发工具)
    - **注意**: 仓颉有强大的原生并发模型 (Actor/Coroutines)，需评估是否需要移植 Java 的并发工具，或者设计更符合仓颉风格的并发工具。

---

## 🛠 技术债与优化 (Technical Debt)

- **文档完善**: 为所有 Public API 补充 KDoc 风格注释。
- **性能基准测试**: 对核心工具 (`StringUtils`, `ArrayUtils`) 进行 Benchmark 测试，对比标准库性能。
- **宏支持**: 考虑使用仓颉宏 (`macro`) 简化 `Builder` 模式的使用 (例如 `@ToString` 宏)。

## 📅 下一步行动建议

建议优先开发 **SystemUtils** 和 **RandomStringUtils**，这两个模块依赖少且使用频率高。
