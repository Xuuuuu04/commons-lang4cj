# Exception 包设计方案 (v1.2.0)

> **版本**: v1.2.0
> **创建日期**: 2026-01-19
> **设计者**: @Architect
> **参考项目**: Apache Commons Lang `org.apache.commons.lang3.exception`

---

## 1. 架构决策记录 (ADR)

### ADR-001: 异常链处理策略

**背景**: 需要提供异常链遍历和根因查找功能

**选项**:
- **A)** 使用递归遍历异常链
- **B)** 使用 while 循环遍历异常链

**决策**: 选项 B (while 循环)

**理由**:
- 避免深层递归导致的栈溢出
- 性能更好，尾递归优化不确定

**风险**: 无

---

### ADR-002: 堆栈跟踪处理

**背景**: 需要获取和格式化异常堆栈跟踪

**选项**:
- **A)** 使用仓颉标准库的堆栈跟踪 API (如果存在)
- **B)** 不提供堆栈跟踪相关方法

**决策**: 选项 A + 降级到选项 B

**理由**:
- 仓颉 1.0.4 的 `Exception` 类可能没有 `stackTrace` 属性
- 先尝试访问，如果不存在则返回空数组
- 在文档中明确说明此限制

**风险**: 功能可能受限，需在 README 中说明

---

### ADR-003: 类型反射支持

**背景**: 需要实现 `hasCause` 和 `indexOfType` 等类型检查方法

**选项**:
- **A)** 使用仓颉的反射 API (如果支持)
- **B)** 简化实现，仅支持异常类型名称匹配
- **C)** 移除类型检查方法

**决策**: 选项 B (简化实现)

**理由**:
- 仓颉 1.0.4 反射 API 功能有限
- 使用 `getClassName()` 字符串匹配实现类型检查
- 性能可能略差，但功能完整

**风险**:
- 类型名称可能包含包名，需处理
- 子类类型检查可能不准确

**实现方案**:
```cangjie
public func hasCause(throwable: Exception, typeStr: String): Bool {
    var cause = throwable.cause
    while (let Some(c) <- cause) {
        if (c.getClassName() == typeStr || c.getClassName().endsWith(typeStr)) {
            return true
        }
        cause = c.cause
    }
    false
}
```

---

### ADR-004: ExceptionContext 线程安全

**背景**: `DefaultExceptionContext` 需要线程安全

**选项**:
- **A)** 使用 `Mutex` 保护内部状态
- **B)** 使用 `ConcurrentHashMap`
- **C)** 不保证线程安全

**决策**: 选项 A (使用 `Mutex`)

**理由**:
- `HashMap` 性能更好，单线程无锁开销
- `Mutex` 保护粒度细，仅保护写操作
- 符合仓颉并发最佳实践

**风险**: 无

---

## 2. 包结构设计

```
src/exception/
├── exception_utils.cj              # ExceptionUtils 工具类
├── exception_context.cj             # ExceptionContext 接口
└── default_exception_context.cj     # DefaultExceptionContext 实现
```

**依赖关系**:
```
exception_utils.cj          # 无依赖 (仅依赖 std.*)
exception_context.cj        # 无依赖
default_exception_context.cj # 依赖 exception_context.cj + std.sync.*
```

---

## 3. 类签名设计

### 3.1 ExceptionUtils (异常工具类)

**文件**: `src/exception/exception_utils.cj`

**职责**: 提供异常操作的静态实用方法

