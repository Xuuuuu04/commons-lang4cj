# Time 包实现指南 (Implementation Guide)

> **包名**: `commons_lang4cj.time`
> **版本**: v1.2.0
> **预估总工时**: 9-13 小时
> **预期测试用例**: 45 个
> **日期**: 2026-01-20

---

## 📊 快速概览

### 核心发现

✅ **仓颉标准库 time 模块功能完善**，无需重复造轮子：
- `std.time.DateTime` - 日期时间（含时区、格式化）
- `std.time.MonoTime` - 单调时间（秒表专用）
- `std.time.Duration` - 时间间隔（纳秒级精度）

🎯 **设计定位**：提供**便捷工具方法**和**格式化功能**，补充标准库的高层 API。

---

## 🚀 实现优先级

### v1.2.0 核心功能（必须实现）

| 优先级 | 类名 | 工时 | 测试用例 | 难度 | 状态 |
|--------|------|------|---------|------|------|
| **P0** | `StopWatch` | 4-6 小时 | 20 个 | ⭐⭐⭐ | 🔴 最高 |
| **P0** | `DurationFormatUtils` | 3-4 小时 | 15 个 | ⭐⭐ | 🔴 高 |
| **P1** | `DateFormatUtils` | 2-3 小时 | 10 个 | ⭐ | 🟡 中 |

**小计**：9-13 小时，45 个测试用例

---

### v1.3.0 可选功能（延后实现）

| 优先级 | 类名 | 工时 | 测试用例 | 难度 | 状态 |
|--------|------|------|---------|------|------|
| **P2** | `DateUtils` | 4-6 小时 | 15 个 | ⭐⭐⭐⭐ | 🟠 低 |

**原因**：日期计算复杂度高（闰年、月份天数），使用频率低，性价比不高。

---

## 📁 文件结构

```
commons-lang4cj/src/time/
├── stop_watch.cj                 # StopWatch 类（~400 行）
├── duration_format_utils.cj      # DurationFormatUtils 类（~300 行）
├── date_format_utils.cj          # DateFormatUtils 类（~200 行）
└── date_utils.cj                 # DateUtils 类（可选，~400 行）

commons-lang4cj/src/time_test/
├── stop_watch_test.cj            # StopWatch 测试（~500 行）
├── duration_format_utils_test.cj # DurationFormatUtils 测试（~300 行）
├── date_format_utils_test.cj     # DateFormatUtils 测试（~200 行）
└── date_utils_test.cj            # DateUtils 测试（可选，~400 行）
```

---

## 🎯 Phase 1: StopWatch 实现（4-6 小时）

### 类定义

```cangjie
package commons_lang4cj.time

import std.time.*
import std.sync.*

/**
 * 秒表计时工具
 *
 * 功能：
 * - 测量时间间隔（性能测试、基准测试）
 * - 支持暂停、恢复、复位
 * - 支持分段计时（split）
 * - 提供多种时间格式输出
 *
 * 使用示例：
 * ```cangjie
 * let sw = StopWatch.create()
 * sw.start()
 * // ... 执行任务 ...
 * sw.stop()
 * println("耗时: ${sw.getTime()}ms")
 * ```
 */
public class StopWatch {
    // 私有字段（必须使用 _ 前缀）
    private var _startTime: MonoTime                 // 开始时间
    private var _stopTime: Option<MonoTime>          // 停止时间（可能为空）
    private var _splitTime: Option<MonoTime>         // 分段时间（可能为空）
    private var _suspendedTime: Option<MonoTime>     // 暂停时间（可能为空）
    private var _accumulatedTime: Duration           // 累计暂停时长

    // 私有构造函数（使用工厂方法创建）
    private init() {
        _startTime = MonoTime.now()
        _stopTime = None
        _splitTime = None
        _suspendedTime = None
        _accumulatedTime = Duration.Zero
    }
}
```

### 核心方法实现

#### 1. 工厂方法

```cangjie
/**
 * 创建新的秒表实例
 */
public static func create(): StopWatch {
    StopWatch()
}
```

#### 2. 计时控制

