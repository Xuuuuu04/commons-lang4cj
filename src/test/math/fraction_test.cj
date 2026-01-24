package commons_lang4cj.test.math

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.math.Fraction
import commons_lang4cj.math.ArithmeticException as CMathArithmeticException

/**
 * Fraction 类单元测试
 *
 * @since 1.1.0
 */
@Test
class FractionTest {
    // ==================== 工厂方法测试 ====================

    @TestCase
    func testGetFractionSimple() {
        let f = Fraction.getFraction(3, 7)
        @Expect(f.getNumerator(), 3)
        @Expect(f.getDenominator(), 7)
    }

    @TestCase
    func testGetFractionNegativeDenominator() {
        let f = Fraction.getFraction(1, -2)
        @Expect(f.getNumerator(), -1)
        @Expect(f.getDenominator(), 2)
    }

    @TestCase
    func testGetFractionZeroDenominator() {
        var caughtException = false
        try {
            Fraction.getFraction(1, 0)
        } catch (e: CMathArithmeticException) {
            caughtException = true
        }
        @Expect(caughtException, true) // 验证成功捕获异常
    }

    @TestCase
    func testGetFractionMixedNumber() {
        let f = Fraction.getFraction(1, 3, 7)
        @Expect(f.getNumerator(), 10)
        @Expect(f.getDenominator(), 7)
    }

    @TestCase
    func testGetFractionInt() {
        let f = Fraction.getFraction(5)
        @Expect(f.getNumerator(), 5)
        @Expect(f.getDenominator(), 1)
    }

    @TestCase
    func testGetReducedFraction() {
        let f = Fraction.getReducedFraction(2, 4)
        @Expect(f.getNumerator(), 1)
        @Expect(f.getDenominator(), 2)
    }

    @TestCase
    func testStaticConstants() {
        @Expect(Fraction.ZERO.getNumerator(), 0)
        @Expect(Fraction.ZERO.getDenominator(), 1)
        @Expect(Fraction.ONE.getNumerator(), 1)
        @Expect(Fraction.ONE_HALF.getNumerator(), 1)
        @Expect(Fraction.ONE_HALF.getDenominator(), 2)
    }

    // ==================== 查询方法测试 ====================

    @TestCase
    func testIsZero() {
        @Expect(Fraction.ZERO.isZero(), true)
        @Expect(Fraction.ONE.isZero(), false)
    }

    @TestCase
    func testIsPositive() {
        let f1 = Fraction.getFraction(3, 4)
        @Expect(f1.isPositive(), true)

        let f2 = Fraction.getFraction(-3, 4)
        @Expect(f2.isPositive(), false)
    }

    @TestCase
    func testIsNegative() {
        let f1 = Fraction.getFraction(-3, 4)
        @Expect(f1.isNegative(), true)

        let f2 = Fraction.getFraction(3, 4)
        @Expect(f2.isNegative(), false)
    }

