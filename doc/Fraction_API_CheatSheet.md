# Fraction API 速查表

**版本**: v1.1.0 | **包名**: `commons_lang4cj.math` | **更新**: 2026-01-19

---

## 📦 快速开始

```cangjie
import commons_lang4cj.math.*

// 创建分数
let f1 = Fraction.getFraction(1, 2)  // 1/2
let f2 = Fraction.getFraction(1, 3)  // 1/3

// 运算
let sum = f1.add(f2)  // 5/6
println(sum.toString())  // "5/6"
```

---

## 🏭 工厂方法 (4个)

| 方法 | 参数 | 返回值 | 说明 | 示例 |
|------|------|--------|------|------|
| `getFraction(n, d)` | `n: Int64, d: Int64` | `Fraction` | 创建分数 Y/Z | `getFraction(3, 7)` → 3/7 |
| `getFraction(w, n, d)` | `w: Int64, n: Int64, d: Int64` | `Fraction` | 创建带分数 X Y/Z | `getFraction(1, 3, 7)` → 10/7 |
| `getFraction(n)` | `n: Int64` | `Fraction` | 创建整数 X/1 | `getFraction(5)` → 5/1 |
| `getReducedFraction(n, d)` | `n: Int64, d: Int64` | `Fraction` | 创建约简分数 | `getReducedFraction(2, 4)` → 1/2 |

### ⚠️ 异常

```cangjie
// 分母为零
getFraction(1, 0)  // ❌ 抛出 ArithmeticException

// 带分数规则
getFraction(1, -3, 7)   // ❌ 分子不能为负
getFraction(1, 3, -7)   // ❌ 分母不能为负
getFraction(1, 3, 0)    // ❌ 分母不能为零
```

---

## ➕ 基本运算 (6个)

| 方法 | 参数 | 返回值 | 说明 | 示例 |
|------|------|--------|------|------|
| `add(f)` | `f: Fraction` | `Fraction` | 加法: `this + f` | `1/2 + 1/3` → 5/6 |
| `subtract(f)` | `f: Fraction` | `Fraction` | 减法: `this - f` | `1/2 - 1/3` → 1/6 |
| `multiplyBy(f)` | `f: Fraction` | `Fraction` | 乘法: `this × f` | `1/2 × 2/3` → 1/3 |
| `divideBy(f)` | `f: Fraction` | `Fraction` | 除法: `this ÷ f` | `(1/2) ÷ (1/4)` → 2/1 |
| `negate()` | 无 | `Fraction` | 取反: `-this` | `-(1/2)` → -1/2 |
| `invert()` | 无 | `Fraction` | 倒数: `1/this` | `(1/2)^(-1)` → 2/1 |

### ⚠️ 异常

```cangjie
divideBy(Fraction.ZERO)   // ❌ 抛出 ArithmeticException
invert()                   // ❌ 零无法取倒数
```

---

## 🔢 取整与幂运算 (3个)

| 方法 | 参数 | 返回值 | 说明 | 示例 |
|------|------|--------|------|------|
| `abs()` | 无 | `Fraction` | 绝对值: `\|this\|` | `\|-3/4\|` → 3/4 |
| `pow(n)` | `n: Int64` | `Fraction` | 幂运算: `thisⁿ` | `(2/3)²` → 4/9 |
| `remainder(f)` | `f: Fraction` | `Fraction` | 取余: `this mod f` | `(7/3) mod (2/1)` → 1/3 |

### 示例

```cangjie
let f = Fraction.getFraction(-3, 4)
f.abs()  // 3/4

let f2 = Fraction.getFraction(2, 3)
f2.pow(2)   // 4/9
f2.pow(3)   // 8/27
f2.pow(0)   // 1/1
```

---

## 🔄 类型转换 (5个)

| 方法 | 返回值 | 说明 | 示例 |
|------|--------|------|------|
| `toDouble()` | `Float64` | 转换为双精度浮点数 | `1/2` → 0.5 |
| `toFloat()` | `Float32` | 转换为单精度浮点数 | `1/2` → 0.5 |
| `toInt()` | `Int64` | 转换为整数(截断) | `7/4` → 1 |
| `toIntValue()` | `Int64` | 转换为整数(截断) | `7/4` → 1 |
| `getProperWhole()` | `Int64` | 获取带分数整数部分 | `7/4` → 1 |

### 示例

