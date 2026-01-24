# Exception 包设计总结 (v1.2.0)

> **快速参考文档**
> **创建日期**: 2026-01-19
> **设计者**: @Architect

---

## 📋 核心类一览表

| 类名 | 文件 | 公共方法数 | 职责 | 线程安全 |
|------|------|-----------|------|---------|
| `ExceptionUtils` | `exception_utils.cj` | 18 个 | 异常工具类 | 静态方法 |
| `ExceptionContext` | `exception_context.cj` | 9 个 (接口) | 异常上下文接口 | - |
| `DefaultExceptionContext` | `default_exception_context.cj` | 10 个 | 默认实现 | ✅ 是 (Mutex) |

**总计**: **28 个公共方法**

---

## 🎯 核心功能速查

### ExceptionUtils 核心方法

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `getRootCause(throwable)` | 获取根因异常 | `Exception` |
| `getCause(throwable)` | 获取直接原因 | `Option<Exception>` |
| `getMessage(throwable)` | 获取完整消息 | `String` |
| `getThrowableCount(throwable)` | 获取异常数量 | `Int64` |
| `getThrowables(throwable)` | 获取所有异常 | `Array<Exception>` |
| `hasCause(throwable, typeStr)` | 检查异常类型 | `Bool` |
| `findCause(throwable, typeStr)` | 查找异常 | `Option<Exception>` |
| `indexOfType(throwable, typeStr)` | 查找类型索引 | `Int64` |
| `formatException(throwable)` | 格式化异常 | `String` |
| `hasCycle(throwable)` | 检测循环引用 | `Bool` |

---

### ExceptionContext 核心方法

| 方法签名 | 功能 | 返回值 |
|---------|------|--------|
| `addValue(label, value)` | 添加标签值对 | `ExceptionContext` (链式) |
| `getValues()` | 获取所有值 | `HashMap<String, Any>` |
| `getFirstValue(label)` | 获取第一个值 | `Option<Any>` |
| `getFormattedContext(message)` | 格式化输出 | `String` |
| `clear()` | 清除所有值 | `Unit` |
| `size()` | 标签数量 | `Int64` |
| `containsLabel(label)` | 包含标签 | `Bool` |

---

## 🏗️ 包结构

```
src/exception/
├── exception_utils.cj              # 18 个静态方法
├── exception_context.cj             # 9 个接口方法
└── default_exception_context.cj     # 10 个实例方法 (Mutex 保护)
```

**依赖关系**:
```
exception_utils.cj          (无内部依赖)
exception_context.cj        (无内部依赖)
default_exception_context.cj → exception_context.cj
```

---

## ⚡ 关键实现算法

### 1. 获取根因异常

```cangjie
public static func getRootCause(throwable: Exception): Exception {
    var rootCause = throwable
    while (let Some(cause) <- rootCause.cause) {
        rootCause = cause
    }
    rootCause
}
```

**时间复杂度**: O(n)，n 为异常链长度

---

### 2. 检查异常类型

```cangjie
public static func hasCause(throwable: Exception, typeStr: String): Bool {
    var cause = throwable.cause
    while (let Some(c) <- cause) {
        let className = c.getClassName()
        if (className == typeStr || className.endsWith(".${typeStr}")) {
            return true
        }
        cause = c.cause
    }
    false
}
```

**特点**:
- ✅ 支持精确匹配 (`"IllegalArgumentException"`)
- ✅ 支持后缀匹配 (`".IllegalArgumentException"`)
- ⚠️ 不检查自身，仅检查 cause 链

---

### 3. 格式化异常消息

```cangjie
public static func getMessage(throwable: Exception): String {
    let sb = StringBuilder()
    var current: Option<Exception> = Some(throwable)

    while (let Some(ex) <- current) {
        if (sb.size > 0) {
            sb.append("\n  Caused by: ")
        }
        sb.append(formatException(ex))
        current = ex.cause
    }

    sb.toString()
}
```

**示例输出**:
```
IllegalArgumentException: Invalid parameter
  Caused by: NumberFormatException: For input string: "abc"
  Caused by: ArithmeticException: Division by zero
```

---

### 4. 线程安全的上下文

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

**特点**:
- ✅ 使用 `Mutex` 保护写操作
- ✅ 支持多值标签 (`ArrayList`)
- ✅ 返回 `this` 支持链式调用

---

## 📝 使用示例速查

### 示例 1: 异常链遍历

```cangjie
import commons_lang4cj.exception.*

main() {
    let root = ArithmeticException("Division by zero")
    let wrapper = IllegalArgumentException("Invalid parameter", root)

    // 获取根因
    let rootCause = ExceptionUtils.getRootCause(wrapper)
    println(rootCause.message)  // "Division by zero"

    // 获取完整消息
    let msg = ExceptionUtils.getMessage(wrapper)
    println(msg)

    // 检查异常类型
    if (ExceptionUtils.hasCause(wrapper, "ArithmeticException")) {
        println("Contains ArithmeticException")
    }
}
```

