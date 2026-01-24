# Time 包设计文档 (Design Document)

> **包名**: `commons_lang4cj.time`
> **版本**: v1.2.0
> **日期**: 2026-01-20
> **架构师**: @Architect
> **参考**: Apache Commons Lang `org.apache.commons.lang3.time`

---

## 📋 目录

1. [设计概述](#设计概述)
2. [仓颉标准库能力分析](#仓颉标准库能力分析)
3. [核心类设计](#核心类设计)
4. [架构决策记录 (ADR)](#架构决策记录-adr)
5. [API 设计详情](#api-设计详情)
6. [实现指南](#实现指南)
7. [测试策略](#测试策略)
8. [依赖分析](#依赖分析)
9. [优先级排序](#优先级排序)

---

## 设计概述

### 目标

为 commons-lang4cj 项目提供**时间日期工具类**，补充仓颉标准库 `std.time.*` 的高层实用功能。

### 设计原则

1. **不重复造轮子**: 充分利用 `std.time.DateTime`, `std.time.MonoTime`, `std.time.Duration`
2. **工具类定位**: 提供**便捷方法**和**格式化功能**，而非基础时间类型
3. **简化实现**: 避免复杂的时区逻辑和日期计算（标准库已提供）
4. **实用主义**: 优先实现**高频使用场景**（StopWatch、DurationFormatUtils）

---

## 仓颉标准库能力分析

### ✅ 已有功能（可直接使用）

#### 1. `std.time.DateTime` - 日期时间结构体

**功能**：
- ✅ 日期时间表示（年月日时分秒纳秒）
- ✅ 时区支持（`TimeZone`）
- ✅ 日期时间计算（`+` `-` 操作符）
- ✅ 日期时间比较（`<` `>` `<=` `>=` `==` `!=`）
- ✅ 格式化输出（`format(pattern)`）
- ✅ 字符串解析（`DateTime.parse(str, pattern)`）

**核心属性**：
```cangjie
public struct DateTime {
    public static prop UnixEpoch: DateTime
    public prop year: Int64
    public prop month: Month
    public prop dayOfMonth: Int64
    public prop hour: Int64
    public prop minute: Int64
    public prop second: Int64
    public prop nanosecond: Int64
    public prop zone: TimeZone
    // ...
}
```

**关键方法**：
```cangjie
public static func now(timeZone!: TimeZone = TimeZone.Local): DateTime
public static func nowUTC(): DateTime
public static func fromUnixTimeStamp(d: Duration): DateTime
public func format(pattern: String): String
```

#### 2. `std.time.MonoTime` - 单调时间（秒表）

**功能**：
- ✅ 单调递增时间（不受系统时间调整影响）
- ✅ 高精度纳秒级计时
- ✅ 时间间隔计算（`-` 操作符）
- ✅ 可比较性（`<` `>` `<=` `>=` `==` `!=`）

**核心方法**：
```cangjie
public struct MonoTime {
    public static func now(): MonoTime
    public operator func -(r: MonoTime): Duration
    public operator func <(r: MonoTime): Bool
    // ...
}
```

#### 3. `std.time.Duration` - 时间间隔

**功能**：
- ✅ 时间间隔表示（秒 + 纳秒）
- ✅ 时间单位常量（`second`, `millisecond`, `microsecond`, `nanosecond`）
- ✅ 时间单位转换（`toMilliseconds`, `toMicroseconds`, `toNanoseconds`）
- ✅ 算术运算（`+` `-` `*` `/`）

**核心常量**：
```cangjie
public struct Duration {
    public static const nanosecond: Duration
    public static const microsecond: Duration
    public static const millisecond: Duration
    public static const second: Duration
    public static const minute: Duration
    public static const hour: Duration
    public static const day: Duration
}
```

#### 4. `std.time.DateTimeFormat` - 日期时间格式化

**功能**：
- ✅ 日期时间格式化（`format`）
- ✅ 日期时间解析（`parse`）
- ✅ 支持丰富的格式占位符（`yyyy`, `MM`, `dd`, `HH`, `mm`, `ss`, `SSS` 等）

**格式占位符**：
```
y - 年（如 yyyy = 2024）
M - 月（如 MM = 01-12）
d - 日（如 dd = 01-31）
H - 小时（24小时制，如 HH = 00-23）
m - 分钟（如 mm = 00-59）
s - 秒（如 ss = 00-59）
S - 毫秒/微秒/纳秒（如 SSS = 毫秒）
z - 时区名（如 CST）
Z - 时区偏移（如 +0800）
```

### ❌ 缺失功能（需要实现）

1. **StopWatch** - 秒表计时工具（标准库没有）
2. **DurationFormatUtils** - 持续时间人性化格式化（标准库只支持 DateTime 格式化）
3. **DateFormatUtils** - 常用日期格式快捷方法（标准库需要手动指定格式）
4. **DateUtils** - 日期计算辅助方法（如 `isSameDay`, `truncate`, `round`）

---

## 核心类设计

### 1. StopWatch 类（秒表）- 🟢 P0 最高优先级

**功能定位**：
- 测量时间间隔（性能测试、基准测试）
- 支持暂停、恢复、复位
- 支持分段计时（split）
- 提供多种时间格式输出

**核心状态**：
```cangjie
public class StopWatch {
    // 私有字段（必须使用 _ 前缀）
    private var _startTime: MonoTime       // 开始时间
    private var _stopTime: Option<MonoTime>   // 停止时间（可能为空）
    private var _splitTime: Option<MonoTime>  // 分段时间（可能为空）
    private var _suspendedTime: Option<MonoTime> // 暂停时间（可能为空）
    private var _accumulatedTime: Duration  // 累计暂停时长（用于多次暂停/恢复）
}
```

**核心方法**：
```cangjie
public class StopWatch {
    // 工厂方法
    public static func create(): StopWatch

    // 计时控制
    public func start(): Unit                           // 开始计时
    public func stop(): Unit                            // 停止计时
    public func reset(): Unit                           // 复位（清零）
    public func split(): Unit                           // 分段计时（记录当前时间点）
    public func unsplit(): Unit                         // 取消分段
    public func suspend(): Unit                         // 暂停（临时停止）
    public func resume(): Unit                          // 恢复（从暂停继续）

    // 时间查询（返回毫秒）
    public func getTime(): Int64                        // 总耗时（毫秒）
    public func getNanoTime(): Int64                    // 总耗时（纳秒）
    public func getSplitTime(): Int64                   // 分段耗时（毫秒）
    public func getStartTime(): Int64                   // 开始时间戳（毫秒，从 UnixEpoch 计算）

    // 状态查询
    public func isStarted(): Bool                       // 是否已开始
    public func isStopped(): Bool                       // 是否已停止
    public func isSuspended(): Bool                     // 是否已暂停
    public func isSplit(): Bool                         // 是否分段中

    // 格式化输出
    public func toString(): String                      // "00:00:05.123" (HH:mm:ss.SSS)
    public func toSplitString(): String                 // 分段时间字符串

    // 私有辅助方法
    private func getCurrentTime(): Duration             // 获取当前运行时长
}
```

**使用示例**：
```cangjie
import commons_lang4cj.time.*

main() {
    // 基础用法
    let sw = StopWatch.create()
    sw.start()
    // ... 执行任务 ...
    sw.stop()
    println("耗时: ${sw.getTime()}ms")        // 输出: 耗时: 1234ms
    println(sw.toString())                   // 输出: 00:00:01.234

    // 分段计时
    let sw2 = StopWatch.create()
    sw2.start()
    task1()
    sw2.split()
    task2()
    sw2.split()
    task3()
    sw2.stop()

    println("分段1: ${sw2.toSplitString()}")   // 第一次分段时间
    sw2.unsplit()
    println("分段2: ${sw2.toSplitString()}")   // 第二次分段时间

    // 暂停/恢复
    let sw3 = StopWatch.create()
    sw3.start()
    taskA()
    sw3.suspend()
    doSomethingElse()  // 不计时的代码
    sw3.resume()
    taskB()
    sw3.stop()
    println("净耗时: ${sw3.getTime()}ms")
}
```

**实现要点**：
1. 使用 `std.time.MonoTime.now()` 获取单调时间（不受系统时间影响）
2. 使用 `Option<MonoTime>` 表示可能为空的时间点（仓颉没有 null）
3. 暂停/恢复需要记录暂停前的累计时长
4. 分段计时通过 `splitTime` 记录分段点，`unsplit` 后继续计时

---

### 2. DurationFormatUtils 类（持续时间格式化）- 🟢 P0

**功能定位**：
- 将毫秒/纳秒时长格式化为可读字符串
- 支持自定义格式
- 纯数学计算，不依赖 DateTime

**核心方法**：
```cangjie
public class DurationFormatUtils {
    // 格式化持续时间（默认格式："1天 2小时 3分 4秒"）
    public static func formatDuration(millis: Int64): String

    // 格式化持续时间为 HH:mm:ss（小时可能超过 24）
    public static func formatDurationHMS(millis: Int64): String  // "120:30:45"

    // 格式化持续时间为 ISO8601 duration 格式（如 "PT1H2M3S"）
    public static func formatDurationISO(millis: Int64): String

    // 格式化持续时间为英文单词形式（如 "1 day 2 hours 3 minutes"）
    public static func formatDurationWords(millis: Int64): String

    // 自定义格式化（使用占位符）
    public static func formatDuration(millis: Int64, format: String): String
    // 占位符：
    //   %d - 天
    //   %H - 小时（24小时制）
    //   %m - 分钟
    //   %s - 秒
    //   %S - 毫秒
}
```

**使用示例**：
```cangjie
import commons_lang4cj.time.*

main() {
    let millis = 90061234  // 1天 1小时 1分 1秒 234毫秒

    println(DurationFormatUtils.formatDuration(millis))
    // 输出: "1天 1小时 1分 1秒"

    println(DurationFormatUtils.formatDurationHMS(millis))
    // 输出: "25:01:01"

    println(DurationFormatUtils.formatDurationISO(millis))
    // 输出: "PT25H1M1.234S"

    println(DurationFormatUtils.formatDurationWords(millis))
    // 输出: "1 day 1 hour 1 minute 1 second"

    println(DurationFormatUtils.formatDuration(millis, "%H小时%m分%s秒"))
    // 输出: "25小时1分1秒"
}
```

**实现要点**：
1. 纯数学计算，通过除法和取模获取天、时、分、秒、毫秒
2. 处理负数时长（前面加 `-` 号）
3. 支持零值的友好显示（如 "0秒"）
4. ISO8601 格式需要符合规范（`P[n]DT[n]H[n]M[n]S`）

---

### 3. DateFormatUtils 类（日期格式化快捷方法）- 🟡 P1

**功能定位**：
- 将时间戳（毫秒）格式化为常用日期字符串
- 提供标准日期格式的快捷方法
- 封装 `std.time.DateTime.format()`，简化使用

**核心方法**：
```cangjie
public class DateFormatUtils {
    // 自定义格式化
    public static func format(millis: Int64, pattern: String): String
    public static func formatUTC(millis: Int64, pattern: String): String  // UTC 时区

    // 常用格式快捷方法
    public static func formatTime(millis: Int64): String       // "HH:mm:ss" (如 "15:30:45")
    public static func formatDate(millis: Int64): String       // "yyyy-MM-dd" (如 "2024-01-20")
    public static func formatDateTime(millis: Int64): String   // "yyyy-MM-dd HH:mm:ss" (如 "2024-01-20 15:30:45")
    public static func formatISO(millis: Int64): String        // ISO8601 格式（如 "2024-01-20T15:30:45+08:00"）

    // 带毫秒的格式
    public static func formatDateTimeMillis(millis: Int64): String  // "yyyy-MM-dd HH:mm:ss.SSS" (如 "2024-01-20 15:30:45.123")
}
```

**使用示例**：
```cangjie
import commons_lang4cj.time.*

main() {
    let timestamp = 1705743045123  // 2024-01-20 15:30:45.123

    println(DateFormatUtils.formatDate(timestamp))
    // 输出: "2024-01-20"

    println(DateFormatUtils.formatTime(timestamp))
    // 输出: "15:30:45"

    println(DateFormatUtils.formatDateTime(timestamp))
    // 输出: "2024-01-20 15:30:45"

    println(DateFormatUtils.formatDateTimeMillis(timestamp))
    // 输出: "2024-01-20 15:30:45.123"

    println(DateFormatUtils.formatISO(timestamp))
    // 输出: "2024-01-20T15:30:45+08:00"

    // 自定义格式
    println(DateFormatUtils.format(timestamp, "yyyy年MM月dd日"))
    // 输出: "2024年01月20日"
}
```

**实现要点**：
1. 使用 `std.time.DateTime.fromUnixTimeStamp()` 将毫秒时间戳转换为 DateTime
2. 调用 `DateTime.format(pattern)` 进行格式化
3. UTC 格式使用 `TimeZone.UTC` 或 `DateTime.fromUnixTimeStamp().inTimeZone(TimeZone.UTC)`
4. ISO8601 格式使用标准库的内置格式

---

### 4. DateUtils 类（日期工具）- 🟠 P2（可选）

**功能定位**：
- 日期计算辅助方法（加减天数、月数、年数）
- 日期比较（是否同一天、是否同一月等）
- 日期截断（truncate to day/month/year）
- 日期四舍五入（round）

**⚠️ 可行性评估**：
- ✅ 日期计算：标准库 `DateTime` 支持 `+` `-` 操作符与 `Duration` 运算
- ✅ 日期比较：标准库 `DateTime` 支持比较操作符
- ⚠️ 日期截断：需要自定义实现（没有现成 API）
- ⚠️ 日期四舍五入：需要自定义实现（没有现成 API）

**核心方法**（待实现）：
```cangjie
public class DateUtils {
    // 日期计算（基于时间戳）
    public static func addDays(millis: Int64, amount: Int32): Int64
    public static func addHours(millis: Int64, amount: Int32): Int64
    public static func addMinutes(millis: Int64, amount: Int32): Int64
    public static func addSeconds(millis: Int64, amount: Int32): Int64
    public static func addWeeks(millis: Int64, amount: Int32): Int64
    public static func addMonths(millis: Int64, amount: Int32): Int64  // ⚠️ 复杂
    public static func addYears(millis: Int64, amount: Int32): Int64   // ⚠️ 复杂

    // 日期比较
    public static func isSameDay(millis1: Int64, millis2: Int64): Bool
    public static func isSameLocalDate(millis1: Int64, millis2: Int64): Bool  // 本地时区
    public static func isSameUTCTime(millis1: Int64, millis2: Int64): Bool    // UTC 时区

    // 日期截断（将时间截断到指定精度）
    public static func truncate(millis: Int64, field: DateField): Int64  // 截断到天/月/年
    public static func round(millis: Int64, field: DateField): Int64     // 四舍五入到天/月/年
    public static func ceil(millis: Int64, field: DateField): Int64      // 向上取整到天/月/年

    // 日期常量
    public static const MILLIS_PER_DAY: Int64 = 86400000
    public static const MILLIS_PER_HOUR: Int64 = 3600000
    public static const MILLIS_PER_MINUTE: Int64 = 60000
    public static const MILLIS_PER_SECOND: Int64 = 1000
}

// 日期字段枚举
public enum DateField {
    | Year       // 截断到年（1月1日 00:00:00.000）
    | Month      // 截断到月（本月1日 00:00:00.000）
    | Day        // 截断到日（当天 00:00:00.000）
    | Hour       // 截断到小时（某分 00:00.000）
    | Minute     // 截断到分钟（某秒 .000）
    | Second     // 截断到秒（毫秒归零）
}
```

**使用示例**：
```cangjie
import commons_lang4cj.time.*

main() {
    let now = 1705743045123  // 2024-01-20 15:30:45.123

    // 日期计算
    let tomorrow = DateUtils.addDays(now, 1)
    let nextWeek = DateUtils.addWeeks(now, 1)

    // 日期比较
    let date1 = 1705743045123
    let date2 = 1705743046000  // 同一天
    println(DateUtils.isSameDay(date1, date2))  // 输出: true

    // 日期截断
    let truncated = DateUtils.truncate(now, DateField.Day)  // 2024-01-20 00:00:00.000
    let rounded = DateUtils.round(now, DateField.Hour)      // 2024-01-20 16:00:00.000
}
```

**实现要点**：
1. `addDays/Hours/Minutes/Seconds`：直接使用 `DateTime + Duration`
2. `addMonths/Years`：需要手动计算（月份可能溢出，如 1月31日 + 1个月 = 2月29日？）
3. `isSameDay`：比较年、月、日是否相等
4. `truncate`：将时间部分归零（如截断到天，则时分秒毫秒归零）
5. `round`：根据阈值（如半天）决定向上或向下取整

**⚠️ 实现复杂度**：
- `addMonths` 和 `addYears`：需要处理闰年、不同月份天数（28/29/30/31）
- `truncate` 和 `round`：需要手动构建 DateTime 并转换回时间戳

---

## 架构决策记录 (ADR)

### ADR-001: StopWatch 基于 MonoTime 实现

**背景**：需要实现秒表计时功能，有两种选择：
- 选项 A：使用 `std.time.DateTime.now()`（受系统时间影响）
- 选项 B：使用 `std.time.MonoTime.now()`（不受系统时间影响）

**决策**：选择 **选项 B（MonoTime）**

**理由**：
1. **单调递增**：MonoTime 保证单调递增，不受系统时间调整影响（如 NTP 同步）
2. **高精度**：MonoTime 提供纳秒级精度，适合性能测试
3. **标准库推荐**：仓颉官方文档明确推荐 MonoTime 用于性能测试

**风险**：
- MonoTime 是相对时间，无法转换为绝对时间戳（但不影响秒表功能）

---

### ADR-002: DateUtils 类延后实现（P2 优先级）

**背景**：DateUtils 类涉及复杂的日期计算（addMonths, addYears, truncate, round），需要评估实现复杂度。

**决策**：**延后实现 DateUtils**（标记为 P2 可选）

**理由**：
1. **低频使用场景**：日期计算相比 StopWatch 和格式化工具，使用频率较低
2. **实现复杂度高**：addMonths 和 addYears 需要处理闰年、月份天数等边缘情况
3. **标准库已提供基础能力**：DateTime 已支持 `+` `-` 操作符，可以手动计算
4. **性价比低**：投入大量时间实现，但实际使用价值有限

**替代方案**：
- 用户可以使用 `DateTime + Duration` 手动进行简单计算
- 未来如果需求强烈，再补充实现

---

### ADR-003: DurationFormatUtils 纯数学计算

**背景**：DurationFormatUtils 需要将毫秒时长格式化，有两种实现方式：
- 选项 A：使用 `DateTime.fromUnixTimeStamp()` + `DateTime.format()`
- 选项 B：纯数学计算（除法和取模）

**决策**：选择 **选项 B（纯数学计算）**

**理由**：
1. **不依赖时区**：时长与时区无关，DateTime 会引入时区复杂性
2. **性能更好**：纯数学计算比 DateTime 创建和格式化更快
3. **支持超大时长**：不受 DateTime 表示范围限制（可以格式化 1000 天）
4. **逻辑清晰**：通过除法和取模，代码更易理解

**示例**：
```cangjie
// 90061234 毫秒 = 1天 1小时 1分 1秒 234毫秒
let days = millis / 86400000                    // 1
let hours = (millis % 86400000) / 3600000        // 1
let minutes = (millis % 3600000) / 60000         // 1
let seconds = (millis % 60000) / 1000            // 1
let milliseconds = millis % 1000                // 234
```

---

### ADR-004: DateFormatUtils 封装标准库 DateTime.format()

**背景**：DateFormatUtils 需要将时间戳格式化为日期字符串，有两种实现方式：
- 选项 A：直接封装 `DateTime.format(pattern)`
- 选项 B：重新实现格式化逻辑（如手动拼接字符串）

**决策**：选择 **选项 A（封装标准库）**

**理由**：
1. **标准库功能完善**：`DateTime.format()` 已支持丰富的格式占位符
2. **避免重复造轮子**：重新实现格式化逻辑工作量大且容易出错
3. **保持兼容性**：依赖标准库，确保格式化行为一致
4. **简化维护**：标准库升级时，自动获得新功能

**风险**：
- 无明显风险，标准库 DateTime 功能稳定

---

## API 设计详情

### 完整方法签名表

#### 1. StopWatch 类

| 方法名 | 返回类型 | 功能说明 | 异常 |
|--------|---------|---------|------|
| `create()` | `StopWatch` | 创建新的秒表实例 | - |
| `start()` | `Unit` | 开始计时 | `IllegalStateException`（已开始时调用） |
| `stop()` | `Unit` | 停止计时 | `IllegalStateException`（未开始或已停止时调用） |
| `reset()` | `Unit` | 复位（清零） | - |
| `split()` | `Unit` | 分段计时（记录当前时间点） | `IllegalStateException`（未开始或已停止时调用） |
| `unsplit()` | `Unit` | 取消分段 | `IllegalStateException`（未分段时调用） |
| `suspend()` | `Unit` | 暂停（临时停止） | `IllegalStateException`（未开始、已停止或已暂停时调用） |
| `resume()` | `Unit` | 恢复（从暂停继续） | `IllegalStateException`（未暂停时调用） |
| `getTime()` | `Int64` | 获取总耗时（毫秒） | - |
| `getNanoTime()` | `Int64` | 获取总耗时（纳秒） | - |
| `getSplitTime()` | `Int64` | 获取分段耗时（毫秒） | `IllegalStateException`（未分段时调用） |
| `getStartTime()` | `Int64` | 获取开始时间戳（毫秒，从 UnixEpoch 计算） | `IllegalStateException`（未开始时调用） |
| `isStarted()` | `Bool` | 是否已开始 | - |
| `isStopped()` | `Bool` | 是否已停止 | - |
| `isSuspended()` | `Bool` | 是否已暂停 | - |
| `isSplit()` | `Bool` | 是否分段中 | - |
| `toString()` | `String` | 格式化输出（"HH:mm:ss.SSS"） | - |
| `toSplitString()` | `String` | 分段时间字符串（"HH:mm:ss.SSS"） | `IllegalStateException`（未分段时调用） |

#### 2. DurationFormatUtils 类

| 方法名 | 返回类型 | 功能说明 | 异常 |
|--------|---------|---------|------|
| `formatDuration(millis: Int64)` | `String` | 格式化持续时间（"1天 2小时 3分 4秒"） | - |
| `formatDurationHMS(millis: Int64)` | `String` | 格式化为 "HH:mm:ss"（小时可能超过 24） | - |
| `formatDurationISO(millis: Int64)` | `String` | 格式化为 ISO8601 duration（"PT1H2M3S"） | - |
| `formatDurationWords(millis: Int64)` | `String` | 格式化为英文单词（"1 day 2 hours"） | - |
| `formatDuration(millis: Int64, format: String)` | `String` | 自定义格式化（占位符：%d, %H, %m, %s, %S） | - |

#### 3. DateFormatUtils 类

| 方法名 | 返回类型 | 功能说明 | 异常 |
|--------|---------|---------|------|
| `format(millis: Int64, pattern: String)` | `String` | 自定义格式化（本地时区） | `IllegalArgumentException`（格式非法） |
| `formatUTC(millis: Int64, pattern: String)` | `String` | 自定义格式化（UTC 时区） | `IllegalArgumentException`（格式非法） |
| `formatTime(millis: Int64)` | `String` | 格式化为 "HH:mm:ss" | - |
| `formatDate(millis: Int64)` | `String` | 格式化为 "yyyy-MM-dd" | - |
| `formatDateTime(millis: Int64)` | `String` | 格式化为 "yyyy-MM-dd HH:mm:ss" | - |
| `formatISO(millis: Int64)` | `String` | 格式化为 ISO8601 | - |
| `formatDateTimeMillis(millis: Int64)` | `String` | 格式化为 "yyyy-MM-dd HH:mm:ss.SSS" | - |

#### 4. DateUtils 类（可选，延后实现）

| 方法名 | 返回类型 | 功能说明 | 异常 |
|--------|---------|---------|------|
| `addDays(millis: Int64, amount: Int32)` | `Int64` | 加天数 | - |
| `addHours(millis: Int64, amount: Int32)` | `Int64` | 加小时 | - |
| `addMinutes(millis: Int64, amount: Int32)` | `Int64` | 加分钟 | - |
| `addSeconds(millis: Int64, amount: Int32)` | `Int64` | 加秒 | - |
| `addWeeks(millis: Int64, amount: Int32)` | `Int64` | 加周数 | - |
| `isSameDay(millis1: Int64, millis2: Int64)` | `Bool` | 是否同一天（本地时区） | - |
| `isSameUTCTime(millis1: Int64, millis2: Int64)` | `Bool` | 是否同一 UTC 时间 | - |
| `truncate(millis: Int64, field: DateField)` | `Int64` | 截断到指定精度 | - |
| `round(millis: Int64, field: DateField)` | `Int64` | 四舍五入到指定精度 | - |

---

## 实现指南

### 文件结构

```
commons-lang4cj/src/time/
├── stop_watch.cj                 # StopWatch 类（~400 行）
├── duration_format_utils.cj      # DurationFormatUtils 类（~300 行）
├── date_format_utils.cj          # DateFormatUtils 类（~200 行）
├── date_utils.cj                 # DateUtils 类（可选，~400 行）
└── date_field.cj                 # DateField 枚举（~20 行）

commons-lang4cj/src/time_test/
├── stop_watch_test.cj            # StopWatch 测试（~500 行）
├── duration_format_utils_test.cj # DurationFormatUtils 测试（~300 行）
├── date_format_utils_test.cj     # DateFormatUtils 测试（~200 行）
└── date_utils_test.cj            # DateUtils 测试（可选，~400 行）
```

### 实现顺序

**Phase 1: StopWatch（4-6 小时）**
1. 定义 StopWatch 类和私有字段（`_startTime`, `_stopTime` 等）
2. 实现 `create()`, `start()`, `stop()`, `reset()` 核心方法
3. 实现 `getTime()`, `getNanoTime()`, `getStartTime()` 查询方法
4. 实现 `split()`, `unsplit()` 分段计时功能
5. 实现 `suspend()`, `resume()` 暂停/恢复功能
6. 实现 `toString()`, `toSplitString()` 格式化输出
7. 实现状态查询方法（`isStarted()`, `isStopped()` 等）
8. 编写单元测试（~20 个测试用例）

**Phase 2: DurationFormatUtils（3-4 小时）**
1. 实现 `formatDuration()`（默认格式）
2. 实现 `formatDurationHMS()`（HH:mm:ss 格式）
3. 实现 `formatDurationISO()`（ISO8601 duration 格式）
4. 实现 `formatDurationWords()`（英文单词格式）
5. 实现自定义格式化（占位符替换）
6. 处理边缘情况（负数、零值）
7. 编写单元测试（~15 个测试用例）

**Phase 3: DateFormatUtils（2-3 小时）**
1. 实现 `format()`, `formatUTC()` 基础方法
2. 实现常用格式快捷方法（`formatTime`, `formatDate` 等）
3. 实现 ISO8601 格式化
4. 编写单元测试（~10 个测试用例）

**Phase 4: DateUtils（4-6 小时，可选）**
1. 实现 `addDays/Hours/Minutes/Seconds`（简单）
2. 实现 `addWeeks`（基于天数）
3. 实现 `isSameDay`, `isSameUTCTime`（比较）
4. 实现 `truncate`（截断）
5. 实现 `round`（四舍五入）
6. 编写单元测试（~15 个测试用例）

### 关键实现要点

#### 1. StopWatch - 暂停/恢复逻辑

```cangjie
public func suspend() {
    if (!isStarted() || isStopped() || isSuspended()) {
        throw IllegalStateException("Cannot suspend")
    }
    _suspendedTime = Some(MonoTime.now())
}

public func resume() {
    if (!isSuspended()) {
        throw IllegalStateException("Not suspended")
    }
    let suspendEnd = MonoTime.now()
    let suspendDuration = suspendEnd - _suspendedTime.getOrThrow()
    _accumulatedTime = _accumulatedTime + suspendDuration
    _suspendedTime = None
}

private func getCurrentTime(): Duration {
    let now = MonoTime.now()
    var duration = now - _startTime
    if (let Some(suspended) <- _suspendedTime) {
        // 当前暂停中，计算到暂停前的时长
        duration = suspended - _startTime
    }
    duration = duration - _accumulatedTime
    return duration
}
```

#### 2. DurationFormatUtils - 纯数学计算

```cangjie
public static func formatDuration(millis: Int64): String {
    if (millis == 0) {
        return "0秒"
    }

    let isNegative = millis < 0
    var absMillis = if (isNegative) { -millis } else { millis }

    let days = absMillis / 86400000
    absMillis = absMillis % 86400000
    let hours = absMillis / 3600000
    absMillis = absMillis % 3600000
    let minutes = absMillis / 60000
    absMillis = absMillis % 60000
    let seconds = absMillis / 1000

    let parts = Array<String>()
    if (days > 0) { parts.append("${days}天") }
    if (hours > 0) { parts.append("${hours}小时") }
    if (minutes > 0) { parts.append("${minutes}分") }
    if (seconds > 0) { parts.append("${seconds}秒") }

    let result = if (parts.isEmpty) { "0秒" } else { parts.join(" ") }
    return if (isNegative) { "-${result}" } else { result }
}
```

#### 3. DateFormatUtils - 封装标准库

```cangjie
public static func format(millis: Int64, pattern: String): String {
    let duration = Duration(millis / 1000, (millis % 1000) * 1000000)
    let dateTime = DateTime.fromUnixTimeStamp(duration)
    return dateTime.format(pattern)
}

public static func formatUTC(millis: Int64, pattern: String): String {
    let duration = Duration(millis / 1000, (millis % 1000) * 1000000)
    let dateTime = DateTime.fromUnixTimeStamp(duration).inTimeZone(TimeZone.UTC)
    return dateTime.format(pattern)
}
```

---

## 测试策略

### 测试覆盖目标

- **StopWatch**: 20 个测试用例（覆盖所有状态转换）
- **DurationFormatUtils**: 15 个测试用例（覆盖所有格式化方法）
- **DateFormatUtils**: 10 个测试用例（覆盖所有快捷方法）
- **DateUtils**: 15 个测试用例（如果实现）

**总计：60 个测试用例（预估 45-50 个，如果不含 DateUtils）**

### 关键测试场景

#### 1. StopWatch 测试

```cangjie
@Test
class StopWatchTest {
    @TestCase
    func testBasicStartStop() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 100)
        sw.stop()
        let time = sw.getTime()
        @Expect(time >= 100 && time < 200, true)  // 100ms 左右
    }

    @TestCase
    func testSplit() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 50)
        sw.split()
        let splitTime = sw.getSplitTime()
        @Expect(splitTime >= 50 && splitTime < 100, true)

        sleep(Duration.millisecond * 50)
        sw.stop()
        let totalTime = sw.getTime()
        @Expect(totalTime >= 100 && totalTime < 200, true)
    }

    @TestCase
    func testSuspendResume() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 50)
        sw.suspend()

        sleep(Duration.millisecond * 50)  // 不计时

        sw.resume()
        sleep(Duration.millisecond * 50)
        sw.stop()

        let time = sw.getTime()
        @Expect(time >= 100 && time < 150, true)  // 约 100ms
    }

    @TestCase
    func testReset() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 100)
        sw.stop()
        sw.reset()

        @Expect(sw.isStarted(), false)
        @Expect(sw.isStopped(), false)
    }
}
```

#### 2. DurationFormatUtils 测试

```cangjie
@Test
class DurationFormatUtilsTest {
    @TestCase
    func testFormatDuration() {
        @Expect(DurationFormatUtils.formatDuration(90061000), "1天 1小时 1分 1秒")
        @Expect(DurationFormatUtils.formatDuration(3661000), "1小时 1分 1秒")
        @Expect(DurationFormatUtils.formatDuration(61000), "1分 1秒")
        @Expect(DurationFormatUtils.formatDuration(1000), "1秒")
        @Expect(DurationFormatUtils.formatDuration(0), "0秒")
        @Expect(DurationFormatUtils.formatDuration(-1000), "-1秒")
    }

    @TestCase
    func testFormatDurationHMS() {
        @Expect(DurationFormatUtils.formatDurationHMS(90061000), "25:01:01")
        @Expect(DurationFormatUtils.formatDurationHMS(3661000), "1:01:01")
        @Expect(DurationFormatUtils.formatDurationHMS(61000), "0:01:01")
    }

    @TestCase
    func testFormatDurationISO() {
        @Expect(DurationFormatUtils.formatDurationISO(3661000), "PT1H1M1S")
        @Expect(DurationFormatUtils.formatDurationISO(90061000), "PT25H1M1S")
    }
}
```

#### 3. DateFormatUtils 测试

```cangjie
@Test
class DateFormatUtilsTest {
    @TestCase
    func testFormatDate() {
        let timestamp = 1705743045000  // 2024-01-20 15:30:45
        let date = DateFormatUtils.formatDate(timestamp)
        @Expect(date, "2024-01-20")
    }

    @TestCase
    func testFormatTime() {
        let timestamp = 1705743045000  // 2024-01-20 15:30:45
        let time = DateFormatUtils.formatTime(timestamp)
        @Expect(time, "15:30:45")
    }

    @TestCase
    func testFormatDateTime() {
        let timestamp = 1705743045000  // 2024-01-20 15:30:45
        let dateTime = DateFormatUtils.formatDateTime(timestamp)
        @Expect(dateTime, "2024-01-20 15:30:45")
    }
}
```

---

## 依赖分析

### 外部依赖

| 包/模块 | 依赖类型 | 用途 | 可选性 |
|---------|---------|------|--------|
| `std.time.DateTime` | ✅ 必需 | 日期时间表示和格式化 | ❌ 不可选 |
| `std.time.MonoTime` | ✅ 必需 | 单调时间（StopWatch 计时） | ❌ 不可选 |
| `std.time.Duration` | ✅ 必需 | 时间间隔表示和计算 | ❌ 不可选 |
| `std.time.TimeZone` | ✅ 必需 | 时区支持（UTC 格式化） | ❌ 不可选 |
| `std.time.DateTimeFormat` | ❌ 不直接依赖 | 格式化逻辑（通过 DateTime.format()） | - |
| `std.collection.ArrayList` | ✅ 可选 | 字符串拼接（DurationFormatUtils） | ⚠️ 可用 StringBuilder 替代 |

### 内部依赖

| 模块 | 依赖类型 | 用途 |
|------|---------|------|
| `commons_lang4cj.exception` | ✅ 可选 | 异常类（如 `IllegalStateException`） |

**⚠️ 注意**：
- StopWatch 不依赖任何其他 commons-lang4cj 模块
- DurationFormatUtils 不依赖任何其他 commons-lang4cj 模块
- DateFormatUtils 不依赖任何其他 commons-lang4cj 模块
- DateUtils 不依赖任何其他 commons-lang4cj 模块

**结论**：time 包是**独立的工具包**，不依赖项目其他模块，可以优先开发。

---

## 优先级排序

### P0 - 必须实现（v1.2.0 核心功能）

1. **StopWatch**（4-6 小时）
   - 优先级：🔴 **最高**
   - 使用频率：⭐⭐⭐⭐⭐
   - 实现难度：⭐⭐⭐（中等）
   - 测试用例：20 个

2. **DurationFormatUtils**（3-4 小时）
   - 优先级：🔴 **高**
   - 使用频率：⭐⭐⭐⭐
   - 实现难度：⭐⭐（简单）
   - 测试用例：15 个

**P0 小计**：7-10 小时，35 个测试用例

---

### P1 - 应该实现（v1.2.0 增强功能）

3. **DateFormatUtils**（2-3 小时）
   - 优先级：🟡 **中**
   - 使用频率：⭐⭐⭐
   - 实现难度：⭐（很简单）
   - 测试用例：10 个

**P1 小计**：2-3 小时，10 个测试用例

---

### P2 - 可选实现（v1.3.0 或延后）

4. **DateUtils**（4-6 小时）
   - 优先级：🟠 **低**
   - 使用频率：⭐⭐
   - 实现难度：⭐⭐⭐⭐（复杂）
   - 测试用例：15 个
   - **建议**：延后到 v1.3.0，根据用户反馈决定是否实现

**P2 小计**：4-6 小时，15 个测试用例

---

## 总结

### 实现计划

| Phase | 模块 | 工时 | 测试用例 | 优先级 | 版本 |
|-------|------|------|---------|--------|------|
| Phase 1 | StopWatch | 4-6 小时 | 20 个 | P0 | v1.2.0 |
| Phase 2 | DurationFormatUtils | 3-4 小时 | 15 个 | P0 | v1.2.0 |
| Phase 3 | DateFormatUtils | 2-3 小时 | 10 个 | P1 | v1.2.0 |
| Phase 4 | DateUtils | 4-6 小时 | 15 个 | P2 | v1.3.0（可选） |

**v1.2.0 总计**：9-13 小时，45 个测试用例

**v1.3.0 总计**：4-6 小时，15 个测试用例（可选）

---

## 附录

### A. 参考资源

- **Apache Commons Lang Time**: https://commons.apache.org/proper/commons-lang/apidocs/org/apache/commons/lang3/time/package-summary.html
- **仓颉标准库 std.time**: `cangJie_docs/libs/std/time/`
- **仓颉标准库 std.core.Duration**: `cangJie_docs/libs/std/core/core_package_api/core_package_structs.md`

### B. 与 Apache Commons Lang 的差异

| 类名 | Apache Commons Lang | commons-lang4cj | 差异原因 |
|------|---------------------|-----------------|---------|
| `StopWatch` | 基于 `System.currentTimeMillis()` | 基于 `std.time.MonoTime` | MonoTime 单调递增，不受系统时间影响 |
| `DurationFormatUtils` | 支持 Period 格式化（"1年 2个月"） | 仅支持 Duration（"1天 2小时"） | Period 需要日历计算，复杂度高 |
| `DateFormatUtils` | 支持 `FastDateFormat` | 封装 `std.time.DateTime.format()` | 仓颉标准库已提供高效格式化 |
| `DateUtils` | 完整实现（addMonths, truncate, round） | 部分实现或延后 | 日期计算复杂度高，使用频率低 |

### C. 仓颉语言限制

1. **不支持可变参数**：使用数组参数代替（如 `formatDuration(pattern: String, args: Array<String>)`）
2. **Option<T> 代替 null**：所有可能为空的值使用 `Option<T>` 类型
3. **枚举不能带参数**：DateField 使用纯枚举，不存储额外数据

---

**文档版本**: v1.0
**最后更新**: 2026-01-20
**审核者**: @Guardian（待审核）
**状态**: ✅ 设计完成，待实现

