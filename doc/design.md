# commons-lang4cj 库设计介绍

## 描述

本文档详细介绍 `commons-lang4cj` 库的设计，这是一个使用仓颉（Cangjie）编程语言实现的 Apache Commons Lang 移植版本。该库提供了一套极其实用的工具类，填补了标准库在日常开发中的空白，旨在让仓颉开发更加高效、优雅。

commons-lang4cj 库的核心价值在于：

- **工具类集合**：提供字符串处理、数组操作、对象工具、数学计算等常用功能
- **Builder 模式**：简化 equals、hashCode、toString 等方法的重写
- **可变包装类**：为基本类型提供可变包装，支持在闭包中修改值
- **时间日期工具**：提供日期计算、格式化、计时等功能
- **并发工具**：包含 Memoizer（缓存）、CircuitBreaker（熔断器）、BackgroundInitializer 等高级并发组件
- **文本处理**：提供字符串转义、变量替换、相似度计算等功能

本项目严格遵循仓颉语言编程规范，提供类型安全、空值安全（Option-safe）的 API 设计。

## 核心包设计

### 1. utils 包 - 核心工具类

#### StringUtils 类设计

**类描述**：
`StringUtils` 是字符串操作工具类，提供了 null-safe 的字符串处理方法。与仓颉标准库的 String 方法不同，`StringUtils` 可以安全地处理空字符串和空白字符串。

**核心功能分类**：

```cangjie
package commons_lang4cj.utils

public class StringUtils {
    // 空值检查
    public static func isEmpty(str: String): Bool
    public static func isNotEmpty(str: String): Bool
    public static func isBlank(str: String): Bool
    public static func isNotBlank(str: String): Bool

    // 截取与分割
    public static func trim(str: String): String
    public static func split(str: String, separator: String): Array<String>
    public static func split(str: String, separator: String, maxSplit: Int64): Array<String>
    public static func join(collection: Array<String>, separator: String): String

    // 查询与比较
    public static func equals(str1: String, str2: String): Bool
    public static func compare(str1: String, str2: String): Int64
    public static func contains(str: String, searchStr: String): Bool
    public static func indexOf(str: String, searchStr: String): Int64
    public static func lastIndexOf(str: String, searchStr: String): Int64
    public static func startsWith(str: String, prefix: String): Bool
    public static func endsWith(str: String, suffix: String): Bool

    // 替换与删除
    public static func replace(str: String, searchStr: String, replacement: String): String
    public static func replaceOnce(str: String, searchStr: String, replacement: String): String
    public static func remove(str: String, removeStr: String): String

    // 截取
    public static func substring(str: String, start: Int64): String
    public static func substring(str: String, start: Int64, end: Int64): String
    public static func left(str: String, length: Int64): String
    public static func right(str: String, length: Int64): String
    public static func mid(str: String, pos: Int64, length: Int64): String

    // 大小写转换
    public static func upperCase(str: String): String
    public static func lowerCase(str: String): String
    public static func capitalize(str: String): String
    public static func uncapitalize(str: String): String
    public static func swapCase(str: String): String

    // 填充与对齐
    public static func leftPad(str: String, size: Int64, padStr: String): String
    public static func rightPad(str: String, size: Int64, padStr: String): String
    public static func center(str: String, size: Int64): String

    // 反转
    public static func reverse(str: String): String
    public static func reverseDelimited(str: String, separator: String): String

    // 其他
    public static func countMatches(str: String, sub: String): Int64
    public static func isAlpha(str: String): Bool
    public static func isNumeric(str: String): Bool
    public static func isAlphanumeric(str: String): Bool
    public static func abbreviate(str: String, maxWidth: Int64): String
    public static func rotate(str: String, shift: Int64): String
}
```

**设计限制**：
- `split` 方法的 `maxSplit` 参数未完全实现，当前行为与标准 split 一致
- 仅支持 ASCII 字符的大小写转换，不支持 Unicode 完整处理
- `toStrings` 方法返回空数组（待完善）

#### ArrayUtils 类设计

**类描述**：
`ArrayUtils` 提供数组操作工具方法。由于仓颉的 `Array<T>` 是长度不变的集合，所有修改操作都返回新数组。

