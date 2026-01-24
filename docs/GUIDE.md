# commons-lang4cj 用户指南

本指南详细介绍了 `commons-lang4cj` 库中各个模块的功能与使用场景。

## 目录

1.  [Core Utils (核心工具)](#core-utils)
2.  [Concurrent (并发工具)](#concurrent)
3.  [Time (时间工具)](#time)
4.  [Builder (构建器)](#builder)
5.  [Math (数学工具)](#math)
6.  [其他模块](#others)

---

## <a id="core-utils"></a>1. Core Utils (核心工具)

### StringUtils
处理字符串的核心类，提供空值安全的操作。
- `isEmpty / isBlank`: 检查字符串状态。
- `trim / strip`: 去除空白。
- `substring / left / right`: 截取子串。
- `join`: 字符串拼接。

### ValidateUtils
用于防御性编程，验证参数有效性。
- `isTrue`: 断言布尔值。
- `notNone`: 断言 Option 不为 None。
- `notEmpty`: 断言集合或字符串不为空。
- `validState`: 断言对象状态。

```cangjie
ValidateUtils.isTrue(age > 0, "Age must be positive")
let val = ValidateUtils.notNone(optValue, "Value cannot be None")
```

---

## <a id="concurrent"></a>2. Concurrent (并发工具)

### Memoizer
实现高并发场景下的计算结果缓存。它使用 `ConcurrentHashMap` 存储 `Future`，确保对于同一个 Key，计算逻辑只会被执行一次，即使多个线程同时请求。

### CircuitBreaker (熔断器)
提供系统保护机制。
- `EventCountCircuitBreaker`: 基于事件计数（错误数/请求数）触发熔断。
- `ThresholdCircuitBreaker`: 基于阈值触发。

### BackgroundInitializer
用于后台安全地初始化资源，支持获取初始化过程中的异常。

---

## <a id="time"></a>3. Time (时间工具)

### DateUtils
弥补 `std.time.DateTime` 在日期计算方面的便捷性。
- `addYears / addMonths / addDays`: 日期加减。
- `truncate`: 日期截断（如截断到天、小时）。
- `isSameDay`: 比较日期。
- `parseDate`: 支持多种格式尝试解析。

### StopWatch
用于代码计时和性能分析。支持 `start`, `stop`, `split`, `suspend`, `resume`。

---

## <a id="builder"></a>4. Builder (构建器)

### ToStringBuilder
辅助实现 `toString()` 方法。
```cangjie
public func toString(): String {
    return ToStringBuilder(this)
        .append("id", id)
        .append("name", name)
        .build()
}
```

### EqualsBuilder & HashCodeBuilder
辅助实现 `equals` 和 `hashCode`，确保两者的一致性。

---

## <a id="math"></a>5. Math (数学工具)

### Fraction
提供分数的数学运算（加减乘除、约分、倒数）。
```cangjie
let f1 = Fraction.getFraction(1, 3) // 1/3
let f2 = Fraction.getFraction(1, 6) // 1/6
let result = f1.add(f2)             // 1/2
```

---

## <a id="others"></a>6. 其他模块

- **Mutable**: `MutableInt`, `MutableBoolean` 等，用于需要在 lambda 或闭包中修改数值的场景。
- **Tuple**: `Pair<L, R>` 和 `Triple<L, M, R>`，用于函数返回多个值。
- **RandomUtils**: 提供简便的随机数生成方法（包括随机字符串）。
- **SystemUtils**: 获取当前操作系统、仓颉版本、用户目录等信息。
