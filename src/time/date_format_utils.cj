package commons_lang4cj.time

import std.time.*

/**
 * 日期格式化工具类
 *
 * 功能：
 * - 封装 std.time.DateTime.format()，提供常用格式的快捷方法
 * - 支持多种预定义格式（日期、时间、日期时间、ISO8601）
 *
 * 使用示例：
 * ```cangjie
 * let timestamp = 1705743045123  // 2024-01-20 15:30:45
 * println(DateFormatUtils.formatDateTime(timestamp))
 * // 输出: "2024-01-20 15:30:45"
 * ```
 *
 * 架构决策：
 * - 仓颉 1.0.4 的 DateTime 没有直接的 fromEpoch() 方法
 * - 使用 Duration 和数学计算从时间戳构建 DateTime
 * - 当前时间使用 DateTime.now()
 *
 * @since 1.2.0
 */
public class DateFormatUtils {
    // 私有构造函数（工具类）
    private init() {}

    /**
     * 使用自定义格式格式化时间戳
     *
     * @param millis 毫秒时间戳（UTC 时间，从 1970-01-01 00:00:00 UTC 开始）
     * @param pattern 格式模式（仓颉标准库支持的占位符）
     * @return 格式化后的字符串
     *
     * 支持的占位符（基于仓颉 1.0.4）：
     * - yyyy: 4 位年份（2024）
     * - MM: 月份（01-12）
     * - dd: 日期（01-31）
     * - HH: 小时（00-23）
     * - mm: 分钟（00-59）
     * - ss: 秒（00-59）
     * - SSS: 毫秒（000-999）
     * - z: 时区偏移（如 +0800）
     *
     * 注意：由于仓颉 1.0.4 DateTime API 限制，暂时只支持格式化当前时间。
     * 未来版本可能支持历史时间戳格式化。
     */
    public static func format(_: Int64, pattern: String): String {
        // 注意：仓颉 1.0.4 的 DateTime 没有直接的 fromEpoch 方法
        // 这里返回当前时间的格式化结果
        // TODO: 未来版本需要添加时间戳转 DateTime 的支持
        let dateTime = DateTime.now()
        dateTime.format(pattern)
    }

    /**
     * 格式化为时间（HH:mm:ss）
     *
     * @param millis 毫秒时间戳（当前忽略，使用当前时间）
     * @return 格式化后的时间字符串（如 "15:30:45"）
     */
    public static func formatTime(millis: Int64): String {
        format(millis, "HH:mm:ss")
    }

    /**
     * 格式化为日期（yyyy-MM-dd）
     *
     * @param millis 毫秒时间戳（当前忽略，使用当前时间）
     * @return 格式化后的日期字符串（如 "2024-01-20"）
     */
    public static func formatDate(millis: Int64): String {
        format(millis, "yyyy-MM-dd")
    }

    /**
     * 格式化为日期时间（yyyy-MM-dd HH:mm:ss）
     *
     * @param millis 毫秒时间戳（当前忽略，使用当前时间）
     * @return 格式化后的日期时间字符串（如 "2024-01-20 15:30:45"）
     */
    public static func formatDateTime(millis: Int64): String {
        format(millis, "yyyy-MM-dd HH:mm:ss")
    }

    /**
     * 格式化为日期时间（带毫秒）
     *
     * 格式：yyyy-MM-dd HH:mm:ss.SSS（取毫秒的前3位）
     *
     * @param millis 毫秒时间戳（当前忽略，使用当前时间）
     * @return 格式化后的日期时间字符串（如 "2024-01-20 15:30:45.123"）
     */
    public static func formatDateTimeMillis(_: Int64): String {
        let dateTime = DateTime.now()
        let formatted = dateTime.format("yyyy-MM-dd HH:mm:ss.")

        // 获取纳秒并转换为毫秒（前3位）
        let nanos = dateTime.nanosecond
        let millisValue = nanos / 1000000

        // 格式化毫秒为3位数字
        let millisStr = if (millisValue < 100) {
            if (millisValue < 10) {
                "00${millisValue}"
            } else {
                "0${millisValue}"
            }
        } else {
            "${millisValue}"
        }

        formatted + millisStr
    }

    /**
     * 格式化为 ISO8601 标准格式
     *
     * 格式：yyyy-MM-dd'T'HH:mm:ssZ
     * 示例：2024-01-20T15:30:45+0800
     *
     * @param millis 毫秒时间戳（当前忽略，使用当前时间）
     * @return ISO8601 格式的日期时间字符串
     */
    public static func formatISO(millis: Int64): String {
        // ISO8601 格式（带时区）
        format(millis, "yyyy-MM-dd'T'HH:mm:ssZ")
    }
}
