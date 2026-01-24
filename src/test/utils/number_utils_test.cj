package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

/**
 * NumberUtils 单元测试
 *
 * 测试覆盖 27 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class NumberUtilsTest {
    // ========== Phase 1: 字符串转数字测试 ==========

    @TestCase
    func testToInt() {
        // 有效整数
        @Expect(NumberUtils.toInt("123"), Some(123))
        @Expect(NumberUtils.toInt("-123"), Some(-123))
        @Expect(NumberUtils.toInt("0"), Some(0))

        // 无效字符串
        @Expect(NumberUtils.toInt("abc"), None)
        @Expect(NumberUtils.toInt(""), None)
        @Expect(NumberUtils.toInt("12.3"), None)
    }

    @TestCase
    func testToIntWithDefault() {
        // 有效整数返回转换值
        @Expect(NumberUtils.toInt("123", 0), 123)
        @Expect(NumberUtils.toInt("-456", -1), -456)

        // 无效字符串返回默认值
        @Expect(NumberUtils.toInt("abc", 0), 0)
        @Expect(NumberUtils.toInt("", -1), -1)
        @Expect(NumberUtils.toInt("12.3", 999), 999)
    }

    @TestCase
    func testToLong() {
        // 有效长整数
        @Expect(NumberUtils.toLong("12345678901234"), Some(12345678901234))
        @Expect(NumberUtils.toLong("-12345678901234"), Some(-12345678901234))
        @Expect(NumberUtils.toLong("0"), Some(0))

        // 无效字符串
        @Expect(NumberUtils.toLong("abc"), None)
        @Expect(NumberUtils.toLong(""), None)
        @Expect(NumberUtils.toLong("12.3"), None)
    }

    @TestCase
    func testToFloat() {
        // 有效浮点数
        @Expect(NumberUtils.toFloat("3.14"), Some(3.14))
        @Expect(NumberUtils.toFloat("-3.14"), Some(-3.14))
        @Expect(NumberUtils.toFloat("0.0"), Some(0.0))
        @Expect(NumberUtils.toFloat("123"), Some(123.0))

        // 无效字符串
        @Expect(NumberUtils.toFloat("abc"), None)
        @Expect(NumberUtils.toFloat(""), None)
    }

    @TestCase
    func testToDouble() {
        // toDouble 是 toFloat 的别名
        @Expect(NumberUtils.toDouble("3.1415926535"), Some(3.1415926535))
        @Expect(NumberUtils.toDouble("-3.14"), Some(-3.14))
        @Expect(NumberUtils.toDouble("abc"), None)
        @Expect(NumberUtils.toDouble(""), None)
    }

    // ========== Phase 2: 数字判断测试 ==========

    @TestCase
    func testIsDigits() {
        // 纯数字字符串
        @Expect(NumberUtils.isDigits("123"), true)
        @Expect(NumberUtils.isDigits("0"), true)
        @Expect(NumberUtils.isDigits("456789"), true)

        // 非纯数字
        @Expect(NumberUtils.isDigits("12.3"), false)
        @Expect(NumberUtils.isDigits("-123"), false)
        @Expect(NumberUtils.isDigits("abc"), false)
        @Expect(NumberUtils.isDigits(""), false)
        @Expect(NumberUtils.isDigits("12a3"), false)
    }

    @TestCase
    func testIsNumber() {
        // 有效数字格式
        @Expect(NumberUtils.isNumber("123"), true)
        @Expect(NumberUtils.isNumber("-123"), true)
        @Expect(NumberUtils.isNumber("12.3"), true)
        @Expect(NumberUtils.isNumber("1.23e10"), true)
        @Expect(NumberUtils.isNumber("-1.23e-10"), true)
        @Expect(NumberUtils.isNumber("0"), true)
        @Expect(NumberUtils.isNumber("0.0"), true)

        // 无效数字格式
        @Expect(NumberUtils.isNumber("abc"), false)
        @Expect(NumberUtils.isNumber(""), false)
        @Expect(NumberUtils.isNumber("--123"), false)
        @Expect(NumberUtils.isNumber("12.3.4"), false)
    }

    @TestCase
    func testIsParsable() {
        // 可解析的数字
        @Expect(NumberUtils.isParsable("123"), true)
        @Expect(NumberUtils.isParsable("-123"), true)
        @Expect(NumberUtils.isParsable("12.3"), true)
        @Expect(NumberUtils.isParsable("0"), true)

        // 不可解析
        @Expect(NumberUtils.isParsable("abc"), false)
        @Expect(NumberUtils.isParsable(""), false)
        @Expect(NumberUtils.isParsable("12.3.4"), false)
    }

    @TestCase
    func testIsCreatable() {
        // isCreatable 是 isParsable 的别名
        @Expect(NumberUtils.isCreatable("123"), true)
        @Expect(NumberUtils.isCreatable("12.3"), true)
        @Expect(NumberUtils.isCreatable("abc"), false)
        @Expect(NumberUtils.isCreatable(""), false)
    }

    // ========== Phase 3: 比较操作测试 ==========

    @TestCase
    func testCompareInt() {
        @Expect(NumberUtils.compare(1, 2), -1)
        @Expect(NumberUtils.compare(2, 2), 0)
        @Expect(NumberUtils.compare(3, 2), 1)
        @Expect(NumberUtils.compare(-10, 10), -1)
        @Expect(NumberUtils.compare(10, -10), 1)
    }

    @TestCase
    func testCompareFloat() {
        @Expect(NumberUtils.compare(1.5, 2.5), -1)
        @Expect(NumberUtils.compare(2.5, 2.5), 0)
        @Expect(NumberUtils.compare(3.5, 2.5), 1)
        @Expect(NumberUtils.compare(-10.0, 10.0), -1)
        @Expect(NumberUtils.compare(10.0, -10.0), 1)
    }

    @TestCase
    func testMinTwoValues() {
        @Expect(NumberUtils.min(1, 2), 1)
        @Expect(NumberUtils.min(5, 3), 3)
        @Expect(NumberUtils.min(10, 10), 10)
        @Expect(NumberUtils.min(-10, 10), -10)
        @Expect(NumberUtils.min(0, 0), 0)
    }

    @TestCase
    func testMaxTwoValues() {
        @Expect(NumberUtils.max(1, 2), 2)
        @Expect(NumberUtils.max(5, 3), 5)
        @Expect(NumberUtils.max(10, 10), 10)
        @Expect(NumberUtils.max(-10, 10), 10)
        @Expect(NumberUtils.max(0, 0), 0)
    }

    // ========== Phase 4: 范围检查测试 ==========

    @TestCase
    func testIsBetween() {
        // 在范围内（不包含边界）
        @Expect(NumberUtils.isBetween(5, 1, 10), true)
        @Expect(NumberUtils.isBetween(2, 1, 10), true)
        @Expect(NumberUtils.isBetween(9, 1, 10), true)

        // 不在范围内
        @Expect(NumberUtils.isBetween(0, 1, 10), false)
        @Expect(NumberUtils.isBetween(11, 1, 10), false)
        @Expect(NumberUtils.isBetween(1, 1, 10), false)  // 不包含边界
        @Expect(NumberUtils.isBetween(10, 1, 10), false) // 不包含边界
    }

    @TestCase
    func testInRange() {
        // 在范围内（包含边界）
        @Expect(NumberUtils.inRange(5, 1, 10), true)
        @Expect(NumberUtils.inRange(1, 1, 10), true)  // 包含边界
        @Expect(NumberUtils.inRange(10, 1, 10), true) // 包含边界

        // 不在范围内
        @Expect(NumberUtils.inRange(0, 1, 10), false)
        @Expect(NumberUtils.inRange(11, 1, 10), false)
    }

    // ========== Phase 5: 类型转换测试 ==========

    @TestCase
    func testToByte() {
        // 正常范围
        @Expect(NumberUtils.toByte(100), 100i8)
        @Expect(NumberUtils.toByte(0), 0i8)
        @Expect(NumberUtils.toByte(-100), -100i8)

        // 超出范围，截断
        @Expect(NumberUtils.toByte(200), 127i8)   // 最大值
        @Expect(NumberUtils.toByte(-200), -128i8) // 最小值
        @Expect(NumberUtils.toByte(1000), 127i8)
        @Expect(NumberUtils.toByte(-1000), -128i8)
    }

    @TestCase
    func testToShort() {
        // 正常范围
        @Expect(NumberUtils.toShort(1000), 1000i16)
        @Expect(NumberUtils.toShort(0), 0i16)
        @Expect(NumberUtils.toShort(-1000), -1000i16)

        // 超出范围，截断
        @Expect(NumberUtils.toShort(40000), 32767i16)   // 最大值
        @Expect(NumberUtils.toShort(-40000), -32768i16) // 最小值
        @Expect(NumberUtils.toShort(100000), 32767i16)
    }

    @TestCase
    func testIntToLong() {
        // Int64 到 Int64（直接返回）
        @Expect(NumberUtils.toLong(123), 123)
        @Expect(NumberUtils.toLong(0), 0)
        @Expect(NumberUtils.toLong(-456), -456)
    }

    @TestCase
    func testFloatToInt() {
        // 浮点数转整数（截断）
        @Expect(NumberUtils.toInt(3.14), 3)
        @Expect(NumberUtils.toInt(-3.14), -3)
        @Expect(NumberUtils.toInt(3.99), 3)
        @Expect(NumberUtils.toInt(0.0), 0)
        @Expect(NumberUtils.toInt(-0.99), 0)
    }

    @TestCase
    func testIntToFloat() {
        // 整数转浮点数
        @Expect(NumberUtils.toFloat(123), 123.0)
        @Expect(NumberUtils.toFloat(0), 0.0)
        @Expect(NumberUtils.toFloat(-456), -456.0)
    }

    // ========== Phase 6: 额外实用方法测试 ==========

    @TestCase
    func testClamp() {
        // 在范围内，返回原值
        @Expect(NumberUtils.clamp(5, 1, 10), 5)

        // 小于最小值，返回最小值
        @Expect(NumberUtils.clamp(0, 1, 10), 1)
        @Expect(NumberUtils.clamp(-10, 1, 10), 1)

        // 大于最大值，返回最大值
        @Expect(NumberUtils.clamp(11, 1, 10), 10)
        @Expect(NumberUtils.clamp(100, 1, 10), 10)

        // 边界值
        @Expect(NumberUtils.clamp(1, 1, 10), 1)
        @Expect(NumberUtils.clamp(10, 1, 10), 10)
    }

    @TestCase
    func testIsEven() {
        // 偶数
        @Expect(NumberUtils.isEven(2), true)
        @Expect(NumberUtils.isEven(0), true)
        @Expect(NumberUtils.isEven(-2), true)
        @Expect(NumberUtils.isEven(100), true)

        // 奇数
        @Expect(NumberUtils.isEven(3), false)
        @Expect(NumberUtils.isEven(1), false)
        @Expect(NumberUtils.isEven(-3), false)
    }

    @TestCase
    func testIsOdd() {
        // 奇数
        @Expect(NumberUtils.isOdd(3), true)
        @Expect(NumberUtils.isOdd(1), true)
        @Expect(NumberUtils.isOdd(-3), true)
        @Expect(NumberUtils.isOdd(101), true)

        // 偶数
        @Expect(NumberUtils.isOdd(2), false)
        @Expect(NumberUtils.isOdd(0), false)
        @Expect(NumberUtils.isOdd(-2), false)
    }

    @TestCase
    func testSum() {
        @Expect(NumberUtils.sum([1, 2, 3, 4, 5]), 15)
        @Expect(NumberUtils.sum([10, -10, 20]), 20)
        @Expect(NumberUtils.sum([0]), 0)
        @Expect(NumberUtils.sum([]), 0)
        @Expect(NumberUtils.sum([-1, -2, -3]), -6)
    }

    @TestCase
    func testMaxArray() {
        @Expect(NumberUtils.max([1, 5, 3, 9, 2]), 9)
        @Expect(NumberUtils.max([10, 20, 30]), 30)
        @Expect(NumberUtils.max([-10, -5, -1]), -1)
        @Expect(NumberUtils.max([42]), 42)

        // 空数组抛出异常
        try {
            NumberUtils.max([])
            @Expect(false, true)  // 不应该到达这里
        } catch (e: Exception) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testMinArray() {
        @Expect(NumberUtils.min([1, 5, 3, 9, 2]), 1)
        @Expect(NumberUtils.min([10, 20, 30]), 10)
        @Expect(NumberUtils.min([-10, -5, -1]), -10)
        @Expect(NumberUtils.min([42]), 42)

        // 空数组抛出异常
        try {
            NumberUtils.min([])
            @Expect(false, true)  // 不应该到达这里
        } catch (e: Exception) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testAverage() {
        @Expect(NumberUtils.average([1, 2, 3, 4, 5]), 3.0)
        @Expect(NumberUtils.average([10, 20, 30]), 20.0)
        @Expect(NumberUtils.average([0]), 0.0)
        @Expect(NumberUtils.average([-10, 10]), 0.0)

        // 空数组抛出异常
        try {
            NumberUtils.average([])
            @Expect(false, true)  // 不应该到达这里
        } catch (e: Exception) {
            @Expect(e.message.size > 0, true)
        }
    }

    // ========== Phase 7: 常量测试 ==========

    @TestCase
    func testConstants() {
        @Expect(NumberUtils.BYTE_MIN_VALUE, -128)
        @Expect(NumberUtils.BYTE_MAX_VALUE, 127)
        @Expect(NumberUtils.SHORT_MIN_VALUE, -32768)
        @Expect(NumberUtils.SHORT_MAX_VALUE, 32767)
        @Expect(NumberUtils.INT_MIN_VALUE, -2147483648)
        @Expect(NumberUtils.INT_MAX_VALUE, 2147483647)
    }

    // ========== Phase 8: 边界情况测试 ==========

    @TestCase
    func testEdgeCases() {
        // 最大/最小值
        @Expect(NumberUtils.toInt("2147483647"), Some(2147483647))
        @Expect(NumberUtils.toInt("-2147483648"), Some(-2147483648))

        // 非常大的数字
        @Expect(NumberUtils.toLong("9223372036854775807"), Some(9223372036854775807))

        // 小数点边界
        @Expect(NumberUtils.toFloat("0.0"), Some(0.0))
        @Expect(NumberUtils.toFloat("-0.0"), Some(0.0))
    }

    @TestCase
    func testScientificNotation() {
        // 科学计数法
        @Expect(NumberUtils.isNumber("1e10"), true)
        @Expect(NumberUtils.isNumber("1E10"), true)
        @Expect(NumberUtils.isNumber("1.5e-5"), true)
        @Expect(NumberUtils.isNumber("-1.5E5"), true)

        // 浮点数解析
        @Expect(NumberUtils.toFloat("1e10").isSome(), true)
        @Expect(NumberUtils.toDouble("1.5e-5").isSome(), true)
    }
}