```cangjie
package commons_lang4cj.exception

import std.collection.*
import std.unittest.*

/**
 * 异常工具类
 * 提供异常操作的实用方法，包括异常链遍历、根因查找、消息格式化等
 *
 * @since 1.2.0
 */
public class ExceptionUtils {
    /**
     * 获取异常链的根因异常
     *
     * @param throwable 目标异常
     * @return 根因异常（如果没有 cause，返回自身）
     *
     * @example
     * ```cangjie
     * let root = ExceptionUtils.getRootCause(wrapper)
     * println(root.message)
     * ```
     */
    public static func getRootCause(throwable: Exception): Exception

    /**
     * 获取异常的直接原因
     *
     * @param throwable 目标异常
     * @return Option<Exception> - 直接原因异常
     *
     * @example
     * ```cangjie
     * if (let Some(cause) <- ExceptionUtils.getCause(wrapper)) {
     *     println(cause.message)
     * }
     * ```
     */
    public static func getCause(throwable: Exception): Option<Exception>

    /**
     * 获取异常的完整消息（包含所有 cause 的消息）
     *
     * @param throwable 目标异常
     * @return 格式化的消息字符串
     *
     * @example
     * ```cangjie
     * // 输出: "Exception: wrapper
     * // Caused by: Exception: cause1
     * // Caused by: Exception: root"
     * let msg = ExceptionUtils.getMessage(wrapper)
     * ```
     */
    public static func getMessage(throwable: Exception): String

    /**
     * 获取异常的基本消息（不包含 cause）
     *
     * @param throwable 目标异常
     * @return 异常消息
     */
    public static func getBasicMessage(throwable: Exception): String

    /**
     * 获取异常链中的异常数量
     *
     * @param throwable 目标异常
     * @return 异常链长度（至少为 1）
     */
    public static func getThrowableCount(throwable: Exception): Int64

    /**
     * 获取异常链中的所有异常
     *
     * @param throwable 目标异常
     * @return 异常数组（从自身到根因）
     */
    public static func getThrowables(throwable: Exception): Array<Exception>

    /**
     * 检查异常链中是否包含指定类型的异常
     *
     * @param throwable 目标异常
     * @param typeStr 异常类型名称（如 "IllegalArgumentException"）
     * @return 是否包含
     *
     * @example
     * ```cangjie
     * if (ExceptionUtils.hasCause(wrapper, "IllegalArgumentException")) {
     *     println("Contains IllegalArgumentException")
     * }
     * ```
     */
    public static func hasCause(throwable: Exception, typeStr: String): Bool

    /**
     * 查找异常链中指定类型的第一个异常
     *
     * @param throwable 目标异常
     * @param typeStr 异常类型名称
     * @return Option<Exception> - 找到的异常
     */
    public static func findCause(throwable: Exception, typeStr: String): Option<Exception>

    /**
     * 查找异常链中指定类型的索引位置
     *
     * @param throwable 目标异常
     * @param typeStr 异常类型名称
     * @return 索引位置（-1 表示未找到，0 表示自身）
     */
    public static func indexOfType(throwable: Exception, typeStr: String): Int64

    /**
     * 打印异常堆栈跟踪到标准错误输出
     *
     * @param throwable 目标异常
     */
    public static func printStackTrace(throwable: Exception): Unit

    /**
     * 获取异常堆栈跟踪为字符串数组
     *
     * ⚠️ 注意: 此方法依赖于仓颉标准库的堆栈跟踪 API
     * 如果不可用，返回空数组
     *
     * @param throwable 目标异常
     * @return 堆栈跟踪字符串数组
     */
    public static func getStackTrace(throwable: Exception): Array<String>

    /**
     * 获取异常的根因消息
     *
     * @param throwable 目标异常
     * @return 根因消息（如果没有 cause，返回自身消息）
     */
    public static func getRootCauseMessage(throwable: Exception): String

    /**
     * 检查异常是否由指定类型的异常引起
     *
     * @param throwable 目标异常
     * @param typeStr 异常类型名称
     * @return 是否由该类型引起
     */
    public static func isCausedBy(throwable: Exception, typeStr: String): Bool

    /**
     * 获取异常链中指定索引位置的异常
     *
     * @param throwable 目标异常
     * @param index 索引位置（0 表示自身）
     * @return Option<Exception> - 该位置的异常
     */
    public static func getThrowable(throwable: Exception, index: Int64): Option<Exception>

    /**
     * 检查异常是否包含指定类型的异常（包括自身）
     *
     * @param throwable 目标异常
     * @param typeStr 异常类型名称
     * @return 是否包含
     */
    public static func hasType(throwable: Exception, typeStr: String): Bool

    /**
     * 重新抛出异常（包装为运行时异常）
     *
     * @param throwable 目标异常
     * @throws Exception 总是抛出
     */
    public static func rethrow(throwable: Exception): Unit

    /**
     * 获取异常的类名
     *
     * @param throwable 目标异常
     * @return 类名
     */
    public static func getClassName(throwable: Exception): String

    /**
     * 格式化异常消息（包含类名和消息）
     *
     * @param throwable 目标异常
     * @return 格式化的消息
     *
     * @example
     * ```cangjie
     * // 输出: "IllegalArgumentException: Invalid parameter"
     * let msg = ExceptionUtils.formatException(ex)
     * ```
     */
    public static func formatException(throwable: Exception): String

    /**
     * 检查异常链是否有循环引用
     *
     * @param throwable 目标异常
     * @return 是否有循环
     */
    public static func hasCycle(throwable: Exception): Bool
}
```

---

### 3.2 ExceptionContext (异常上下文接口)

**文件**: `src/exception/exception_context.cj`

**职责**: 定义异常上下文接口，用于附加诊断信息

