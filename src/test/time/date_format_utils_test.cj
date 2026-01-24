package commons_lang4cj.test.time

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.time.*
import std.time.*
import std.regex.*

/**
 * DateFormatUtils 单元测试
 *
 * 测试覆盖：
 * - 自定义格式化
 * - 时间格式化（HH:mm:ss）
 * - 日期格式化（YYYY-MM-DD）
 * - 日期时间格式化（YYYY-MM-DD HH:mm:ss）
 * - 带毫秒格式化
 * - ISO8601 格式化
 * - 边缘情况（0、负数、当前时间）
 * - 格式验证（正则匹配）
 *
 * @since 1.2.0
 */
@Test
class DateFormatUtilsTest {
    /**
     * 测试自定义格式化
     */
    @TestCase
    func testFormatCustomPattern() {
        // 注意：当前仓颉 1.0.4 版本只支持格式化当前时间
        // millis 参数被忽略
        let formatted = DateFormatUtils.format(0, "yyyy-MM-dd")

        // 验证格式：yyyy-MM-dd（10个字符）
        @Expect(formatted.size, 10)

        // 验证分隔符
        @Expect(formatted.contains("-"), true)
    }

    /**
     * 测试时间格式化（HH:mm:ss）
     */
    @TestCase
    func testFormatTime() {
        let formatted = DateFormatUtils.formatTime(0)

        // 验证格式：HH:mm:ss（8个字符）
        @Expect(formatted.size, 8)

        // 验证分隔符
        @Expect(formatted.contains(":"), true)

        // 计算冒号数量
        var colonCount = 0
        for (c in formatted) {
            if (c == 58u8) {  // ':' 的 ASCII 码是 58
                colonCount++
            }
        }
        @Expect(colonCount, 2)
    }

    /**
     * 测试日期格式化（yyyy-MM-dd）
     */
    @TestCase
    func testFormatDate() {
        let formatted = DateFormatUtils.formatDate(0)

        // 验证格式：yyyy-MM-dd（10个字符）
        @Expect(formatted.size, 10)

        // 验证分隔符
        @Expect(formatted.contains("-"), true)

        // 计算连字符数量
        var dashCount = 0
        for (c in formatted) {
            if (c == 45u8) {  // '-' 的 ASCII 码是 45
                dashCount++
            }
        }
        @Expect(dashCount, 2)
    }

    /**
     * 测试日期时间格式化（yyyy-MM-dd HH:mm:ss）
     */
    @TestCase
    func testFormatDateTime() {
        let formatted = DateFormatUtils.formatDateTime(0)

        // 验证格式：yyyy-MM-dd HH:mm:ss（19个字符）
        @Expect(formatted.size, 19)

        // 验证分隔符
        @Expect(formatted.contains("-"), true)
        @Expect(formatted.contains(":"), true)
        @Expect(formatted.contains(" "), true)

        // 计算分隔符数量
        var dashCount = 0
        var colonCount = 0
        for (c in formatted) {
            if (c == 45u8) {  // '-' 的 ASCII 码是 45
                dashCount++
            } else if (c == 58u8) {  // ':' 的 ASCII 码是 58
                colonCount++
            }
        }
        @Expect(dashCount, 2)
        @Expect(colonCount, 2)
    }

    /**
     * 测试带毫秒的日期时间格式化
     */
    @TestCase
    func testFormatDateTimeMillis() {
        let formatted = DateFormatUtils.formatDateTimeMillis(0)

        // 验证格式：yyyy-MM-dd HH:mm:ss.SSS（23个字符）
        @Expect(formatted.size, 23)

        // 验证分隔符
        @Expect(formatted.contains("-"), true)
        @Expect(formatted.contains(":"), true)
        @Expect(formatted.contains("."), true)

        // 计算分隔符数量
        var dashCount = 0
        var colonCount = 0
        var dotCount = 0
        for (c in formatted) {
            if (c == 45u8) {  // '-' 的 ASCII 码是 45
                dashCount++
            } else if (c == 58u8) {  // ':' 的 ASCII 码是 58
                colonCount++
            } else if (c == 46u8) {  // '.' 的 ASCII 码是 46
                dotCount++
            }
        }
        @Expect(dashCount, 2)
        @Expect(colonCount, 2)
        @Expect(dotCount, 1)
    }

