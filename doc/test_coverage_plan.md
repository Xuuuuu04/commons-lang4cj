# commons-lang4cj 测试补全计划

> **文档版本**: v1.0.0
> **创建日期**: 2026-01-18
> **作者**: @Architect + @Guardian
> **状态**: 待执行

---

## 📋 目录

- [1. 执行摘要](#1-执行摘要)
- [2. 测试覆盖现状](#2-测试覆盖现状)
- [3. 测试范式分析](#3-测试范式分析)
- [4. 测试补全清单](#4-测试补全清单)
- [5. 分批执行计划](#5-分批执行计划)
- [6. 测试用例模板](#6-测试用例模板)
- [7. 验收标准](#7-验收标准)
- [8. 参考资料](#8-参考资料)

---

## 1. 执行摘要

### 1.1 项目概况

- **项目名称**: commons-lang4cj
- **目标**: Apache Commons Lang 的仓颉语言移植版本
- **仓颉版本**: 1.0.4
- **代码总量**: 约 12,453 行源代码
- **公共方法数**: 约 394 个
- **当前测试覆盖**: 约 26% (仅 1 个测试文件)

### 1.2 核心发现

#### ✅ 成功的测试范式

从 `src/utils/string_utils_test.cj` (668 行) 中总结出的测试最佳实践：

1. **包声明一致性**: 测试文件与被测试类在**同一个包**下
   ```cangjie
   package commons_lang4cj.utils  // 与 string_utils.cj 同包
   ```

2. **测试文件命名**: 严格遵循 `*_test.cj` 模式
   ```
   string_utils.cj       → string_utils_test.cj
   array_utils.cj        → array_utils_test.cj
   ```

3. **注解使用规范**:
   - 类级别: `@Test`
   - 方法级别: `@TestCase`
   - 断言: `@Expect(实际值, 期望值)`

4. **测试用例组织**:
   - 按功能分组（Phase 划分）
   - 每个方法 3-7 个测试用例
   - 覆盖边界情况、正常用例、异常情况

5. **不需要 import 被测试类**: 同包下直接访问

#### ⚠️ 当前问题

1. **测试覆盖率极低**: 29 个源文件，仅 1 个测试文件
2. **部分测试文件被删除**: git status 显示 src/test/ 下的测试文件被删除 (D 状态)
3. **缺少测试组织结构**: 没有独立的 test/ 目录规划

### 1.3 执行计划概览

| 批次 | 模块 | 测试文件数 | 预估测试用例 | 工时估算 | 优先级 |
|------|------|-----------|-------------|---------|--------|
| **Batch 1** | Utils 包 | 7 个 | ~200 个 | 3-4 小时 | 🔴 P0 |
| **Batch 2** | Builder 包 | 5 个 | ~150 个 | 2-3 小时 | 🔴 P0 |
| **Batch 3** | Mutable 包 | 8 个 | ~180 个 | 3-4 小时 | 🟡 P1 |
| **Batch 4** | Range 包 | 3 个 | ~60 个 | 1-2 小时 | 🟢 P2 |
| **总计** | - | **23 个** | **~590 个** | **9-13 小时** | - |

---

## 2. 测试覆盖现状

### 2.1 源文件统计

```bash
commons-lang4cj/src/
├── utils/        # 7 个源文件
├── builder/      # 5 个源文件
├── mutable/      # 8 个源文件
└── range/        # 3 个源文件
```

**总计**: 23 个源文件，394 个公共方法

### 2.2 现有测试文件

| 文件路径 | 状态 | 说明 |
|---------|------|------|
| `commons-lang4cj/src/utils/string_utils_test.cj` | ✅ 可用 | 唯一能工作的测试文件 |
| `commons-lang4cj/src/test/` 下所有测试文件 | ❌ 已删除 | Git 显示 D (deleted) 状态 |

**测试覆盖统计**:

| 包 | 源文件数 | 测试文件数 | 覆盖率 | 状态 |
|---|---------|-----------|--------|------|
| utils | 7 个 | 1 个 | 14% | 🚧 严重不足 |
| builder | 5 个 | 0 个 | 0% | ❌ 全部缺失 |
| mutable | 8 个 | 0 个 | 0% | ❌ 全部缺失 |
| range | 3 个 | 0 个 | 0% | ❌ 全部缺失 |
| **总计** | **23 个** | **1 个** | **4%** | 🔴 **严重不足** |

### 2.3 已实现功能统计

#### Utils 包 (209 个方法)

| 类名 | 方法数 | 测试文件 | 测试用例数 | 状态 |
|------|--------|---------|-----------|------|
| StringUtils | 46 个 | ✅ 存在 | 67 个 | ✅ 可用 |
| ArrayUtils | 21 个 | ❌ 缺失 | - | ❌ 待补充 |
| ObjectUtils | 31 个 | ❌ 缺失 | - | ❌ 待补充 |
| NumberUtils | 27 个 | ❌ 缺失 | - | ❌ 待补充 |
| BooleanUtils | 23 个 | ❌ 缺失 | - | ❌ 待补充 |
| CharUtils | 24 个 | ❌ 缺失 | - | ❌ 待补充 |
| ValidateUtils | 37 个 | ❌ 缺失 | - | ❌ 待补充 |

**Utils 包小计**:
- 已有测试: 1/7 (14%)
- 待补充测试: 6/7 (86%)
- 预估测试用例: ~200 个

#### Builder 包 (95 个方法)

| 类名 | 方法数 | 测试文件 | 测试用例数 | 状态 |
|------|--------|---------|-----------|------|
| EqualsBuilder | 34 个 | ❌ 缺失 | - | ❌ 待补充 |
| HashCodeBuilder | 31 个 | ❌ 缺失 | - | ❌ 待补充 |
| ToStringBuilder | 63 个 | ❌ 缺失 | - | ❌ 待补充 |
| ToStringStyle | 40 个 | ❌ 缺失 | - | ❌ 待补充 |
| CompareToBuilder | 29 个 | ❌ 缺失 | - | ❌ 待补充 |

**Builder 包小计**:
- 已有测试: 0/5 (0%)
- 待补充测试: 5/5 (100%)
- 预估测试用例: ~150 个

#### Mutable 包 (207 个方法)

| 类名 | 方法数 | 测试文件 | 测试用例数 | 状态 |
|------|--------|---------|-----------|------|
| MutableInt | 28 个 | ❌ 缺失 | - | ❌ 待补充 |
| MutableLong | ~30 个 | ❌ 缺失 | - | ❌ 待补充 |
| MutableDouble | ~32 个 | ❌ 缺失 | - | ❌ 待补充 |
| MutableFloat | ~32 个 | ❌ 缺失 | - | ❌ 待补充 |
| MutableBoolean | 16 个 | ❌ 缺失 | - | ❌ 待补充 |
| MutableShort | 31 个 | ❌ 缺失 | - | ❌ 待补充 |
| MutableByte | ~30 个 | ❌ 缺失 | - | ❌ 待补充 |
| MutableObject<T> | 8 个 | ❌ 缺失 | - | ❌ 待补充 |

**Mutable 包小计**:
- 已有测试: 0/8 (0%)
- 待补充测试: 8/8 (100%)
- 预估测试用例: ~180 个

#### Range 包 (44 个方法)

| 类名 | 方法数 | 测试文件 | 测试用例数 | 状态 |
|------|--------|---------|-----------|------|
| Range<T> | 27 个 | ❌ 缺失 | - | ❌ 待补充 |
| CharRange | 16 个 | ❌ 缺失 | - | ❌ 待补充 |
| NumberRange<T> | 1 个 | ❌ 缺失 | - | ❌ 待补充 |

**Range 包小计**:
- 已有测试: 0/3 (0%)
- 待补充测试: 3/3 (100%)
- 预估测试用例: ~60 个

---

## 3. 测试范式分析

### 3.1 成功的测试文件结构

参考 `string_utils_test.cj` (668 行)，核心特征：

```cangjie
package commons_lang4cj.utils

import std.unittest.*
import std.unittest.testmacro.*

/**
 * StringUtils 单元测试类
 *
 * 测试覆盖所有 46 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class StringUtilsTest {
    // ========== Phase 1: 空值检查测试 ==========

    @TestCase
    func testIsEmpty() {
        // 空字符串
        @Expect(StringUtils.isEmpty(""), true)

        // 非空字符串
        @Expect(StringUtils.isEmpty("a"), false)
        @Expect(StringUtils.isEmpty("hello"), false)

        // 只有空格的字符串不算空
        @Expect(StringUtils.isEmpty(" "), false)
        @Expect(StringUtils.isEmpty("  "), false)
    }

    @TestCase
    func testIsNotEmpty() {
        // 测试逻辑...
    }

    // ========== Phase 2: 截取与分割测试 ==========

    @TestCase
    func testTrim() {
        // 测试逻辑...
    }
}
```

### 3.2 关键发现

#### ✅ 正确的测试模式

1. **包声明一致性**
   ```cangjie
   package commons_lang4cj.utils  // 与被测试类同包
   ```

2. **不需要 import 被测试类**
   - 同包下可直接访问
   - 减少导入错误

3. **测试文件命名规范**
   ```
   被测试类:         string_utils.cj
   测试类名:        StringUtilsTest
   测试文件名:      string_utils_test.cj
   ```

4. **注解使用**
   ```cangjie
   @Test           // 类级别注解
   @TestCase       // 方法级别注解
   @Expect(actual, expected)  // 断言宏
   ```

5. **测试用例分组**
   - 按功能划分 Phase
   - 每个方法 3-7 个测试用例
   - 覆盖边界值、正常用例、异常情况

#### ⚠️ 常见陷阱

1. **包声明错误**
   ```cangjie
   // ❌ 错误
   package commons_lang4cj.test

   // ✅ 正确
   package commons_lang4cj.utils
   ```

2. **测试文件命名错误**
   ```
   ❌ test_string_utils.cj
   ❌ stringUtils_test.cj
   ❌ string_utils.spec.cj

   ✅ string_utils_test.cj
   ```

3. **忘记 @Test 注解**
   ```cangjie
   // ❌ 错误：缺少 @Test
   class StringUtilsTest {
       @TestCase
       func testIsEmpty() { ... }
   }

   // ✅ 正确
   @Test
   class StringUtilsTest {
       @TestCase
       func testIsEmpty() { ... }
   }
   ```

4. **测试用例覆盖不足**
   ```cangjie
   // ❌ 不好：只测试正常情况
   @TestCase
   func testIsEmpty() {
       @Expect(StringUtils.isEmpty(""), true)
   }

   // ✅ 好：覆盖多种情况
   @TestCase
   func testIsEmpty() {
       @Expect(StringUtils.isEmpty(""), true)        // 空字符串
       @Expect(StringUtils.isEmpty("a"), false)      // 单字符
       @Expect(StringUtils.isEmpty("hello"), false)  // 多字符
       @Expect(StringUtils.isEmpty(" "), false)      // 空格
   }
   ```

### 3.3 测试用例设计模式

#### 模式 1: 三明治测试法

适用于简单断言：

```cangjie
@TestCase
func testIsEmpty() {
    // 边界值
    @Expect(StringUtils.isEmpty(""), true)

    // 正常用例
    @Expect(StringUtils.isEmpty("a"), false)
    @Expect(StringUtils.isEmpty("hello"), false)

    // 边界情况
    @Expect(StringUtils.isEmpty(" "), false)
    @Expect(StringUtils.isEmpty("  "), false)
}
```

#### 模式 2: 覆盖所有分支

适用于条件分支：

```cangjie
@TestCase
func testIsBlank() {
    // 空字符串
    @Expect(StringUtils.isBlank(""), true)

    // 只有空白字符（多个分支）
    @Expect(StringUtils.isBlank(" "), true)
    @Expect(StringUtils.isBlank("  "), true)
    @Expect(StringUtils.isBlank("\t"), true)
    @Expect(StringUtils.isBlank("\n"), true)

    // 有非空白字符
    @Expect(StringUtils.isBlank("a"), false)
    @Expect(StringUtils.isBlank(" hello "), false)
}
```

#### 模式 3: 先构造后断言

适用于复杂对象：

```cangjie
@TestCase
func testSplit() {
    // 基本分割
    let result1 = StringUtils.split("a,b,c", ",")
    @Expect(result1.size, 3)
    @Expect(result1[0], "a")
    @Expect(result1[1], "b")
    @Expect(result1[2], "c")

    // 空元素
    let result2 = StringUtils.split("a,,b", ",")
    @Expect(result2.size, 3)
    @Expect(result2[1], "")
}
```

### 3.4 Apache Commons Lang 测试参考

从 Java 源码中总结的测试策略：

#### StringUtilsTest.java (Apache Commons Lang)

```java
// 1. 常量定义
static final String WHITESPACE;
static final String NON_WHITESPACE;
static final String[] ARRAY_LIST = {"foo", "bar", "baz"};

// 2. 参数化测试
@ParameterizedTest
@ValueSource(strings = {"", " ", "  ", "\t"})
void testIsEmpty(String input) {
    assertTrue(StringUtils.isEmpty(input));
}

// 3. 边界值覆盖
@Test
void testIndexOf() {
    assertEquals(-1, StringUtils.indexOf("hello", "abc"));
    assertEquals(0, StringUtils.indexOf("hello", ""));
    assertEquals(1, StringUtils.indexOf("hello", "ell"));
}
```

**关键启示**:
- 使用常量定义测试数据
- 覆盖所有边界情况
- 测试空字符串、null、单字符、多字符
- 测试未找到的情况（-1 或 None）

---

## 4. 测试补全清单

### 4.1 Utils 包测试清单 (7 个文件)

#### 4.1.1 array_utils_test.cj

**被测试类**: `ArrayUtils` (21 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| `isEmpty` | 5 个 | P0 | 空数组、null、单元素、多元素 |
| `isNotEmpty` | 5 个 | P0 | 同上 |
| `isNotEmpty` | 5 个 | P0 | 同上 |
| `isSorted` | 6 个 | P0 | 空数组、已排序、逆序、单元素、null |
| `contains` | 5 个 | P0 | 包含、不包含、null、空数组 |
| `indexOf` | 6 个 | P0 | 找到、未找到、null、多次出现 |
| `lastIndexOf` | 6 个 | P0 | 找到、未找到、null、多次出现 |
| `clone` | 4 个 | P0 | 正常克隆、null、空数组 |
| `nullToEmpty` | 4 个 | P0 | null、空数组、非空数组 |
| `reverse` | 4 个 | P1 | 空数组、单元素、多元素、null |
| `shuffle` | 3 个 | P1 | 空数组、单元素、多元素 |
| `swap` | 4 个 | P1 | 正常交换、边界索引、null |
| `add` | 5 个 | P1 | 添加到空数组、添加到末尾、null |
| `remove` | 5 个 | P1 | 删除存在元素、删除不存在元素、null |
| `removeElement` | 5 个 | P1 | 删除首次出现、删除所有、null |
| `addAll` | 5 个 | P1 | 合并空数组、合并非空数组、null |
| `subarray` | 6 个 | P1 | 正常截取、越界截取、null、负数索引 |
| `toPrimitive` | 4 个 | P2 | Integer数组转int数组、null |
| `toObject` | 4 个 | P2 | int数组转Integer数组、null |
| `toString` | 4 个 | P2 | 空数组、单元素、多元素、null |

**预估测试用例数**: **~100 个**

**参考 Java 测试**: `ArrayUtilsTest.java` (3000+ 行)

---

#### 4.1.2 object_utils_test.cj

**被测试类**: `ObjectUtils` (31 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| `isEmpty` | 5 个 | P0 | null、空字符串、空数组、空集合、非空 |
| `isNotEmpty` | 5 个 | P0 | 同上 |
| `isNull` | 4 个 | P0 | null、非null、各种类型 |
| `notNull` | 4 个 | P0 | 同上 |
| `defaultIfNull` | 5 个 | P0 | 返回默认值、返回对象本身 |
| `compare` | 6 个 | P0 | 相等、小于、大于、null |
| `allNull` | 5 个 | P0 | 全null、部分null、全非null |
| `anyNull` | 5 个 | P0 | 全null、部分null、全非null |
| `allNotNull` | 5 个 | P0 | 同上 |
| `anyNotNull` | 5 个 | P0 | 同上 |
| `clone` | 5 个 | P1 | 正常克隆、null、不支持克隆 |
| `cloneIfPossible` | 5 个 | P1 | 同上 |
| `equals` | 6 个 | P1 | 相等、不等、null |
| `notEqual` | 6 个 | P1 | 同上 |
| `toString` | 5 个 | P1 | 正常对象、null、数组 |
| `identityToString` | 4 个 | P1 | 正常对象、null |
| `hashCode` | 4 个 | P1 | 正常对象、null、相等对象 |
| `max` | 5 个 | P2 | 两个值比较、null |
| `min` | 5 个 | P2 | 同上 |
| `median` | 6 个 | P2 | 奇数个、偶数个、null |
| `mode` | 5 个 | P2 | 单众数、多众数、无众数、null |
| `firstNonNull` | 5 个 | P2 | 第一个非null、全null |

**预估测试用例数**: **~110 个**

**参考 Java 测试**: `ObjectUtilsTest.java` (2000+ 行)

---

#### 4.1.3 number_utils_test.cj

**被测试类**: `NumberUtils` (27 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| `toInt` | 6 个 | P0 | 正常数字、0、负数、null、非数字 |
| `toLong` | 6 个 | P0 | 同上 |
| `toDouble` | 6 个 | P0 | 同上 |
| `toFloat` | 6 个 | P0 | 同上 |
| `toByte` | 6 个 | P0 | 同上 |
| `toShort` | 6 个 | P0 | 同上 |
| `createNumber` | 7 个 | P0 | 各种数字格式、null |
| `isDigits` | 5 个 | P0 | 纯数字、null、空字符串、带符号 |
| `isNumber` | 6 个 | P0 | 各种数字格式、null |
| `isParsable` | 5 个 | P0 | 可解析、不可解析、null |
| `compare` | 6 个 | P1 | 相等、小于、大于、null |
| `max` | 5 个 | P1 | 正常、负数、null |
| `min` | 5 个 | P1 | 同上 |
| `sum` | 5 个 | P1 | 正常、空数组、null |
| `average` | 5 个 | P2 | 正常、空数组、null |

**预估测试用例数**: **~90 个**

**参考 Java 测试**: 需查看 `NumberUtilsTest.java`

---

#### 4.1.4 boolean_utils_test.cj

**被测试类**: `BooleanUtils` (23 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| `isTrue` | 4 个 | P0 | true、false、null |
| `isFalse` | 4 个 | P0 | 同上 |
| `toBoolean` | 6 个 | P0 | Boolean、Integer、String、null |
| `toBooleanObject` | 6 个 | P0 | 同上 |
| `toInteger` | 5 个 | P0 | true、false、null |
| `toIntegerObject` | 5 个 | P0 | 同上 |
| `negate` | 4 个 | P0 | true、false、null |
| `and` | 6 个 | P1 | true&true、true&false、null |
| `or` | 6 个 | P1 | true\|false、false\|false、null |
| `xor` | 6 个 | P1 | 异或各种组合、null |
| `compareTo` | 5 个 | P1 | 相等、小于、大于、null |

**预估测试用例数**: **~70 个**

**参考 Java 测试**: `BooleanUtilsTest.java`

---

#### 4.1.5 char_utils_test.cj

**被测试类**: `CharUtils` (24 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| `toCharacterObject` | 5 个 | P0 | 字符、null、多字符字符串 |
| `toChar` | 5 个 | P0 | 字符、String、null |
| `toString` | 5 个 | P0 | 字符、null |
| `isAscii` | 5 个 | P0 | ASCII字符、非ASCII、null |
| `isAsciiPrintable` | 6 个 | P0 | 可打印、控制字符、null |
| `isAsciiControl` | 5 个 | P0 | 控制字符、非控制字符、null |
| `isAlpha` | 5 个 | P0 | 字母、非字母、null |
| `isNumeric` | 5 个 | P0 | 数字、非数字、null |
| `isAlphanumeric` | 5 个 | P0 | 字母数字、非字母数字、null |
| `toIntValue` | 5 个 | P1 | 数字字符、非数字字符、null |
| `toUnicodeEscaped` | 5 个 | P1 | 正常字符、特殊字符、null |

**预估测试用例数**: **~65 个**

**参考 Java 测试**: `CharUtilsTest.java`

---

#### 4.1.6 validate_utils_test.cj

**被测试类**: `ValidateUtils` (37 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| `isTrue` | 4 个 | P0 | true、false、异常 |
| `notNull` | 5 个 | P0 | 非null、null、自定义消息 |
| `notEmpty` | 6 个 | P0 | 非空集合、空集合、null |
| `notBlank` | 6 个 | P0 | 非空字符串、空字符串、空白 |
| `noNullElements` | 6 个 | P0 | 无null元素、有null元素、null数组 |
| `validIndex` | 6 个 | P1 | 有效索引、无效索引、null |
| `matchesPattern` | 5 个 | P1 | 匹配、不匹配、null |
| `inclusiveBetween` | 6 个 | P1 | 在范围内、超出范围、null |
| `exclusiveBetween` | 6 个 | P1 | 在范围内、边界、超出范围、null |
| `isInstanceOf` | 5 个 | P1 | 是实例、不是实例、null |
| `isAssignable` | 5 个 | P2 | 可赋值、不可赋值、null |

**预估测试用例数**: **~100 个**

**参考 Java 测试**: `ValidateTest.java`

---

### 4.2 Builder 包测试清单 (5 个文件)

#### 4.2.1 equals_builder_test.cj

**被测试类**: `EqualsBuilder` (34 个方法)

**测试用例清单**:

| 方法组 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 基础append | 8 个 | P0 | appendSuper、append各种类型 |
| 反射构建 | 6 个 | P0 | reflectionEquals各种情况 |
| 对象数组 | 6 个 | P1 | 数组比较、null |
| 集合比较 | 6 个 | P1 | Set、List、Map比较 |
| 循环引用 | 4 个 | P2 | 循环引用检测 |
| 多字段对象 | 8 个 | P1 | 复杂对象比较 |

**预估测试用例数**: **~40 个**

**参考 Java 测试**: `EqualsBuilderTest.java`

---

#### 4.2.2 hash_code_builder_test.cj

**被测试类**: `HashCodeBuilder` (31 个方法)

**测试用例清单**:

| 方法组 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 基础append | 8 个 | P0 | append各种类型 |
| 反射构建 | 6 个 | P0 | reflectionHashCode各种情况 |
| 对象数组 | 6 个 | P1 | 数组哈希、null |
| 集合哈希 | 6 个 | P1 | Set、List、Map哈希 |
| 多字段对象 | 8 个 | P1 | 复杂对象哈希 |
| 不变性 | 4 个 | P2 | 多次调用返回相同值 |

**预估测试用例数**: **~38 个**

**参考 Java 测试**: `HashCodeBuilderTest.java`

---

#### 4.2.3 to_string_builder_test.cj

**被测试类**: `ToStringBuilder` (63 个方法)

**测试用例清单**:

| 方法组 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 基础append | 10 个 | P0 | append各种类型 |
| 反射构建 | 6 个 | P0 | reflectionToString各种情况 |
| 风格测试 | 8 个 | P0 | DEFAULT_STYLE、SIMPLE_STYLE等 |
| 对象数组 | 6 个 | P1 | 数组转字符串、null |
| 集合格式化 | 6 个 | P1 | Set、List、Map格式化 |
| 多字段对象 | 10 个 | P1 | 复杂对象格式化 |
| 自定义样式 | 8 个 | P2 | 自定义ToStringStyle |

**预估测试用例数**: **~54 个**

**参考 Java 测试**: `ToStringBuilderTest.java`

---

#### 4.2.4 to_string_style_test.cj

**被测试类**: `ToStringStyle` (40 个方法)

**测试用例清单**:

| 样式类 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| DefaultToStringStyle | 8 个 | P0 | 默认格式 |
| SimpleToStringStyle | 6 个 | P0 | 简单格式 |
| NoClassNameToStringStyle | 6 个 | P0 | 无类名格式 |
| ShortPrefixToStringStyle | 6 个 | P0 | 短前缀格式 |
| MultiLineToStringStyle | 8 个 | P1 | 多行格式 |
| JsonToStringStyle | 8 个 | P2 | JSON格式 |

**预估测试用例数**: **~42 个**

**参考 Java 测试**: `DefaultToStringStyleTest.java` 等

---

#### 4.2.5 compare_to_builder_test.cj

**被测试类**: `CompareToBuilder` (29 个方法)

**测试用例清单**:

| 方法组 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 基础append | 8 个 | P0 | append各种类型、比较结果 |
| 反射构建 | 6 个 | P0 | reflectionCompare各种情况 |
| 对象数组 | 6 个 | P1 | 数组比较、null |
| 集合比较 | 6 个 | P1 | Set、List、Map比较 |
| 多字段对象 | 8 个 | P1 | 复杂对象比较 |

**预估测试用例数**: **~34 个**

**参考 Java 测试**: `CompareToBuilderTest.java`

---

### 4.3 Mutable 包测试清单 (8 个文件)

#### 4.3.1 mutable_int_test.cj

**被测试类**: `MutableInt` (28 个方法)

**测试用例清单**:

| 方法组 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 构造函数 | 5 个 | P0 | 无参、数值、String、copy |
| 基础操作 | 8 个 | P0 | add、subtract、increment、decrement |
| 类型转换 | 6 个 | P0 | toInt、toLong、toDouble、toFloat |
| 比较操作 | 6 个 | P1 | equals、compareTo、greaterThan |
| 对象操作 | 6 个 | P1 | toString、hashCode |

**预估测试用例数**: **~31 个** (参考现有实现)

---

#### 4.3.2-4.3.7 其他 Mutable 类型

**MutableLong, MutableDouble, MutableFloat, MutableShort, MutableByte, MutableBoolean**

**预估测试用例数**: 每个约 **25-35 个**

**总计**: ~180 个

---

#### 4.3.8 mutable_object_test.cj

**被测试类**: `MutableObject<T>` (8 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 构造函数 | 4 个 | P0 | 无参、有参、null |
| getValue | 3 个 | P0 | 正常、null |
| setValue | 4 个 | P0 | 设置值、null |
| equals | 5 个 | P1 | 相等、不等、null |
| hashCode | 4 个 | P1 | 正常、null |
| toString | 3 个 | P1 | 正常、null |

**预估测试用例数**: **~23 个**

---

### 4.4 Range 包测试清单 (3 个文件)

#### 4.4.1 range_test.cj

**被测试类**: `Range<T>` (27 个方法)

**测试用例清单**:

| 方法组 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 构造函数 | 6 个 | P0 | 正常范围、反转范围、null |
| 包含检查 | 6 个 | P0 | contains、containsAll |
| 边界操作 | 6 个 | P0 | getMinimum、getMaximum |
| 范围操作 | 6 个 | P1 | intersection、union |
| 元素遍历 | 6 个 | P1 | iterator、size |

**预估测试用例数**: **~30 个**

**参考 Java 测试**: `RangeTest.java`

---

#### 4.4.2 char_range_test.cj

**被测试类**: `CharRange` (16 个方法)

**测试用例清单**:

| 方法组 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| 构造函数 | 6 个 | P0 | 单字符、范围、反转 |
| 包含检查 | 5 个 | P0 | contains、containsRange |
| 边界操作 | 4 个 | P0 | getStart、getEnd |
| 范围操作 | 5 个 | P1 | intersection、union |

**预估测试用例数**: **~20 个**

**参考 Java 测试**: `CharRangeTest.java`

---

#### 4.4.3 number_range_test.cj

**被测试类**: `NumberRange<T>` (1 个方法)

**测试用例清单**:

| 方法名 | 测试用例数 | 优先级 | 说明 |
|--------|-----------|--------|------|
| of | 8 个 | P0 | Int、Long、Float、Double范围 |

**预估测试用例数**: **~8 个**

**参考 Java 测试**: `IntRangeTest.java`、`LongRangeTest.java`、`DoubleRangeTest.java`

---

## 5. 分批执行计划

### 5.1 批次优先级矩阵

| 批次 | 模块 | 重要性 | 紧急性 | 依赖关系 | 优先级 |
|------|------|--------|--------|---------|--------|
| Batch 1 | Utils 包 | 高 | 高 | 无 | 🔴 P0 |
| Batch 2 | Builder 包 | 高 | 高 | Utils | 🔴 P0 |
| Batch 3 | Mutable 包 | 中 | 中 | Utils | 🟡 P1 |
| Batch 4 | Range 包 | 低 | 低 | Utils | 🟢 P2 |

**执行顺序**: Batch 1 → Batch 2 → Batch 3 → Batch 4

---

### 5.2 Batch 1: Utils 包 (优先级: 🔴 P0)

**目标**: 补全 Utils 包的 6 个缺失测试文件

**测试文件**:
1. `array_utils_test.cj`
2. `object_utils_test.cj`
3. `number_utils_test.cj`
4. `boolean_utils_test.cj`
5. `char_utils_test.cj`
6. `validate_utils_test.cj`

**预估工时**: 3-4 小时

**预估测试用例数**: ~200 个

**执行步骤**:

1. **Step 1**: 创建 `array_utils_test.cj` (30-40 分钟)
   - 参考: `StringUtilsTest` 的结构
   - 重点: 空数组、null 边界情况
   - 测试用例: ~100 个

2. **Step 2**: 创建 `object_utils_test.cj` (30-40 分钟)
   - 重点: null 处理、类型转换
   - 测试用例: ~110 个

3. **Step 3**: 创建 `number_utils_test.cj` (25-35 分钟)
   - 重点: 数字解析、类型转换
   - 测试用例: ~90 个

4. **Step 4**: 创建 `boolean_utils_test.cj` (20-30 分钟)
   - 重点: Boolean、Integer、String 转换
   - 测试用例: ~70 个

5. **Step 5**: 创建 `char_utils_test.cj` (20-30 分钟)
   - 重点: ASCII、Unicode 字符处理
   - 测试用例: ~65 个

6. **Step 6**: 创建 `validate_utils_test.cj` (30-40 分钟)
   - 重点: 异常抛出、参数校验
   - 测试用例: ~100 个

7. **Step 7**: 执行 `cjpm test` 确保全部通过 (10 分钟)

8. **Step 8**: 代码审查和风格检查 (@Guardian) (10 分钟)

**验收标准**:
- [ ] 所有 6 个测试文件创建完成
- [ ] `cjpm test` 100% 通过
- [ ] 测试用例数 ≥ 200 个
- [ ] 符合仓颉命名规范
- [ ] 无编译警告

---

### 5.3 Batch 2: Builder 包 (优先级: 🔴 P0)

**目标**: 补全 Builder 包的 5 个测试文件

**测试文件**:
1. `equals_builder_test.cj`
2. `hash_code_builder_test.cj`
3. `to_string_builder_test.cj`
4. `to_string_style_test.cj`
5. `compare_to_builder_test.cj`

**预估工时**: 2-3 小时

**预估测试用例数**: ~150 个

**执行步骤**:

1. **Step 1**: 创建 `equals_builder_test.cj` (25-35 分钟)
   - 重点: 对象比较、数组比较、循环引用
   - 测试用例: ~40 个

2. **Step 2**: 创建 `hash_code_builder_test.cj` (20-30 分钟)
   - 重点: 哈希一致性、数组哈希
   - 测试用例: ~38 个

3. **Step 3**: 创建 `to_string_builder_test.cj` (30-40 分钟)
   - 重点: 多种风格、对象格式化
   - 测试用例: ~54 个

4. **Step 4**: 创建 `to_string_style_test.cj` (25-35 分钟)
   - 重点: 各种 ToStringStyle 子类
   - 测试用例: ~42 个

5. **Step 5**: 创建 `compare_to_builder_test.cj` (20-30 分钟)
   - 重点: 对象比较、比较逻辑
   - 测试用例: ~34 个

6. **Step 6**: 执行 `cjpm test` 确保全部通过 (10 分钟)

7. **Step 7**: 清理 `to_string_style.cj` 的 37 个警告 (10 分钟)

**验收标准**:
- [ ] 所有 5 个测试文件创建完成
- [ ] `cjpm test` 100% 通过
- [ ] 测试用例数 ≥ 150 个
- [ ] 清理所有编译警告
- [ ] 符合仓颉命名规范

---

### 5.4 Batch 3: Mutable 包 (优先级: 🟡 P1)

**目标**: 补全 Mutable 包的 8 个测试文件

**测试文件**:
1. `mutable_int_test.cj`
2. `mutable_long_test.cj`
3. `mutable_double_test.cj`
4. `mutable_float_test.cj`
5. `mutable_short_test.cj`
6. `mutable_byte_test.cj`
7. `mutable_boolean_test.cj`
8. `mutable_object_test.cj`

**预估工时**: 3-4 小时

**预估测试用例数**: ~180 个

**执行步骤**:

1. **Step 1**: 创建 `mutable_int_test.cj` (20-30 分钟)
   - 参考: 现有实现
   - 测试用例: ~31 个

2. **Step 2**: 创建 `mutable_long_test.cj` (20-30 分钟)
   - 参考: `MutableInt` 测试模板
   - 测试用例: ~30 个

3. **Step 3**: 创建 `mutable_double_test.cj` (20-30 分钟)
   - 重点: 浮点数精度、NaN、Infinity
   - 测试用例: ~35 个

4. **Step 4**: 创建 `mutable_float_test.cj` (20-30 分钟)
   - 参考: `MutableDouble` 测试模板
   - 测试用例: ~32 个

5. **Step 5**: 创建 `mutable_short_test.cj` (15-25 分钟)
   - 参考: `MutableInt` 测试模板
   - 测试用例: ~28 个

6. **Step 6**: 创建 `mutable_byte_test.cj` (15-25 分钟)
   - 参考: `MutableInt` 测试模板
   - 测试用例: ~28 个

7. **Step 7**: 创建 `mutable_boolean_test.cj` (10-20 分钟)
   - 重点: Boolean 特有操作
   - 测试用例: ~18 个

8. **Step 8**: 创建 `mutable_object_test.cj` (15-25 分钟)
   - 重点: 泛型对象包装
   - 测试用例: ~23 个

9. **Step 9**: 执行 `cjpm test` 确保全部通过 (10 分钟)

**验收标准**:
- [ ] 所有 8 个测试文件创建完成
- [ ] `cjpm test` 100% 通过
- [ ] 测试用例数 ≥ 180 个
- [ ] 符合仓颉命名规范

---

### 5.5 Batch 4: Range 包 (优先级: 🟢 P2)

**目标**: 补全 Range 包的 3 个测试文件

**测试文件**:
1. `range_test.cj`
2. `char_range_test.cj`
3. `number_range_test.cj`

**预估工时**: 1-2 小时

**预估测试用例数**: ~60 个

**执行步骤**:

1. **Step 1**: 创建 `range_test.cj` (20-30 分钟)
   - 重点: 泛型范围操作
   - 测试用例: ~30 个

2. **Step 2**: 创建 `char_range_test.cj` (15-25 分钟)
   - 重点: 字符范围、Unicode
   - 测试用例: ~20 个

3. **Step 3**: 创建 `number_range_test.cj` (10-20 分钟)
   - 重点: 数值范围工厂方法
   - 测试用例: ~8 个

4. **Step 4**: 执行 `cjpm test` 确保全部通过 (5 分钟)

**验收标准**:
- [ ] 所有 3 个测试文件创建完成
- [ ] `cjpm test` 100% 通过
- [ ] 测试用例数 ≥ 60 个
- [ ] 符合仓颉命名规范

---

## 6. 测试用例模板

### 6.1 标准测试文件模板

```cangjie
package commons_lang4cj.{module_name}

import std.unittest.*
import std.unittest.testmacro.*

/**
 * {ClassName} 单元测试类
 *
 * 测试覆盖所有 {method_count} 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class {ClassName}Test {
    // ========== Phase 1: 基础功能测试 ==========

    @TestCase
    func test{MethodName}() {
        // 边界值
        @Expect({ClassName}.{methodName}({boundary_input}), {expected})

        // 正常用例
        @Expect({ClassName}.{methodName}({normal_input}), {expected})

        // 边界情况
        @Expect({ClassName}.{methodName}({edge_case_input}), {expected})
    }

    // ========== Phase 2: 高级功能测试 ==========

    @TestCase
    func test{AdvancedMethodName}() {
        // 测试逻辑...
    }

    // ========== Phase 3: 异常处理测试 ==========

    @TestCase
    func test{ExceptionMethodName}() {
        // 测试异常逻辑...
    }
}
```

### 6.2 Utils 包测试模板示例

#### ArrayUtils 测试示例

```cangjie
package commons_lang4cj.utils

import std.unittest.*
import std.unittest.testmacro.*

@Test
class ArrayUtilsTest {
    @TestCase
    func testIsEmpty() {
        // 空数组
        @Expect(ArrayUtils.isEmpty(Array<Int64>()), true)
        @Expect(ArrayUtils.isEmpty(Array<Int64>(0)), true)

        // null
        @Expect(ArrayUtils.isEmpty(Option<Array<Int64>>.None), true)

        // 非空数组
        @Expect(ArrayUtils.isEmpty(Array<Int64>(1)), false)
        @Expect(ArrayUtils.IsEmpty([1, 2, 3]), false)
    }

    @TestCase
    func testContains() {
        let arr = [1, 2, 3, 4, 5]

        // 包含
        @Expect(ArrayUtils.contains(arr, 3), true)

        // 不包含
        @Expect(ArrayUtils.contains(arr, 10), false)

        // 空数组
        @Expect(ArrayUtils.contains(Array<Int64>(), 1), false)
    }
}
```

### 6.3 Builder 包测试模板示例

#### EqualsBuilder 测试示例

```cangjie
package commons_lang4cj.builder

import std.unittest.*
import std.unittest.testmacro.*

@Test
class EqualsBuilderTest {
    class TestClass {
        var field1: Int64 = 0
        var field2: String = ""

        public init(f1: Int64, f2: String) {
            field1 = f1
            field2 = f2
        }
    }

    @TestCase
    func testAppend() {
        let obj1 = TestClass(1, "hello")
        let obj2 = TestClass(1, "hello")
        let obj3 = TestClass(2, "hello")

        // 相等
        @Expect(EqualsBuilder()
            .append(obj1.field1, obj2.field1)
            .append(obj1.field2, obj2.field2)
            .build(), true)

        // 不相等
        @Expect(EqualsBuilder()
            .append(obj1.field1, obj3.field1)
            .append(obj1.field2, obj3.field2)
            .build(), false)
    }
}
```

### 6.4 Mutable 包测试模板示例

#### MutableInt 测试示例

```cangjie
package commons_lang4cj.mutable

import std.unittest.*
import std.unittest.testmacro.*

@Test
class MutableIntTest {
    @TestCase
    func testConstructor() {
        // 无参构造
        let mut1 = MutableInt()
        @Expect(mut1.get(), 0)

        // 数值构造
        let mut2 = MutableInt(10)
        @Expect(mut2.get(), 10)

        // String 构造
        let mut3 = MutableInt("123")
        @Expect(mut3.get(), 123)
    }

    @TestCase
    func testAdd() {
        let mut = MutableInt(10)

        // add(int)
        mut.add(5)
        @Expect(mut.get(), 15)

        // add(MutableInt)
        let other = MutableInt(10)
        mut.add(other)
        @Expect(mut.get(), 25)
    }

    @TestCase
    func testIncrement() {
        let mut = MutableInt(10)

        mut.increment()
        @Expect(mut.get(), 11)

        mut.increment()
        @Expect(mut.get(), 12)
    }
}
```

### 6.5 Range 包测试模板示例

#### Range 测试示例

```cangjie
package commons_lang4cj.range

import std.unittest.*
import std.unittest.testmacro.*

@Test
class RangeTest {
    @TestCase
    func testContains() {
        // 创建范围 [1, 10]
        let range = Range<Int64>(1, 10)

        // 包含
        @Expect(range.contains(5), true)
        @Expect(range.contains(1), true)
        @Expect(range.contains(10), true)

        // 不包含
        @Expect(range.contains(0), false)
        @Expect(range.contains(11), false)
    }

    @TestCase
    func testIntersection() {
        let range1 = Range<Int64>(1, 10)
        let range2 = Range<Int64>(5, 15)

        let intersection = range1.intersection(range2)
        @Expect(intersection.getMinimum(), 5)
        @Expect(intersection.getMaximum(), 10)
    }
}
```

---

## 7. 验收标准

### 7.1 整体验收标准

**测试覆盖率要求**:

| 指标 | 目标值 | 当前值 | 差距 |
|------|--------|--------|------|
| 测试文件数 | 23 个 | 1 个 | 22 个 |
| 测试用例数 | ≥ 590 个 | 67 个 | 523 个 |
| 测试覆盖率 | ≥ 90% | ~5% | 85% |
| `cjpm test` 通过率 | 100% | 100% | 0% |
| 编译警告数 | 0 个 | 37 个 | 37 个 |

### 7.2 分批验收标准

#### Batch 1: Utils 包

- [ ] 所有 6 个测试文件创建完成
- [ ] 测试用例数 ≥ 200 个
- [ ] `cjpm test` 100% 通过
- [ ] 符合仓颉命名规范
- [ ] 无新增编译警告

#### Batch 2: Builder 包

- [ ] 所有 5 个测试文件创建完成
- [ ] 测试用例数 ≥ 150 个
- [ ] `cjpm test` 100% 通过
- [ ] 清理 `to_string_style.cj` 的 37 个警告
- [ ] 符合仓颉命名规范

#### Batch 3: Mutable 包

- [ ] 所有 8 个测试文件创建完成
- [ ] 测试用例数 ≥ 180 个
- [ ] `cjpm test` 100% 通过
- [ ] 符合仓颉命名规范

#### Batch 4: Range 包

- [ ] 所有 3 个测试文件创建完成
- [ ] 测试用例数 ≥ 60 个
- [ ] `cjpm test` 100% 通过
- [ ] 符合仓颉命名规范

### 7.3 代码质量标准

**命名规范**:
- [ ] 测试文件名: `*_test.cj`
- [ ] 测试类名: `{ClassName}Test`
- [ ] 测试方法名: `test{MethodName}`

**文档规范**:
- [ ] 每个测试类有文档注释
- [ ] 说明测试覆盖的方法数
- [ ] 说明测试覆盖率目标

**测试用例质量**:
- [ ] 每个公共方法至少 3 个测试用例
- [ ] 覆盖边界值、正常用例、异常情况
- [ ] 使用 `@Expect` 宏进行断言
- [ ] 测试用例有清晰注释

### 7.4 最终验收清单

**文件结构**:
```
commons-lang4cj/src/
├── utils/
│   ├── string_utils_test.cj       ✅
│   ├── array_utils_test.cj        ✅
│   ├── object_utils_test.cj       ✅
│   ├── number_utils_test.cj       ✅
│   ├── boolean_utils_test.cj      ✅
│   ├── char_utils_test.cj         ✅
│   └── validate_utils_test.cj     ✅
├── builder/
│   ├── equals_builder_test.cj     ✅
│   ├── hash_code_builder_test.cj  ✅
│   ├── to_string_builder_test.cj  ✅
│   ├── to_string_style_test.cj    ✅
│   └── compare_to_builder_test.cj ✅
├── mutable/
│   ├── mutable_int_test.cj        ✅
│   ├── mutable_long_test.cj       ✅
│   ├── mutable_double_test.cj     ✅
│   ├── mutable_float_test.cj      ✅
│   ├── mutable_short_test.cj      ✅
│   ├── mutable_byte_test.cj       ✅
│   ├── mutable_boolean_test.cj    ✅
│   └── mutable_object_test.cj     ✅
└── range/
    ├── range_test.cj              ✅
    ├── char_range_test.cj         ✅
    └── number_range_test.cj       ✅
```

**测试执行**:
```bash
$ cjpm test
All tests passed! ✅

Test Summary:
- Total tests: 590
- Passed: 590
- Failed: 0
- Coverage: 90%+
```

---

## 8. 参考资料

### 8.1 项目内部资料

1. **成功测试文件**:
   - `commons-lang4cj/src/utils/string_utils_test.cj` (668 行)
   - 测试用例: 67 个
   - 覆盖方法: 46 个

2. **源代码文件**:
   - `commons-lang4cj/src/utils/*.cj` (7 个文件)
   - `commons-lang4cj/src/builder/*.cj` (5 个文件)
   - `commons-lang4cj/src/mutable/*.cj` (8 个文件)
   - `commons-lang4cj/src/range/*.cj` (3 个文件)

3. **项目文档**:
   - `README.md` - 项目说明
   - `ANALYSIS_REPORT.md` - 需求分析
   - `CLAUDE.md` - 开发规范

### 8.2 仓颉测试框架

1. **标准库文档**:
   - `std.unittest.*` - 测试框架
   - `std.unittest.testmacro.*` - 测试宏

2. **核心注解**:
   - `@Test` - 标记测试类
   - `@TestCase` - 标记测试方法
   - `@Expect(actual, expected)` - 断言宏

3. **参考示例**:
   ```cangjie
   @Test
   class MyTest {
       @TestCase
       func testMethod() {
           @Expect(func(), expected)
       }
   }
   ```

### 8.3 Apache Commons Lang 测试参考

**Java 测试文件位置**: `commons-lang/src/test/java/org/apache/commons/lang3/`

**核心测试类**:

| Java 测试类 | 对应仓颉类 | 文件行数 |
|------------|-----------|---------|
| StringUtilsTest.java | StringUtils | 3000+ 行 |
| ArrayUtilsTest.java | ArrayUtils | ~3000 行 |
| ObjectUtilsTest.java | ObjectUtils | 2000+ 行 |
| NumberUtilsTest.java | NumberUtils | ~1500 行 |
| BooleanUtilsTest.java | BooleanUtils | ~1000 行 |
| CharUtilsTest.java | CharUtils | ~800 行 |
| ValidateTest.java | ValidateUtils | ~1200 行 |
| EqualsBuilderTest.java | EqualsBuilder | ~1500 行 |
| HashCodeBuilderTest.java | HashCodeBuilder | ~1200 行 |
| ToStringBuilderTest.java | ToStringBuilder | ~2000 行 |
| RangeTest.java | Range | ~800 行 |
| CharRangeTest.java | CharRange | ~600 行 |

**测试策略学习**:
1. 参数化测试 (`@ParameterizedTest`)
2. 边界值覆盖
3. null 处理
4. 异常情况测试
5. 集合测试
6. 性能测试 (可选)

### 8.4 最佳实践参考

**优秀的仓颉项目**:
- `deque4cj` - 双端队列实现
- `feign4cj` - HTTP 客户端
- `aad4cj` - 活动目录认证

**测试覆盖报告**:
- 使用 `cjpm test --coverage` 查看覆盖率
- 目标: ≥ 90% 代码覆盖率
- 重点: 公共 API 100% 覆盖

---

## 9. 附录

### 9.1 测试用例统计表

| 包 | 类名 | 方法数 | 测试用例数 | 估算工时 |
|---|--------|--------|-----------|---------|
| utils | StringUtils | 46 | 67 ✅ | - |
| utils | ArrayUtils | 21 | ~100 | 30-40 分钟 |
| utils | ObjectUtils | 31 | ~110 | 30-40 分钟 |
| utils | NumberUtils | 27 | ~90 | 25-35 分钟 |
| utils | BooleanUtils | 23 | ~70 | 20-30 分钟 |
| utils | CharUtils | 24 | ~65 | 20-30 分钟 |
| utils | ValidateUtils | 37 | ~100 | 30-40 分钟 |
| **Utils 小计** | **209** | **~602** | **3-4 小时** |
| builder | EqualsBuilder | 34 | ~40 | 25-35 分钟 |
| builder | HashCodeBuilder | 31 | ~38 | 20-30 分钟 |
| builder | ToStringBuilder | 63 | ~54 | 30-40 分钟 |
| builder | ToStringStyle | 40 | ~42 | 25-35 分钟 |
| builder | CompareToBuilder | 29 | ~34 | 20-30 分钟 |
| **Builder 小计** | **197** | **~208** | **2-3 小时** |
| mutable | MutableInt | 28 | ~31 | 20-30 分钟 |
| mutable | MutableLong | ~30 | ~30 | 20-30 分钟 |
| mutable | MutableDouble | ~32 | ~35 | 20-30 分钟 |
| mutable | MutableFloat | ~32 | ~32 | 20-30 分钟 |
| mutable | MutableShort | 31 | ~28 | 15-25 分钟 |
| mutable | MutableByte | ~30 | ~28 | 15-25 分钟 |
| mutable | MutableBoolean | 16 | ~18 | 10-20 分钟 |
| mutable | MutableObject<T> | 8 | ~23 | 15-25 分钟 |
| **Mutable 小计** | **~207** | **~225** | **3-4 小时** |
| range | Range<T> | 27 | ~30 | 20-30 分钟 |
| range | CharRange | 16 | ~20 | 15-25 分钟 |
| range | NumberRange<T> | 1 | ~8 | 10-20 分钟 |
| **Range 小计** | **44** | **~58** | **1-2 小时** |
| **总计** | **~657** | **~1,093** | **9-13 小时** |

### 9.2 工时估算

**总工时**: 9-13 小时

**分批工时**:
- Batch 1 (Utils): 3-4 小时
- Batch 2 (Builder): 2-3 小时
- Batch 3 (Mutable): 3-4 小时
- Batch 4 (Range): 1-2 小时

**建议执行节奏**:
- 每天 1 批 (2-4 小时)
- 4 天完成所有测试
- 第 5 天进行整体回归测试

### 9.3 风险与缓解

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| 仓颉 API 不熟悉 | 高 | 中 | 先查阅 `cangJie_docs/` |
| 测试用例设计不足 | 中 | 中 | 参考 Java 测试文件 |
| 编译错误多 | 中 | 低 | 增量开发，及时编译 |
| 工时估算不准 | 低 | 中 | 预留 20% 缓冲时间 |

---

## 10. 执行建议

### 10.1 立即行动 (本周)

1. **@Architect**: 确认测试文件组织结构
   - 是否放在 `src/utils/` 同目录下？
   - 还是创建独立的 `src/test/` 目录？

2. **@Developer**: 开始 Batch 1
   - 优先创建 `array_utils_test.cj`
   - 参考 `string_utils_test.cj` 的成功模式

3. **@Guardian**: 制定代码审查清单
   - 命名规范检查
   - 测试覆盖率检查
   - 编译警告检查

### 10.2 短期目标 (2 周)

- [ ] 完成 Batch 1 (Utils 包)
- [ ] 完成 Batch 2 (Builder 包)
- [ ] 清理所有编译警告
- [ ] 测试覆盖率达到 80%+

### 10.3 中期目标 (1 个月)

- [ ] 完成 Batch 3 (Mutable 包)
- [ ] 完成 Batch 4 (Range 包)
- [ ] 测试覆盖率达到 90%+
- [ ] 更新 README.md 的测试覆盖标记

---

**文档结束**

**下一步行动**: 请确认测试文件组织结构，然后立即开始 Batch 1 的执行。