```cangjie
package commons_lang4cj.exception

/**
 * 异常上下文接口
 * 允许异常附加标签值对（Label-Value Pairs）作为诊断信息
 *
 * @since 1.2.0
 */
public interface ExceptionContext {
    /**
     * 添加标签值对
     *
     * @param label 标签
     * @param value 值（任意类型）
     * @return this (支持链式调用)
     */
    public mut func addValue(label: String, value: Any): ExceptionContext

    /**
     * 获取所有标签值对
     *
     * @return Map<String, Any> - 标签值对映射
     */
    public func getValues(): HashMap<String, Any>

    /**
     * 获取指定标签的第一个值
     *
     * @param label 标签
     * @return Option<Any> - 该标签的值
     */
    public func getFirstValue(label: String): Option<Any>

    /**
     * 获取指定标签的所有值
     *
     * @param label 标签
     * @return Array<Any> - 该标签的所有值
     */
    public func getValues(label: String): Array<Any>

    /**
     * 设置异常的堆栈跟踪
     *
     * ⚠️ 注意: 此方法可能不受仓颉标准库支持
     *
     * @param throwable 目标异常
     * @param stackTrace 堆栈跟踪字符串数组
     */
    public func setStackTrace(throwable: Exception, stackTrace: Array<String>): Unit

    /**
     * 获取格式化的上下文信息
     *
     * @return 格式化的字符串
     */
    public func getFormattedContext(message: String): String

    /**
     * 清除所有标签值对
     */
    public mut func clear(): Unit

    /**
     * 获取标签数量
     *
     * @return 标签数量
     */
    public func size(): Int64

    /**
     * 检查是否包含指定标签
     *
     * @param label 标签
     * @return 是否包含
     */
    public func containsLabel(label: String): Bool
}
```

---

### 3.3 DefaultExceptionContext (默认异常上下文实现)

**文件**: `src/exception/default_exception_context.cj`

**职责**: 默认的异常上下文实现，线程安全

```cangjie
package commons_lang4cj.exception

import std.collection.*
import std.sync.*

/**
 * 默认异常上下文实现
 * 线程安全的异常上下文，使用 HashMap 存储标签值对
 *
 * @since 1.2.0
 */
public class DefaultExceptionContext <: ExceptionContext {
    // 私有字段
    private var _values: HashMap<String, ArrayList<Any>> = HashMap<String, ArrayList<Any>>()
    private let _mutex: Mutex = Mutex()

    /**
     * 构造函数
     */
    public init()

    /**
     * 添加标签值对（线程安全）
     *
     * @param label 标签
     * @param value 值
     * @return this (支持链式调用)
     */
    public override mut func addValue(label: String, value: Any): ExceptionContext

    /**
     * 获取所有标签值对（线程安全）
     *
     * @return HashMap<String, Any> - 仅返回每个标签的第一个值
     */
    public override func getValues(): HashMap<String, Any>

    /**
     * 获取指定标签的第一个值（线程安全）
     *
     * @param label 标签
     * @return Option<Any> - 该标签的第一个值
     */
    public override func getFirstValue(label: String): Option<Any>

    /**
     * 获取指定标签的所有值（线程安全）
     *
     * @param label 标签
     * @return Array<Any> - 该标签的所有值
     */
    public override func getValues(label: String): Array<Any>

    /**
     * 设置异常堆栈跟踪（未实现，返回 Unit）
     *
     * ⚠️ 注意: 仓颉 1.0.4 不支持设置堆栈跟踪
     *
     * @param throwable 目标异常
     * @param stackTrace 堆栈跟踪
     */
    public override func setStackTrace(throwable: Exception, stackTrace: Array<String>): Unit

    /**
     * 获取格式化的上下文信息
     *
     * @param message 基础消息
     * @return 格式化的字符串
     *
     * @example
     * ```cangjie
     * // 输出:
     * // Exception details
     * //   key1: value1
     * //   key2: value2
     * ```
     */
    public override func getFormattedContext(message: String): String

    /**
     * 清除所有标签值对（线程安全）
     */
    public override mut func clear(): Unit

    /**
     * 获取标签数量（线程安全）
     *
     * @return 标签数量
     */
    public override func size(): Int64

    /**
     * 检查是否包含指定标签（线程安全）
     *
     * @param label 标签
     * @return 是否包含
     */
    public override func containsLabel(label: String): Bool

    /**
     * 获取内部状态的副本（用于调试）
     *
     * @return HashMap<String, ArrayList<Any>> - 内部状态副本
     */
    public func getInternalState(): HashMap<String, ArrayList<Any>>
}
```

---

## 4. 实现指南

### 4.1 ExceptionUtils 核心方法实现

#### 4.1.1 getRootCause (获取根因异常)

```cangjie
public static func getRootCause(throwable: Exception): Exception {
    var rootCause = throwable
    while (let Some(cause) <- rootCause.cause) {
        rootCause = cause
    }
    rootCause
}
```

**算法说明**:
1. 从当前异常开始
2. 循环遍历 `cause` 链
3. 返回最后一个异常

**时间复杂度**: O(n)，n 为异常链长度

---

#### 4.1.2 getThrowableCount (获取异常数量)

