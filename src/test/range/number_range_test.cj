package commons_lang4cj.test.range

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.range.NumberRange

/**
 * NumberRange 单元测试
 *
 * 测试覆盖 NumberRange 工厂类的所有公共方法
 * 测试覆盖率目标：≥ 90%
 */
@Test
class NumberRangeTest {
    /**
     * 测试 NumberRange.ofInt() 方法 - 基本整数范围
     */
    @TestCase
    func testOfIntBasic() {
        let range = NumberRange.ofInt(1, 10)

        @Expect(range.getMinimum(), 1)
        @Expect(range.getMaximum(), 10)
    }

    /**
     * 测试 NumberRange.ofInt() 方法 - 反向范围（自动交换）
     */
    @TestCase
    func testOfIntReversed() {
        let range = NumberRange.ofInt(10, 1)

        @Expect(range.getMinimum(), 1)
        @Expect(range.getMaximum(), 10)
    }

    /**
     * 测试 NumberRange.ofInt() 方法 - 负数范围
     */
    @TestCase
    func testOfIntNegative() {
        let range = NumberRange.ofInt(-10, -1)

        @Expect(range.getMinimum(), -10)
        @Expect(range.getMaximum(), -1)
    }

    /**
     * 测试 NumberRange.ofInt() 方法 - 包含零的范围
     */
    @TestCase
    func testOfIntIncludesZero() {
        let range = NumberRange.ofInt(-5, 5)

        @Expect(range.getMinimum(), -5)
        @Expect(range.getMaximum(), 5)
        @Expect(range.contains(0), true)
    }

    /**
     * 测试 NumberRange.ofDouble() 方法 - 基本浮点范围
     */
    @TestCase
    func testOfDoubleBasic() {
        let range = NumberRange.ofDouble(1.5, 10.5)

        @Expect(range.getMinimum(), 1.5)
        @Expect(range.getMaximum(), 10.5)
    }

    /**
     * 测试 NumberRange.ofDouble() 方法 - 反向范围
     */
    @TestCase
    func testOfDoubleReversed() {
        let range = NumberRange.ofDouble(10.5, 1.5)

        @Expect(range.getMinimum(), 1.5)
        @Expect(range.getMaximum(), 10.5)
    }

    /**
     * 测试 NumberRange.ofFloat() 方法 - 基本单精度浮点范围
     */
    @TestCase
    func testOfFloatBasic() {
        let range = NumberRange.ofFloat(1.5, 10.5)

        @Expect(range.getMinimum(), 1.5)
        @Expect(range.getMaximum(), 10.5)
    }

    /**
     * 测试 NumberRange.ofFloat() 方法 - 反向范围
     */
    @TestCase
    func testOfFloatReversed() {
        let range = NumberRange.ofFloat(10.5, 1.5)

        @Expect(range.getMinimum(), 1.5)
        @Expect(range.getMaximum(), 10.5)
    }
}
