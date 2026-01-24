package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

/**
 * ValidateUtils 单元测试
 *
 * 测试覆盖 37 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class ValidateUtilsTest {
    // ========== Phase 1: 真值验证测试 ==========

    @TestCase
    func testIsTrue() {
        // true 通过
        ValidateUtils.isTrue(true)

        // false 抛出异常
        try {
            ValidateUtils.isTrue(false)
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testIsTrueWithMessage() {
        // true 通过
        ValidateUtils.isTrue(true, "错误消息")

        // false 抛出带自定义消息的异常
        try {
            ValidateUtils.isTrue(false, "值必须为true")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "值必须为true")
        }
    }

    @TestCase
    func testIsFalse() {
        // false 通过
        ValidateUtils.isFalse(false)

        // true 抛出异常
        try {
            ValidateUtils.isFalse(true)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testIsFalseWithMessage() {
        // false 通过
        ValidateUtils.isFalse(false, "错误消息")

        // true 抛出带自定义消息的异常
        try {
            ValidateUtils.isFalse(true, "值必须为false")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "值必须为false")
        }
    }

    // ========== Phase 2: 空值验证测试 ==========

    @TestCase
    func testNotNull() {
        // Some 值通过
        let val: Option<Int64> = Some(42)
        @Expect(ValidateUtils.notNull(val), 42)

        // None 抛出异常
        let noneVal: Option<Int64> = None
        try {
            ValidateUtils.notNull(noneVal)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testNotNullWithMessage() {
        let val: Option<Int64> = Some(42)
        @Expect(ValidateUtils.notNull(val, "对象不能为空"), 42)

        let noneVal: Option<Int64> = None
        try {
            ValidateUtils.notNull(noneVal, "对象不能为空")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "对象不能为空")
        }
    }

    @TestCase
    func testNotEmptyArray() {
        // 非空数组通过
        let arr1 = [1, 2, 3]
        @Expect(ValidateUtils.notEmpty(arr1).size, 3)

        // 空数组抛出异常
        let arr2: Array<Int64> = []
        try {
            ValidateUtils.notEmpty(arr2)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testNotEmptyStringArray() {
        let arr1 = ["a", "b", "c"]
        @Expect(ValidateUtils.notEmpty(arr1).size, 3)

        let arr2: Array<String> = []
        try {
            ValidateUtils.notEmpty(arr2)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testNotEmptyString() {
        @Expect(ValidateUtils.notEmpty("hello"), "hello")

        try {
            ValidateUtils.notEmpty("")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testNotBlank() {
        @Expect(ValidateUtils.notBlank("hello"), "hello")
        @Expect(ValidateUtils.notBlank("  hello  "), "  hello  ")

        try {
            ValidateUtils.notBlank("")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }

        try {
            ValidateUtils.notBlank("   ")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    // ========== Phase 3: 索引验证测试 ==========

    @TestCase
    func testValidIndexWithSize() {
        // 有效索引
        ValidateUtils.validIndex(0, 5)
        ValidateUtils.validIndex(4, 5)

        // 无效索引
        try {
            ValidateUtils.validIndex(-1, 5)
            @Expect(false, true)
        } catch (e: IndexOutOfBoundsException) {
        }

        try {
            ValidateUtils.validIndex(5, 5)
            @Expect(false, true)
        } catch (e: IndexOutOfBoundsException) {
        }
    }

    @TestCase
    func testValidIndexWithArray() {
        let arr = [1, 2, 3]

        // 有效索引
        ValidateUtils.validIndex(arr, 0)
        ValidateUtils.validIndex(arr, 2)

        // 无效索引
        try {
            ValidateUtils.validIndex(arr, -1)
            @Expect(false, true)
        } catch (e: IndexOutOfBoundsException) {
        }

        try {
            ValidateUtils.validIndex(arr, 3)
            @Expect(false, true)
        } catch (e: IndexOutOfBoundsException) {
        }
    }

    // ========== Phase 4: 范围验证测试 ==========

    @TestCase
    func testExclusiveBetween() {
        // 在范围内（不包含边界）
        ValidateUtils.exclusiveBetween(5, 10, 7)

        // 不在范围内
        try {
            ValidateUtils.exclusiveBetween(5, 10, 5)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }

        try {
            ValidateUtils.exclusiveBetween(5, 10, 10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testInclusiveBetween() {
        // 在范围内（包含边界）
        ValidateUtils.inclusiveBetween(5, 10, 5)
        ValidateUtils.inclusiveBetween(5, 10, 7)
        ValidateUtils.inclusiveBetween(5, 10, 10)

        // 不在范围内
        try {
            ValidateUtils.inclusiveBetween(5, 10, 4)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }

        try {
            ValidateUtils.inclusiveBetween(5, 10, 11)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    // ========== Phase 5: 类型验证测试 ==========

    @TestCase
    func testIsInstanceOf() {
        let val1: Option<String> = Some("hello")
        let val2: Option<Int64> = Some(42)
        let noneVal: Option<String> = None

        // String 类型检查
        let result1 = ValidateUtils.isInstanceOf(val1, { _: String => true }, { => false })
        @Expect(result1, true)

        let result2 = ValidateUtils.isInstanceOf(noneVal, { _: String => true }, { => false })
        @Expect(result2, false)

        // Int64 类型检查
        let result3 = ValidateUtils.isInstanceOf<Int64>(val2, { _ => true }, { => false })
        @Expect(result3, true)
    }

    @TestCase
    func testIsInstanceOfWithConverter() {
        let val1: Option<String> = Some("hello")
        @Expect(ValidateUtils.isInstanceOf(val1, "类型错误", { s => s }), "hello")

        let noneVal: Option<String> = None
        try {
            ValidateUtils.isInstanceOf(noneVal, "类型错误", { s => s })
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "类型错误")
        }
    }

    // ========== Phase 6: 正数与非负数验证测试 ==========

    @TestCase
    func testPositive() {
        @Expect(ValidateUtils.positive(10), 10)
        @Expect(ValidateUtils.positive(1), 1)

        try {
            ValidateUtils.positive(0)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }

        try {
            ValidateUtils.positive(-10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testPositiveWithMessage() {
        @Expect(ValidateUtils.positive(10, "错误"), 10)

        try {
            ValidateUtils.positive(0, "必须为正数")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "必须为正数")
        }
    }

    @TestCase
    func testNotNegative() {
        @Expect(ValidateUtils.notNegative(10), 10)
        @Expect(ValidateUtils.notNegative(0), 0)

        try {
            ValidateUtils.notNegative(-10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testNotNegativeWithMessage() {
        @Expect(ValidateUtils.notNegative(10, "错误"), 10)
        @Expect(ValidateUtils.notNegative(0, "错误"), 0)

        try {
            ValidateUtils.notNegative(-10, "不能为负数")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "不能为负数")
        }
    }

    // ========== Phase 7: 数组元素验证测试 ==========

    @TestCase
    func testNoNullElements() {
        let arr1 = [Some(1), Some(2), Some(3)]
        @Expect(ValidateUtils.noNullElements(arr1).size, 3)

        let arr2: Array<Option<Int64>> = [Some(1), None, Some(3)]
        try {
            ValidateUtils.noNullElements(arr2)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testNoNullElementsWithMessage() {
        let arr1 = [Some(1), Some(2), Some(3)]
        @Expect(ValidateUtils.noNullElements(arr1, "消息").size, 3)

        let arr2: Array<Option<Int64>> = [Some(1), None, Some(3)]
        try {
            ValidateUtils.noNullElements(arr2, "包含空元素")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "包含空元素")
        }
    }

    @TestCase
    func testNoEmptyElements() {
        let arr1 = ["a", "b", "c"]
        @Expect(ValidateUtils.noEmptyElements(arr1).size, 3)

        let arr2 = ["a", "", "c"]
        try {
            ValidateUtils.noEmptyElements(arr2)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testNoEmptyElementsWithMessage() {
        let arr1 = ["a", "b", "c"]
        @Expect(ValidateUtils.noEmptyElements(arr1, "消息").size, 3)

        let arr2 = ["a", "", "c"]
        try {
            ValidateUtils.noEmptyElements(arr2, "包含空字符串")
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "包含空字符串")
        }
    }

    // ========== Phase 8: 状态验证测试 ==========

    @TestCase
    func testValidState() {
        ValidateUtils.validState(true)

        try {
            ValidateUtils.validState(false)
            @Expect(false, true)
        } catch (e: IllegalStateException) {
        }
    }

    @TestCase
    func testValidStateWithMessage() {
        ValidateUtils.validState(true, "状态有效")

        try {
            ValidateUtils.validState(false, "对象未初始化")
            @Expect(false, true)
        } catch (e: IllegalStateException) {
            @Expect(e.message, "对象未初始化")
        }
    }

    @TestCase
    func testValidStateTrue() {
        ValidateUtils.validStateTrue(true)

        try {
            ValidateUtils.validStateTrue(false)
            @Expect(false, true)
        } catch (e: IllegalStateException) {
        }
    }

    // ========== Phase 9: 匹配元素验证测试 ==========

    @TestCase
    func testMatchesPattern() {
        @Expect(ValidateUtils.matchesPattern("abc123", #"^\w+$"#), "abc123")

        try {
            ValidateUtils.matchesPattern("abc-123", #"^\w+$"#)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testLength() {
        @Expect(ValidateUtils.length("hello", 1, 10), "hello")

        try {
            ValidateUtils.length("", 1, 10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }

        try {
            ValidateUtils.length("hello", 1, 3)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testInclusiveBetweenComparable() {
        @Expect(ValidateUtils.inclusiveBetweenComparable(5, 1, 10), 5)

        try {
            ValidateUtils.inclusiveBetweenComparable(0, 1, 10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }

        try {
            ValidateUtils.inclusiveBetweenComparable(11, 1, 10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testExclusiveOutside() {
        @Expect(ValidateUtils.exclusiveOutside(0, 10, 20), 0)
        @Expect(ValidateUtils.exclusiveOutside(25, 10, 20), 25)

        try {
            ValidateUtils.exclusiveOutside(12, 10, 20)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }

        try {
            ValidateUtils.exclusiveOutside(15, 10, 20)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testEqual() {
        ValidateUtils.equal(10, 10)

        try {
            ValidateUtils.equal(10, 20)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testNotEqual() {
        ValidateUtils.notEqual(10, 20)

        try {
            ValidateUtils.notEqual(10, 10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testEven() {
        @Expect(ValidateUtils.even(10), 10)
        @Expect(ValidateUtils.even(0), 0)

        try {
            ValidateUtils.even(11)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testOdd() {
        @Expect(ValidateUtils.odd(11), 11)
        @Expect(ValidateUtils.odd(-11), -11)

        try {
            ValidateUtils.odd(10)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testIsIn() {
        let validValues = [1, 2, 3, 4, 5]
        @Expect(ValidateUtils.isIn(3, validValues), 3)

        try {
            ValidateUtils.isIn(10, validValues)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func testIsNotIn() {
        let invalidValues = [1, 2, 3]
        @Expect(ValidateUtils.isNotIn(5, invalidValues), 5)

        try {
            ValidateUtils.isNotIn(2, invalidValues)
            @Expect(false, true)
        } catch (e: IllegalArgumentException) {
        }
    }

    // ========== 边界情况测试 ==========

    @TestCase
    func testBoundaryConditions() {
        // 边界值
        ValidateUtils.exclusiveBetween(0, 100, 50)
        ValidateUtils.inclusiveBetween(0, 100, 0)
        ValidateUtils.inclusiveBetween(0, 100, 100)

        // 索引边界
        let arr = [1, 2, 3]
        ValidateUtils.validIndex(arr, 0)
        ValidateUtils.validIndex(arr, arr.size - 1)

        // 字符串长度边界
        ValidateUtils.length("a", 1, 1)
        ValidateUtils.length("abc", 3, 3)
    }

    @TestCase
    func testMultipleValidations() {
        // 组合验证
        let value = 10
        ValidateUtils.positive(value)
        ValidateUtils.even(value)
        ValidateUtils.inclusiveBetween(0, 100, value)

        let arr = [Some(1), Some(2)]
        ValidateUtils.noNullElements(arr)
        ValidateUtils.notEmpty(arr)
    }
}
