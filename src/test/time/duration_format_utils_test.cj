package commons_lang4cj.test.time

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.time.*

/**
 * DurationFormatUtils 单元测试
 *
 * 测试覆盖：
 * - 默认格式化（formatDuration）
 * - HMS 格式化（formatDurationHMS）
 * - ISO8601 格式化（formatDurationISO）
 * - 英文单词格式化（formatDurationWords）
 * - 自定义格式化（formatDuration with pattern）
 * - 边缘情况（0、负数、大时长）
 *
 * @since 1.2.0
 */
@Test
class DurationFormatUtilsTest {
    /**
     * 测试默认格式化 - 天
     */
    @TestCase
    func testFormatDurationDays() {
        @Expect(DurationFormatUtils.formatDuration(86400000), "1天")
        @Expect(DurationFormatUtils.formatDuration(172800000), "2天")
    }

    /**
     * 测试默认格式化 - 小时
     */
    @TestCase
    func testFormatDurationHours() {
        @Expect(DurationFormatUtils.formatDuration(3600000), "1小时")
        @Expect(DurationFormatUtils.formatDuration(7200000), "2小时")
        @Expect(DurationFormatUtils.formatDuration(3661000), "1小时 1分 1秒")
    }

    /**
     * 测试默认格式化 - 分钟
     */
    @TestCase
    func testFormatDurationMinutes() {
        @Expect(DurationFormatUtils.formatDuration(60000), "1分")
        @Expect(DurationFormatUtils.formatDuration(120000), "2分")
        @Expect(DurationFormatUtils.formatDuration(61000), "1分 1秒")
    }

    /**
     * 测试默认格式化 - 秒
     */
    @TestCase
    func testFormatDurationSeconds() {
        @Expect(DurationFormatUtils.formatDuration(1000), "1秒")
        @Expect(DurationFormatUtils.formatDuration(2000), "2秒")
        @Expect(DurationFormatUtils.formatDuration(0), "0秒")
    }

    /**
     * 测试默认格式化 - 复合时长
     */
    @TestCase
    func testFormatDurationCompound() {
        @Expect(DurationFormatUtils.formatDuration(90061000), "1天 1小时 1分 1秒")
        @Expect(DurationFormatUtils.formatDuration(90061234), "1天 1小时 1分 1秒")
    }

    /**
     * 测试默认格式化 - 负数
     */
    @TestCase
    func testFormatDurationNegative() {
        @Expect(DurationFormatUtils.formatDuration(-1000), "-1秒")
        @Expect(DurationFormatUtils.formatDuration(-3661000), "-1小时 1分 1秒")
    }

    /**
     * 测试 HMS 格式化
     */
    @TestCase
    func testFormatDurationHMS() {
        @Expect(DurationFormatUtils.formatDurationHMS(0), "00:00:00")
        @Expect(DurationFormatUtils.formatDurationHMS(1000), "00:00:01")
        @Expect(DurationFormatUtils.formatDurationHMS(61000), "00:01:01")
        @Expect(DurationFormatUtils.formatDurationHMS(3661000), "01:01:01")
        @Expect(DurationFormatUtils.formatDurationHMS(90061000), "25:01:01")
    }

    /**
     * 测试 HMS 格式化 - 负数
     */
    @TestCase
    func testFormatDurationHMSNegative() {
        @Expect(DurationFormatUtils.formatDurationHMS(-1000), "-00:00:01")
        @Expect(DurationFormatUtils.formatDurationHMS(-3661000), "-01:01:01")
    }

    /**
     * 测试 ISO8601 格式化
     */
    @TestCase
    func testFormatDurationISO() {
        @Expect(DurationFormatUtils.formatDurationISO(0), "PT0S")
        @Expect(DurationFormatUtils.formatDurationISO(1000), "PT1S")
        @Expect(DurationFormatUtils.formatDurationISO(61000), "PT1M1S")
        @Expect(DurationFormatUtils.formatDurationISO(3661000), "PT1H1M1S")
        @Expect(DurationFormatUtils.formatDurationISO(90061000), "P1DT1H1M1S")
    }

    /**
     * 测试 ISO8601 格式化 - 带毫秒
     */
    @TestCase
    func testFormatDurationISOMillis() {
        @Expect(DurationFormatUtils.formatDurationISO(1234), "PT1.234S")
        @Expect(DurationFormatUtils.formatDurationISO(61234), "PT1M1.234S")
    }

    /**
     * 测试英文单词格式化
     */
    @TestCase
    func testFormatDurationWords() {
        @Expect(DurationFormatUtils.formatDurationWords(0), "0 seconds")
        @Expect(DurationFormatUtils.formatDurationWords(1000), "1 second")
        @Expect(DurationFormatUtils.formatDurationWords(2000), "2 seconds")
        @Expect(DurationFormatUtils.formatDurationWords(60000), "1 minute")
        @Expect(DurationFormatUtils.formatDurationWords(3600000), "1 hour")
        @Expect(DurationFormatUtils.formatDurationWords(86400000), "1 day")
        @Expect(DurationFormatUtils.formatDurationWords(90061000), "1 day 1 hour 1 minute 1 second")
    }

    /**
     * 测试英文单词格式化 - 复数形式
     */
    @TestCase
    func testFormatDurationWordsPlural() {
        @Expect(DurationFormatUtils.formatDurationWords(7200000), "2 hours")
        @Expect(DurationFormatUtils.formatDurationWords(120000), "2 minutes")
        @Expect(DurationFormatUtils.formatDurationWords(2000), "2 seconds")
    }

    /**
     * 测试自定义格式化
     */
    @TestCase
    func testFormatDurationWithPattern() {
        @Expect(DurationFormatUtils.formatDuration(3661000, "%H小时%m分%s秒"), "1小时1分1秒")
        @Expect(DurationFormatUtils.formatDuration(3661000, "%d天%H小时%m分%s秒"), "0天1小时1分1秒")
        @Expect(DurationFormatUtils.formatDuration(90061000, "%d天%H小时%m分%s秒"), "1天1小时1分1秒")
    }

    /**
     * 测试自定义格式化 - 毫秒补零
     */
    @TestCase
    func testFormatDurationWithPatternMillis() {
        @Expect(DurationFormatUtils.formatDuration(1234, "%s.%S"), "1.234")
        @Expect(DurationFormatUtils.formatDuration(100, "%s.%S"), "0.100")
        @Expect(DurationFormatUtils.formatDuration(1, "%s.%S"), "0.001")
    }

    /**
     * 测试大时长（超过 1 天）
     */
    @TestCase
    func testLargeDuration() {
        let twoDays = 2 * 86400000
        @Expect(DurationFormatUtils.formatDuration(twoDays), "2天")
        @Expect(DurationFormatUtils.formatDurationHMS(twoDays), "48:00:00")
    }
}
