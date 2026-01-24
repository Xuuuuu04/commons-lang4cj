package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

/**
 * BooleanUtils 单元测试
 *
 * 测试覆盖 23 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class BooleanUtilsTest {
    // ========== 基本比较操作测试 ==========

    @TestCase
    func testIsTrue() {
        @Expect(BooleanUtils.isTrue(true), true)
        @Expect(BooleanUtils.isTrue(false), false)
    }

    @TestCase
    func testIsFalse() {
        @Expect(BooleanUtils.isFalse(true), false)
        @Expect(BooleanUtils.isFalse(false), true)
    }

    @TestCase
    func testIsNotTrue() {
        @Expect(BooleanUtils.isNotTrue(true), false)
        @Expect(BooleanUtils.isNotTrue(false), true)
    }

    @TestCase
    func testIsNotFalse() {
        @Expect(BooleanUtils.isNotFalse(true), true)
        @Expect(BooleanUtils.isNotFalse(false), false)
    }

    @TestCase
    func testNegate() {
        @Expect(BooleanUtils.negate(true), false)
        @Expect(BooleanUtils.negate(false), true)
    }

    // ========== 字符串转换测试 ==========

    @TestCase
    func testToBooleanString() {
        // true 值（不区分大小写）
        @Expect(BooleanUtils.toBoolean("true"), true)
        @Expect(BooleanUtils.toBoolean("TRUE"), true)
        @Expect(BooleanUtils.toBoolean("TrUe"), true)

        @Expect(BooleanUtils.toBoolean("on"), true)
        @Expect(BooleanUtils.toBoolean("ON"), true)
        @Expect(BooleanUtils.toBoolean("yes"), true)
        @Expect(BooleanUtils.toBoolean("YES"), true)
        @Expect(BooleanUtils.toBoolean("y"), true)
        @Expect(BooleanUtils.toBoolean("Y"), true)
        @Expect(BooleanUtils.toBoolean("t"), true)
        @Expect(BooleanUtils.toBoolean("T"), true)
        @Expect(BooleanUtils.toBoolean("1"), true)

        // false 值
        @Expect(BooleanUtils.toBoolean("false"), false)
        @Expect(BooleanUtils.toBoolean("FALSE"), false)
        @Expect(BooleanUtils.toBoolean("off"), false)
        @Expect(BooleanUtils.toBoolean("no"), false)
        @Expect(BooleanUtils.toBoolean("n"), false)
        @Expect(BooleanUtils.toBoolean("f"), false)
        @Expect(BooleanUtils.toBoolean("0"), false)

        // 无效值返回 false
        @Expect(BooleanUtils.toBoolean("invalid"), false)
        @Expect(BooleanUtils.toBoolean(""), false)
        @Expect(BooleanUtils.toBoolean("abc"), false)
    }

    @TestCase
    func testToBooleanStringWithDefault() {
        // 有效值返回对应值
        @Expect(BooleanUtils.toBoolean("true", false), true)
        @Expect(BooleanUtils.toBoolean("false", true), false)

        // 无效值返回默认值
        @Expect(BooleanUtils.toBoolean("invalid", false), false)
        @Expect(BooleanUtils.toBoolean("invalid", true), true)
        @Expect(BooleanUtils.toBoolean("", true), true)
    }

    @TestCase
    func testToBooleanObject() {
        // true 值
        @Expect(BooleanUtils.toBooleanObject("true"), Some(true))
        @Expect(BooleanUtils.toBooleanObject("yes"), Some(true))
        @Expect(BooleanUtils.toBooleanObject("on"), Some(true))
        @Expect(BooleanUtils.toBooleanObject("1"), Some(true))

        // false 值
        @Expect(BooleanUtils.toBooleanObject("false"), Some(false))
        @Expect(BooleanUtils.toBooleanObject("no"), Some(false))
        @Expect(BooleanUtils.toBooleanObject("0"), Some(false))

        // 无效值返回 None
        @Expect(BooleanUtils.toBooleanObject("invalid"), None)
        @Expect(BooleanUtils.toBooleanObject(""), None)
    }

    @TestCase
    func testToString() {
        @Expect(BooleanUtils.toString(true), "true")
        @Expect(BooleanUtils.toString(false), "false")
    }

    @TestCase
    func testToStringOnOff() {
        @Expect(BooleanUtils.toStringOnOff(true), "on")
        @Expect(BooleanUtils.toStringOnOff(false), "off")
    }

    @TestCase
    func testToStringYesNo() {
        @Expect(BooleanUtils.toStringYesNo(true), "yes")
        @Expect(BooleanUtils.toStringYesNo(false), "no")
    }

    // ========== 整数转换测试 ==========

    @TestCase
    func testIntToBoolean() {
        @Expect(BooleanUtils.toBoolean(0), false)
        @Expect(BooleanUtils.toBoolean(1), true)
        @Expect(BooleanUtils.toBoolean(-1), true)
        @Expect(BooleanUtils.toBoolean(2), true)
        @Expect(BooleanUtils.toBoolean(100), true)
        @Expect(BooleanUtils.toBoolean(-100), true)
    }

    @TestCase
    func testBooleanToInteger() {
        @Expect(BooleanUtils.toInteger(true), 1)
        @Expect(BooleanUtils.toInteger(false), 0)
    }

    // ========== 逻辑运算测试 ==========

    @TestCase
    func testAndTwoValues() {
        @Expect(BooleanUtils.and(true, true), true)
        @Expect(BooleanUtils.and(true, false), false)
        @Expect(BooleanUtils.and(false, true), false)
        @Expect(BooleanUtils.and(false, false), false)
    }

    @TestCase
    func testOrTwoValues() {
        @Expect(BooleanUtils.or(true, true), true)
        @Expect(BooleanUtils.or(true, false), true)
        @Expect(BooleanUtils.or(false, true), true)
        @Expect(BooleanUtils.or(false, false), false)
    }

    @TestCase
    func testXorTwoValues() {
        @Expect(BooleanUtils.xor(true, true), false)
        @Expect(BooleanUtils.xor(true, false), true)
        @Expect(BooleanUtils.xor(false, true), true)
        @Expect(BooleanUtils.xor(false, false), false)
    }

    @TestCase
    func testNand() {
        @Expect(BooleanUtils.nand(true, true), false)
        @Expect(BooleanUtils.nand(true, false), true)
        @Expect(BooleanUtils.nand(false, true), true)
        @Expect(BooleanUtils.nand(false, false), true)
    }

    // ========== 数组操作测试 ==========

    @TestCase
    func testAndArray() {
        // 所有元素都为 true
        @Expect(BooleanUtils.and([true, true, true]), true)

        // 有 false 元素
        @Expect(BooleanUtils.and([true, false, true]), false)
        @Expect(BooleanUtils.and([false, false, false]), false)

        // 空数组返回 true
        @Expect(BooleanUtils.and([]), true)

        // 单元素数组
        @Expect(BooleanUtils.and([true]), true)
        @Expect(BooleanUtils.and([false]), false)
    }

    @TestCase
    func testOrArray() {
        // 有 true 元素
        @Expect(BooleanUtils.or([true, true, true]), true)
        @Expect(BooleanUtils.or([true, false, true]), true)
        @Expect(BooleanUtils.or([false, true, false]), true)

        // 全部为 false
        @Expect(BooleanUtils.or([false, false, false]), false)

        // 空数组返回 false
        @Expect(BooleanUtils.or([]), false)

        // 单元素数组
        @Expect(BooleanUtils.or([true]), true)
        @Expect(BooleanUtils.or([false]), false)
    }

    @TestCase
    func testXorArray() {
        // true 的个数为偶数
        @Expect(BooleanUtils.xor([true, true]), false)
        @Expect(BooleanUtils.xor([true, true, true, true]), false)
        @Expect(BooleanUtils.xor([false, false]), false)

        // true 的个数为奇数
        @Expect(BooleanUtils.xor([true, false]), true)
        @Expect(BooleanUtils.xor([true, true, true]), true)
        @Expect(BooleanUtils.xor([true, false, false]), true)

        // 空数组返回 false
        @Expect(BooleanUtils.xor([]), false)
    }

    @TestCase
    func testCountTrue() {
        @Expect(BooleanUtils.countTrue([true, false, true]), 2)
        @Expect(BooleanUtils.countTrue([false, false]), 0)
        @Expect(BooleanUtils.countTrue([true, true]), 2)
        @Expect(BooleanUtils.countTrue([true, true, true, true]), 4)
        @Expect(BooleanUtils.countTrue([]), 0)
    }

    @TestCase
    func testCountFalse() {
        @Expect(BooleanUtils.countFalse([true, false, true]), 1)
        @Expect(BooleanUtils.countFalse([false, false]), 2)
        @Expect(BooleanUtils.countFalse([true, true]), 0)
        @Expect(BooleanUtils.countFalse([false, false, false, false]), 4)
        @Expect(BooleanUtils.countFalse([]), 0)
    }

    // ========== 比较操作测试 ==========

    @TestCase
    func testCompare() {
        // 相等
        @Expect(BooleanUtils.compare(true, true), 0)
        @Expect(BooleanUtils.compare(false, false), 0)

        // true > false
        @Expect(BooleanUtils.compare(true, false), 1)
        @Expect(BooleanUtils.compare(false, true), -1)
    }

    // ========== 常量测试 ==========

    @TestCase
    func testConstants() {
        @Expect(BooleanUtils.FALSE, "false")
        @Expect(BooleanUtils.NO, "no")
        @Expect(BooleanUtils.OFF, "off")
        @Expect(BooleanUtils.ON, "on")
        @Expect(BooleanUtils.TRUE, "true")
        @Expect(BooleanUtils.YES, "yes")
    }

    // ========== 边界情况测试 ==========

    @TestCase
    func testEdgeCases() {
        // 混合大小写
        @Expect(BooleanUtils.toBoolean("TrUe"), true)
        @Expect(BooleanUtils.toBoolean("FaLsE"), false)
        @Expect(BooleanUtils.toBoolean("YeS"), true)
        @Expect(BooleanUtils.toBoolean("No"), false)

        // 空字符串
        @Expect(BooleanUtils.toBoolean(""), false)
        @Expect(BooleanUtils.toBooleanObject(""), None)

        // 带空格的字符串（应该无效）
        @Expect(BooleanUtils.toBoolean(" true"), false)
        @Expect(BooleanUtils.toBoolean("true "), false)

        // 大型数组
        let largeArray = Array<Bool>(100, { _ => true })
        @Expect(BooleanUtils.and(largeArray), true)
        @Expect(BooleanUtils.countTrue(largeArray), 100)

        let mixedArray = Array<Bool>(10, { i => i % 2 == 0 })
        @Expect(BooleanUtils.xor(mixedArray), true)  // 5 个 true（索引 0,2,4,6,8），奇数个 true
    }

    @TestCase
    func testArrayOperations() {
        // 测试空数组的各种操作
        let emptyArray = Array<Bool>()
        @Expect(BooleanUtils.and(emptyArray), true)
        @Expect(BooleanUtils.or(emptyArray), false)
        @Expect(BooleanUtils.xor(emptyArray), false)
        @Expect(BooleanUtils.countTrue(emptyArray), 0)
        @Expect(BooleanUtils.countFalse(emptyArray), 0)
    }
}