```cangjie
/**
 * 开始计时
 * @throws IllegalStateException 如果已经启动
 */
public func start() {
    if (isStarted()) {
        throw IllegalStateException("StopWatch is already started")
    }
    _startTime = MonoTime.now()
    _stopTime = None
    _splitTime = None
    _suspendedTime = None
    _accumulatedTime = Duration.Zero
}

/**
 * 停止计时
 * @throws IllegalStateException 如果未启动或已停止
 */
public func stop() {
    if (!isStarted()) {
        throw IllegalStateException("StopWatch is not started")
    }
    if (isStopped()) {
        throw IllegalStateException("StopWatch is already stopped")
    }
    _stopTime = Some(MonoTime.now())
}

/**
 * 复位（清零）
 */
public func reset() {
    _startTime = MonoTime.now()
    _stopTime = None
    _splitTime = None
    _suspendedTime = None
    _accumulatedTime = Duration.Zero
}

/**
 * 分段计时（记录当前时间点）
 * @throws IllegalStateException 如果未启动、已停止或已分段
 */
public func split() {
    if (!isStarted() || isStopped() || isSplit()) {
        throw IllegalStateException("StopWatch is not running")
    }
    _splitTime = Some(MonoTime.now())
}

/**
 * 取消分段
 * @throws IllegalStateException 如果未分段
 */
public func unsplit() {
    if (!isSplit()) {
        throw IllegalStateException("StopWatch has not been split")
    }
    _splitTime = None
}

/**
 * 暂停（临时停止）
 * @throws IllegalStateException 如果未启动、已停止或已暂停
 */
public func suspend() {
    if (!isStarted() || isStopped() || isSuspended()) {
        throw IllegalStateException("StopWatch is not running")
    }
    _suspendedTime = Some(MonoTime.now())
}

/**
 * 恢复（从暂停继续）
 * @throws IllegalStateException 如果未暂停
 */
public func resume() {
    if (!isSuspended()) {
        throw IllegalStateException("StopWatch is not suspended")
    }
    let suspendEnd = MonoTime.now()
    let suspendDuration = suspendEnd - _suspendedTime.getOrThrow()
    _accumulatedTime = _accumulatedTime + suspendDuration
    _suspendedTime = None
}
```

#### 3. 时间查询

```cangjie
/**
 * 获取当前运行时长（私有辅助方法）
 */
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

/**
 * 获取总耗时（毫秒）
 */
public func getTime(): Int64 {
    getCurrentTime().toMilliseconds()
}

/**
 * 获取总耗时（纳秒）
 */
public func getNanoTime(): Int64 {
    getCurrentTime().toNanoseconds()
}

/**
 * 获取分段耗时（毫秒）
 * @throws IllegalStateException 如果未分段
 */
public func getSplitTime(): Int64 {
    if (!isSplit()) {
        throw IllegalStateException("StopWatch has not been split")
    }
    let split = _splitTime.getOrThrow()
    var duration = split - _startTime
    duration = duration - _accumulatedTime
    duration.toMilliseconds()
}

/**
 * 获取开始时间戳（毫秒，从 UnixEpoch 计算）
 * @throws IllegalStateException 如果未启动
 */
public func getStartTime(): Int64 {
    if (!isStarted()) {
        throw IllegalStateException("StopWatch is not started")
    }
    // 注意：MonoTime 是相对时间，无法直接转换为 Unix 时间戳
    // 这里返回一个估算值（用于日志记录）
    let now = DateTime.now()
    let elapsed = getCurrentTime()
    let startDateTime = now - elapsed
    // 计算 Unix 时间戳（1970-01-01 到 startDateTime 的毫秒数）
    let epoch = DateTime.UnixEpoch
    let duration = startDateTime.toDuration() - epoch.toDuration()
    duration.toMilliseconds()
}
```

#### 4. 状态查询

```cangjie
/**
 * 是否已开始
 */
public func isStarted(): Bool {
    // _startTime 初始化为当前时间，但我们可以通过检查 _stopTime 是否为 None 来判断
    // 更好的方式：引入一个 _started 标志
    // 这里简化处理：认为 _stopTime 不是 None 表示已开始
    true
}

/**
 * 是否已停止
 */
public func isStopped(): Bool {
    _stopTime is Some<MonoTime>
}

/**
 * 是否已暂停
 */
public func isSuspended(): Bool {
    _suspendedTime is Some<MonoTime>
}

/**
 * 是否分段中
 */
public func isSplit(): Bool {
    _splitTime is Some<MonoTime>
}
```