    @TestCase
    func testGetProperWhole() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.getProperWhole(), 1)
    }

    @TestCase
    func testGetProperNumerator() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.getProperNumerator(), 3)
    }

    // ==================== 基本运算测试 ====================

    @TestCase
    func testAdd() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 3)
        let result = f1.add(f2)
        @Expect(result.getNumerator(), 5)
        @Expect(result.getDenominator(), 6)
    }

    @TestCase
    func testSubtract() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 3)
        let result = f1.subtract(f2)
        @Expect(result.getNumerator(), 1)
        @Expect(result.getDenominator(), 6)
    }

    @TestCase
    func testMultiplyBy() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(2, 3)
        let result = f1.multiplyBy(f2)
        @Expect(result.getNumerator(), 1)
        @Expect(result.getDenominator(), 3)
    }

    @TestCase
    func testDivideBy() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 4)
        let result = f1.divideBy(f2)
        @Expect(result.getNumerator(), 2)
        @Expect(result.getDenominator(), 1)
    }

    @TestCase
    func testDivideByZero() {
        let f1 = Fraction.getFraction(1, 2)
        var caughtException = false
        try {
            f1.divideBy(Fraction.ZERO)
        } catch (e: CMathArithmeticException) {
            caughtException = true
        }
        @Expect(caughtException, true) // 验证成功捕获异常
    }

    @TestCase
    func testNegate() {
        let f = Fraction.getFraction(1, 2)
        let result = f.negate()
        @Expect(result.getNumerator(), -1)
        @Expect(result.getDenominator(), 2)
    }

    @TestCase
    func testInvert() {
        let f = Fraction.getFraction(2, 3)
        let result = f.invert()
        @Expect(result.getNumerator(), 3)
        @Expect(result.getDenominator(), 2)
    }

    @TestCase
    func testInvertZero() {
        var caughtException = false
        try {
            Fraction.ZERO.invert()
        } catch (e: CMathArithmeticException) {
            caughtException = true
        }
        @Expect(caughtException, true) // 验证成功捕获异常
    }

    // ==================== 取整与幂运算测试 ====================

    @TestCase
    func testAbs() {
        let f = Fraction.getFraction(-3, 4)
        let result = f.abs()
        @Expect(result.getNumerator(), 3)
        @Expect(result.isPositive(), true)
    }

    @TestCase
    func testPow() {
        let f = Fraction.getFraction(2, 3)
        let result = f.pow(2)
        @Expect(result.getNumerator(), 4)
        @Expect(result.getDenominator(), 9)
    }

    @TestCase
    func testPowZero() {
        let f = Fraction.getFraction(2, 3)
        let result = f.pow(0)
        @Expect(result.getNumerator(), 1)
        @Expect(result.getDenominator(), 1)
    }

    @TestCase
    func testRemainder() {
        let f1 = Fraction.getFraction(7, 3)
        let f2 = Fraction.getFraction(2, 1)
        let remainder = f1.remainder(f2)
        @Expect(remainder.getNumerator(), 1)
        @Expect(remainder.getDenominator(), 3)
    }

    // ==================== 类型转换测试 ====================

    @TestCase
    func testToDouble() {
        let f = Fraction.getFraction(1, 2)
        let result = f.toDouble()
        // 浮点数转换允许一定的精度误差
        @Expect(result > 0.5 - 1e-15, true)
        @Expect(result < 0.5 + 1e-15, true)
    }

    @TestCase
    func testToFloat() {
        let f = Fraction.getFraction(1, 2)
        let result = f.toFloat()
        // 浮点数转换允许一定的精度误差
        @Expect(result > 0.5 - 1e-7, true)
        @Expect(result < 0.5 + 1e-7, true)
    }

    @TestCase
    func testToInt() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.toInt(), 1)
    }

    @TestCase
    func testToIntValue() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.toIntValue(), 1)
    }

    // ==================== 比较和哈希测试 ====================

    @TestCase
    func testCompareTo() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 3)
        @Expect(f1.compareTo(f2), 1)

        let f3 = Fraction.getFraction(1, 2)
        @Expect(f1.compareTo(f3), 0)

        let f4 = Fraction.getFraction(1, 4)
        @Expect(f4.compareTo(f1), -1)
    }

    @TestCase
    func testEquals() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(2, 4)
        @Expect(f1.equals(f2), false)

        let f3 = Fraction.getFraction(1, 2)
        @Expect(f1.equals(f3), true)

        @Expect(f1.equals(None), false)
    }

    @TestCase
    func testHashCode() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 2)
        @Expect(f1.hashCode(), f2.hashCode())
    }

    // ==================== 字符串方法测试 ====================

    @TestCase
    func testToString() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.toString(), "7/4")
    }

    @TestCase
    func testToProperString() {
        let f = Fraction.getFraction(7, 4)
        @Expect(f.toProperString(), "1 3/4")

        let f2 = Fraction.getFraction(3, 4)
        @Expect(f2.toProperString(), "3/4")

        let f3 = Fraction.getFraction(4, 2)
        @Expect(f3.toProperString(), "2")
    }

    // ==================== 边界情况测试 ====================

    @TestCase
    func testLargeNumbers() {
        let f = Fraction.getReducedFraction(1000000, 2000000)
        @Expect(f.getNumerator(), 1)
        @Expect(f.getDenominator(), 2)
    }

    @TestCase
    func testZeroAdd() {
        let f1 = Fraction.getFraction(1, 2)
        let result = f1.add(Fraction.ZERO)
        @Expect(result.getNumerator(), f1.getNumerator())
        @Expect(result.getDenominator(), f1.getDenominator())
    }

    @TestCase
    func testZeroMultiply() {
        let f1 = Fraction.getFraction(1, 2)
        let result = f1.multiplyBy(Fraction.ZERO)
        @Expect(result.getNumerator(), 0)
        @Expect(result.getDenominator(), 1)
    }

    @TestCase
    func testNegativeAdd() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(-1, 2)
        let result = f1.add(f2)
        @Expect(result.getNumerator(), 0)
        @Expect(result.getDenominator(), 1)
    }

    @TestCase
    func testFractionGreaterThanOne() {
        let f = Fraction.getFraction(5, 3)
        @Expect(f.getProperWhole(), 1)
        @Expect(f.getProperNumerator(), 2)
        @Expect(f.toProperString(), "1 2/3")
    }

    @TestCase
    func testComplexCalculation() {
        let f1 = Fraction.getFraction(1, 2)
        let f2 = Fraction.getFraction(1, 3)
        let f3 = Fraction.getFraction(1, 6)

        // (1/2 + 1/3 - 1/6) × 2 = ?
        let result = f1.add(f2).subtract(f3).multiplyBy(Fraction.getFraction(2, 1))
        @Expect(result.getNumerator(), 4)
        @Expect(result.getDenominator(), 3)
    }
}