```cangjie
package commons_lang4cj.utils

public class ArrayUtils {
    // 空值与长度检查
    public static func isEmpty<T>(array: Array<T>): Bool
    public static func isNotEmpty<T>(array: Array<T>): Bool
    public static func getLength<T>(array: ?Array<T>): Int64

    // 查询操作
    public static func indexOf<T>(array: Array<T>, value: T): Int64
    public static func contains<T>(array: Array<T>, value: T): Bool
    public static func lastIndexOf<T>(array: Array<T>, value: T): Int64

    // 修改操作（返回新数组）
    public static func add<T>(array: Array<T>, element: T): Array<T>
    public static func add<T>(array: Array<T>, index: Int64, element: T): Array<T>
    public static func addAll<T>(array1: Array<T>, array2: Array<T>): Array<T>
    public static func remove<T>(array: Array<T>, index: Int64): Array<T>
    public static func removeElement<T>(array: Array<T>, element: T): Array<T>

    // 反转与排序
    public static func reverse<T>(array: Array<T>): Array<T>
    public static func swap<T>(array: Array<T>, index1: Int64, index2: Int64): Array<T>

    // 子数组操作
    public static func subarray<T>(array: Array<T>, startIndex: Int64, endIndex: Int64): Array<T>

    // 比较操作
    public static func isSameLength<T>(array1: Array<T>, array2: Array<T>): Bool
    public static func isSorted<T>(array: Array<T>): Bool

    // 转换操作
    public static func toString<T>(array: Array<T>): String
    public static func clone<T>(array: Array<T>): Array<T>

    // 填充操作
    public static func fill<T>(array: Array<T>, value: T): Array<T>
}
```

**设计限制**：
- 由于仓颉 Array<T> 长度不可变，所有修改操作都返回新数组，性能开销较大
- 没有原位修改操作（如 sort），排序操作需要额外处理
- 不支持多维数组操作

#### ObjectUtils 类设计

**类描述**：
`ObjectUtils` 提供对象操作工具方法，使用 `Option<T>` 而非 null 处理缺失值。

```cangjie
package commons_lang4cj.utils

public class ObjectUtils {
    // 空值处理
    public static func isNull(obj: ?Object): Bool
    public static func notNull(obj: ?Object): Bool
    public static func defaultIfNull<T>(obj: ?T, defaultValue: T): T

    // 相等比较
    public static func equal(obj1: ?Object, obj2: ?Object): Bool
    public static func notEqual(obj1: ?Object, obj2: ?Object): Bool

    // 比较操作
    public static func compare<T>(c1: ?T, c2: ?T): Int64 where T <: Comparable<T>
    public static func min<T>(o1: T, o2: T): T where T <: Comparable<T>
    public static func max<T>(o1: T, o2: T): T where T <: Comparable<T>

    // 哈希码
    public static func hash(obj: ?Object): Int64
    public static func hashString(obj: ?Object): String

    // 字符串表示
    public static func toString(obj: ?Object): String
    public static func identityToString(obj: Object): String

    // 类型检查
    public static func isType(obj: ?Object, typeName: String): Bool
    public static func isString(obj: ?Object): Bool
    public static func isInt64(obj: ?Object): Bool
    public static func isFloat64(obj: ?Object): Bool
    public static func isNumber(obj: ?Object): Bool
    public static func isArray(obj: ?Object): Bool
    public static func isSame(obj1: ?Object, obj2: ?Object): Bool

    // 其他实用方法
    public static func firstNonNull<T>(values: Array<T>): T
    public static func requireNonNull<T>(obj: ?T): T
    public static func allNull(objs: Array<?Object>): Bool
    public static func anyNull(objs: Array<?Object>): Bool
    public static func containsNull(objs: Array<?Object>): Bool
    public static func filterNonNull<T>(objs: Array<?T>): Array<T>
    public static func safeCast<T>(obj: ?Object, type: Type): ?T
    public static func clone<T>(obj: T): T
    public static func compareTo<T>(o1: ?T, o2: ?T): Int64 where T <: Comparable<T>
}
```

**设计限制**：
- 运行时类型信息受限，`getTypeName` 返回固定值
- 使用 Option<T> 而不是 null，与 Java 原生 API 不完全兼容

### 2. builder 包 - 构建器模式

#### EqualsBuilder 类设计

**类描述**：
`EqualsBuilder` 使用构建器模式简化 `equals` 方法的实现。