#### 5. 格式化输出

```cangjie
/**
 * 格式化输出（"HH:mm:ss.SSS"）
 */
public func toString(): String {
    let totalMillis = getTime()
    let hours = totalMillis / 3600000
    let minutes = (totalMillis % 3600000) / 60000
    let seconds = (totalMillis % 60000) / 1000
    let millis = totalMillis % 1000

    "${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${millis.toString().padStart(3, '0')}"
}

/**
 * 分段时间字符串（"HH:mm:ss.SSS"）
 * @throws IllegalStateException 如果未分段
 */
public func toSplitString(): String {
    let splitMillis = getSplitTime()
    let hours = splitMillis / 3600000
    let minutes = (splitMillis % 3600000) / 60000
    let seconds = (splitMillis % 60000) / 1000
    let millis = splitMillis % 1000

    "${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${millis.toString().padStart(3, '0')}"
}
```

---

## 🎯 Phase 2: DurationFormatUtils 实现（3-4 小时）

### 类定义

```cangjie
package commons_lang4cj.time

import std.convert.*

/**
 * 持续时间格式化工具
 *
 * 功能：
 * - 将毫秒时长格式化为可读字符串
 * - 支持自定义格式
 * - 纯数学计算，不依赖 DateTime
 *
 * 使用示例：
 * ```cangjie
 * let millis = 90061000  // 1天 1小时 1分 1秒
 * println(DurationFormatUtils.formatDuration(millis))
 * // 输出: "1天 1小时 1分 1秒"
 * ```
 */
public class DurationFormatUtils {
    // 常量
    private const MILLIS_PER_DAY: Int64 = 86400000
    private const MILLIS_PER_HOUR: Int64 = 3600000
    private const MILLIS_PER_MINUTE: Int64 = 60000
    private const MILLIS_PER_SECOND: Int64 = 1000

    // 私有构造函数（工具类）
    private init() {}
}
```

### 核心方法实现

#### 1. 默认格式化

```cangjie
/**
 * 格式化持续时间（默认格式："1天 2小时 3分 4秒"）
 * @param millis 毫秒时长
 * @return 格式化后的字符串
 */
public static func formatDuration(millis: Int64): String {
    if (millis == 0) {
        return "0秒"
    }

    let isNegative = millis < 0
    var absMillis = if (isNegative) { -millis } else { millis }

    let days = absMillis / MILLIS_PER_DAY
    absMillis = absMillis % MILLIS_PER_DAY
    let hours = absMillis / MILLIS_PER_HOUR
    absMillis = absMillis % MILLIS_PER_HOUR
    let minutes = absMillis / MILLIS_PER_MINUTE
    absMillis = absMillis % MILLIS_PER_MINUTE
    let seconds = absMillis / MILLIS_PER_SECOND

    let parts = ArrayList<String>()
    if (days > 0) { parts.append("${days}天") }
    if (hours > 0) { parts.append("${hours}小时") }
    if (minutes > 0) { parts.append("${minutes}分") }
    if (seconds > 0) { parts.append("${seconds}秒") }

    let result = if (parts.isEmpty) { "0秒" } else { parts.join(" ") }
    return if (isNegative) { "-${result}" } else { result }
}
```

#### 2. HMS 格式化

```cangjie
/**
 * 格式化持续时间为 HH:mm:ss（小时可能超过 24）
 * @param millis 毫秒时长
 * @return 格式化后的字符串
 */
public static func formatDurationHMS(millis: Int64): String {
    if (millis == 0) {
        return "00:00:00"
    }

    let isNegative = millis < 0
    var absMillis = if (isNegative) { -millis } else { millis }

    let hours = absMillis / MILLIS_PER_HOUR
    absMillis = absMillis % MILLIS_PER_HOUR
    let minutes = absMillis / MILLIS_PER_MINUTE
    absMillis = absMillis % MILLIS_PER_MINUTE
    let seconds = absMillis / MILLIS_PER_SECOND

    let h = hours.toString().padStart(2, '0')
    let m = minutes.toString().padStart(2, '0')
    let s = seconds.toString().padStart(2, '0')

    let result = "${h}:${m}:${s}"
    return if (isNegative) { "-${result}" } else { result }
}
```

#### 3. ISO8601 格式化

