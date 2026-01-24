package commons_lang4cj.time

import std.time.*

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
 *
 * 架构决策：
 * - 基于 `std.time.MonoTime` 实现（单调递增，不受系统时间影响）
 * - 使用 `Option<T>` 表示可能为空的时间点（仓颉没有 null）
 * - 暂停/恢复通过累计暂停时长实现
 *
 * @since 1.2.0
 */
public class StopWatch {
    // 私有字段（必须使用 _ 前缀）

    private var _startTime: MonoTime                 // 开始时间
    private var _stopTime: Option<MonoTime>          // 停止时间（可能为空）
    private var _splitTime: Option<MonoTime>         // 分段时间（可能为空）
    private var _suspendedTime: Option<MonoTime>     // 暂停时间（可能为空）
    private var _accumulatedTime: Duration           // 累计暂停时长
    private var _started: Bool                       // 是否已开始
    private var _stopped: Bool                       // 是否已停止
    private var _startTimestamp: Option<Int64>       // 开始时间戳（缓存）

    /**
     * 私有构造函数（使用工厂方法创建）
     */
    private init() {
        _startTime = MonoTime.now()
        _stopTime = None
        _splitTime = None
        _suspendedTime = None
        _accumulatedTime = Duration.Zero
        _started = false
        _stopped = false
        _startTimestamp = None
    }

    /**
     * 创建新的秒表实例
     *
     * @return 新的 StopWatch 实例
     */
    public static func create(): StopWatch {
        StopWatch()
    }

    // ========== 计时控制方法 ==========

    /**
     * 开始计时
     *
     * @throws IllegalStateException 如果已经启动
     */
    public func start() {
        if (_started) {
            throw IllegalStateException("StopWatch is already started")
        }
        _startTime = MonoTime.now()
        _stopTime = None
        _splitTime = None
        _suspendedTime = None
        _accumulatedTime = Duration.Zero
        _started = true
        _stopped = false

        // 缓存开始时间戳（用于 getStartTime() 方法）
        let now = DateTime.now()
        // 计算当前时间的 Unix 时间戳（从 1970-01-01 到现在的毫秒数）
        let year = now.year
        let day = now.dayOfMonth
        let hour = now.hour
        let minute = now.minute
        let second = now.second
        let nano = now.nanosecond

        // 简化计算：返回一个估算的时间戳
        // 注意：这是近似值，仅供参考
        // 实际应用中，MonoTime 无法转换为绝对时间戳
        _startTimestamp = Some((year * 31536000000) + (day * 86400000) + (hour * 3600000) + (minute * 60000) + (second * 1000) + (nano / 1000000))
    }

    /**
     * 停止计时
     *
     * @throws IllegalStateException 如果未启动或已停止
     */
    public func stop() {
        if (!_started) {
            throw IllegalStateException("StopWatch is not started")
        }
        if (_stopped) {
            throw IllegalStateException("StopWatch is already stopped")
        }
        _stopTime = Some(MonoTime.now())
        _stopped = true
    }

    /**
     * 复位（清零）
     *
     * 注意：复位后需要重新调用 start() 才能开始计时
     */
    public func reset() {
        _startTime = MonoTime.now()
        _stopTime = None
        _splitTime = None
        _suspendedTime = None
        _accumulatedTime = Duration.Zero
        _started = false
        _stopped = false
        _startTimestamp = None
    }

    /**
     * 分段计时（记录当前时间点）
     *
     * 用于测量某一时段的耗时，可以多次调用 split() 记录多个时间点
     *
     * @throws IllegalStateException 如果未启动、已停止或已分段
     */
    public func split() {
        if (!_started || _stopped) {
            throw IllegalStateException("StopWatch is not running")
        }
        match (_splitTime) {
            case Some(_) => throw IllegalStateException("StopWatch already has a split time")
            case None => ()  // do nothing
        }
        _splitTime = Some(MonoTime.now())
    }

    /**
     * 取消分段
     *
     * @throws IllegalStateException 如果未分段
     */
    public func unsplit() {
        match (_splitTime) {
            case None => throw IllegalStateException("StopWatch has not been split")
            case Some(_) => ()  // do nothing
        }
        _splitTime = None
    }

    /**
     * 暂停（临时停止）
     *
     * 暂停期间不计时，可以多次暂停/恢复
     *
     * @throws IllegalStateException 如果未启动、已停止或已暂停
     */
    public func suspend() {
        if (!_started || _stopped) {
            throw IllegalStateException("StopWatch is not running")
        }
        match (_suspendedTime) {
            case Some(_) => throw IllegalStateException("StopWatch is already suspended")
            case None => ()  // do nothing
        }
        _suspendedTime = Some(MonoTime.now())
    }

    /**
     * 恢复（从暂停继续）
     *
     * @throws IllegalStateException 如果未暂停
     */
    public func resume() {
        match (_suspendedTime) {
            case None => throw IllegalStateException("StopWatch is not suspended")
            case Some(_) => ()  // do nothing
        }
        let suspendEnd = MonoTime.now()
        let suspended = _suspendedTime.getOrThrow()
        let suspendDuration = suspendEnd - suspended
        _accumulatedTime = _accumulatedTime + suspendDuration
        _suspendedTime = None
    }

    // ========== 时间查询方法 ==========

