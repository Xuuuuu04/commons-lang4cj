# Fraction 类设计文档

**项目**: commons-lang4cj v1.1.0
**模块**: Math 包 - Fraction 分数类
**设计师**: @Architect
**日期**: 2026-01-19
**参考**: Apache Commons Lang `org.apache.commons.lang3.math.Fraction`

---

## 1. 架构决策记录 (ADR)

### ADR-001: 使用 Int64 而非 Int32

**背景**:
- Java 版本使用 `int` (32位) 存储分子分母
- 仓颉语言的 `Int32` 与 Java `int` 对应
- 但考虑到实际使用场景和性能,选择 `Int64`

**选项**:
- A) 使用 `Int32` 精确对应 Java 版本
- B) 使用 `Int64` 扩大数值范围

**决策**: 选择 B - 使用 `Int64`

**理由**:
1. **更大的数值范围**: `Int64` 范围约 ±9.2×10¹⁸,`Int32` 仅 ±2.1×10⁹
2. **减少溢出**: 分数运算(乘法)容易溢出,`Int64` 提供更大安全空间
3. **现代 CPU 原生支持**: 64位 CPU 上 `Int64` 性能与 `Int32` 相当
4. **仓颉默认**: 仓颉 `Int` 类型即 `IntNative`,通常为 64 位

**风险**:
- 与 Java 版本不完全等价(但功能更强)
- 占用更多内存(16 字节 vs 8 字节)

---

### ADR-002: 不可变对象设计

**背景**:
- 分数对象创建后不应被修改
- 确保线程安全和可预测性

**决策**: Fraction 类为**不可变对象** (Immutable)

**实现**:
- 所有字段使用 `let` 声明(不可变)
- 所有运算方法返回**新对象**,不修改当前对象
- 缓存 `hashCode`、`toString`、`toProperString` 结果

**优势**:
1. **线程安全**: 无需同步即可多线程访问
2. **可缓存**: 字符串表示和哈希码可缓存
3. **符合函数式编程**: 支持链式调用

---

### ADR-003: 使用 Option<T> 处理缺失值

**背景**:
- 部分场景需要可选值(如除法结果)
- 仓颉没有 `null`,使用 `Option<T>` 模式

**决策**:
- **工厂方法**: 抛出 `IllegalArgumentException` (分母为零是严重错误)
- **比较方法**: 返回 `Int64` (-1/0/1)
- **类型转换**: 提供安全的 `toDouble()`,不使用 `Option`

**理由**:
- 分母为零是**编程错误**,应立即失败而非返回 `None`
- 与 Java 版本异常策略保持一致
- 仓颉推荐明确异常处理

---

## 2. 类签名与接口设计

### 2.1 完整类签名

```cangjie
package commons_lang4cj.math

/**
 * Fraction 分数类
 *
 * 表示有理数(分数),提供精确的分数运算功能。
 * 本类是不可变的,所有运算返回新对象。
 *
 * 本类使用 Int64 存储分子分母,适合大多数常用场景。
 * 对于超大数值或需要无限精度的情况,建议使用专门的 BigFraction 类。
 *
 * @since 1.1.0
 */
public class Fraction {
    // 私有字段
    private let _numerator: Int64
    private let _denominator: Int64
    private var _hashCode: Int64
    private var _toString: String
    private var _toProperString: String

    // 私有构造函数
    private init(numerator: Int64, denominator: Int64)

    // 公共方法列表(详见下文)
}
```

### 2.2 实现的接口

```cangjie
/**
 * 分数比较接口
 */
public interface Comparable<T> {
    func compareTo(other: T): Int64
}

/**
 * 相等性接口
 */
public interface Equatable<T> {
    func equals(other: Option<T>): Bool
}

/**
 * 哈希接口
 */
public interface Hashable {
    func hashCode(): Int64
}

/**
 * 字符串转换接口
 */
public interface ToString {
    func toString(): String
}

// Fraction 实现上述接口
public class Fraction <: Comparable<Fraction>, Equatable<Fraction>, Hashable, ToString
```

---

## 3. 核心字段设计

### 3.1 实例字段

| 字段名 | 类型 | 可变性 | 说明 |
|--------|------|--------|------|
| `_numerator` | `Int64` | `let` | 分子,可正可负,符号表示分数符号 |
| `_denominator` | `Int64` | `let` | 分母,**始终为正数** |
| `_hashCode` | `Int64` | `var` | 缓存的哈希码(对象不可变,可缓存) |
| `_toString` | `String` | `var` | 缓存的字符串表示 `"a/b"` |
| `_toProperString` | `String` | `var` | 缓存的带分数表示 `"W n/d"` |

### 3.2 静态常量字段