```cangjie
public static func getThrowableCount(throwable: Exception): Int64 {
    var count = 1
    var current = throwable
    while (let Some(cause) <- current.cause) {
        count++
        current = cause
    }
    count
}
```

**算法说明**:
1. 初始计数为 1（自身）
2. 遍历 cause 链，每找到一个就 +1
3. 返回总数

---

#### 4.1.3 hasCause (检查异常类型)

```cangjie
public static func hasCause(throwable: Exception, typeStr: String): Bool {
    var cause = throwable.cause
    while (let Some(c) <- cause) {
        let className = c.getClassName()
        // 精确匹配或后缀匹配
        if (className == typeStr || className.endsWith(".${typeStr}")) {
            return true
        }
        cause = c.cause
    }
    false
}
```

**算法说明**:
1. 从当前异常的 cause 开始
2. 检查每个异常的类名
3. 支持精确匹配（`"IllegalArgumentException"`）
4. 支持后缀匹配（`".IllegalArgumentException"`）

**注意事项**:
- 不检查自身，只检查 cause 链
- 使用 `endsWith` 支持包名前缀

---

#### 4.1.4 getMessage (获取完整消息)

```cangjie
public static func getMessage(throwable: Exception): String {
    let sb = StringBuilder()
    var current: Option<Exception> = Some(throwable)

    while (let Some(ex) <- current) {
        // 添加当前异常消息
        if (sb.size > 0) {
            sb.append("\n  Caused by: ")
        }
        sb.append(formatException(ex))

        // 移动到下一个
        current = ex.cause
    }

    sb.toString()
}

private static func formatException(throwable: Exception): String {
    let className = throwable.getClassName()
    let message = throwable.message
    if (message.isEmpty()) {
        className
    } else {
        "${className}: ${message}"
    }
}
```

**算法说明**:
1. 使用 `StringBuilder` 拼接消息
2. 每个异常一行，缩进显示
3. 格式: `ClassName: message`

**示例输出**:
```
IllegalArgumentException: Invalid parameter
  Caused by: NumberFormatException: For input string: "abc"
  Caused by: ArithmeticException: Division by zero
```

---

#### 4.1.5 getThrowables (获取所有异常)

```cangjie
public static func getThrowables(throwable: Exception): Array<Exception> {
    let throwables = ArrayList<Exception>()
    var current: Option<Exception> = Some(throwable)

    while (let Some(ex) <- current) {
        throwables.append(ex)
        current = ex.cause
    }

    throwables.toArray()
}
```

**算法说明**:
1. 使用 `ArrayList` 收集异常
2. 从自身到根因顺序收集
3. 转换为不可变 `Array` 返回

---

### 4.2 DefaultExceptionContext 核心方法实现

#### 4.2.1 addValue (添加标签值对)

```cangjie
public override mut func addValue(label: String, value: Any): ExceptionContext {
    synchronized(_mutex) {
        if (let Some(list) <- _values.get(label)) {
            list.append(value)
        } else {
            let list = ArrayList<Any>()
            list.append(value)
            _values.put(label, list)
        }
    }
    this
}
```

**算法说明**:
1. 使用 `Mutex` 保护写操作
2. 每个标签维护一个 `ArrayList` (支持多值)
3. 返回 `this` 支持链式调用

**线程安全**: ✅ 使用 `synchronized`

---

#### 4.2.2 getFormattedContext (格式化上下文)

```cangjie
public override func getFormattedContext(message: String): String {
    synchronized(_mutex) {
        if (_values.isEmpty) {
            return message
        }

        let sb = StringBuilder()
        sb.append(message)

        if (!message.isEmpty()) {
            sb.append("\n")
        }

        sb.append("Exception details:\n")

        for ((label, list) in _values) {
            sb.append("  ${label}: ")
            if (list.size > 1) {
                sb.append("[${list.joinToString(", ")}]")
            } else if (let Some(first) <- list.first()) {
                sb.append("${first}")
            }
            sb.append("\n")
        }

        sb.toString()
    }
}
```

**算法说明**:
1. 使用 `Mutex` 保护读操作（简化实现）
2. 格式化输出所有标签值对
3. 多值标签显示为数组格式

**示例输出**:
```
Exception details
  key1: value1
  key2: [value2a, value2b, value2c]
```

---

## 5. 测试策略

### 5.1 ExceptionUtils 测试用例

**文件**: `src/exception/exception_utils_test.cj`

**预估测试用例数**: 20-25 个