```cangjie
package commons_lang4cj.builder

public class EqualsBuilder {
    public init()
    public func append(lhs: ?Object, rhs: ?Object): EqualsBuilder
    public func appendSuper(superEquals: Bool): EqualsBuilder
    public func isEquals(): Bool
}
```

**使用示例**：
```cangjie
class Person {
    var name: String
    var age: Int64

    public func equals(other: Option<Person>): Bool {
        match (other) {
            case Some(p) => EqualsBuilder()
                .append(this.name, p.name)
                .append(this.age, p.age)
                .isEquals()
            case None => false
        }
    }
}
```

#### HashCodeBuilder 类设计

**类描述**：
`HashCodeBuilder` 使用构建器模式简化 `hashCode` 方法的实现。

```cangjie
package commons_lang4cj.builder

public class HashCodeBuilder {
    public init(initialOddNumber: Int64, multiplierOddNumber: Int64)
    public func append(value: Int64): HashCodeBuilder
    public func append(value: Float64): HashCodeBuilder
    public func append(obj: ?Object): HashCodeBuilder
    public func appendSuper(superHashCode: Int64): HashCodeBuilder
    public func toHashCode(): Int64
}
```

#### ToStringBuilder 类设计

**类描述**：
`ToStringBuilder` 使用构建器模式简化 `toString` 方法的实现。

```cangjie
package commons_lang4cj.builder

public class ToStringBuilder {
    public init(obj: Object, style: ToStringStyle)
    public func append(fieldName: String, value: Int64): ToStringBuilder
    public func append(fieldName: String, value: ?Object): ToStringBuilder
    public func append(fieldName: String, value: Array<Byte>): ToStringBuilder
    public func appendSuper(superToString: String): ToStringBuilder
    public func toString(): String
}

public class ToStringStyle {
    public static val DEFAULT_STYLE: ToStringStyle
    public static val NO_FIELD_NAMES_STYLE: ToStringStyle
    public static val SHORT_PREFIX_STYLE: ToStringStyle
    public static val SIMPLE_STYLE: ToStringStyle
}
```

#### CompareToBuilder 类设计

**类描述**：
`CompareToBuilder` 使用构建器模式简化 `compareTo` 方法的实现。

```cangjie
package commons_lang4cj.builder

public class CompareToBuilder {
    public init()
    public func append(lhs: Int64, rhs: Int64): CompareToBuilder
    public func append<T>(lhs: ?T, rhs: ?T): CompareToBuilder where T <: Comparable<T>
    public func appendSuper(superCompare: Int64): CompareToBuilder
    public func toComparison(): Int64
}
```

### 3. mutable 包 - 可变包装类

#### MutableInt 类设计

**类描述**：
`MutableInt` 为 `Int64` 类型提供可变包装器，支持在闭包中修改值。

```cangjie
package commons_lang4cj.mutable

public class MutableInt <: Comparable<MutableInt> {
    public init()
    public init(value: Int64)
    public func get(): Int64
    public func set(value: Int64): Unit
    public func add(value: Int64): Unit
    public func subtract(value: Int64): Unit
    public func multiply(value: Int64): Unit
    public func divide(value: Int64): Unit
    public func increment(): Unit
    public func decrement(): Unit
    public func compareTo(other: MutableInt): Int64
    public func toString(): String
}
```

**类似的可变包装类**：
- `MutableLong`: Int64 可变包装
- `MutableDouble`: Float64 可变包装（支持 NaN 检查）
- `MutableFloat`: Float32 可变包装
- `MutableByte`: Byte 可变包装
- `MutableShort`: Int16 可变包装
- `MutableBoolean`: Bool 可变包装（支持 `and`, `or`, `xor` 逻辑运算）
- `MutableObject<T>`: 泛型对象包装器（`get`, `set`, `reset` 方法）

### 4. time 包 - 时间日期工具

#### StopWatch 类设计

**类描述**：
`StopWatch` 提供简单的计时功能。

```cangjie
package commons_lang4cj.time

public class StopWatch {
    public static func create(): StopWatch
    public func start(): Unit
    public func stop(): Unit
    public func reset(): Unit
    public func getTime(): Int64
    public func split(): Unit
    public func unsplit(): Unit
    public func getSplitTime(): Int64
    public func toString(): String
}
```

#### DateFormatUtils 类设计

**类描述**：
`DateFormatUtils` 提供日期格式化功能。