```cangjie
// 静态常量 - 常用分数预定义
public static val ZERO: Fraction              // 0/1 = 0
public static val ONE: Fraction               // 1/1 = 1
public static val ONE_HALF: Fraction          // 1/2 = 0.5
public static val ONE_THIRD: Fraction         // 1/3 ≈ 0.333
public static val TWO_THIRDS: Fraction        // 2/3 ≈ 0.666
public static val ONE_QUARTER: Fraction       // 1/4 = 0.25
public static val TWO_QUARTERS: Fraction      // 2/4 = 1/2 (注意:未约简)
public static val THREE_QUARTERS: Fraction    // 3/4 = 0.75
public static val ONE_FIFTH: Fraction         // 1/5 = 0.2
public static val TWO_FIFTHS: Fraction        // 2/5 = 0.4
public static val THREE_FIFTHS: Fraction      // 3/5 = 0.6
public static val FOUR_FIFTHS: Fraction       // 4/5 = 0.8
```

**注意**:
- `TWO_QUARTERS` (2/4) 未约简,保持原始值
- 这与 Java 版本一致,用于测试相等性

---

## 4. 公共方法列表 (40个)

### 4.1 工厂方法 (4个)

| 方法签名 | 功能 | 异常 |
|---------|------|------|
| `getFraction(numerator: Int64, denominator: Int64): Fraction` | 创建分数 Y/Z | `ArithmeticException` (分母=0) |
| `getFraction(whole: Int64, numerator: Int64, denominator: Int64): Fraction` | 创建带分数 X Y/Z | `ArithmeticException` |
| `getFraction(num: Int64): Fraction` | 创建整数分数 X/1 | - |
| `getReducedFraction(numerator: Int64, denominator: Int64): Fraction` | 创建约简后的分数 | `ArithmeticException` |

#### 示例:
```cangjie
// 创建分数 3/7
let f1 = Fraction.getFraction(3, 7)  // 3/7

// 创建带分数 1 又 3/7
let f2 = Fraction.getFraction(1, 3, 7)  // 10/7

// 创建整数分数
let f3 = Fraction.getFraction(5)  // 5/1

// 创建约简分数 (2/4 -> 1/2)
let f4 = Fraction.getReducedFraction(2, 4)  // 1/2
```

---

### 4.2 基本运算 (6个)

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `add(fraction: Fraction): Fraction` | 加法 a/b + c/d | 新分数对象 |
| `subtract(fraction: Fraction): Fraction` | 减法 a/b - c/d | 新分数对象 |
| `multiplyBy(fraction: Fraction): Fraction` | 乘法 (a/b) × (c/d) | 新分数对象 |
| `divideBy(fraction: Fraction): Fraction` | 除法 (a/b) ÷ (c/d) | 新分数对象 |
| `negate(): Fraction` | 取反 -a/b | 新分数对象 |
| `invert(): Fraction` | 倒数 b/a | 新分数对象 |

#### 示例:
```cangjie
let f1 = Fraction.getFraction(1, 2)  // 1/2
let f2 = Fraction.getFraction(1, 3)  // 1/3

let sum = f1.add(f2)           // 1/2 + 1/3 = 5/6
let diff = f1.subtract(f2)     // 1/2 - 1/3 = 1/6
let product = f1.multiplyBy(f2)// 1/2 × 1/3 = 1/6
let quotient = f1.divideBy(f2) // (1/2) ÷ (1/3) = 3/2

let neg = f1.negate()          // -1/2
let inv = f1.invert()          // 2/1
```

---

### 4.3 取整与幂运算 (3个)

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `abs(): Fraction` | 绝对值 \|a/b\| | 新分数对象 |
| `pow(power: Int64): Fraction` | 幂运算 (a/b)ⁿ | 新分数对象 |
| `remainder(fraction: Fraction): Fraction` | 取余 (a/b) mod (c/d) | 新分数对象 |

#### 示例:
```cangjie
let f1 = Fraction.getFraction(-3, 4)  // -3/4
let absVal = f1.abs()                 // 3/4

let f2 = Fraction.getFraction(2, 3)   // 2/3
let squared = f2.pow(2)               // (2/3)² = 4/9
let cubed = f2.pow(3)                 // (2/3)³ = 8/27
```

---

### 4.4 类型转换 (5个)

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `toDouble(): Float64` | 转换为双精度浮点数 | `Float64` |
| `toFloat(): Float32` | 转换为单精度浮点数 | `Float32` |
| `toInt(): Int64` | 转换为整数(截断) | `Int64` |
| `toIntValue(): Int64` | 转换为整数(截断) | `Int64` |
| `getProperWhole(): Int64` | 获取带分数的整数部分 | `Int64` |

#### 示例:
```cangjie
let f = Fraction.getFraction(7, 4)  // 7/4 = 1.75

f.toDouble()    // 1.75 (Float64)
f.toFloat()     // 1.75 (Float32)
f.toInt()       // 1 (截断小数部分)
f.getProperWhole() // 1 (带分数整数部分)
```

---