```cangjie
let f = Fraction.getFraction(7, 4)

f.toDouble()       // 1.75
f.toFloat()        // 1.75
f.toInt()          // 1 (截断小数部分)
f.getProperWhole() // 1 (带分数整数部分)
```

---

## ⚖️ 比较方法 (2个)

| 方法 | 参数 | 返回值 | 说明 | 示例 |
|------|------|--------|------|------|
| `compareTo(f)` | `f: Fraction` | `Int64` | 比较大小 | -1/0/1 |
| `equals(o)` | `o: Option<Fraction>` | `Bool` | 相等性比较 | `true`/`false` |

### compareTo 返回值

```cangjie
// -1: this < f
//  0: this == f
//  1: this > f

let f1 = Fraction.getFraction(1, 2)
let f2 = Fraction.getFraction(1, 3)

f1.compareTo(f2)  // 1 (1/2 > 1/3)
f2.compareTo(f1)  // -1 (1/3 < 1/2)
f1.compareTo(f1)  // 0 (相等)
```

### equals 注意事项

```cangjie
// equals 比较分子分母值,而非数学值
let f1 = Fraction.getFraction(1, 2)
let f2 = Fraction.getFraction(2, 4)

f1.equals(f2)  // false (1/2 ≠ 2/4)
f1.equals(f1)  // true

f1.equals(None)  // false
```

---

## 🔍 查询方法 (7个)

| 方法 | 返回值 | 说明 | 示例 |
|------|--------|------|------|
| `getNumerator()` | `Int64` | 获取分子 | 7/4 → 7 |
| `getDenominator()` | `Int64` | 获取分母 | 7/4 → 4 |
| `getProperNumerator()` | `Int64` | 获取真分数分子 | 7/4 → 3 |
| `getProperWhole()` | `Int64` | 获取整数部分 | 7/4 → 1 |
| `isZero()` | `Bool` | 是否为零 | `0/1` → `true` |
| `isPositive()` | `Bool` | 是否为正 | `3/4` → `true` |
| `isNegative()` | `Bool` | 是否为负 | `-3/4` → `true` |

### 示例

```cangjie
let f = Fraction.getFraction(7, 4)  // 7/4 = 1 又 3/4

f.getNumerator()        // 7 (分子)
f.getDenominator()      // 4 (分母)
f.getProperNumerator()  // 3 (真分数部分: 7 % 4)
f.getProperWhole()      // 1 (整数部分: 7 / 4)

f.isZero()      // false
f.isPositive()  // true
f.isNegative()  // false
```

---

## 📝 字符串方法 (2个)

| 方法 | 返回值 | 说明 | 示例 |
|------|--------|------|------|
| `toString()` | `String` | 假分数字符串 `"a/b"` | `7/4` → `"7/4"` |
| `toProperString()` | `String` | 带分数字符串 `"W n/d"` | `7/4` → `"1 3/4"` |

### 示例

```cangjie
let f1 = Fraction.getFraction(7, 4)   // 7/4 = 1.75
let f2 = Fraction.getFraction(3, 4)   // 3/4 = 0.75
let f3 = Fraction.getFraction(4, 2)   // 4/2 = 2

f1.toString()         // "7/4"
f1.toProperString()   // "1 3/4"

f2.toString()         // "3/4"
f2.toProperString()   // "3/4" (小于1,无整数部分)

f3.toString()         // "4/2"
f3.toProperString()   // "2" (整数)
```

---

## 🔐 哈希方法 (1个)

| 方法 | 返回值 | 说明 | 公式 |
|------|--------|------|------|
| `hashCode()` | `Int64` | 计算哈希码 | `(numerator * 31) + denominator` |

### 示例

```cangjie
let f1 = Fraction.getFraction(1, 2)
let f2 = Fraction.getFraction(1, 2)

f1.hashCode() == f2.hashCode()  // true (相等对象有相等哈希码)
```

---

## 📌 静态常量 (12个)