```cangjie
package commons_lang4cj.time

public class DateFormatUtils {
    public static func format(date: String, pattern: String): String
    public static func parse(dateStr: String, pattern: String): String

    // 预定义格式常量
    public static val ISO_DATE_FORMAT: String
    public static val ISO_TIME_FORMAT: String
    public static val ISO_DATETIME_FORMAT: String
}
```

#### DurationFormatUtils 类设计

**类描述**：
`DurationFormatUtils` 提供时长格式化功能。

```cangjie
package commons_lang4cj.time

public class DurationFormatUtils {
    public static func formatDuration(durationMillis: Int64, format: String): String
    public static func formatPeriod(startMillis: Int64, endMillis: Int64, format: String): String
}
```

#### DateUtils 类设计

**类描述**：
`DateUtils` 提供日期计算功能。

```cangjie
package commons_lang4cj.time

public class DateUtils {
    public static func addDays(date: String, amount: Int64): String
    public static func addHours(date: String, amount: Int64): String
    public static func addMinutes(date: String, amount: Int64): String
    public static func isSameDay(date1: String, date2: String): Bool
    public static func truncate(date: String, field: String): String
}
```

**设计限制**：
- 主要使用 String 类型处理日期，而非复杂的时间对象
- 不支持时区处理
- 缺少复杂的日历操作（如节假日计算）

### 5. math 包 - 数学工具

#### Fraction 类设计

**类描述**：
`Fraction` 提供精确的分数运算功能。

```cangjie
package commons_lang4cj.math

public class Fraction <: Comparable<Fraction> {
    // 工厂方法
    public static func getFraction(numerator: Int64, denominator: Int64): Fraction
    public static func getFraction(whole: Int64, numerator: Int64, denominator: Int64): Fraction
    public static func getReducedFraction(numerator: Int64, denominator: Int64): Fraction

    // 基本运算
    public func add(fraction: Fraction): Fraction
    public func subtract(fraction: Fraction): Fraction
    public func multiplyBy(fraction: Fraction): Fraction
    public func divideBy(fraction: Fraction): Fraction
    public func negate(): Fraction
    public func invert(): Fraction

    // 取整与幂运算
    public func abs(): Fraction
    public func pow(power: Int64): Fraction
    public func remainder(fraction: Fraction): Fraction

    // 类型转换
    public func toDouble(): Float64
    public func toFloat(): Float32
    public func toInt(): Int64
    public func getProperNumerator(): Int64
    public func getProperWhole(): Int64

    // 查询方法
    public func getNumerator(): Int64
    public func getDenominator(): Int64
    public func isZero(): Bool
    public func isPositive(): Bool
    public func isNegative(): Bool

    // 比较与字符串
    public func compareTo(other: Fraction): Int64
    public func equals(other: Option<Fraction>): Bool
    public func hashCode(): Int64
    public func toString(): String
    public func toProperString(): String

    // 静态常量
    public static val ZERO: Fraction
    public static val ONE: Fraction
    public static val ONE_HALF: Fraction
    public static val ONE_THIRD: Fraction
    public static val TWO_THIRDS: Fraction
}
```

**设计限制**：
- Fraction 类的实现相对简单，缺少高级运算（如连分数）
- 不支持复数等数学类型
- 分数运算可能溢出 Int64 范围

#### IEEE754rUtils 类设计

**类描述**：
`IEEE754rUtils` 提供符合 IEEE 754r 标准的浮点数比较。

```cangjie
package commons_lang4cj.math

public class IEEE754rUtils {
    public static func min(d1: Float64, d2: Float64): Float64
    public static func max(d1: Float64, d2: Float64): Float64
    public static func compare(d1: Float64, d2: Float64): Int64
}
```

### 6. text 包 - 文本处理

#### WordUtils 类设计

**类描述**：
`WordUtils` 提供单词级别的文本处理。

```cangjie
package commons_lang4cj.text

public class WordUtils {
    public static func capitalize(str: String): String
    public static func capitalize(str: String, delimiters: Array<Char>): String
    public static func uncapitalize(str: String): String
    public static func wrap(str: String, wrapLength: Int64): String
    public static func swapCase(str: String): String
}
```

#### StrSubstitutor 类设计

**类描述**：
`StrSubstitutor` 提供字符串变量替换功能。