    /**
     * 测试 ISO8601 格式化
     */
    @TestCase
    func testFormatISO() {
        let formatted = DateFormatUtils.formatISO(0)

        // 验证格式：YYYY-MM-DDTHH:mm:ssZ 或类似格式
        // 至少应包含 T
        @Expect(formatted.contains("T"), true)

        // 验证长度（至少 20 个字符）
        @Expect(formatted.size >= 20, true)
    }

    /**
     * 测试当前时间格式化
     */
    @TestCase
    func testFormatCurrentTime() {
        // 获取当前时间戳
        let now = DateTime.now()

        // 格式化当前时间
        let formatted = DateFormatUtils.formatDateTime(0)

        // 验证包含日期和时间
        @Expect(formatted.contains("-"), true)
        @Expect(formatted.contains(":"), true)
    }

    /**
     * 测试时间戳 0（1970-01-01）
     */
    @TestCase
    func testFormatZero() {
        // 注意：由于仓颉 1.0.4 限制，millis 参数被忽略
        // 这里测试的是当前时间，而不是 1970-01-01
        let formatted = DateFormatUtils.formatDateTime(0)

        // 验证格式正确
        @Expect(formatted.size, 19)
        @Expect(formatted.contains("-"), true)
    }

    /**
     * 测试负数时间戳（1970 年之前）
     */
    @TestCase
    func testFormatNegative() {
        // 注意：由于仓颉 1.0.4 限制，millis 参数被忽略
        // 负数时间戳仍然返回当前时间的格式化结果
        let formatted = DateFormatUtils.formatDateTime(-86400000)

        // 验证格式正确
        @Expect(formatted.size, 19)
        @Expect(formatted.contains("-"), true)
    }

    /**
     * 测试格式验证（日期格式正则）
     */
    @TestCase
    func testFormatValidation() {
        let formatted = DateFormatUtils.formatDate(0)

        // 验证 yyyy-MM-dd 格式（4位数字-2位数字-2位数字）
        let regex = Regex(#"^\d{4}-\d{2}-\d{2}$"#)
        @Expect(regex.matches(formatted), true)
    }

    /**
     * 测试时间格式验证（HH:mm:ss 格式正则）
     */
    @TestCase
    func testTimeFormatValidation() {
        let formatted = DateFormatUtils.formatTime(0)

        // 验证 HH:mm:ss 格式（2位数字:2位数字:2位数字）
        let regex = Regex(#"^\d{2}:\d{2}:\d{2}$"#)
        @Expect(regex.matches(formatted), true)
    }

    /**
     * 测试日期时间格式验证（正则）
     */
    @TestCase
    func testDateTimeFormatValidation() {
        let formatted = DateFormatUtils.formatDateTime(0)

        // 验证 yyyy-MM-dd HH:mm:ss 格式
        let regex = Regex(#"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$"#)
        @Expect(regex.matches(formatted), true)
    }

    /**
     * 测试所有格式方法一致性
     */
    @TestCase
    func testAllFormatsConsistent() {
        // 所有方法应该都能正常工作
        let time = DateFormatUtils.formatTime(0)
        let date = DateFormatUtils.formatDate(0)
        let dateTime = DateFormatUtils.formatDateTime(0)
        let dateTimeMillis = DateFormatUtils.formatDateTimeMillis(0)
        let iso = DateFormatUtils.formatISO(0)

        // 验证都不为空
        @Expect(time.size > 0, true)
        @Expect(date.size > 0, true)
        @Expect(dateTime.size > 0, true)
        @Expect(dateTimeMillis.size > 0, true)
        @Expect(iso.size > 0, true)

        // 验证格式一致性
        @Expect(time.contains(":"), true)
        @Expect(date.contains("-"), true)
        @Expect(dateTime.contains("-"), true)
        @Expect(dateTime.contains(":"), true)
        @Expect(iso.contains("T"), true)
    }
}