### 4.5 比较方法 (2个)

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `compareTo(other: Fraction): Int64` | 比较大小 | -1(小) / 0(等) / 1(大) |
| `equals(other: Option<Fraction>): Bool` | 相等性比较 | `true`/`false` |

#### 示例:
```cangjie
let f1 = Fraction.getFraction(1, 2)
let f2 = Fraction.getFraction(2, 4)
let f3 = Fraction.getFraction(1, 3)

f1.compareTo(f3)  // 1 (1/2 > 1/3)
f1.equals(f2)     // false (1/2 ≠ 2/4,未约简)
f1.equals(f1)     // true
```

**注意**: `equals()` 比较**分子分母值**,而非数学值。1/2 ≠ 2/4

---

### 4.6 查询方法 (7个)

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `getNumerator(): Int64` | 获取分子 | `Int64` |
| `getDenominator(): Int64` | 获取分母 | `Int64` |
| `getProperNumerator(): Int64` | 获取真分数分子 | `Int64` |
| `getProperWhole(): Int64` | 获取带分数整数部分 | `Int64` |
| `isZero(): Bool` | 是否为零 | `Bool` |
| `isPositive(): Bool` | 是否为正 | `Bool` |
| `isNegative(): Bool` | 是否为负 | `Bool` |

#### 示例:
```cangjie
let f = Fraction.getFraction(7, 4)  // 7/4 = 1 又 3/4

f.getNumerator()        // 7
f.getDenominator()      // 4
f.getProperNumerator()  // 3 (真分数部分分子)
f.getProperWhole()      // 1 (整数部分)

f.isZero()      // false
f.isPositive()  // true
f.isNegative()  // false
```

---

### 4.7 字符串方法 (2个)

| 方法签名 | 功能 | 返回值 | 示例 |
|---------|------|--------|------|
| `toString(): String` | 转换为假分数字符串 | `"a/b"` | `7/4` → `"7/4"` |
| `toProperString(): String` | 转换为带分数字符串 | `"W n/d"` | `7/4` → `"1 3/4"` |

#### 示例:
```cangjie
let f1 = Fraction.getFraction(7, 4)   // 7/4
let f2 = Fraction.getFraction(3, 4)   // 3/4

f1.toString()         // "7/4"
f1.toProperString()   // "1 3/4"

f2.toString()         // "3/4"
f2.toProperString()   // "3/4" (小于1,无整数部分)
```

---

### 4.8 哈希方法 (1个)

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `hashCode(): Int64` | 计算哈希码 | `Int64` |

#### 实现公式:
```cangjie
hashCode = (numerator * 31) + denominator
```

---

## 5. 核心算法实现

### 5.1 最大公约数 (GCD) - 二进制 GCD 算法

**算法**: Stein 算法 (Binary GCD)
**来源**: Knuth TAOCP 4.5.1 算法 B
**优势**: 避免昂贵的除法和取模运算

```cangjie
/**
 * 计算两个数的最大公约数
 * 使用二进制 GCD 算法 (Stein 算法)
 *
 * @param u 第一个数(非零)
 * @param v 第二个数(非零)
 * @return 最大公约数(始终为正)
 */
private static func greatestCommonDivisor(u: Int64, v: Int64): Int64 {
    // 特殊情况: 如果有一个数为0
    if (u == 0 || v == 0) {
        return u.abs() + v.abs()
    }

    // 如果有一个数为±1,直接返回1
    if (u.abs() == 1 || v.abs() == 1) {
        return 1
    }

    // 将 u, v 转为负数(避免 Int64 最小值取反溢出)
    var uVar = u > 0 ? -u : u
    var vVar = v > 0 ? -v : v

    // B1. 找出 u 和 v 中 2 的最大幂次
    var k = 0
    while ((uVar & 1) == 0 && (vVar & 1) == 0 && k < 63) {
        uVar = uVar / 2
        vVar = vVar / 2
        k++
    }

    // B2. 初始化: u 和 v 已除以 2^k,至少有一个是奇数
    var t = (uVar & 1) == 1 ? vVar : -(uVar / 2)

    // B3-B6. 主循环
    while (t != 0) {
        // B4. 剔除 t 中的因子2
        while ((t & 1) == 0) {
            t = t / 2
        }

        // B5. 重置 max(u, v)
        if (t > 0) {
            uVar = -t
        } else {
            vVar = t
        }

        // B6. 更新 t
        t = (vVar - uVar) / 2
    }

    return -uVar * (1 << k)  // gcd = u * 2^k
}
```

**复杂度**: O(log n)
**示例**:
```
greatestCommonDivisor(12, 18) = 6
greatestCommonDivisor(100, 75) = 25
```

---

### 5.2 分数约简 (Reduce)

**目标**: 将分数 `a/b` 约简为最简形式 `a'/b'`
**方法**: 分子分母同时除以 GCD