| 序号 | 测试用例名称 | 描述 |
|------|-------------|------|
| 1 | `testGetRootCauseNoCause` | 测试无 cause 的异常返回自身 |
| 2 | `testGetRootCauseSingleCause` | 测试单层 cause |
| 3 | `testGetRootCauseMultipleCauses` | 测试多层 cause |
| 4 | `testGetCauseWithCause` | 测试有 cause 返回 Some |
| 5 | `testGetCauseNoCause` | 测试无 cause 返回 None |
| 6 | `testGetThrowableCount` | 测试异常链计数 |
| 7 | `testGetThrowables` | 测试获取所有异常 |
| 8 | `testHasCauseExactMatch` | 测试精确类型匹配 |
| 9 | `testHasCauseSuffixMatch` | 测试后缀匹配 |
| 10 | `testHasCauseNotFound` | 测试未找到类型 |
| 11 | `testFindCause` | 测试查找指定类型 |
| 12 | `testIndexOfType` | 测试类型索引 |
| 13 | `testGetMessage` | 测试完整消息格式化 |
| 14 | `testGetBasicMessage` | 测试基本消息 |
| 15 | `testGetRootCauseMessage` | 测试根因消息 |
| 16 | `testIsCausedBy` | 测试由指定类型引起 |
| 17 | `testGetThrowable` | 测试获取指定索引异常 |
| 18 | `testHasType` | 测试包含指定类型 |
| 19 | `testFormatException` | 测试异常格式化 |
| 20 | `testHasCycle` | 测试循环引用检测 |
| 21 | `testGetStackTrace` | 测试堆栈跟踪获取 |
| 22 | `testPrintStackTrace` | 测试打印堆栈跟踪 |

---

### 5.2 DefaultExceptionContext 测试用例

**文件**: `src/exception/default_exception_context_test.cj`

**预估测试用例数**: 15-20 个

| 序号 | 测试用例名称 | 描述 |
|------|-------------|------|
| 1 | `testAddValueSingle` | 测试添加单个值 |
| 2 | `testAddValueMultiple` | 测试添加多个值 |
| 3 | `testAddValueChaining` | 测试链式调用 |
| 4 | `testGetValues` | 测试获取所有值 |
| 5 | `testGetFirstValue` | 测试获取第一个值 |
| 6 | `testGetValuesLabel` | 测试获取指定标签的所有值 |
| 7 | `testGetFormattedContext` | 测试格式化输出 |
| 8 | `testClear` | 测试清除所有值 |
| 9 | `testSize` | 测试标签数量 |
| 10 | `testContainsLabel` | 测试包含标签 |
| 11 | `testGetValuesEmpty` | 测试空上下文 |
| 12 | `testAddValueThreadSafety` | 测试线程安全性 |
| 13 | `testGetInternalState` | 测试获取内部状态 |
| 14 | `testSetStackTrace` | 测试设置堆栈跟踪 (应无操作) |
| 15 | `testOverwriteValue` | 测试覆盖已存在的值 |

---

## 6. 使用示例

### 6.1 ExceptionUtils 基础用法

```cangjie
import commons_lang4cj.exception.*
import std.io.*

main() {
    // 创建异常链
    let root = ArithmeticException("Division by zero")
    let middle = IllegalArgumentException("Invalid parameter", root)
    let wrapper = Exception("Service failed", middle)

    // 获取根因异常
    let rootCause = ExceptionUtils.getRootCause(wrapper)
    println(rootCause.message)  // 输出: Division by zero

    // 检查异常链
    if (ExceptionUtils.hasCause(wrapper, "IllegalArgumentException")) {
        println("Contains IllegalArgumentException")
    }

    // 获取完整消息
    let fullMessage = ExceptionUtils.getMessage(wrapper)
    println(fullMessage)
    // 输出:
    // Exception: Service failed
    //   Caused by: IllegalArgumentException: Invalid parameter
    //   Caused by: ArithmeticException: Division by zero

    // 获取异常链数量
    let count = ExceptionUtils.getThrowableCount(wrapper)
    println("Throwable count: ${count}")  // 输出: 3
}
```

---

### 6.2 异常类型查找

```cangjie
main() {
    let root = ArithmeticException("Root error")
    let wrapper = IllegalArgumentException("Wrapper error", root)

    // 查找指定类型的异常
    if (let Some(arithEx) <- ExceptionUtils.findCause(wrapper, "ArithmeticException")) {
        println("Found: ${arithEx.message}")
    }

    // 获取类型索引
    let index = ExceptionUtils.indexOfType(wrapper, "ArithmeticException")
    println("Index: ${index}")  // 输出: 2 (0=wrapper, 1=middle, 2=root)
}
```

---

### 6.3 DefaultExceptionContext 用法