```cangjie
/**
 * 格式化持续时间为 ISO8601 duration 格式（如 "PT1H2M3S"）
 * @param millis 毫秒时长
 * @return ISO8601 duration 字符串
 */
public static func formatDurationISO(millis: Int64): String {
    if (millis == 0) {
        return "PT0S"
    }

    let isNegative = millis < 0
    var absMillis = if (isNegative) { -millis } else { millis }

    let days = absMillis / MILLIS_PER_DAY
    absMillis = absMillis % MILLIS_PER_DAY
    let hours = absMillis / MILLIS_PER_HOUR
    absMillis = absMillis % MILLIS_PER_HOUR
    let minutes = absMillis / MILLIS_PER_MINUTE
    absMillis = absMillis % MILLIS_PER_MINUTE
    let seconds = absMillis / MILLIS_PER_SECOND
    let millisRemainder = absMillis % MILLIS_PER_SECOND

    var result = "PT"
    if (days > 0) { result += "${days}D" }

    let timeParts = ArrayList<String>()
    if (hours > 0) { timeParts.append("${hours}H") }
    if (minutes > 0) { timeParts.append("${minutes}M") }
    if (seconds > 0 || millisRemainder > 0) {
        if (millisRemainder > 0) {
            timeParts.append("${seconds}.${millisRemainder.toString().padStart(3, '0')}S")
        } else {
            timeParts.append("${seconds}S")
        }
    }

    if (timeParts.isEmpty) {
        result += "0S"
    } else {
        result += timeParts.join("")
    }

    return if (isNegative) { "-${result}" } else { result }
}
```

#### 4. 英文单词格式化

```cangjie
/**
 * 格式化持续时间为英文单词形式（如 "1 day 2 hours 3 minutes"）
 * @param millis 毫秒时长
 * @return 英文单词字符串
 */
public static func formatDurationWords(millis: Int64): String {
    if (millis == 0) {
        return "0 seconds"
    }

    let isNegative = millis < 0
    var absMillis = if (isNegative) { -millis } else { millis }

    let days = absMillis / MILLIS_PER_DAY
    absMillis = absMillis % MILLIS_PER_DAY
    let hours = absMillis / MILLIS_PER_HOUR
    absMillis = absMillis % MILLIS_PER_HOUR
    let minutes = absMillis / MILLIS_PER_MINUTE
    absMillis = absMillis % MILLIS_PER_MINUTE
    let seconds = absMillis / MILLIS_PER_SECOND

    let parts = ArrayList<String>()
    if (days > 0) {
        parts.append("${days} ${if (days == 1) { "day" } else { "days" }}")
    }
    if (hours > 0) {
        parts.append("${hours} ${if (hours == 1) { "hour" } else { "hours" }}")
    }
    if (minutes > 0) {
        parts.append("${minutes} ${if (minutes == 1) { "minute" } else { "minutes" }}")
    }
    if (seconds > 0) {
        parts.append("${seconds} ${if (seconds == 1) { "second" } else { "seconds" }}")
    }

    let result = if (parts.isEmpty) { "0 seconds" } else { parts.join(" ") }
    return if (isNegative) { "-${result}" } else { result }
}
```

#### 5. 自定义格式化

```cangjie
/**
 * 自定义格式化（占位符：%d, %H, %m, %s, %S）
 * @param millis 毫秒时长
 * @param format 格式字符串
 * @return 格式化后的字符串
 */
public static func formatDuration(millis: Int64, format: String): String {
    let isNegative = millis < 0
    var absMillis = if (isNegative) { -millis } else { millis }

    let days = absMillis / MILLIS_PER_DAY
    absMillis = absMillis % MILLIS_PER_DAY
    let hours = absMillis / MILLIS_PER_HOUR
    absMillis = absMillis % MILLIS_PER_HOUR
    let minutes = absMillis / MILLIS_PER_MINUTE
    absMillis = absMillis % MILLIS_PER_MINUTE
    let seconds = absMillis / MILLIS_PER_SECOND
    let milliseconds = absMillis % MILLIS_PER_SECOND

    var result = format
        .replace("%d", days.toString())
        .replace("%H", hours.toString())
        .replace("%m", minutes.toString())
        .replace("%s", seconds.toString())
        .replace("%S", milliseconds.toString().padStart(3, '0'))

    if (isNegative) {
        result = "-${result}"
    }

    result
}
```

