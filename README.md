<div align="center">
<h1>commons-lang4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.4-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/license-Apache--2.0-blue" style="display: inline-block;" />
</p>

## 介绍

**commons-lang4cj** 是 Apache Commons Lang 的仓颉（Cangjie）语言移植版本。它提供了一套极其实用的工具类，填补了标准库在日常开发中的空白，旨在让仓颉开发更加高效、优雅。

本项目严格遵循仓颉语言编程规范，提供类型安全、空值安全（Option-safe）的 API 设计。

### 项目特性

- **核心工具**: `StringUtils`, `ObjectUtils`, `ArrayUtils`, `ValidateUtils` 等核心工具
- **构建器模式**: `EqualsBuilder`, `HashCodeBuilder`, `ToStringBuilder`, `CompareToBuilder`
- **可变包装**: `MutableInt`, `MutableLong`, `MutableDouble` 等可变包装类
- **并发工具**: `Memoizer`（高并发缓存）, `CircuitBreaker`（熔断器）, `BackgroundInitializer`, `LazyInitializer`
- **时间日期**: `DateUtils`（日期计算）, `StopWatch`（秒表）, `DateFormatUtils`, `DurationFormatUtils`
- **数学计算**: `Fraction`（分数运算）, `IEEE754rUtils`
- **文本处理**: `WordUtils`, `StringEscapeUtils`, `StrSubstitutor`, `StrTokenizer`, `LevenshteinDistance`
- **随机数生成**: `RandomStringUtils`, `RandomUtils`
- **元组支持**: `Pair`, `Triple`
- **范围处理**: `Range`, `NumberRange`, `CharRange`
- **枚举工具**: `EnumUtils`
- **反射工具**: `ClassUtils`
- **系统工具**: `SystemUtils`

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
├── CHANGELOG.md
├── CLAUDE.md
└── src
    ├── builder/              # 构建器模式实现 (Equals, HashCode, ToString, CompareTo)
    ├── concurrent/           # 并发工具 (CircuitBreaker, Memoizer, LazyInitializer)
    ├── enums/                # 枚举工具
    ├── exception/            # 异常处理
    ├── extension/            # 扩展方法 (String extension)
    ├── math/                 # 数学工具 (Fraction, IEEE754r)
    ├── mutable/              # 可变基本类型包装
    ├── random/               # 随机数工具
    ├── range/                # 范围处理
    ├── reflect/              # 反射工具
    ├── system/               # 系统属性
    ├── text/                 # 文本处理 (Levenshtein, Escape, Substitutor)
    ├── time/                 # 时间日期工具
    ├── tuple/                # 元组 (Pair, Triple)
    ├── utils/                # 核心工具 (String, Object, Array, Number, Boolean, Char)
    └── test/                 # 单元测试
```

### 接口说明

主要功能类的详细用法，请参考 [API 文档](./doc/feature_api.md) 或 [设计文档](./doc/design.md)。

#### 核心 API 概览

**StringUtils**:
```cangjie
public static func isBlank(str: String): Bool
public static func isEmpty(str: String): Bool
public static func capitalize(str: String): String
public static func split(str: String, separator: String): Array<String>
public static func join(collection: Array<String>, separator: String): String
```

**ArrayUtils**:
```cangjie
public static func isEmpty<T>(array: Array<T>): Bool
public static func add<T>(array: Array<T>, element: T): Array<T>
public static func contains<T>(array: Array<T>, value: T): Bool
```

**ObjectUtils**:
```cangjie
public static func isNull(obj: ?Object): Bool
public static func defaultIfNull<T>(obj: ?T, defaultValue: T): T
public static func equal(obj1: ?Object, obj2: ?Object): Bool
```

**EqualsBuilder**:
```cangjie
public class EqualsBuilder {
    public func append(lhs: ?Object, rhs: ?Object): EqualsBuilder
    public func isEquals(): Bool
}
```

**StopWatch**:
```cangjie
public class StopWatch {
    public static func create(): StopWatch
    public func start(): Unit
    public func stop(): Unit
    public func getTime(): Int64
}
```

**Fraction**:
```cangjie
public class Fraction {
    public static func getFraction(numerator: Int64, denominator: Int64): Fraction
    public func add(fraction: Fraction): Fraction
    public func multiplyBy(fraction: Fraction): Fraction
    public func toDouble(): Float64
}
```

## 使用说明

### 依赖安装

在 `cjpm.toml` 中添加依赖：

```toml
[dependencies]
  commons_lang4cj = { git = "https://github.com/mumu-xsy/commons-lang4cj.git" }
```

### 编译构建

```shell
cjpm update
cjpm build
```

### 功能示例

#### StringUtils 示例

功能示例描述：本示例展示了如何使用 StringUtils 进行字符串操作，包括空白检查、大小写转换、分割和连接等。

```cangjie
import commons_lang4cj.utils.*