---

### 示例 2: 异常上下文

```cangjie
main() {
    let context = DefaultExceptionContext()

    // 链式添加
    context.addValue("userId", "12345")
           .addValue("operation", "createOrder")
           .addValue("retryCount", 3)

    // 格式化输出
    let msg = context.getFormattedContext("Order failed")
    println(msg)
    // 输出:
    // Order failed
    // Exception details:
    //   userId: 12345
    //   operation: createOrder
    //   retryCount: 3

    // 查询值
    if (let Some(userId) <- context.getFirstValue("userId")) {
        println("User ID: ${userId}")
    }
}
```

---

## ⚠️ 仓颉语言适配说明

### 已知限制

| 功能 | Java | 仓颉 | 说明 |
|------|------|------|------|
| 类型反射 | `instanceof` | 字符串匹配 ⚠️ | 使用 `getClassName()` |
| 堆栈跟踪 | `getStackTrace()` | 可能不支持 ⚠️ | 依赖标准库 |
| 设置堆栈 | `setStackTrace()` | 不支持 ❌ | 方法存在但无操作 |
| 异常链 | `getCause()` | `cause: Option<Exception>` | 使用 Option 模式 ✅ |

### API 差异

**Java**:
```java
if (ex.getCause() != null) {
    Throwable cause = ex.getCause();
}
```

**仓颉**:
```cangjie
if (let Some(cause) <- ex.cause) {
    // 处理 cause
}
```

---

## 📊 测试策略

### 测试文件

| 文件 | 测试用例数 | 覆盖率目标 |
|------|-----------|-----------|
| `exception_utils_test.cj` | 20-25 个 | ≥ 90% |
| `default_exception_context_test.cj` | 15-20 个 | ≥ 90% |

**总计**: 35-45 个测试用例

---

### 关键测试用例

**ExceptionUtils**:
- ✅ `testGetRootCauseNoCause` - 无 cause 返回自身
- ✅ `testGetRootCauseMultipleCauses` - 多层 cause
- ✅ `testHasCauseExactMatch` - 精确类型匹配
- ✅ `testHasCauseSuffixMatch` - 后缀匹配
- ✅ `testHasCycle` - 循环引用检测

**DefaultExceptionContext**:
- ✅ `testAddValueChaining` - 链式调用
- ✅ `testGetFormattedContext` - 格式化输出
- ✅ `testAddValueThreadSafety` - 线程安全性

---

## 🎯 验收标准

### 编译标准
- [ ] `cjpm build` 无错误
- [ ] `cjpm build` 无警告
- [ ] 所有公共方法有文档注释

### 测试标准
- [ ] 测试覆盖率 ≥ 90%
- [ ] 所有测试用例通过
- [ ] 线程安全性测试通过

### 代码质量
- [ ] 私有字段使用 `_` 前缀
- [ ] 命名符合仓颉规范
- [ ] 无 TODO 或 FIXME

---

## 📦 交付清单

### 代码文件 (5 个)
- [ ] `src/exception/exception_utils.cj`
- [ ] `src/exception/exception_context.cj`
- [ ] `src/exception/default_exception_context.cj`
- [ ] `src/exception/exception_utils_test.cj`
- [ ] `src/exception/default_exception_context_test.cj`

### 文档文件 (4 个)
- [ ] `doc/exception_package_design.md` (详细设计)
- [ ] `doc/exception_api_reference.md` (API 文档)
- [ ] `doc/exception_summary.md` (本文档)
- [ ] 更新 `README.md`

---

## ⏱️ 工时估算

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

## 🚀 下一步行动

### 立即开始 (@Developer)
1. 创建 `src/exception/` 目录
2. 实现 `ExceptionUtils` (18 个方法)
3. 实现 `ExceptionContext` 接口
4. 实现 `DefaultExceptionContext` (10 个方法)
5. 编写测试用例 (35-45 个)
6. 编译验证: `cjpm build`
7. 测试验证: `cjpm test`

### 代码审查 (@Guardian)
8. 检查命名规范
9. 检查文档注释
10. 检查线程安全性
11. 验证测试覆盖率

---

## 📚 参考资源

- **详细设计**: `doc/exception_package_design.md`
- **Java 原项目**: `org.apache.commons.lang3.exception`
- **仓颉标准库**: `std.collection.*`, `std.sync.*`

---

**总结文档版本**: v1.0.0
**最后更新**: 2026-01-19
**设计者**: @Architect
**状态**: ✅ 设计完成，等待实现