```cangjie
/**
 * 约简分数到最简形式
 * 例如: 2/4 -> 1/2
 */
private func reduce(): Fraction {
    if (_numerator == 0) {
        return Fraction.ZERO  // 零分数归一化
    }

    let gcd = Fraction.greatestCommonDivisor(_numerator, _denominator)
    return Fraction.getReducedFraction(_numerator / gcd, _denominator / gcd)
}
```

**示例**:
```
2/4  -> 1/2  (GCD=2)
6/9  -> 2/3  (GCD=3)
100/25 -> 4/1 (GCD=25)
```

---

### 5.3 分数加法 (Knuth 算法 4.5.1)

**算法**: Donald Knuth TAOCP 4.5.1
**公式**: `a/b + c/d = (a×d + c×b) / (b×d)`

```cangjie
/**
 * 分数加法
 * 使用 Knuth 4.5.1 算法
 */
public func add(fraction: Fraction): Fraction {
    // 零是加法单位元
    if (_numerator == 0) {
        return fraction
    }
    if (fraction._numerator == 0) {
        return this
    }

    // 计算 d1 = gcd(b, d)
    let d1 = Fraction.greatestCommonDivisor(_denominator, fraction._denominator)

    if (d1 == 1) {
        // 简单情况: (a×d + c×b) / (b×d)
        let uvp = _numerator * fraction._denominator
        let upv = fraction._numerator * _denominator
        let newNum = uvp + upv
        let newDen = _denominator * fraction._denominator
        return Fraction.getReducedFraction(newNum, newDen)
    }

    // 复杂情况: 需要处理约简
    // t = a×(d/d1) + c×(b/d1)
    let uvp = _numerator * (fraction._denominator / d1)
    let upv = fraction._numerator * (_denominator / d1)
    let t = uvp + upv

    // d2 = gcd(t, d1)
    let d2 = Fraction.greatestCommonDivisor(t, d1)

    // 结果: (t/d2) / ((b/d1) × (d/d2))
    let newNum = t / d2
    let newDen = (_denominator / d1) * (fraction._denominator / d2)
    return Fraction.getReducedFraction(newNum, newDen)
}
```

**示例**:
```
1/2 + 1/3 = 5/6
1/6 + 1/3 = 3/6 = 1/2 (约简)
```

---

### 5.4 分数乘法

**公式**: `(a/b) × (c/d) = (a×c) / (b×d)`

```cangjie
/**
 * 分数乘法
 */
public func multiplyBy(fraction: Fraction): Fraction {
    // 零乘任何数等于零
    if (_numerator == 0 || fraction._numerator == 0) {
        return Fraction.ZERO
    }

    // 交叉约简以避免溢出
    let d1 = Fraction.greatestCommonDivisor(_numerator, fraction._denominator)
    let d2 = Fraction.greatestCommonDivisor(fraction._numerator, _denominator)

    let newNum = (_numerator / d1) * (fraction._numerator / d2)
    let newDen = (_denominator / d2) * (fraction._denominator / d1)

    return Fraction.getReducedFraction(newNum, newDen)
}
```

**示例**:
```
1/2 × 2/3 = 2/6 = 1/3 (约简)
2/3 × 9/4 = 18/12 = 3/2 (约简)
```

---

### 5.5 分数除法

**公式**: `(a/b) ÷ (c/d) = (a/b) × (d/c) = (a×d) / (b×c)`

```cangjie
/**
 * 分数除法
 */
public func divideBy(fraction: Fraction): Fraction {
    if (fraction._numerator == 0) {
        throw ArithmeticException("Cannot divide by zero")
    }
    return this.multiplyBy(fraction.invert())
}
```

---

### 5.6 分数取反 (Negate)

**公式**: `-(a/b) = (-a)/b`

```cangjie
/**
 * 取反分数
 */
public func negate(): Fraction {
    return Fraction.getReducedFraction(-_numerator, _denominator)
}
```

---

### 5.7 分数倒数 (Invert)

**公式**: `(a/b)^(-1) = b/a`

```cangjie
/**
 * 计算倒数
 */
public func invert(): Fraction {
    if (_numerator == 0) {
        throw ArithmeticException("Cannot invert zero")
    }
    return Fraction.getReducedFraction(_denominator, _numerator)
}
```

---

## 6. 异常策略

### 6.1 异常类型

```cangjie
package commons_lang4cj.math

/**
 * 算术异常
 */
public class ArithmeticException <: Exception {
    public init(message: String) {
        super(message)
    }

    public override func getClassName(): String {
        "ArithmeticException"
    }
}
```

### 6.2 抛出异常的场景