```cangjie
package commons_lang4cj.text

public class StrSubstitutor {
    public init()
    public init(prefix: String, suffix: String)
    public func replace(source: String): String
    public func replace(source: String, valueMap: HashMap<String, String>): String
    public func replace(source: String, valueProps: Array<(String, String)>): String
}
```

#### StrTokenizer 类设计

**类描述**：
`StrTokenizer` 提供高级字符串分割功能。

```cangjie
package commons_lang4cj.text

public class StrTokenizer {
    public init(str: String, separator: Char)
    public func iterator(): Iterator<String>
    public func toArray(): Array<String>
    public func hasNext(): Bool
    public func next(): String
}
```

#### StringEscapeUtils 类设计

**类描述**：
`StringEscapeUtils` 提供字符串转义功能。

```cangjie
package commons_lang4cj.text

public class StringEscapeUtils {
    public static func escapeHtml(str: String): String
    public static func unescapeHtml(str: String): String
    public static func escapeJava(str: String): String
    public static func unescapeJava(str: String): String
    public static func escapeXml(str: String): String
    public static func unescapeXml(str: String): String
}
```

#### LevenshteinDistance 类设计

**类描述**：
`LevenshteinDistance` 计算字符串编辑距离。

```cangjie
package commons_lang4cj.text

public class LevenshteinDistance {
    public static func apply(left: String, right: String): Int64
}
```

**设计限制**：
- 部分文本处理功能依赖仓颉标准库，功能可能受限
- 不支持 Unicode 规范化等高级文本处理

### 7. concurrent 包 - 并发工具

#### Memoizer 类设计

**类描述**：
`Memoizer` 提供带缓存的函数计算，支持线程安全。

```cangjie
package commons_lang4cj.concurrent

public class Memoizer<TInput, TResult> {
    public init(computer: (TInput) -> TResult)
    public func get(input: TInput): TResult
}
```

#### CircuitBreaker 类设计

**类描述**：
`CircuitBreaker` 实现熔断器模式，防止级联故障。

```cangjie
package commons_lang4cj.concurrent

public class CircuitBreaker {
    public init(threshold: Int64, timeout: Int64)
    public func call<T>(operation: () -> T): ?T
    public func isOpen(): Bool
    public func close(): Unit
    public func open(): Unit
}
```

#### BackgroundInitializer 类设计

**类描述**：
`BackgroundInitializer` 提供后台任务初始化功能。

```cangjie
package commons_lang4cj.concurrent

public class BackgroundInitializer<T> {
    public init(initializer: () -> T)
    public func get(): ?T
    public func isCompleted(): Bool
}
```

#### LazyInitializer 类设计

**类描述**：
`LazyInitializer` 提供线程安全的延迟初始化。

```cangjie
package commons_lang4cj.concurrent

public class LazyInitializer<T> {
    public init(initializer: () -> T)
    public func get(): T
    public func isInitialized(): Bool
}
```

**设计限制**：
- 缺少高级并发特性（如 ExecutorService、线程池管理）
- 并发控制功能相对基础

### 8. 其他包

#### random 包

**RandomStringUtils**：生成随机字符串
```cangjie
public class RandomStringUtils {
    public static func random(length: Int32): String
    public static func randomAlphabetic(length: Int32): String
    public static func randomAlphanumeric(length: Int32): String
    public static func randomNumeric(length: Int32): String
}
```

**RandomUtils**：生成随机基本类型值
```cangjie
public class RandomUtils {
    public static func nextInt(): Int32
    public static func nextLong(): Int64
    public static func nextFloat(): Float32
    public static func nextDouble(): Float64
}
```

#### tuple 包

**Pair**：键值对
```cangjie
public class Pair<K, V> {
    public static func of<K, V>(left: K, right: V): Pair<K, V>
    public func getLeft(): K
    public func getRight(): V
    public func toString(): String
}
```

**Triple**：三元组
```cangjie
public class Triple<L, M, R> {
    public static func of<L, M, R>(left: L, middle: M, right: R): Triple<L, M, R>
    public func getLeft(): L
    public func getMiddle(): M
    public func getRight(): R
}
```

#### range 包

**Range<T>**：通用范围类
```cangjie
public class Range<T> where T <: Comparable<T> {
    public func isInRange(value: T): Bool
}
```

## 架构图

### 依赖关系