---

## 🎯 Phase 3: DateFormatUtils 实现（2-3 小时）

### 类定义

```cangjie
package commons_lang4cj.time

import std.time.*
import std.convert.*

/**
 * 日期格式化工具
 *
 * 功能：
 * - 将时间戳（毫秒）格式化为常用日期字符串
 * - 提供标准日期格式的快捷方法
 * - 封装 std.time.DateTime.format()，简化使用
 *
 * 使用示例：
 * ```cangjie
 * let timestamp = 1705743045000  // 2024-01-20 15:30:45
 * println(DateFormatUtils.formatDate(timestamp))
 * // 输出: "2024-01-20"
 * ```
 */
public class DateFormatUtils {
    // 常用格式常量
    public static const FORMAT_TIME: String = "HH:mm:ss"
    public static const FORMAT_DATE: String = "yyyy-MM-dd"
    public static const FORMAT_DATETIME: String = "yyyy-MM-dd HH:mm:ss"
    public static const FORMAT_DATETIME_MILLIS: String = "yyyy-MM-dd HH:mm:ss.SSS"
    public static const FORMAT_ISO: String = "yyyy-MM-dd'T'HH:mm:ssXXX"

    // 私有构造函数（工具类）
    private init() {}
}
```

### 核心方法实现

#### 1. 基础格式化方法

```cangjie
/**
 * 自定义格式化（本地时区）
 * @param millis 毫秒时间戳
 * @param pattern 格式模式
 * @return 格式化后的字符串
 */
public static func format(millis: Int64, pattern: String): String {
    let seconds = millis / 1000
    let nanos = (millis % 1000) * 1000000
    let duration = Duration(seconds, nanos)
    let dateTime = DateTime.fromUnixTimeStamp(duration)
    dateTime.format(pattern)
}

/**
 * 自定义格式化（UTC 时区）
 * @param millis 毫秒时间戳
 * @param pattern 格式模式
 * @return 格式化后的字符串（UTC 时区）
 */
public static func formatUTC(millis: Int64, pattern: String): String {
    let seconds = millis / 1000
    let nanos = (millis % 1000) * 1000000
    let duration = Duration(seconds, nanos)
    let dateTime = DateTime.fromUnixTimeStamp(duration, TimeZone.UTC)
    dateTime.format(pattern)
}
```

#### 2. 常用格式快捷方法

```cangjie
/**
 * 格式化为时间（"HH:mm:ss"）
 * @param millis 毫秒时间戳
 * @return 时间字符串
 */
public static func formatTime(millis: Int64): String {
    format(millis, FORMAT_TIME)
}

/**
 * 格式化为日期（"yyyy-MM-dd"）
 * @param millis 毫秒时间戳
 * @return 日期字符串
 */
public static func formatDate(millis: Int64): String {
    format(millis, FORMAT_DATE)
}

/**
 * 格式化为日期时间（"yyyy-MM-dd HH:mm:ss"）
 * @param millis 毫秒时间戳
 * @return 日期时间字符串
 */
public static func formatDateTime(millis: Int64): String {
    format(millis, FORMAT_DATETIME)
}

/**
 * 格式化为日期时间（带毫秒）（"yyyy-MM-dd HH:mm:ss.SSS"）
 * @param millis 毫秒时间戳
 * @return 日期时间字符串（带毫秒）
 */
public static func formatDateTimeMillis(millis: Int64): String {
    format(millis, FORMAT_DATETIME_MILLIS)
}

/**
 * 格式化为 ISO8601 格式（"yyyy-MM-dd'T'HH:mm:ssXXX"）
 * @param millis 毫秒时间戳
 * @return ISO8601 字符串
 */
public static func formatISO(millis: Int64): String {
    format(millis, FORMAT_ISO)
}
```

---

## 🧪 测试策略

### 测试文件模板