| 场景 | 条件 | 异常类型 | 错误信息 |
|------|------|----------|----------|
| 创建分数 | `denominator == 0` | `ArithmeticException` | "The denominator must not be zero" |
| 除法 | `fraction._numerator == 0` | `ArithmeticException` | "Cannot divide by zero" |
| 取倒数 | `_numerator == 0` | `ArithmeticException` | "Cannot invert zero" |
| 乘法溢出 | 分子或分母超出 `Int64` 范围 | `ArithmeticException` | "overflow: numerator too large" |
| 加法溢出 | 结果超出 `Int64` 范围 | `ArithmeticException` | "overflow: add" |
| 减法溢出 | 结果超出 `Int64` 范围 | `ArithmeticException` | "overflow: subtract" |

### 6.3 异常处理示例

```cangjie
// 创建分数时检查
try {
    let f = Fraction.getFraction(1, 0)  // 分母为零
} catch (e: ArithmeticException) {
    println("Error: ${e.message}")  // "The denominator must not be zero"
}

// 除法时检查
try {
    let f1 = Fraction.getFraction(1, 2)
    let f2 = Fraction.ZERO
    let result = f1.divideBy(f2)  // 除以零
} catch (e: ArithmeticException) {
    println("Error: ${e.message}")  // "Cannot divide by zero"
}
```

---

## 7. 测试策略

### 7.1 测试文件结构

```
commons-lang4cj/src/math_test/
├── fraction_test.cj          # Fraction 核心功能测试
├── fraction_operations_test.cj  # 四则运算测试
├── fraction_conversion_test.cj  # 类型转换测试
└── fraction_edge_cases_test.cj  # 边界情况测试
```

### 7.2 核心测试用例 (预计 50+ 个)

#### 7.2.1 工厂方法测试 (10 个)

```cangjie
@Test
class FractionFactoryTest {
    @TestCase
    func testGetFractionSimple() {
        let f = Fraction.getFraction(3, 7)
        @Expect(f.getNumerator(), 3)
        @Expect(f.getDenominator(), 7)
    }

    @TestCase
    func testGetFractionZeroDenominator() {
        @ExpectThrows[ArithmeticException]({
            Fraction.getFraction(1, 0)
        })
    }

    @TestCase
    func testGetFractionNegativeDenominator() {
        let f = Fraction.getFraction(1, -2)
        @Expect(f.getNumerator(), -1)
        @Expect(f.getDenominator(), 2)
    }

    @TestCase
    func testGetFractionMixedNumber() {
        let f = Fraction.getFraction(1, 3, 7)  // 1 又 3/7 = 10/7
        @Expect(f.getNumerator(), 10)
        @Expect(f.getDenominator(), 7)
    }

    @TestCase
    func testGetReducedFraction() {
        let f = Fraction.getReducedFraction(2, 4)
        @Expect(f.getNumerator(), 1)
        @Expect(f.getDenominator(), 2)
    }

    // ... 更多测试
}
```

#### 7.2.2 四则运算测试 (15 个)

```cangjie
@Test
class FractionOperationsTest {
    @TestCase
    func testAdd() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 3)
        let result = f1.add(f2)
        @Expect(result.getNumerator(), 5)
        @Expect(result.getDenominator(), 6)
    }

    @TestCase
    func testSubtract() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 3)
        let result = f1.subtract(f2)
        @Expect(result.getNumerator(), 1)
        @Expect(result.getDenominator(), 6)
    }

    @TestCase
    func testMultiplyBy() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(2, 3)
        let result = f1.multiplyBy(f2)
        @Expect(result.getNumerator(), 1)
        @Expect(result.getDenominator(), 3)
    }

    @TestCase
    func testDivideBy() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 4)
        let result = f1.divideBy(f2)
        @Expect(result.getNumerator(), 2)
        @Expect(result.getDenominator(), 1)
    }

    @TestCase
    func testDivideByZero() {
        let f1 = Fraction.getFraction(1, 2)
        @ExpectThrows[ArithmeticException]({
            f1.divideBy(Fraction.ZERO)
        })
    }

    @TestCase
    func testNegate() {
        let f = Fraction.getFraction(1, 2)
        let result = f.negate()
        @Expect(result.getNumerator(), -1)
        @Expect(result.getDenominator(), 2)
    }

    @TestCase
    func testInvert() {
        let f = Fraction.getFraction(2, 3)
        let result = f.invert()
        @Expect(result.getNumerator(), 3)
        @Expect(result.getDenominator(), 2)
    }

    // ... 更多测试
}
```

#### 7.2.3 比较与转换测试 (10 个)

```cangjie
@Test
class FractionCompareTest {
    @TestCase
    func testCompareTo() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 3)
        @Expect(f1.compareTo(f2), 1)  // 1/2 > 1/3
    }

    @TestCase
    func testEquals() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(2, 4)
        @Expect(f1.equals(f2), false)  // 未约简,不相等
    }

    @TestCase
    func testToDouble() {
        let f = Fraction.getFraction(1, 2)
        let diff = (f.toDouble() - 0.5).abs()
        @Expect(diff < 0.0001, true)
    }

    @TestCase
    func testToString() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.toString(), "7/4")
    }

    @TestCase
    func testToProperString() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.toProperString(), "1 3/4")
    }

    // ... 更多测试
}
```