```cangjie
main() {
    let context = DefaultExceptionContext()

    // 添加诊断信息
    context.addValue("userId", "12345")
           .addValue("operation", "createOrder")
           .addValue("retryCount", 3)
           .addValue("parameters", "[orderId: 67890]")

    // 获取格式化上下文
    let message = context.getFormattedContext("Order creation failed")
    println(message)
    // 输出:
    // Order creation failed
    // Exception details:
    //   userId: 12345
    //   operation: createOrder
    //   retryCount: 3
    //   parameters: [orderId: 67890]

    // 查询特定标签
    if (let Some(userId) <- context.getFirstValue("userId")) {
        println("User ID: ${userId}")
    }

    // 获取标签数量
    println("Context size: ${context.size()}")  // 输出: 4
}
```

---

### 6.4 线程安全示例

```cangjie
import std.sync.*

main() {
    let context = DefaultExceptionContext()
    let threads = ArrayList<Future<Unit>>()

    // 多线程并发添加值
    for (i in 0..10) {
        let fut = spawn {
            context.addValue("thread", i)
            context.addValue("count", i * 2)
        }
        threads.append(fut)
    }

    // 等待所有线程完成
    for (fut in threads) {
        let _ = fut.get()
    }

    // 验证结果
    println("Total labels: ${context.size()}")  // 应该是 2
    println("Thread values: ${context.getValues("thread").size}")  // 应该是 10
}
```

---

### 6.5 异常链遍历

```cangjie
main() {
    let root = ArithmeticException("Root")
    let middle = IllegalArgumentException("Middle", root)
    let wrapper = Exception("Wrapper", middle)

    // 获取所有异常并遍历
    let throwables = ExceptionUtils.getThrowables(wrapper)

    println("Exception chain:")
    for ((i, ex) in throwables.enumerate()) {
        println("  [${i}] ${ExceptionUtils.formatException(ex)}")
    }
    // 输出:
    // Exception chain:
    //   [0] Exception: Wrapper
    //   [1] IllegalArgumentException: Middle
    //   [2] ArithmeticException: Root
}
```

---

### 6.6 异常链循环检测

```cangjie
main() {
    // 创建循环引用 (理论上不应该发生，但需要防御)
    let ex1 = Exception("Exception 1")
    let ex2 = Exception("Exception 2", ex1)
    // ex1.cause = ex2  // 如果仓颉允许设置 cause

    // 检测循环
    if (ExceptionUtils.hasCycle(ex1)) {
        println("Warning: Circular exception chain detected!")
    }
}
```

---

## 7. 依赖关系

### 7.1 外部依赖

**仅依赖标准库**:
- `std.collection.*` - `HashMap`, `ArrayList`, `StringBuilder`
- `std.sync.*` - `Mutex`
- `std.unittest.*` - 测试框架
- `std.io.*` - 标准输入输出

**无第三方依赖**

---

### 7.2 内部依赖

```
exception_utils.cj
  └─ (无内部依赖)

exception_context.cj
  └─ (无内部依赖)

default_exception_context.cj
  └─ exception_context.cj (接口)
```

---

## 8. 仓颉语言适配

### 8.1 已知限制

| 功能 | Java 实现 | 仓颉实现 | 限制说明 |
|------|----------|---------|---------|
| **类型反射** | `instanceof` + `Class.isInstance()` | 字符串匹配 ⚠️ | 使用 `getClassName()` 字符串匹配 |
| **堆栈跟踪** | `Throwable.getStackTrace()` | 可能不支持 ⚠️ | 依赖标准库支持 |
| **设置堆栈** | `Throwable.setStackTrace()` | 不支持 ❌ | 仓颉异常不可变 |
| **有原因构造器** | `Throwable(message, cause)` | 支持 ✅ | `Exception(message, cause)` |
| **异常链** | `Throwable.getCause()` | 支持 ✅ | `throwable.cause: Option<Exception>` |

---

### 8.2 API 差异处理

#### 8.2.1 cause 属性类型

**Java**: `Throwable.getCause()` 返回 `Throwable` (可能为 null)

**仓颉**: `throwable.cause` 返回 `Option<Exception>`

**适配**:
```cangjie
// ✅ 仓颉风格：使用 Option 模式
if (let Some(cause) <- throwable.cause) {
    // 处理 cause
}

// ❌ 避免：不要使用 null 检查
```

---

#### 8.2.2 异常消息

**Java**: `Throwable.getMessage()` 返回 `String` (可能为 null)

**仓颉**: `throwable.message` 返回 `String`

**适配**:
```cangjie
// 检查消息是否为空
if (throwable.message.isEmpty()) {
    // 没有消息
}
```

---

#### 8.2.3 类型检查

**Java**: 使用 `instanceof`

**仓颉**: 使用 `is` 操作符或 `getClassName()`

**适配**:
```cangjie
// 方法 1: 使用 is 操作符
if (ex is IllegalArgumentException) {
    // 处理
}

// 方法 2: 使用字符串匹配 (用于 hasCause)
if (ex.getClassName() == "IllegalArgumentException") {
    // 处理
}
```

---

### 8.3 最佳实践

