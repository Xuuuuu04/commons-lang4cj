<div align="center">
<h1>commons-lang4cj</h1>
</div>

<p align="center">
<img alt="release" src="https://img.shields.io/badge/release-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="cjc" src="https://img.shields.io/badge/cjc-v1.0.4-brightgreen" style="display: inline-block;" />
<img alt="license" src="https://img.shields.io/badge/license-Apache--2.0-blue" style="display: inline-block;" />
</p>

## 介绍

**commons-lang4cj** 是 Apache Commons Lang 的仓颉（Cangjie）语言移植版本。它提供了一套极其实用的工具类，填补了标准库在日常开发中的空白，旨在让仓颉开发更加高效、优雅。

本项目严格遵循仓颉语言编程规范，提供类型安全、空值安全（Option-safe）的 API 设计。

### 项目特性

- **Core Utils**: `StringUtils`, `ObjectUtils`, `ArrayUtils`, `ValidateUtils` 等核心工具。
- **Extensions**: 提供 `String` 类型的扩展方法（如 `str.isBlank()`），带来流式编程体验。
- **Concurrent**: 高级并发工具，包含 `Memoizer` (高并发缓存), `CircuitBreaker` (熔断器), `BackgroundInitializer`。
- **Time**: `DateUtils` (日期计算), `StopWatch` (秒表), `DateFormatUtils`。
- **Builder**: `ToStringBuilder`, `EqualsBuilder`, `HashCodeBuilder`，简化对象方法重写。
- **Math**: `Fraction` (分数运算), `IEEE754rUtils`。
- **Mutable**: `MutableInt`, `MutableLong` 等可变包装类。
- **Tuple**: `Pair`, `Triple` 元组支持。

### 项目计划

- 2026/01/16 项目初始化
- 2026/01/17 完成 Phase 1 Utils 包
- 2026/01/20 完成 Phase 3 Mutable 包
- 2026/01/24 完成 Phase 5 Extended Packages
- 2026/01/24 v1.0.0 发布

## 项目架构

### 源码目录

```shell
.
├── README.md
├── LICENSE
├── cjpm.toml
└── src
    ├── builder/              # 构建器模式实现 (Equals, HashCode, ToString)
    ├── concurrent/           # 并发工具 (CircuitBreaker, Memoizer)
    ├── enums/                # 枚举工具
    ├── exception/            # 异常处理
    ├── extension/            # 扩展方法 (String extension)
    ├── math/                 # 数学工具 (Fraction, IEEE754r)
    ├── mutable/              # 可变基本类型包装
    ├── random/               # 随机数工具
    ├── range/                # 范围处理
    ├── reflect/              # 反射工具
    ├── system/               # 系统属性
    ├── text/                 # 文本处理 (Levenshtein, Escape)
    ├── time/                 # 时间日期工具
    ├── tuple/                # 元组 (Pair, Triple)
    ├── utils/                # 核心工具 (String, Object, Array)
    └── test/                 # 单元测试
```

### 接口说明

主要功能类的详细用法，请参考 [用户指南](./docs/user_guide.md)。

#### 核心 API 概览

```cangjie
// StringUtils
public static func isBlank(str: String): Bool
public static func capitalize(str: String): String

// DateUtils
public static func addDays(date: DateTime, amount: Int64): DateTime
public static func isSameDay(date1: DateTime, date2: DateTime): Bool

// StopWatch
public class StopWatch {
    public static func create(): StopWatch
    public func start(): Unit
    public func stop(): Unit
    public func getTime(): Int64
}
```

## 使用说明

### 编译构建

```shell
cjpm update
cjpm build
```

### 功能示例

#### String Extensions (流式调用)

```cangjie
import commons_lang4cj.extension.*

main() {
    let str = "  Cangjie  "
    // 链式调用：去空 -> 转大写 -> 缩略
    let result = str.trim().upperCase().abbreviate(5)
    println(result) // 输出: "CANG..."
}
```

#### DateUtils (日期计算)

```cangjie
import commons_lang4cj.time.*
import std.time.*

main() {
    let now = DateTime.now()
    let tomorrow = DateUtils.addDays(now, 1)

    if (DateUtils.isSameDay(now, tomorrow)) {
        println("Same day")
    } else {
        println("Different day")
    }
}
```

## 开源协议

本项目基于 Apache-2.0 协议开源。

## 参与贡献

欢迎提交 Issue 和 PR！请确保您的代码符合仓颉语言规范，并包含对应的测试用例。