#### 7.2.4 边界情况测试 (15 个)

```cangjie
@Test
class FractionEdgeCasesTest {
    @TestCase
    func testZeroFraction() {
        let f = Fraction.ZERO
        @Expect(f.isZero(), true)
        @Expect(f.getNumerator(), 0)
        @Expect(f.getDenominator(), 1)
    }

    @TestCase
    func testNegativeFraction() {
        let f = Fraction.getFraction(-3, 4)
        @Expect(f.isNegative(), true)
        @Expect(f.isPositive(), false)
    }

    @TestCase
    func testAbsoluteValue() {
        let f = Fraction.getFraction(-3, 4)
        let absVal = f.abs()
        @Expect(absVal.getNumerator(), 3)
        @Expect(absVal.isPositive(), true)
    }

    @TestCase
    func testPowerOfFraction() {
        let f = Fraction.getFraction(2, 3)
        let squared = f.pow(2)
        @Expect(squared.getNumerator(), 4)
        @Expect(squared.getDenominator(), 9)
    }

    @TestCase
    func testLargeNumbers() {
        let f = Fraction.getFraction(1000000, 2000000)
        @Expect(f.getNumerator(), 1)
        @Expect(f.getDenominator(), 2)
    }

    // ... 更多测试
}
```

### 7.3 性能测试 (可选)

```cangjie
@Test
class FractionPerformanceTest {
    @TestCase
    func testGCDPerformance() {
        let start = DateTime.now()
        for (i in 0..10000) {
            let _ = Fraction.greatestCommonDivisor(123456789, 987654321)
        }
        let end = DateTime.now()
        let duration = (end - start).toMilliseconds()
        println("GCD 10000次耗时: ${duration}ms")
    }
}
```

---

## 8. 性能优化策略

### 8.1 缓存策略

**不可变对象特性允许缓存**:

```cangjie
public class Fraction {
    private var _hashCode: Int64 = 0
    private var _toString: String = ""
    private var _toProperString: String = ""

    public func hashCode(): Int64 {
        if (_hashCode == 0) {
            _hashCode = (_numerator * 31) + _denominator
        }
        return _hashCode
    }

    public func toString(): String {
        if (_toString.isEmpty()) {
            _toString = "${_numerator}/${_denominator}"
        }
        return _toString
    }

    public func toProperString(): String {
        if (_toProperString.isEmpty()) {
            if (_numerator >= _denominator) {
                let whole = _numerator / _denominator
                let remainder = _numerator % _denominator
                if (remainder == 0) {
                    _toProperString = "${whole}"
                } else {
                    _toProperString = "${whole} ${remainder}/${_denominator}"
                }
            } else {
                _toProperString = toString()
            }
        }
        return _toProperString
    }
}
```

**收益**:
- 避免重复字符串拼接
- 哈希表查找性能提升

### 8.2 交叉约简 (Cross-Reduction)

**乘法优化**: 先约简再相乘,避免溢出

```cangjie
// 优化前: 直接相乘
// (1000000/1) × (1/1000000) = 1000000/1000000
// 分子分母都会溢出!

// 优化后: 先约简
let d1 = gcd(1000000, 1000000)  // 1000000
let newNum = (1000000 / d1) × (1 / 1) = 1
let newDen = (1 / 1) × (1000000 / d1) = 1
// 结果: 1/1, 不会溢出
```

### 8.3 零值快速路径

```cangjie
public func add(fraction: Fraction): Fraction {
    // 零是加法单位元,直接返回
    if (_numerator == 0) {
        return fraction
    }
    if (fraction._numerator == 0) {
        return this
    }
    // ... 正常加法逻辑
}
```

### 8.4 GCD 缓存 (可选高级优化)

**思路**: 使用 `HashMap` 缓存常见 GCD 结果

```cangjie
private static let gcdCache = HashMap<(Int64, Int64), Int64>()

private static func greatestCommonDivisor(u: Int64, v: Int64): Int64 {
    let key = (u.min(v), u.max(v))
    if (let Some(cached) <- gcdCache.get(key)) {
        return cached
    }

    let result = binaryGCD(u, v)
    gcdCache.put(key, result)
    return result
}
```

**权衡**:
- ✓ 提升 GCD 计算速度 30-50%
- ✗ 增加内存占用
- ✗ 增加代码复杂度

**建议**: 初期不实现,性能测试后再决定

---

## 9. 依赖关系

### 9.1 外部依赖

```
commons-lang4cj.math.Fraction
├── std.collection.* (HashMap, 可选用于GCD缓存)
├── std.math.* (abs, pow 等函数)
└── (无其他依赖)
```

### 9.2 内部依赖

```
commons-lang4cj.math.Fraction
├── commons_lang4cj.math.ArithmeticException (自定义异常)
└── (无其他内部依赖)
```