main() {
    // 空白检查
    let str = "  Hello World  "
    println(StringUtils.isBlank(str))  // true

    // 去除空白
    let trimmed = StringUtils.trim(str)
    println(trimmed)  // "Hello World"

    // 大小写转换
    let upper = StringUtils.upperCase(trimmed)
    println(upper)  // "HELLO WORLD"

    // 分割和连接
    let parts = StringUtils.split("a,b,c", ",")
    let joined = StringUtils.join(parts, "-")
    println(joined)  // "a-b-c"

    // 替换
    let replaced = StringUtils.replace("Hello World", "World", "Cangjie")
    println(replaced)  // "Hello Cangjie"
}
```

执行结果如下：

```shell
true
Hello World
HELLO WORLD
a-b-c
Hello Cangjie
```

#### ArrayUtils 示例

功能示例描述：本示例展示了如何使用 ArrayUtils 进行数组操作，包括合并、添加、反转和查询等。

```cangjie
import commons_lang4cj.utils.*

main() {
    let arr1 = Array<Int64>([1, 2, 3])
    let arr2 = Array<Int64>([4, 5, 6])

    // 合并数组
    let merged = ArrayUtils.addAll(arr1, arr2)
    println(merged)  // [1, 2, 3, 4, 5, 6]

    // 添加元素
    let added = ArrayUtils.add(merged, 7)
    println(added)  // [1, 2, 3, 4, 5, 6, 7]

    // 反转
    let reversed = ArrayUtils.reverse(added)
    println(reversed)  // [7, 6, 5, 4, 3, 2, 1]

    // 查询
    println(ArrayUtils.contains(merged, 3))  // true
    println(ArrayUtils.indexOf(merged, 5))  // 4
}
```

执行结果如下：

```shell
[1, 2, 3, 4, 5, 6]
[1, 2, 3, 4, 5, 6, 7]
[7, 6, 5, 4, 3, 2, 1]
true
4
```

#### EqualsBuilder 示例

功能示例描述：本示例展示了如何使用 EqualsBuilder 简化 equals 方法的实现。

```cangjie
import commons_lang4cj.builder.*

class Person {
    var name: String
    var age: Int64

    public init(name: String, age: Int64) {
        this.name = name
        this.age = age
    }

    public func equals(other: Option<Person>): Bool {
        match (other) {
            case Some(p) => EqualsBuilder()
                .append(this.name, p.name)
                .append(this.age, p.age)
                .isEquals()
            case None => false
        }
    }

    public func hashCode(): Int64 {
        HashCodeBuilder(17, 37)
            .append(this.name)
            .append(this.age)
            .toHashCode()
    }

    public func toString(): String {
        ToStringBuilder(this, ToStringStyle.DEFAULT_STYLE)
            .append("name", this.name)
            .append("age", this.age)
            .toString()
    }
}

main() {
    let p1 = Person("Alice", 30)
    let p2 = Person("Alice", 30)
    let p3 = Person("Bob", 25)

    println(p1.equals(p2))  // true
    println(p1.equals(p3))  // false
    println(p1.hashCode() == p2.hashCode())  // true
    println(p1.toString())  // "Person@hash[name=Alice,age=30]"
}
```

执行结果如下：

```shell
true
false
true
Person@hash[name=Alice,age=30]
```

#### MutableInt 示例

功能示例描述：本示例展示了如何使用可变包装类在闭包中修改值。

```cangjie
import commons_lang4cj.mutable.*

main() {
    let counter = MutableInt(0)

    // 在闭包中修改值
    let increment = { =>
        counter.increment()
        counter.add(10)
    }

    increment()
    println(counter.get())  // 11

    // 算术运算
    counter.multiplyBy(2)
    println(counter.get())  // 22
}
```

执行结果如下：

```shell
11
22
```

#### StopWatch 示例

功能示例描述：本示例展示了如何使用 StopWatch 进行计时操作。

```cangjie
import commons_lang4cj.time.*

main() {
    let watch = StopWatch.create()

    watch.start()
    // 模拟工作
    Thread.sleep(1000)
    watch.stop()

    println("耗时: ${watch.getTime()}ms")  // 耗时: 1000ms
    println(watch.toString())  // "0:00:01.000"
}
```

执行结果如下：

```shell
耗时: 1000ms
0:00:01.000
```

#### Fraction 示例

功能示例描述：本示例展示了如何使用 Fraction 进行精确的分数运算。

```cangjie
import commons_lang4cj.math.*

main() {
    let f1 = Fraction.getFraction(1, 2)
    let f2 = Fraction.getFraction(1, 3)

    // 四则运算
    let sum = f1.add(f2)
    println(sum.toString())  // "5/6"

    let product = f1.multiplyBy(f2)
    println(product.toString())  // "1/6"

    // 类型转换
    println(f1.toDouble())  // 0.5

    // 比较
    println(f1.compareTo(f2))  // 1 (1/2 > 1/3)
}
```

执行结果如下：

```shell
5/6
1/6
0.5
1
```

#### StringEscapeUtils 示例

功能示例描述：本示例展示了如何使用 StringEscapeUtils 进行字符串转义操作，防止 XSS 攻击。

```cangjie
import commons_lang4cj.text.*