| 常量 | 值 | 说明 |
|------|-----|------|
| `ZERO` | 0/1 | 零 |
| `ONE` | 1/1 | 一 |
| `ONE_HALF` | 1/2 | 二分之一 |
| `ONE_THIRD` | 1/3 | 三分之一 |
| `TWO_THIRDS` | 2/3 | 三分之二 |
| `ONE_QUARTER` | 1/4 | 四分之一 |
| `TWO_QUARTERS` | 2/4 | 四分之二 (未约简) |
| `THREE_QUARTERS` | 3/4 | 四分之三 |
| `ONE_FIFTH` | 1/5 | 五分之一 |
| `TWO_FIFTHS` | 2/5 | 五分之二 |
| `THREE_FIFTHS` | 3/5 | 五分之三 |
| `FOUR_FIFTHS` | 4/5 | 五分之四 |

### 示例

```cangjie
Fraction.ZERO         // 0/1
Fraction.ONE          // 1/1
Fraction.ONE_HALF     // 1/2
Fraction.TWO_THIRDS   // 2/3
```

---

## 🎯 常用模式

### 创建分数

```cangjie
// 简单分数
let f1 = Fraction.getFraction(3, 7)     // 3/7

// 带分数
let f2 = Fraction.getFraction(1, 3, 7)  // 1 又 3/7 = 10/7

// 整数
let f3 = Fraction.getFraction(5)        // 5/1

// 约简分数
let f4 = Fraction.getReducedFraction(2, 4)  // 1/2

// 静态常量
let f5 = Fraction.ONE_HALF              // 1/2
```

### 四则运算链

```cangjie
let f1 = Fraction.getFraction(1, 2)
let f2 = Fraction.getFraction(1, 3)
let f3 = Fraction.getFraction(1, 6)

// (1/2 + 1/3 - 1/6) × 2
let result = f1.add(f2).subtract(f3).multiplyBy(Fraction.getFraction(2, 1))
println(result.toString())  // "4/3"
```

### 比较

```cangjie
let f1 = Fraction.getFraction(1, 2)
let f2 = Fraction.getFraction(1, 3)

// 方法1: compareTo
if (f1.compareTo(f2) > 0) {
    println("f1 > f2")
}

// 方法2: 直接比较
if (f1.toDouble() > f2.toDouble()) {
    println("f1 > f2")
}
```

### 转换为整数

```cangjie
let f = Fraction.getFraction(7, 4)

// 方法1: toInt() (截断)
let i1 = f.toInt()  // 1

// 方法2: getProperWhole() (整数部分)
let i2 = f.getProperWhole()  // 1

// 方法3: 四舍五入
let i3 = (f.toDouble() + 0.5).toInt()  // 2
```

### 格式化输出

```cangjie
let f = Fraction.getFraction(7, 4)

// 假分数形式
println(f.toString())         // "7/4"

// 带分数形式
println(f.toProperString())   // "1 3/4"

// 小数形式
println(f.toDouble())         // 1.75

// 自定义格式
println("${f.getProperWhole()} 又 ${f.getProperNumerator()}/${f.getDenominator()}")
// "1 又 3/4"
```

---

## ⚠️ 注意事项

### 1. 分母规范化

```cangjie
// 负号始终在分子上
let f = Fraction.getFraction(1, -2)
println(f.getNumerator())    // -1
println(f.getDenominator())  // 2 (分母始终为正)
```

### 2. equals vs compareTo

```cangjie
let f1 = Fraction.getFraction(1, 2)
let f2 = Fraction.getFraction(2, 4)

f1.equals(f2)       // false (分子分母不同)
f1.compareTo(f2)    // 0 (数学值相等)
```

### 3. 数值溢出

```cangjie
// Int64 仍有范围限制,极大数值会溢出
let f1 = Fraction.getFraction(10000000000, 1)
let f2 = Fraction.getFraction(10000000000, 1)
let product = f1.multiplyBy(f2)  // 可能溢出!
```

### 4. 转换精度丢失

```cangjie
// 转换为浮点数可能丢失精度
let f = Fraction.getFraction(1, 3)
f.toDouble()  // 0.333333... (近似值)
```

---

## 📊 性能特征

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

## 🔗 相关资源

- **设计文档**: [Fraction_Design_Document.md](./Fraction_Design_Document.md)
- **实现指南**: [Fraction_Implementation_Guide.md](./Fraction_Implementation_Guide.md)
- **Java 参考**: [Apache Commons Lang Fraction](https://github.com/apache/commons-lang/blob/master/src/main/java/org/apache/commons/lang3/math/Fraction.java)
- **项目主页**: [commons-lang4cj](https://github.com/mumu-xsy/commons-lang4cj)

---

**最后更新**: 2026-01-19 | **版本**: v1.1.0
