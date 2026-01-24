package examples

import commons_lang4cj.time.*
import std.time.*

/**
 * 调试 DateFormatUtils 输出格式
 */
main() {
    println("=== Debug DateFormatUtils ===")

    // 测试当前日期格式
    let dateStr = DateFormatUtils.formatDate(0)
    println("formatDate(0): [${dateStr}] (size: ${dateStr.size})")
    println("  Characters: ")
    for (c in dateStr) {
        println("    [${c}] code: ${c.toInt64()}")
    }

    println()

    // 测试 DateTime.now() 的原始格式
    let now = DateTime.now()
    println("DateTime.now(): [${now}]")

    println()

    // 测试 DateTime.format()
    let formatted = now.format("YYYY-MM-DD")
    println("format('YYYY-MM-DD'): [${formatted}] (size: ${formatted.size})")

    println()

    // 测试时间格式
    let timeStr = DateFormatUtils.formatTime(0)
    println("formatTime(0): [${timeStr}] (size: ${timeStr.size})")

    println()

    // 测试日期时间格式
    let dateTimeStr = DateFormatUtils.formatDateTime(0)
    println("formatDateTime(0): [${dateTimeStr}] (size: ${dateTimeStr.size})")

    println()

    // 测试带毫秒格式
    let dateTimeMillisStr = DateFormatUtils.formatDateTimeMillis(0)
    println("formatDateTimeMillis(0): [${dateTimeMillisStr}] (size: ${dateTimeMillisStr.size})")

    println()

    // 测试原始格式输出
    let rawFormat = now.format("YYYY-MM-DD HH:mm:ss.SSS")
    println("Raw format: [${rawFormat}] (size: ${rawFormat.size})")

    println()

    // 测试 ISO 格式
    let isoFormat = DateFormatUtils.formatISO(0)
    println("formatISO(0): [${isoFormat}] (size: ${isoFormat.size})")
}