1. **Option 模式优先**:
   ```cangjie
   // ✅ 推荐
   if (let Some(cause) <- ExceptionUtils.getCause(ex)) { ... }

   // ❌ 避免
   let cause = ExceptionUtils.getCause(ex)
   if (cause != None) { ... }
   ```

2. **不可变优先**:
   - `ExceptionUtils` 所有方法都是静态的
   - 不维护内部状态

3. **线程安全**:
   - `DefaultExceptionContext` 使用 `Mutex` 保护
   - 读操作也加锁（简化实现，性能可接受）

---

## 9. 性能考虑

### 9.1 时间复杂度

| 方法 | 时间复杂度 | 说明 |
|------|-----------|------|
| `getRootCause` | O(n) | n 为异常链长度 |
| `getThrowableCount` | O(n) | 遍历异常链 |
| `hasCause` | O(n) | 遍历异常链 + 字符串匹配 |
| `getThrowables` | O(n) | 遍历 + 数组构建 |
| `getMessage` | O(n) | 遍历 + 字符串拼接 |

---

### 9.2 空间复杂度

| 方法 | 空间复杂度 | 说明 |
|------|-----------|------|
| `getRootCause` | O(1) | 仅保存引用 |
| `getThrowables` | O(n) | 创建新数组 |
| `getMessage` | O(n) | StringBuilder 缓冲区 |
| `DefaultExceptionContext` | O(m) | m 为标签数量 |

---

### 9.3 优化建议

1. **避免频繁遍历异常链**:
   ```cangjie
   // ❌ 避免：多次遍历
   if (ExceptionUtils.hasCause(ex, "A")) { ... }
   if (ExceptionUtils.hasCause(ex, "B")) { ... }

   // ✅ 推荐：一次遍历
   let throwables = ExceptionUtils.getThrowables(ex)
   for (t in throwables) {
       if (t.getClassName() == "A" || t.getClassName() == "B") {
           // 处理
       }
   }
   ```

2. **使用 StringBuilder 拼接字符串**:
   - 避免频繁的 `+` 操作
   - 预分配合理容量

---

## 10. 后续扩展计划

### 10.1 v1.3.0 计划

- [ ] 添加 `ExceptionUtils.throwableToString()` 方法
- [ ] 支持 `setStackTrace` (如果仓颉标准库支持)
- [ ] 添加更多格式化选项

### 10.2 v1.4.0 计划

- [ ] 实现 `ContextedRuntimeException` (带上下文的运行时异常)
- [ ] 添加异常序列化/反序列化支持
- [ ] 提供异常链修复工具

---

## 11. 文档需求

### 11.1 README 更新

需要在 `README.md` 中添加：

```markdown
## Exception 包 (v1.2.0)

### 功能特性

- 异常链遍历和根因查找
- 异常类型检查和查找
- 异常消息格式化
- 异常上下文管理（线程安全）

### 使用示例

\`\`\`cangjie
import commons_lang4cj.exception.*

let rootCause = ExceptionUtils.getRootCause(wrapper)
let context = DefaultExceptionContext()
context.addValue("key", "value")
\`\`\`

### 约束与限制

- ⚠️ 类型检查使用字符串匹配，不支持反射
- ⚠️ 堆栈跟踪功能依赖标准库支持
- ⚠️ 不支持设置异常堆栈跟踪
```

---

### 11.2 API 文档

创建 `doc/exception_api_reference.md`：

- 完整的类和方法签名
- 所有公共方法的文档注释
- 使用示例
- 参数说明
- 返回值说明
- 异常说明

---

## 12. 验收标准

### 12.1 编译标准

- [ ] `cjpm build` 无错误
- [ ] `cjpm build` 无警告 (或仅有可接受的警告)
- [ ] 所有公共方法有文档注释

### 12.2 测试标准

- [ ] 测试覆盖率 ≥ 90%
- [ ] 所有测试用例通过
- [ ] 线程安全性测试通过

### 12.3 代码质量标准

- [ ] 私有字段使用 `_` 前缀
- [ ] 命名符合仓颉规范
- [ ] 无 TODO 或 FIXME (除非有明确说明)
- [ ] Git 提交信息符合规范

---

## 13. 风险与缓解措施

### 13.1 技术风险

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| 仓颉反射 API 限制 | 类型检查不精确 | 高 | 使用字符串匹配，文档说明 |
| 堆栈跟踪不支持 | 部分功能缺失 | 中 | 提供降级方案，返回空数组 |
| 线程安全问题 | 并发错误 | 低 | 使用 `Mutex` 保护，编写测试 |

---

### 13.2 项目风险

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| 工时估算不准 | 延期 | 中 | 增量实现，优先核心功能 |
| 测试不充分 | 线上 Bug | 低 | 严格执行测试策略，代码审查 |