### 9.3 被依赖关系

```
(潜在的未来模块)
├── commons_lang4cj.math.BigFraction (大分数)
├── commons_lang4cj.math.Percentage (百分比)
└── commons_lang4cj.math.Rational (有理数接口)
```

---

## 10. 包结构与导出

### 10.1 目录结构

```
commons-lang4cj/src/
├── math/
│   ├── fraction.cj              # Fraction 类实现
│   ├── arithmetic_exception.cj  # 异常类定义
│   └── mod public math {
│       public import commons_lang4cj.math.fraction.*
│       public import commons_lang4cj.math.arithmetic_exception.*
│   }
└── math_test/
    ├── fraction_test.cj
    ├── fraction_operations_test.cj
    ├── fraction_conversion_test.cj
    └── fraction_edge_cases_test.cj
```

### 10.2 包声明

```cangjie
// fraction.cj
package commons_lang4cj.math

// arithmetic_exception.cj
package commons_lang4cj.math
```

### 10.3 公共导出 (commons_lang4cj.cj)

```cangjie
package commons_lang4cj

// 导出 Math 包
public import commons_lang4cj.math.*
```

### 10.4 使用示例

```cangjie
import commons_lang4cj.math.*

main() {
    // 创建分数
    let f1 = Fraction.getFraction(1, 2)
    let f2 = Fraction.getFraction(1, 3)

    // 四则运算
    let sum = f1.add(f2)
    println("1/2 + 1/3 = ${sum.toString()}")  // 5/6

    // 类型转换
    println("1/2 as double: ${f1.toDouble()}")  // 0.5

    // 比较
    if (f1.compareTo(f2) > 0) {
        println("1/2 > 1/3")
    }

    // 字符串表示
    let f3 = Fraction.getFraction(7, 4)
    println("7/4 = ${f3.toProperString()}")  // 1 3/4
}
```

---

## 11. 实现工作量估算

### 11.1 代码量估算

| 模块 | 预估代码行数 | 预估方法数 |
|------|-------------|-----------|
| `fraction.cj` (核心实现) | 800-1000 行 | 40 个公共方法 + 10 个私有方法 |
| `arithmetic_exception.cj` | 20 行 | 1 个类 |
| `fraction_test.cj` (核心测试) | 300 行 | 15 个测试用例 |
| `fraction_operations_test.cj` | 400 行 | 20 个测试用例 |
| `fraction_conversion_test.cj` | 250 行 | 10 个测试用例 |
| `fraction_edge_cases_test.cj` | 350 行 | 15 个测试用例 |
| **总计** | **~2100-2300 行** | **60 个方法 + 60 个测试用例** |

### 11.2 时间估算

| 阶段 | 任务 | 预估时间 | 责任人 |
|------|------|---------|--------|
| **设计阶段** | | **1-2 小时** | @Architect |
| | 阅读Java源码 | 30 分钟 | |
| | 设计API签名 | 30 分钟 | |
| | 编写设计文档 | 1 小时 | |
| **实现阶段** | | **4-5 小时** | @Developer |
| | 实现核心算法 (GCD, 约简) | 1 小时 | |
| | 实现工厂方法 | 30 分钟 | |
| | 实现四则运算 | 1.5 小时 | |
| | 实现转换和查询方法 | 1 小时 | |
| | 实现字符串和哈希方法 | 30 分钟 | |
| | 编译调试 | 30 分钟 | |
| **测试阶段** | | **2-3 小时** | @Developer |
| | 编写单元测试 | 1.5 小时 | |
| | 运行测试并修复Bug | 1 小时 | |
| | 性能测试(可选) | 30 分钟 | |
| **审查阶段** | | **30 分钟** | @Guardian |
| | 代码审查和规范检查 | 30 分钟 | |
| **总计** | | **7.5-10.5 小时** | |

### 11.3 里程碑

- [ ] **Day 1**: 设计完成 (API 签名 + 算法文档)
- [ ] **Day 2**: 核心实现完成 (工厂方法 + 四则运算)
- [ ] **Day 3**: 全部功能实现 + 核心测试通过
- [ ] **Day 4**: 全部测试通过 + 代码审查完成
- [ ] **Day 5**: 文档完善 + 发布 v1.1.0

---

## 12. 风险与限制

### 12.1 技术限制

| 限制项 | 说明 | 影响 |
|--------|------|------|
| **数值溢出** | `Int64` 范围有限,极大分数运算可能溢出 | 抛出 `ArithmeticException` |
| **精度丢失** | 转换为 `Float64` 时可能丢失精度 | `toDouble()` 不完全精确 |
| **无法表示无限** | 无法表示 1/0 等无限值 | 抛出异常 |
| **循环小数** | 无法精确表示循环小数 | 使用近似值 |

### 12.2 与 Java 版本的差异