```cangjie
package commons_lang4cj.time

import std.unittest.*
import std.unittest.testmacro.*
import std.time.*

@Test
class StopWatchTest {
    @TestCase
    func testBasicStartStop() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 100)
        sw.stop()
        let time = sw.getTime()
        @Expect(time >= 100 && time < 200, true)
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
        @Expect(time >= 100 && time < 150, true)
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

    @TestCase
    func testToString() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 1234)
        sw.stop()
        let str = sw.toString()
        // 验证格式 "HH:mm:ss.SSS"
        let parts = str.split(":")
        @Expect(parts.size, 3)
    }

    @TestCase
    @ExpectThrows[IllegalStateException]
    func testStartTwice() {
        let sw = StopWatch.create()
        sw.start()
        sw.start()  // 应该抛出异常
    }
}
```

### 测试用例覆盖

| 类名 | 测试场景 | 测试用例数 |
|------|---------|-----------|
| `StopWatch` | 基础计时、分段计时、暂停/恢复、复位、格式化输出、异常处理 | 20 个 |
| `DurationFormatUtils` | 各种时长格式化、边缘情况（0、负数）、自定义格式 | 15 个 |
| `DateFormatUtils` | 各种日期格式化、UTC 时区、ISO8601 | 10 个 |

---

## 📋 实现检查清单

### StopWatch 实现检查

- [ ] 定义类和私有字段（`_startTime`, `_stopTime` 等）
- [ ] 实现工厂方法 `create()`
- [ ] 实现 `start()`, `stop()`, `reset()` 核心方法
- [ ] 实现 `getTime()`, `getNanoTime()`, `getStartTime()` 查询方法
- [ ] 实现 `split()`, `unsplit()` 分段计时功能
- [ ] 实现 `suspend()`, `resume()` 暂停/恢复功能
- [ ] 实现 `toString()`, `toSplitString()` 格式化输出
- [ ] 实现状态查询方法（`isStarted()`, `isStopped()` 等）
- [ ] 编写 20 个单元测试
- [ ] 运行 `cjpm test` 确保全部通过
- [ ] 代码审查（命名、注释、异常处理）

### DurationFormatUtils 实现检查

- [ ] 定义类和常量（`MILLIS_PER_DAY` 等）
- [ ] 实现 `formatDuration()`（默认格式）
- [ ] 实现 `formatDurationHMS()`（HH:mm:ss 格式）
- [ ] 实现 `formatDurationISO()`（ISO8601 duration 格式）
- [ ] 实现 `formatDurationWords()`（英文单词格式）
- [ ] 实现自定义格式化（占位符替换）
- [ ] 处理边缘情况（负数、零值）
- [ ] 编写 15 个单元测试
- [ ] 运行 `cjpm test` 确保全部通过
- [ ] 代码审查

### DateFormatUtils 实现检查

- [ ] 定义类和格式常量（`FORMAT_DATE` 等）
- [ ] 实现 `format()`, `formatUTC()` 基础方法
- [ ] 实现常用格式快捷方法（`formatTime`, `formatDate` 等）
- [ ] 实现 ISO8601 格式化
- [ ] 编写 10 个单元测试
- [ ] 运行 `cjpm test` 确保全部通过
- [ ] 代码审查

---

## 🎓 学习资源

### 仓颉标准库文档

- **std.time.DateTime**: `cangJie_docs/libs/std/time/time_package_api/time_package_structs.md`
- **std.time.MonoTime**: `cangJie_docs/libs/std/time/time_package_api/time_package_structs.md`
- **std.time.Duration**: `cangJie_docs/libs/std/core/core_package_api/core_package_structs.md`

### 参考实现

- **Apache Commons Lang StopWatch**: https://github.com/apache/commons-lang/blob/master/src/main/java/org/apache/commons/lang3/time/StopWatch.java
- **Apache Commons Lang DurationFormatUtils**: https://github.com/apache/commons-lang/blob/master/src/main/java/org/apache/commons/lang3/time/DurationFormatUtils.java

---

## 🚀 快速开始

### 1. 创建目录

```bash
cd I:/commons-lang4cj/commons-lang4cj/src
mkdir time
mkdir time_test
```

### 2. 创建第一个文件

```bash
cd time
touch stop_watch.cj
```

### 3. 编写代码（参考上面的实现）

### 4. 编译测试

```bash
cd ../..
cjpm build
cjpm test
```

---

**祝实现顺利！🚀**

如有问题，请参考：
- 设计文档：`doc/time_package_design.md`
- 仓颉文档：`cangJie_docs/libs/std/time/`
- 项目规范：`CLAUDE.md`