main() {
    let html = "<script>alert('XSS')</script>"

    // HTML 转义
    let escaped = StringEscapeUtils.escapeHtml(html)
    println(escaped)  // "&lt;script&gt;alert('XSS')&lt;/script&gt;"

    // 反转义
    let unescaped = StringEscapeUtils.unescapeHtml(escaped)
    println(unescaped)  // "<script>alert('XSS')</script>"
}
```

执行结果如下：

```shell
&lt;script&gt;alert('XSS')&lt;/script&gt;
<script>alert('XSS')</script>
```

#### StrSubstitutor 示例

功能示例描述：本示例展示了如何使用 StrSubstitutor 进行字符串变量替换。

```cangjie
import commons_lang4cj.text.*

main() {
    let template = "Hello ${name}, welcome to ${place}!"

    let sub = StrSubstitutor()
    let values = HashMap<String, String>()
    values["name"] = "Cangjie"
    values["place"] = "Community"

    let result = sub.replace(template, values)
    println(result)  // "Hello Cangjie, welcome to Community!"
}
```

执行结果如下：

```shell
Hello Cangjie, welcome to Community!
```

#### Memoizer 示例

功能示例描述：本示例展示了如何使用 Memoizer 实现带缓存的函数计算，提高性能。

```cangjie
import commons_lang4cj.concurrent.*

main() {
    // 创建缓存函数（计算斐波那契数列）
    let fib = Memoizer<Int64, Int64>{ n =>
        if (n <= 1) {
            return n
        } else {
            return fib.get(n - 1) + fib.get(n - 2)
        }
    }

    println(fib.get(10))  // 55
    println(fib.get(20))  // 6765
    // 第二次调用会从缓存读取，性能更高
}
```

执行结果如下：

```shell
55
6765
```

#### CircuitBreaker 示例

功能示例描述：本示例展示了如何使用 CircuitBreaker 实现熔断器模式，防止级联故障。

```cangjie
import commons_lang4cj.concurrent.*

main() {
    let breaker = CircuitBreaker(5, 10000)  // 阈值5次，超时10秒

    // 执行受保护的操作
    let result = breaker.call<Int64>{ =>
        // 可能失败的操作
        return 42
    }

    match (result) {
        case Some(value) => println("操作成功: ${value}")
        case None => println("熔断器打开，操作被拒绝")
    }

    // 检查熔断器状态
    if (breaker.isOpen()) {
        println("熔断器已打开")
        breaker.close()  // 手动关闭熔断器
    }
}
```

执行结果如下：

```shell
操作成功: 42
```

## 约束与限制

### 仓颉语言特性限制

**静态类型系统**：
- 仓颉是强类型静态语言，某些动态特性（如反射）功能受限
- 运行时类型信息不如 Java 丰富，`getTypeName` 等方法返回固定值

**数组不可变性**：
- `Array<T>` 长度不可变，所有修改操作返回新数组，性能开销较大
- 没有原位修改操作，内存占用可能较高

**空值处理**：
- 仓颉使用 `Option<T>` 而非 null，与 Java API 不完全兼容
- 需要显式处理 `Option<T>` 类型，代码略显冗长

### 功能实现限制

**StringUtils**：
- `split` 方法的 `maxSplit` 参数未完全实现
- 仅支持 ASCII 字符大小写转换，不支持 Unicode 完整处理

**ArrayUtils**：
- 不支持多维数组操作
- 缺少原位排序功能

**DateUtils**：
- 主要使用 String 类型处理日期，功能受限
- 不支持时区处理
- 缺少复杂的日历操作

**Fraction**：
- 实现相对简单，缺少高级运算（如连分数）
- 不支持大整数（BigInt）
- 分数运算可能溢出 Int64 范围

**Concurrent 包**：
- 缺少高级并发特性（如 ExecutorService、线程池管理）
- 并发控制功能相对基础

### 性能考虑

**内存占用**：
- 由于不可变性设计，频繁操作会产生大量临时对象
- ArrayUtils 所有修改操作都创建新数组

**缓存策略**：
- Fraction 类实现了 hashCode 和 toString 缓存
- 其他工具类未实现缓存优化

### 与 Java 版本差异

**类型系统**：
- Java 使用 `int` (32位)，仓颉使用 `Int64` (64位)
- Java 支持 `null`，仓颉使用 `Option<T>`

**集合框架**：
- Java `List` 支持动态增删，仓颉 `Array<T>` 长度固定
- Java `ArrayList` 提供丰富 API，仓颉数组功能相对简单

**异常处理**：
- Java 支持受检异常（checked exception）
- 仓颉异常机制不同，部分异常处理需要适配

## 参考与依赖

- 本项目参考了 [Apache Commons Lang](https://github.com/apache/commons-lang) 的实现
- 由于仓颉语言特性差异，部分实现进行了适配和优化

## 开源协议

本项目基于 Apache-2.0 协议开源。

## 参与贡献

欢迎提交 Issue 和 PR！请确保您的代码符合仓颉语言规范，并包含对应的测试用例。

本项目 committer: [@mumu_xsy](https://github.com/mumu-xsy)