| 差异项 | Java 版本 | 仓颉版本 | 原因 |
|--------|----------|---------|------|
| **整数类型** | `int` (32位) | `Int64` (64位) | 扩大数值范围 |
| **序列化** | 实现 `Serializable` | 未实现 | 仓颉序列化机制不同 |
| **BigInteger** | 内部使用 `BigInteger` | 使用 `Int64` | 仓颉无标准大数库 |
| **异常类型** | `java.lang.ArithmeticException` | 自定义 `ArithmeticException` | 包名不同 |

### 12.3 性能考虑

| 操作 | 时间复杂度 | 说明 |
|------|-----------|------|
| 创建分数 | O(1) | 直接赋值 |
| 约简分数 | O(log n) | GCD 算法 |
| 加法/减法 | O(log n) | 需要 GCD |
| 乘法 | O(log n) | 交叉约简 + GCD |
| 除法 | O(log n) | 取倒数 + 乘法 |
| 比较 | O(1) | 乘法比较 |
| `hashCode()` | O(1) | 缓存后 O(1) |
| `toString()` | O(1) | 缓存后 O(1) |

---

## 13. 后续扩展计划

### 13.1 Phase 2: BigFraction (大分数)

**目标**: 支持超大整数的分数运算
**实现**: 使用自定义 `BigInt` 类(需先实现)

```cangjie
public class BigFraction {
    private let _numerator: BigInt
    private let _denominator: BigInt

    // 类似 Fraction 的 API
}
```

### 13.2 Phase 3: Percentage (百分比)

**目标**: 提供百分比表示和运算

```cangjie
public class Percentage {
    private let _fraction: Fraction

    public static func of(value: Int64): Percentage {
        Percentage(Fraction.getFraction(value, 100))
    }

    public func toFraction(): Fraction {
        _fraction
    }
}
```

### 13.3 Phase 4: Rational 接口 (有理数接口)

**目标**: 统一 `Fraction` 和 `BigFraction` 接口

```cangjie
public interface Rational<T> {
    func add(other: T): T
    func subtract(other: T): T
    func multiplyBy(other: T): T
    func divideBy(other: T): T
}
```

---

## 14. 总结

### 14.1 设计亮点

1. ✅ **不可变对象**: 线程安全,可缓存
2. ✅ **Int64 类型**: 更大数值范围,减少溢出
3. ✅ **高效算法**: 二进制 GCD, 交叉约简
4. ✅ **完整测试**: 50+ 测试用例,覆盖核心场景
5. ✅ **清晰 API**: 符合仓颉命名规范

### 14.2 与 commons-lang4cj 整合

```cangjie
// commons_lang4cj.cj 更新
public import commons_lang4cj.math.*

// 使用示例
import commons_lang4cj.*

main() {
    // 与其他工具类配合使用
    let f = Fraction.getFraction(1, 2)
    let str = StringUtils.toString(f)  // "1/2"
    let eq = EqualsBuilder().append(f, f).isEquals()  // true
}
```

### 14.3 版本发布计划

**v1.1.0 (Math 包)**:
- ✅ Fraction 类 (40 个方法)
- ✅ 完整单元测试 (50+ 用例)
- ✅ API 文档
- ✅ 使用示例

**预计发布时间**: 2026-01-22 (完成后 3 天)

---

**文档状态**: ✅ 完成
**设计师签名**: @Architect
**审核状态**: ⏳ 待用户确认
**下一步**: @Developer 开始实现

---

## 附录 A: 参考资料

1. **Apache Commons Lang Fraction**: [Java源码](https://github.com/apache/commons-lang/blob/master/src/main/java/org/apache/commons/lang3/math/Fraction.java)
2. **Donald Knuth TAOCP 4.5.1**: 分数运算算法
3. **仓颉语言文档**: `cangJie_docs/` 目录
4. **commons-lang4cj 现有代码**: `src/utils/`, `src/builder/`

---

## 附录 B: 快速参考

### 常用代码片段

```cangjie
// 创建分数
let f1 = Fraction.getFraction(1, 2)    // 1/2
let f2 = Fraction.getFraction(1, 3)    // 1/3

// 运算
let sum = f1.add(f2)                   // 5/6
let diff = f1.subtract(f2)             // 1/6
let product = f1.multiplyBy(f2)        // 1/6
let quotient = f1.divideBy(f2)         // 3/2

// 查询
println(f1.getNumerator())             // 1
println(f1.getDenominator())           // 2
println(f1.toDouble())                 // 0.5
println(f1.toString())                 // "1/2"
println(f1.toProperString())           // "1/2"

// 比较
println(f1.compareTo(f2))             // 1 (大于)
println(f1.equals(f2))                // false

// 静态常量
let zero = Fraction.ZERO               // 0/1
let one = Fraction.ONE                 // 1/1
let half = Fraction.ONE_HALF           // 1/2
```

---

**END OF DESIGN DOCUMENT**
