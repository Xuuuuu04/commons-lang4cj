package commons_lang4cj.time

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
 *
 * @since 1.2.0
 */
public class DurationFormatUtils {
    // 常量
    private static const MILLIS_PER_DAY: Int64 = 86400000
    private static const MILLIS_PER_HOUR: Int64 = 3600000
    private static const MILLIS_PER_MINUTE: Int64 = 60000
    private static const MILLIS_PER_SECOND: Int64 = 1000

    // 私有构造函数（工具类）
    private init() {}

    /**
     * 格式化持续时间（默认格式："1天 2小时 3分 4秒"）
     *
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

        var result = ""
        if (days > 0) { result = if (result.size > 0) { result + " " } else { result }; result += "${days}天" }
        if (hours > 0) { result = if (result.size > 0) { result + " " } else { result }; result += "${hours}小时" }
        if (minutes > 0) { result = if (result.size > 0) { result + " " } else { result }; result += "${minutes}分" }
        if (seconds > 0) { result = if (result.size > 0) { result + " " } else { result }; result += "${seconds}秒" }

        if (result.size == 0) { result = "0秒" }

        return if (isNegative) { "-${result}" } else { result }
    }

    /**
     * 格式化持续时间为 HH:mm:ss（小时可能超过 24）
     *
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

        let h = padStart(hours.toString(), 2, r'0')
        let m = padStart(minutes.toString(), 2, r'0')
        let s = padStart(seconds.toString(), 2, r'0')

        let result = "${h}:${m}:${s}"
        return if (isNegative) { "-${result}" } else { result }
    }

    /**
     * 格式化持续时间为 ISO8601 duration 格式（如 "PT1H2M3S"）
     *
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

        // ISO8601 格式：P[n]DT[n]H[n]M[n]S
        // 日期部分（天）在 T 之前，时间部分在 T 之后
        var datePart = "P"
        if (days > 0) { datePart += "${days}D" }

        var timePart = "T"
        if (hours > 0) { timePart += "${hours}H" }
        if (minutes > 0) { timePart += "${minutes}M" }
        if (seconds > 0 || millisRemainder > 0) {
            if (millisRemainder > 0) {
                let msStr = padStart(millisRemainder.toString(), 3, r'0')
                timePart += "${seconds}.${msStr}S"
            } else {
                timePart += "${seconds}S"
            }
        }

        // 如果没有时间部分，添加 0 秒
        if (timePart == "T") { timePart = "T0S" }

        let result = datePart + timePart

        return if (isNegative) { "-${result}" } else { result }
    }

    /**
     * 格式化持续时间为英文单词形式（如 "1 day 2 hours 3 minutes"）
     *
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

        var result = ""
        if (days > 0) {
            result = if (result.size > 0) { result + " " } else { result }
            result += "${days} ${if (days == 1) { "day" } else { "days" }}"
        }
        if (hours > 0) {
            result = if (result.size > 0) { result + " " } else { result }
            result += "${hours} ${if (hours == 1) { "hour" } else { "hours" }}"
        }
        if (minutes > 0) {
            result = if (result.size > 0) { result + " " } else { result }
            result += "${minutes} ${if (minutes == 1) { "minute" } else { "minutes" }}"
        }
        if (seconds > 0) {
            result = if (result.size > 0) { result + " " } else { result }
            result += "${seconds} ${if (seconds == 1) { "second" } else { "seconds" }}"
        }

        if (result.size == 0) { result = "0 seconds" }

        return if (isNegative) { "-${result}" } else { result }
    }

    /**
     * 自定义格式化（占位符：%d, %H, %m, %s, %S）
     *
     * 支持的占位符：
     * - %d: 天
     * - %H: 小时（24小时制）
     * - %m: 分钟
     * - %s: 秒
     * - %S: 毫秒（3位，补零）
     *
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
        result = result.replace("%d", days.toString())
        result = result.replace("%H", hours.toString())
        result = result.replace("%m", minutes.toString())
        result = result.replace("%s", seconds.toString())
        result = result.replace("%S", padStart(milliseconds.toString(), 3, r'0'))

        if (isNegative) {
            result = "-${result}"
        }

        result
    }

    /**
     * 字符串左填充（私有辅助方法）
     *
     * @param str 原字符串
     * @param targetLength 目标长度
     * @param padChar 填充字符
     * @return 填充后的字符串
     */
    private static func padStart(str: String, targetLength: Int64, padChar: Rune): String {
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