---

## 14. 交付清单

### 14.1 代码文件

- [ ] `src/exception/exception_utils.cj`
- [ ] `src/exception/exception_context.cj`
- [ ] `src/exception/default_exception_context.cj`
- [ ] `src/exception/exception_utils_test.cj`
- [ ] `src/exception/default_exception_context_test.cj`

### 14.2 文档文件

- [ ] `doc/exception_package_design.md` (本文档)
- [ ] `doc/exception_api_reference.md`
- [ ] 更新 `README.md`
- [ ] 更新 `CHANGELOG.md`

---

## 15. 总结

### 15.1 核心价值

本 exception 包为 commons-lang4cj 提供了完整的异常处理工具：

1. **异常链管理**: 遍历、查找、格式化异常链
2. **异常上下文**: 线程安全的诊断信息附加
3. **仓颉适配**: 充分利用 `Option` 模式和字符串匹配

### 15.2 技术亮点

- ✅ **零依赖**: 仅依赖标准库
- ✅ **线程安全**: `DefaultExceptionContext` 使用 `Mutex`
- ✅ **类型安全**: 充分使用 `Option<T>` 处理空值
- ✅ **API 一致**: 符合仓颉语言习惯

### 15.3 预估工时

| 阶段 | 工时 | 负责人 |
|------|------|--------|
| 设计 | 1 小时 | @Architect |
| ExceptionUtils 实现 | 2 小时 | @Developer |
| ExceptionContext 实现 | 1 小时 | @Developer |
| DefaultExceptionContext 实现 | 1.5 小时 | @Developer |
| 测试编写 | 2.5 小时 | @Developer |
| 文档编写 | 1 小时 | @Developer |
| 代码审查 | 0.5 小时 | @Guardian |
| **总计** | **9.5 小时** | - |

---

**设计完成时间**: 2026-01-19
**设计者**: @Architect
**状态**: ✅ 设计完成，等待实现

---

## 附录 A: 完整类签名列表

### A.1 ExceptionUtils

```cangjie
public class ExceptionUtils {
    public static func getRootCause(throwable: Exception): Exception
    public static func getCause(throwable: Exception): Option<Exception>
    public static func getMessage(throwable: Exception): String
    public static func getBasicMessage(throwable: Exception): String
    public static func getThrowableCount(throwable: Exception): Int64
    public static func getThrowables(throwable: Exception): Array<Exception>
    public static func hasCause(throwable: Exception, typeStr: String): Bool
    public static func findCause(throwable: Exception, typeStr: String): Option<Exception>
    public static func indexOfType(throwable: Exception, typeStr: String): Int64
    public static func printStackTrace(throwable: Exception): Unit
    public static func getStackTrace(throwable: Exception): Array<String>
    public static func getRootCauseMessage(throwable: Exception): String
    public static func isCausedBy(throwable: Exception, typeStr: String): Bool
    public static func getThrowable(throwable: Exception, index: Int64): Option<Exception>
    public static func hasType(throwable: Exception, typeStr: String): Bool
    public static func rethrow(throwable: Exception): Unit
    public static func getClassName(throwable: Exception): String
    public static func formatException(throwable: Exception): String
    public static func hasCycle(throwable: Exception): Bool
}
```

**总计**: 18 个公共方法

---

### A.2 ExceptionContext

```cangjie
public interface ExceptionContext {
    public mut func addValue(label: String, value: Any): ExceptionContext
    public func getValues(): HashMap<String, Any>
    public func getFirstValue(label: String): Option<Any>
    public func getValues(label: String): Array<Any>
    public func setStackTrace(throwable: Exception, stackTrace: Array<String>): Unit
    public func getFormattedContext(message: String): String
    public mut func clear(): Unit
    public func size(): Int64
    public func containsLabel(label: String): Bool
}
```

**总计**: 9 个接口方法

---

### A.3 DefaultExceptionContext

```cangjie
public class DefaultExceptionContext <: ExceptionContext {
    public init()
    public override mut func addValue(label: String, value: Any): ExceptionContext
    public override func getValues(): HashMap<String, Any>
    public override func getFirstValue(label: String): Option<Any>
    public override func getValues(label: String): Array<Any>
    public override func setStackTrace(throwable: Exception, stackTrace: Array<String>): Unit
    public override func getFormattedContext(message: String): String
    public override mut func clear(): Unit
    public override func size(): Int64
    public override func containsLabel(label: String): Bool
    public func getInternalState(): HashMap<String, ArrayList<Any>>
}
```

**总计**: 10 个公共方法 (9 个接口方法 + 1 个扩展方法)

---

**总公共方法数**: 18 + 10 = **28 个**

---

**设计文档版本**: v1.0.0
**最后更新**: 2026-01-19
**状态**: ✅ 设计完成
