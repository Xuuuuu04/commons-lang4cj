# Mutable 边缘类型架构设计文档

> **版本**: v1.0.0
> **日期**: 2026-01-17
> **作者**: @Architect
> **状态**: 设计阶段

---

## 📋 目录

1. [设计概述](#1-设计概述)
2. [类型系统确认](#2-类型系统确认)
3. [API 签名定义](#3-api-签名定义)
4. [实现策略](#4-实现策略)
5. [测试策略](#5-测试策略)
6. [风险评估](#6-风险评估)
7. [架构决策记录 (ADR)](#7-架构决策记录-adr)

---

## 1. 设计概述

### 1.1 设计目标

设计 Apache Commons Lang 的 Mutable 边缘类型的仓颉语言版本，包括：

- **MutableBoolean**: 可变布尔包装器
- **MutableShort**: 可变 Int16 包装器
- **MutableByte**: 可变 Int8 包装器
- **MutableObject<T>**: 可变泛型对象包装器

### 1.2 核心原则

1. **代码复用**: 最大化复用已实现的 MutableInt/Long/Double 代码
2. **类型安全**: 充分利用仓颉的类型系统
3. **一致性**: API 风格与现有 Mutable 类保持一致
4. **简单高效**: 避免过度设计

### 1.3 参考模板

| 已实现类 | 代码行数 | 公共方法数 | 复用价值 |
|---------|---------|-----------|---------|
| MutableInt | 329 行 | 28 个 | ⭐⭐⭐⭐⭐ 数值操作模板 |
| MutableLong | 329 行 | ~30 个 | ⭐⭐⭐⭐⭐ 数值操作模板 |
| MutableDouble | 421 行 | ~32 个 | ⭐⭐⭐⭐ 浮点数处理模板 |

---

## 2. 类型系统确认

### 2.1 仓颉整数类型支持

✅ **已确认**: 仓颉 1.0.4 完整支持所有整数类型

| 仓颉类型 | 对应 Java 类型 | 范围 | 大小 | 说明 |
|---------|---------------|------|------|------|
| **Int8** | `byte` | -2^7 ~ 2^7-1 (-128 ~ 127) | 8 位 | ✅ 支持 |
| **Int16** | `short` | -2^15 ~ 2^15-1 (-32768 ~ 32767) | 16 位 | ✅ 支持 |
| **Int32** | `int` | -2^31 ~ 2^31-1 | 32 位 | ✅ 支持 |
| **Int64** | `long` | -2^63 ~ 2^63-1 | 64 位 | ✅ 支持 |
| **UInt8** | `unsigned byte` | 0 ~ 255 | 8 位 | ✅ 支持（Java 无） |
| **UInt16** | `unsigned short` | 0 ~ 65535 | 16 位 | ✅ 支持（Java 无） |
| **UInt32** | `unsigned int` | 0 ~ 2^32-1 | 32 位 | ✅ 支持（Java 无） |
| **UInt64** | `unsigned long` | 0 ~ 2^64-1 | 64 位 | ✅ 支持（Java 无） |

**结论**:
- ✅ **MutableShort 可以实现** (使用 `Int16`)
- ✅ **MutableByte 可以实现** (使用 `Int8`)
- ⚠️ **注意**: 仓颉没有原始类型包装类（Boolean、Integer 等），直接使用 `Bool`、`Int64`

### 2.2 泛型约束

仓颉的泛型系统支持：

```cangjie
// 无约束泛型
class MutableObject<T> { ... }

// 带约束的泛型
class Container<T> where T <: Comparable<T> { ... }

// 多重约束
class Multi<T> where T <: Hashable & Equatable<T> { ... }
```

**决策**:
- **MutableObject<T>**: 不需要约束（与 Java 版本一致）
- 使用 `Option<T>` 处理可能为空的值

---

## 3. API 签名定义

### 3.1 MutableBoolean 类

**文件路径**: `src/mutable/mutable_boolean.cj`

**继承关系**:
```cangjie
public open class MutableBoolean <: Comparable<MutableBoolean>
```

**公共方法清单**（16 个）:

#### 构造函数（3 个）
```cangjie
// 1. 默认构造函数（false）
public init()

// 2. 从 Bool 值构造
public init(value: Bool)

// 3. 从字符串解析
public init(value: String)
```

#### 访问器方法（3 个）
```cangjie
// 获取当前值
public func getValue(): Bool

// 设置新值
public func setValue(value: Bool): Unit

// 设置为 true
public func setTrue(): Unit

// 设置为 false
public func setFalse(): Unit
```

#### 布尔判断方法（2 个）
```cangjie
// 是否为 true
public func isTrue(): Bool

// 是否为 false
public func isFalse(): Bool
```

#### 比较方法（2 个）
```cangjie
// 相等判断
public func equals(obj: Option<Object>): Bool

// 比较（false < true）
public func compareTo(other: MutableBoolean): Int64
```

#### 转换方法（2 个）
```cangjie
// 转为整数（true=1, false=0）
public func toInt(): Int64

// 转为字符串
public func toString(): String
```

#### 工厂方法（2 个）
```cangjie
// 创建实例
static public func of(value: Bool): MutableBoolean

// 从字符串解析
static public func fromString(str: String): Option<MutableBoolean>
```

#### 其他方法（2 个）
```cangjie
// 哈希码
public func hashCode(): Int64

// 转为 Bool（与 getValue 相同）
public func booleanValue(): Bool
```

**私有字段**:
```cangjie
private var _value: Bool = false
```

**常量**:
```cangjie
// 无常量（Java 版本有 TRUE/FALSE 常量，仓颉不需要）
```

---

### 3.2 MutableShort 类

**文件路径**: `src/mutable/mutable_short.cj`

**继承关系**:
```cangjie
public open class MutableShort <: Number
```

**公共方法清单**（31 个）:

#### 构造函数（4 个）
```cangjie
public init()
public init(value: Int16)
public init(value: Number)
public init(value: String)
```

#### 访问器方法（2 个）
```cangjie
public func getValue(): Int16
public func setValue(value: Int16): Unit
```

#### 算术运算（8 个）
```cangjie
public func add(operand: Int16): MutableShort
public func add(operand: Number): MutableShort
public func subtract(operand: Int16): MutableShort
public func subtract(operand: Number): MutableShort
public func increment(): MutableShort
public func decrement(): MutableShort
public func addAndGet(operand: Int16): Int16
public func subtractAndGet(operand: Int16): Int16
```

#### 原子式操作（4 个）
```cangjie
public func getAndAdd(operand: Int16): Int16
public func getAndDecrement(): Int16
public func getAndIncrement(): Int16
public func getAndSubtract(operand: Int16): Int16
```

#### 比较方法（2 个）
```cangjie
public func equals(obj: Option<Object>): Bool
public func compareTo(other: MutableShort): Int64
```

#### 转换方法（4 个）
```cangjie
public func toInt(): Int64
public func toFloat(): Float32
public func toDouble(): Float64
public func toString(): String
```

#### 工厂方法（2 个）
```cangjie
static public func of(value: Int16): MutableShort
static public func fromString(str: String): Option<MutableShort>
```

#### 其他方法（5 个）
```cangjie
public func hashCode(): Int64
public func shortValue(): Int16
```

**私有字段**:
```cangjie
private var _value: Int16 = 0
```

**常量**:
```cangjie
public const MIN_VALUE: Int16 = -32768
public const MAX_VALUE: Int16 = 32767
```

---

### 3.3 MutableByte 类

**文件路径**: `src/mutable/mutable_byte.cj`

**继承关系**:
```cangjie
public open class MutableByte <: Number
```

**公共方法清单**（31 个）:

**完全复制 MutableShort，修改类型**: `Int16` → `Int8`

**常量**:
```cangjie
public const MIN_VALUE: Int8 = -128
public const MAX_VALUE: Int8 = 127
```

---

### 3.4 MutableObject<T> 类

**文件路径**: `src/mutable/mutable_object.cj`

**继承关系**:
```cangjie
public open class MutableObject<T>
```

**公共方法清单**（7 个）:

#### 构造函数（2 个）
```cangjie
// 默认构造函数（值为 None）
public init()

// 指定初始值
public init(value: T)
```

#### 访问器方法（2 个）
```cangjie
// 获取值
public func getValue(): T

// 设置值
public func setValue(value: T): Unit
```

#### 对象方法（3 个）
```cangjie
// 相等判断
public func equals(obj: Option<Object>): Bool

// 哈希码
public func hashCode(): Int64

// 字符串表示
public func toString(): String
```

**私有字段**:
```cangjie
private var _value: T? = None
```

**泛型约束**:
```cangjie
// 无约束（与 Java 版本一致）
// 内部使用 Option<T> 处理可能为空的值
```

---

## 4. 实现策略

### 4.1 代码复用策略

#### 策略 A: 复制-修改法（推荐）

**适用**: MutableShort, MutableByte

**步骤**:
1. 复制 `mutable_int.cj` 为 `mutable_short.cj`
2. 全局替换: `Int64` → `Int16`
3. 修改常量: `MIN_VALUE` / `MAX_VALUE`
4. 修改文档注释
5. 调整异常消息中的类型名称

**优点**:
- ✅ 快速实现（10-15 分钟/类）
- ✅ 代码结构完全一致
- ✅ 测试用例可复用

**缺点**:
- ⚠️ 代码重复（但数值类型本就该独立实现）

---

#### 策略 B: 独立实现

**适用**: MutableBoolean, MutableObject<T>

**原因**:
- Boolean 的语义与数值类型完全不同
- MutableObject 是泛型类，逻辑简单

**实现要点**:
- MutableBoolean: 参考现有结构，实现布尔特有方法（isTrue, isFalse）
- MutableObject: 最简单的可变包装器，7 个方法

---

### 4.2 实现优先级

| 优先级 | 类名 | 复杂度 | 预估工时 | 依赖关系 |
|-------|------|--------|---------|---------|
| 🔴 P0 | MutableBoolean | ⭐ 简单 | 1.5-2 小时 | 无依赖 |
| 🟡 P1 | MutableObject<T> | ⭐ 简单 | 1 小时 | 无依赖 |
| 🟢 P2 | MutableShort | ⭐⭐ 中等 | 2-2.5 小时 | 无依赖 |
| 🟢 P3 | MutableByte | ⭐⭐ 中等 | 2-2.5 小时 | 无依赖 |

**总计**: 6.5-8 小时

**建议实现顺序**:
1. MutableObject<T>（最简单，热身）
2. MutableBoolean（逻辑独立）
3. MutableShort（复制 MutableInt）
4. MutableByte（复制 MutableShort）

---

### 4.3 关键实现细节

#### 4.3.1 范围检查

MutableShort/MutableByte 需要防止溢出：

```cangjie
// ❌ 不要这样做（会静默溢出）
public func add(operand: Int16): MutableShort {
    _value += operand  // 可能溢出
    return this
}

// ✅ 这样做（明确溢出行为）
/**
 * 将一个值加到此实例的值上
 *
 * 注意：此方法不检查溢出，溢出后将产生未定义结果。
 *
 * @param operand 要加的值
 * @return this，支持链式调用
 */
public func add(operand: Int16): MutableShort {
    _value += operand
    return this
}
```

**决策**: 不检查溢出（与 Java 版本一致）

---

#### 4.3.2 字符串解析

MutableBoolean 的字符串解析规则：

```cangjie
// ✅ 支持的格式（不区分大小写）
"true"   → true
"false"  → false
"t"      → true
"f"      → false
"yes"    → true
"no"     → false
"y"      → true
"n"      → false
"1"      → true
"0"      → false

// ❌ 不支持的格式（返回 None）
"maybe", "unknown", "2", etc.
```

**实现**:
```cangjie
static public func fromString(str: String): Option<MutableBoolean> {
    let lower = str.lowercase()
    match (lower) {
        case "true" | "t" | "yes" | "y" | "1" => Some(MutableBoolean(true))
        case "false" | "f" | "no" | "n" | "0" => Some(MutableBoolean(false))
        case _ => None
    }
}
```

---

#### 4.3.3 MutableObject<T> 的默认值处理

```cangjie
// ✅ 使用 Option<T> 表示可能为空的值
public open class MutableObject<T> {
    private var _value: T? = None

    public init() {
        _value = None
    }

    public init(value: T) {
        _value = Some(value)
    }

    public func getValue(): T {
        match (_value) {
            case Some(v) => v
            case None => throw IllegalStateException("Value not set")
        }
    }

    public func setValue(value: T): Unit {
        _value = Some(value)
    }
}
```

**与 Java 版本的差异**:
- Java: 允许 `null` 值
- 仓颉: 使用 `Option<T>` 表示可能为空的值

---

## 5. 测试策略

### 5.1 测试文件组织

```
src/test/
├── mutable_boolean_test.cj     # 15-20 个用例
├── mutable_short_test.cj       # 25-30 个用例
├── mutable_byte_test.cj        # 25-30 个用例
└── mutable_object_test.cj      # 10-15 个用例
```

**总计**: ~75-95 个测试用例

---

### 5.2 测试用例清单

#### MutableBoolean 测试（20 个用例）

| 类别 | 用例 | 预期结果 |
|------|------|---------|
| 构造函数 | `init()` | 值为 false |
| 构造函数 | `init(true)` | 值为 true |
| 构造函数 | `init("true")` | 值为 true |
| 构造函数 | `init("false")` | 值为 false |
| 访问器 | `getValue()` | 返回当前值 |
| 访问器 | `setValue(true)` | 值变为 true |
| 布尔判断 | `isTrue()` | true 时返回 true |
| 布尔判断 | `isFalse()` | false 时返回 true |
| 比较运算 | `compareTo(true)` | 返回 -1 |
| 相等判断 | `equals(true)` | 类型不同，返回 false |
| 转换 | `toInt()` | true→1, false→0 |
| 转换 | `toString()` | "true" 或 "false" |
| 工厂方法 | `of(true)` | 返回实例 |
| 字符串解析 | `fromString("yes")` | 返回 Some(true) |
| 字符串解析 | `fromString("no")` | 返回 Some(false) |
| 字符串解析 | `fromString("invalid")` | 返回 None |
| 边界情况 | `setFalse()` 后 `isFalse()` | 返回 true |
| 边界情况 | `setTrue()` 后 `isTrue()` | 返回 true |
| 哈希码 | `hashCode()` | true→1, false→0 |
| 链式调用 | `setValue(true).isTrue()` | 返回 true |

---

#### MutableShort 测试（30 个用例）

| 类别 | 用例 | 预期结果 |
|------|------|---------|
| 构造函数 | `init()` | 值为 0 |
| 构造函数 | `init(100)` | 值为 100 |
| 构造函数 | `init("100")` | 值为 100 |
| 算术运算 | `add(10)` | 值增加 10 |
| 算术运算 | `subtract(5)` | 值减少 5 |
| 算术运算 | `increment()` | 值加 1 |
| 算术运算 | `decrement()` | 值减 1 |
| 原子操作 | `addAndGet(10)` | 返回新值 |
| 原子操作 | `getAndAdd(10)` | 返回旧值 |
| 比较运算 | `compareTo(100)` | 返回 0 |
| 相等判断 | `equals(MutableShort(100))` | 返回 true |
| 转换 | `toInt()` | 返回 Int64 |
| 转换 | `toDouble()` | 返回 Float64 |
| 边界值 | `init(MAX_VALUE)` | 值为 32767 |
| 边界值 | `init(MIN_VALUE)` | 值为 -32768 |
| 溢出测试 | `MAX_VALUE.add(1)` | 结果未定义 |
| 溢出测试 | `MIN_VALUE.subtract(1)` | 结果未定义 |
| 工厂方法 | `of(100)` | 返回实例 |
| 字符串解析 | `fromString("100")` | 返回 Some |
| 字符串解析 | `fromString("invalid")` | 返回 None |
| 链式调用 | `add(10).subtract(5).getValue()` | 返回 5 |
| 哈希码 | `hashCode()` | 返回值的哈希 |
| 字符串转换 | `toString()` | 返回 "100" |
| **其他 7 个用例** | - | - |

---

#### MutableByte 测试（30 个用例）

**完全复制 MutableShort 测试**，修改边界值：
- `MAX_VALUE` = 127
- `MIN_VALUE` = -128

---

#### MutableObject<T> 测试（15 个用例）

| 类别 | 用例 | 预期结果 |
|------|------|---------|
| 构造函数 | `init()` | 值为 None |
| 构造函数 | `init("hello")` | 值为 Some("hello") |
| 访问器 | `getValue()` | 返回存储的值 |
| 访问器 | `setValue("world")` | 值变为 "world" |
| 相等判断 | `equals(MutableObject("hello"))` | 返回 true |
| 相等判断 | `equals(MutableObject("world"))` | 返回 false |
| 哈希码 | `hashCode()` | 返回值的哈希 |
| 字符串转换 | `toString()` | 返回值的字符串 |
| 边界情况 | `init().getValue()` | 抛出异常 |
| 边界情况 | `init(None)` | 值为 None |
| 泛型支持 | `MutableObject<Int64>(100)` | 支持数值类型 |
| 泛型支持 | `MutableObject<String>("hello")` | 支持字符串 |
| 泛型支持 | `MutableObject<Bool>(true)` | 支持布尔 |
| 链式调用 | `setValue("a").setValue("b").getValue()` | 返回 "b" |
| **其他 1 个用例** | - | - |

---

### 5.3 测试执行策略

```bash
# 1. 编译项目
cjpm build

# 2. 运行所有测试
cjpm test

# 3. 运行单个测试文件
cjpm test -- test=mutable_boolean_test

# 4. 查看测试覆盖率
cjpm test --coverage
```

---

## 6. 风险评估

### 6.1 技术风险

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| **Int8/Int16 溢出** | 🔴 高 | 🟡 中 | 在文档中明确说明，不强制检查 |
| **泛型擦除** | 🟡 中 | 🟢 低 | 仓颉泛型在运行时保留，问题较小 |
| **字符串解析失败** | 🟡 中 | 🟡 中 | 使用 `Option<T>` 返回 None，而非抛异常 |
| **相等判断复杂** | 🟢 低 | 🟢 低 | 参考已有实现（MutableInt） |

---

### 6.2 与 Java 版本的差异

| 差异点 | Java 版本 | 仓颉版本 | 兼容性 |
|-------|----------|---------|--------|
| **布尔类型** | `boolean` + `Boolean` | 只有 `Bool` | ✅ 兼容 |
| **整数类型** | `short` / `byte` | `Int16` / `Int8` | ✅ 兼容 |
| **空值处理** | `null` | `Option<T>` / `None` | ⚠️ 需适配 |
| **泛型实现** | 类型擦除 | 保留泛型 | ✅ 更好 |
| **相等判断** | `instanceof` | `as` 操作符 | ✅ 等价 |
| **常量定义** | `TRUE` / `FALSE` | 无（不需要） | ✅ 简化 |

---

### 6.3 性能考虑

| 操作 | 性能 | 说明 |
|------|------|------|
| **值存取** | O(1) | 直接访问 `_value` 字段 |
| **算术运算** | O(1) | 原生整数运算 |
| **字符串解析** | O(n) | n = 字符串长度 |
| **哈希计算** | O(1) | 直接返回值或其哈希 |

**结论**: 性能与 Java 版本相当

---

## 7. 架构决策记录 (ADR)

### ADR-001: 是否实现 MutableShort/MutableByte

**状态**: ✅ 已批准

**背景**:
- 需要确认仓颉 1.0.4 是否支持 Int8/Int16 类型
- 如果不支持，需要考虑替代方案

**选项**:
- **选项 A**: 实现完整的 MutableShort/MutableByte（使用 Int8/Int16）
- **选项 B**: 跳过这两个类，仅实现 MutableBoolean 和 MutableObject<T>
- **选项 C**: 使用 Int64 + 范围检查模拟（复杂且低效）

**决策**: 选择 **选项 A**

**理由**:
1. ✅ 仓颉 1.0.4 完整支持 Int8 和 Int16 类型
2. ✅ 可以直接复制 MutableInt 的实现（10-15 分钟/类）
3. ✅ 与 Java 版本功能对等
4. ✅ 提供完整的 Mutable 类型体系

**风险**:
- ⚠️ 需要注意溢出行为（与 Java 版本一致，不检查溢出）

---

### ADR-002: MutableObject<T> 的泛型约束设计

**状态**: ✅ 已批准

**背景**:
- Java 版本的 `MutableObject<T>` 允许 `T` 为任意类型（包括 null）
- 仓颉没有 `null`，使用 `Option<T>` 表示可能为空的值

**选项**:
- **选项 A**: 无约束泛型 `class MutableObject<T>`（推荐）
- **选项 B**: 带约束泛型 `class MutableObject<T> where T <: Any`

**决策**: 选择 **选项 A**

**理由**:
1. ✅ 与 Java 版本 API 一致
2. ✅ 仓颉的泛型默认就是无约束的
3. ✅ 内部使用 `Option<T>` 处理可能为空的值
4. ✅ 简单直接，无需额外约束

**实现细节**:
```cangjie
public open class MutableObject<T> {
    private var _value: T? = None  // 使用 Option<T>

    public init() {
        _value = None
    }

    public init(value: T) {
        _value = Some(value)
    }

    public func getValue(): T {
        match (_value) {
            case Some(v) => v
            case None => throw IllegalStateException("Value not set")
        }
    }
}
```

---

### ADR-003: 是否提取 MutableNumber<T> 基类

**状态**: ❌ 已拒绝

**背景**:
- MutableInt/MutableLong/MutableShort/MutableByte 有大量重复代码
- 考虑是否提取公共基类 `MutableNumber<T>`

**选项**:
- **选项 A**: 提取 `MutableNumber<T>` 基类
- **选项 B**: 不提取，直接复制代码

**决策**: 选择 **选项 B**（不提取基类）

**理由**:
1. ✅ 数值类型是不同的类型（Int8/Int16/Int32/Int64），不能多态
2. ✅ 提取基类后仍然需要为每个类型实现具体方法
3. ✅ 复制-修改法更快（10-15 分钟 vs 1-2 小时）
4. ✅ 每个类独立，更清晰
5. ✅ 参考已有的 MutableInt/MutableLong/MutableDouble 实现（都是独立的）

**成本效益分析**:
| 方案 | 开发时间 | 维护成本 | 代码清晰度 |
|------|---------|---------|-----------|
| 提取基类 | 1-2 小时 | 高（修改影响面大） | 中等 |
| 复制代码 | 10-15 分钟 | 低（独立修改） | 高 |

**结论**: 不值得为节省 300 行代码而增加复杂度

---

### ADR-004: 字符串解析的格式兼容性

**状态**: ✅ 已批准

**背景**:
- MutableBoolean 需要从字符串解析
- Java 版本使用 `Boolean.valueOf()`，只支持 "true"/"false"

**选项**:
- **选项 A**: 严格模式（只支持 "true"/"false"，区分大小写）
- **选项 B**: 宽松模式（支持多种格式，不区分大小写）

**决策**: 选择 **选项 B**（宽松模式）

**理由**:
1. ✅ 用户友好（支持 "yes"/"no"/"1"/"0" 等常见格式）
2. ✅ 不区分大小写（符合直觉）
3. ✅ 无效格式返回 `None`，不抛异常（符合仓颉习惯）
4. ✅ 参考 `BooleanUtils.toBoolean()` 的实现

**支持的格式**:
```cangjie
// ✅ true 的格式
"true", "True", "TRUE"
"t", "T"
"yes", "Yes", "YES"
"y", "Y"
"1"

// ✅ false 的格式
"false", "False", "FALSE"
"f", "F"
"no", "No", "NO"
"n", "N"
"0"

// ❌ 无效格式（返回 None）
"maybe", "unknown", "2", "abc", etc.
```

---

## 8. 实施计划

### 8.1 开发时间线

| 阶段 | 任务 | 预估时间 | 责任人 |
|------|------|---------|--------|
| **Phase 1** | MutableObject<T> 实现 + 测试 | 1 小时 | @Developer |
| **Phase 2** | MutableBoolean 实现 + 测试 | 1.5-2 小时 | @Developer |
| **Phase 3** | MutableShort 实现 + 测试 | 2-2.5 小时 | @Developer |
| **Phase 4** | MutableByte 实现 + 测试 | 2-2.5 小时 | @Developer |
| **Phase 5** | 集成测试 + 文档更新 | 1 小时 | @Developer + @Guardian |
| **总计** | - | **7.5-9 小时** | - |

---

### 8.2 验收标准

#### 代码质量
- ✅ 所有文件通过 `cjpm build` 无错误编译
- ✅ 所有测试通过 `cjpm test`
- ✅ 零编译警告（@Guardian 检查）
- ✅ 私有字段使用 `_` 前缀
- ✅ 公共 API 有文档注释

#### 测试覆盖
- ✅ 每个类都有对应的 `*_test.cj` 文件
- ✅ 测试用例数 ≥ 75 个
- ✅ 覆盖所有公共方法
- ✅ 包含边界情况测试

#### 文档更新
- ✅ 更新 `README.md`（添加 4 个类的说明）
- ✅ 更新 `CLAUDE.md`（项目状态）
- ✅ 创建实现报告（`Mutable_Edge_Types_Report.md`）

---

### 8.3 交付物清单

#### 源代码文件（4 个）
```
src/mutable/
├── mutable_boolean.cj     # ~150 行
├── mutable_short.cj       # ~329 行
├── mutable_byte.cj        # ~329 行
└── mutable_object.cj      # ~100 行
```

#### 测试文件（4 个）
```
src/test/
├── mutable_boolean_test.cj   # ~300 行，20 用例
├── mutable_short_test.cj     # ~450 行，30 用例
├── mutable_byte_test.cj      # ~450 行，30 用例
└── mutable_object_test.cj    # ~250 行，15 用例
```

#### 文档文件（2 个）
```
doc/
├── design/Mutable_Edge_Types_Design.md    # 本文件
└── Mutable_Edge_Types_Report.md           # 实现报告（完成后）
```

---

## 9. 附录

### 9.1 参考资料

#### Java 源码
- `commons-lang/src/main/java/org/apache/commons/lang3/mutable/MutableBoolean.java`
- `commons-lang/src/main/java/org/apache/commons/lang3/mutable/MutableShort.java`
- `commons-lang/src/main/java/org/apache/commons/lang3/mutable/MutableByte.java`
- `commons-lang/src/main/java/org/apache/commons/lang3/mutable/MutableObject.java`

#### 仓颉文档
- `cangJie_docs/libs/std/core/core_package_api/core_package_intrinsics.md`
- `cangJie_docs/libs/std/core/core_package_api/core_package_interfaces.md`

#### 已实现代码
- `src/mutable/mutable_int.cj`（329 行，28 个方法）
- `src/mutable/mutable_double.cj`（421 行，32 个方法）

---

### 9.2 术语表

| 术语 | 说明 |
|------|------|
| **Mutable** | 可变包装器，允许在闭包中修改外部变量 |
| **Option<T>** | 仓颉的类型，表示可能为空的值（Some(T) 或 None） |
| **Int8/Int16** | 仓颉的整数类型，对应 Java 的 byte/short |
| **溢出** | 数值超出类型的表示范围（如 Int8 > 127） |
| **ADR** | Architecture Decision Record，架构决策记录 |

---

### 9.3 变更记录

| 版本 | 日期 | 变更内容 | 作者 |
|------|------|---------|------|
| v1.0.0 | 2026-01-17 | 初始设计文档 | @Architect |

---

## 10. 审批与签字

**设计者**: @Architect
**审查者**: @Developer, @Guardian
**状态**: ✅ 设计完成，等待实现

---

**下一步行动**:
1. ✅ 用户审批此设计
2. ✅ @Developer 开始实现（按优先级顺序）
3. ✅ @Guardian 代码审查
4. ✅ 更新文档

**预计完成时间**: 7.5-9 小时（1 个工作日）