- **utils 包**：是最基础的工具包，提供字符串、数组、对象等基础操作
- **builder 包**：依赖 utils 包，用于构建 equals、hashCode、toString 等方法
- **mutable 包**：独立的基础包，提供可变包装类
- **time 包**：依赖 utils 包，提供时间日期处理
- **math 包**：独立的基础包，提供数学计算
- **text 包**：依赖 utils 包，提供高级文本处理
- **concurrent 包**：独立的高级包，提供并发工具
- **random/tuple/range 包**：独立的功能包

### 包依赖层次

```
Level 0: mutable, math, concurrent, random, tuple, range
Level 1: utils
Level 2: builder, time, text
```

## 使用示例

### 示例 1：StringUtils 文本处理

```cangjie
import commons_lang4cj.utils.*

main() {
    let str = "  Hello World  "

    // 空白检查
    println(StringUtils.isBlank(str))  // true

    // 去除空白
    let trimmed = StringUtils.trim(str)
    println(trimmed)  // "Hello World"

    // 大小写转换
    let upper = StringUtils.upperCase(trimmed)
    println(upper)  // "HELLO WORLD"

    // 替换
    let replaced = StringUtils.replace(trimmed, "World", "Cangjie")
    println(replaced)  // "Hello Cangjie"

    // 分割
    let parts = StringUtils.split("a,b,c", ",")
    println(parts)  // ["a", "b", "c"]

    // 连接
    let joined = StringUtils.join(parts, "-")
    println(joined)  // "a-b-c"
}
```

### 示例 2：ArrayUtils 数组操作

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

    // 子数组
    let sub = ArrayUtils.subarray(reversed, 2, 5)
    println(sub)  // [5, 4, 3]
}
```

### 示例 3：Builder 模式

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

    println(p1.equals(p2))  // true
    println(p1.hashCode() == p2.hashCode())  // true
    println(p1.toString())  // "Person@hash[name=Alice,age=30]"
}
```

### 示例 4：MutableInt 可变包装

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

### 示例 5：StopWatch 计时器

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

### 示例 6：Fraction 分数运算

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

### 示例 7：StringEscapeUtils 字符串转义

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

### 示例 8：StrSubstitutor 变量替换

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

### 示例 9：Memoizer 缓存

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

### 示例 10：CircuitBreaker 熔断器

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

## 已知限制与客观事实

### 1. 仓颉语言特性限制

**静态类型系统**：
- 仓颉是强类型静态语言，某些动态特性（如反射）功能受限
- 运行时类型信息不如 Java 丰富，`getTypeName` 等方法返回固定值

**数组不可变性**：
- `Array<T>` 长度不可变，所有修改操作返回新数组，性能开销较大
- 没有原位修改操作，内存占用可能较高

**空值处理**：
- 仓颉使用 `Option<T>` 而非 null，与 Java API 不完全兼容
- 需要显式处理 `Option<T>` 类型，代码略显冗长

### 2. 功能实现限制

**StringUtils**：
- `split` 方法的 `maxSplit` 参数未完全实现
- 仅支持 ASCII 字符大小写转换，不支持 Unicode 完整处理
- `toStrings` 方法返回空数组（待完善）

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

### 3. 性能考虑

**内存占用**：
- 由于不可变性设计，频繁操作会产生大量临时对象
- ArrayUtils 所有修改操作都创建新数组

**缓存策略**：
- Fraction 类实现了 hashCode 和 toString 缓存
- 其他工具类未实现缓存优化

### 4. 与 Java 版本差异

**类型系统**：
- Java 使用 `int` (32位)，仓颉使用 `Int64` (64位)
- Java 支持 `null`，仓颉使用 `Option<T>`

**集合框架**：
- Java `List` 支持动态增删，仓颉 `Array<T>` 长度固定
- Java `ArrayList` 提供丰富 API，仓颉数组功能相对简单

**异常处理**：
- Java 支持受检异常（checked exception）
- 仓颉异常机制不同，部分异常处理需要适配

### 5. 未来改进方向

**性能优化**：
- 实现 GCD 缓存优化 Fraction 运算
- 减少不必要的临时对象创建

**功能扩展**：
- 完善 Unicode 支持
- 增加更多日期时间操作
- 实现高级并发特性（如线程池）

**兼容性**：
- 提供与 Java API 更好的互操作性
- 支持更多 Java Commons Lang 功能

---

**文档版本**: v1.0.0
**最后更新**: 2026-01-24
**维护者**: @mumu_xsy