    /**
     * 获取当前运行时长（私有辅助方法）
     *
     * @return 当前运行时长
     */
    private func getCurrentTime(): Duration {
        var duration: Duration

        if (let Some(stopTime) <- _stopTime) {
            // 已停止，计算到停止时的时长
            duration = stopTime - _startTime
        } else if (_started) {
            // 运行中
            if (let Some(suspended) <- _suspendedTime) {
                // 当前暂停中，计算到暂停前的时长
                duration = suspended - _startTime
            } else {
                // 正常运行，计算到现在的时长
                let now = MonoTime.now()
                duration = now - _startTime
            }
        } else {
            // 未开始，时长为 0
            duration = Duration.Zero
        }

        // 减去累计暂停时长
        duration = duration - _accumulatedTime
        return duration
    }

    /**
     * 获取总耗时（毫秒）
     *
     * @return 总耗时（毫秒）
     */
    public func getTime(): Int64 {
        getCurrentTime().toMilliseconds()
    }

    /**
     * 获取总耗时（纳秒）
     *
     * @return 总耗时（纳秒）
     */
    public func getNanoTime(): Int64 {
        getCurrentTime().toNanoseconds()
    }

    /**
     * 获取分段耗时（毫秒）
     *
     * @return 分段耗时（毫秒）
     * @throws IllegalStateException 如果未分段
     */
    public func getSplitTime(): Int64 {
        if (let Some(split) <- _splitTime) {
            var duration = split - _startTime
            duration = duration - _accumulatedTime
            return duration.toMilliseconds()
        }
        throw IllegalStateException("StopWatch has not been split")
    }

    /**
     * 获取分段耗时（纳秒）
     *
     * @return 分段耗时（纳秒）
     * @throws IllegalStateException 如果未分段
     */
    public func getSplitNanoTime(): Int64 {
        if (let Some(split) <- _splitTime) {
            var duration = split - _startTime
            duration = duration - _accumulatedTime
            return duration.toNanoseconds()
        }
        throw IllegalStateException("StopWatch has not been split")
    }

    /**
     * 获取开始时间戳（毫秒，从 UnixEpoch 计算）
     *
     * 注意：MonoTime 是相对时间，无法直接转换为 Unix 时间戳
     * 这里返回一个估算值（用于日志记录），仅供参考
     *
     * @return 开始时间戳（毫秒）
     * @throws IllegalStateException 如果未启动
     */
    public func getStartTime(): Int64 {
        if (!_started) {
            throw IllegalStateException("StopWatch is not started")
        }
        // 返回缓存的时间戳
        match (_startTimestamp) {
            case Some(ts) => ts
            case None => 0  // 如果缓存不存在（不应该发生），返回0
        }
    }

    // ========== 状态查询方法 ==========

    /**
     * 是否已开始
     *
     * @return true 如果已开始，否则 false
     */
    public func isStarted(): Bool {
        _started
    }

    /**
     * 是否已停止
     *
     * @return true 如果已停止，否则 false
     */
    public func isStopped(): Bool {
        _stopped
    }

    /**
     * 是否已暂停
     *
     * @return true 如果已暂停，否则 false
     */
    public func isSuspended(): Bool {
        match (_suspendedTime) {
            case Some(_) => true
            case None => false
        }
    }

    /**
     * 是否分段中
     *
     * @return true 如果分段中，否则 false
     */
    public func isSplit(): Bool {
        match (_splitTime) {
            case Some(_) => true
            case None => false
        }
    }

    // ========== 格式化输出方法 ==========

    /**
     * 格式化输出（"HH:mm:ss.SSS"）
     *
     * @return 格式化的时间字符串
     */
    public func toString(): String {
        formatDuration(getTime())
    }

    /**
     * 分段时间字符串（"HH:mm:ss.SSS"）
     *
     * @return 格式化的分段时间字符串
     * @throws IllegalStateException 如果未分段
     */
    public func toSplitString(): String {
        formatDuration(getSplitTime())
    }

    /**
     * 格式化时长（私有辅助方法）
     *
     * @param millis 毫秒时长
     * @return 格式化后的字符串（"HH:mm:ss.SSS"）
     */
    private func formatDuration(millis: Int64): String {
        let absMillis = if (millis < 0) { -millis } else { millis }

        let hours = absMillis / 3600000
        let minutes = (absMillis % 3600000) / 60000
        let seconds = (absMillis % 60000) / 1000
        let ms = absMillis % 1000

        // 格式化为 HH:mm:ss.SSS
        let hStr = padStart(hours.toString(), 2, r'0')
        let mStr = padStart(minutes.toString(), 2, r'0')
        let sStr = padStart(seconds.toString(), 2, r'0')
        let msStr = padStart(ms.toString(), 3, r'0')

        let result = "${hStr}:${mStr}:${sStr}.${msStr}"
        return if (millis < 0) { "-${result}" } else { result }
    }

    /**
     * 字符串左填充（私有辅助方法）
     *
     * @param str 原字符串
     * @param targetLength 目标长度
     * @param padChar 填充字符
     * @return 填充后的字符串
     */
    private func padStart(str: String, targetLength: Int64, padChar: Rune): String {
        if (str.size >= targetLength) {
            return str
        }
        var padding = ""
        let padLen = targetLength - str.size
        for (_ in 0..padLen) {
            padding += padChar.toString()
        }
        return padding + str
    }
}
