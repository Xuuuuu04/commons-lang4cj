package commons_lang4cj.time

import std.time.*

/**
 * 操作 DateTime 的工具类
 */
public class DateUtils {

    /**
     * 判断两个日期是否是同一天（忽略时间部分）
     *
     * @param date1 第一个日期
     * @param date2 第二个日期
     * @return 如果是同一天返回 true，否则返回 false
     */
    public static func isSameDay(date1: DateTime, date2: DateTime): Bool {
        return date1.year == date2.year &&
               date1.month == date2.month &&
               date1.dayOfMonth == date2.dayOfMonth
    }

    /**
     * 将日期截断到天（时分秒毫秒置零）
     *
     * @param date 原日期
     * @return 截断后的新日期
     */
    public static func truncate(date: DateTime): DateTime {
        return DateTime.of(
            year: date.year,
            month: date.month,
            dayOfMonth: date.dayOfMonth,
            hour: 0,
            minute: 0,
            second: 0,
            nanosecond: 0,
            timeZone: date.zone
        )
    }

    /**
     * 增加年份
     *
     * @param date 原日期
     * @param amount 增加的年数（可为负）
     * @return 增加后的新日期
     */
    public static func addYears(date: DateTime, amount: Int64): DateTime {
        return addMonths(date, amount * 12)
    }

    /**
     * 尝试使用多个模式解析日期字符串
     *
     * @param str 日期字符串
     * @param patterns 日期格式模式数组
     * @return 解析成功返回 Some(DateTime)，全部失败返回 None
     */
    public static func parseDate(str: String, patterns: Array<String>): Option<DateTime> {
        for (pattern in patterns) {
            try {
                return Some(DateTime.parse(str, pattern))
            } catch (e: Exception) {
                // 忽略异常，尝试下一个模式
                continue
            }
        }
        return None
    }

    /**
     * 增加月份
     *
     * @param date 原日期
     * @param amount 增加的月数（可为负）
     * @return 增加后的新日期
     */
    public static func addMonths(date: DateTime, amount: Int64): DateTime {
        if (amount == 0) {
            return date
        }

        // 获取当前年月信息
        // Month 枚举转整数 (1-12)
        // 假设 Month 提供了 ordinal 或者可以通过匹配获取数值，这里通过辅助函数转换
        let currentYear = date.year
        let currentMonthVal = monthToInt(date.month)
        let currentDay = date.dayOfMonth

        // 计算新的总月数 (以 0 年 1 月为基准的绝对月数)
        // 注意：这里简单处理，假设年份足够大不溢出
        // 逻辑：(当前年 * 12 + (当前月 - 1)) + amount
        let totalMonths = currentYear * 12 + (currentMonthVal - 1) + amount

        var newYear = totalMonths / 12
        var newMonthIndex = totalMonths % 12

        // 处理负数取模的情况
        if (newMonthIndex < 0) {
            newMonthIndex += 12
            newYear -= 1
        }

        let newMonthVal = newMonthIndex + 1
        let newMonth = intToMonth(newMonthVal)

        // 月底修正 (Clamp)
        // 获取新月份的最大天数
        let maxDay = getDaysInMonth(newYear, newMonth)
        let newDay = if (currentDay > maxDay) { maxDay } else { currentDay }

        return DateTime.of(
            year: newYear,
            month: newMonth,
            dayOfMonth: newDay,
            hour: date.hour,
            minute: date.minute,
            second: date.second,
            nanosecond: date.nanosecond,
            timeZone: date.zone
        )
    }

    // 增加周
    public static func addWeeks(date: DateTime, amount: Int64): DateTime {
        return addDays(date, amount * 7)
    }

    // 增加天
    public static func addDays(date: DateTime, amount: Int64): DateTime {
        // 使用 Duration 计算
        // 注意：DateTime + Duration 可能会涉及时区变化，但标准库应该处理好了
        // Duration.day 是 24 小时
        return date + (Duration.day * amount)
    }

    // 增加小时
    public static func addHours(date: DateTime, amount: Int64): DateTime {
        return date + (Duration.hour * amount)
    }

    // 增加分钟
    public static func addMinutes(date: DateTime, amount: Int64): DateTime {
        return date + (Duration.minute * amount)
    }

    // 增加秒
    public static func addSeconds(date: DateTime, amount: Int64): DateTime {
        return date + (Duration.second * amount)
    }

    // --- 内部辅助函数 ---

    private static func monthToInt(m: Month): Int64 {
        match (m) {
            case Month.January => 1
            case Month.February => 2
            case Month.March => 3
            case Month.April => 4
            case Month.May => 5
            case Month.June => 6
            case Month.July => 7
            case Month.August => 8
            case Month.September => 9
            case Month.October => 10
            case Month.November => 11
            case Month.December => 12
        }
    }

    private static func intToMonth(v: Int64): Month {
        match (v) {
            case 1 => Month.January
            case 2 => Month.February
            case 3 => Month.March
            case 4 => Month.April
            case 5 => Month.May
            case 6 => Month.June
            case 7 => Month.July
            case 8 => Month.August
            case 9 => Month.September
            case 10 => Month.October
            case 11 => Month.November
            case 12 => Month.December
            case _ => throw IllegalArgumentException("Invalid month value: ${v}")
        }
    }

    private static func getDaysInMonth(year: Int64, month: Month): Int64 {
        match (month) {
            case Month.January | Month.March | Month.May | Month.July | Month.August | Month.October | Month.December => 31
            case Month.April | Month.June | Month.September | Month.November => 30
            case Month.February =>
                if (isLeapYear(year)) { 29 } else { 28 }
        }
    }

    private static func isLeapYear(year: Int64): Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
}
