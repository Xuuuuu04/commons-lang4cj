package commons_lang4cj.test.math

import std.unittest.*
import std.unittest.testmacro.*
import std.math.*
import commons_lang4cj.math.IEEE754rUtils

/**
 * IEEE754rUtils 单元测试
 *
 * 测试 IEEE754rUtils 类的所有公共方法
 * 覆盖 NaN、无穷大、正常值等各种情况
 */
@Test
class IEEE754rUtilsTest {

    // ========== isNaN 测试 ==========

    /**
     * 测试 Float64 isNaN 方法 - 正常值
     */
    @TestCase
    func testIsNaNFloat64WithNormalValue() {
        @Expect(IEEE754rUtils.isNaN(1.0), false)
        @Expect(IEEE754rUtils.isNaN(0.0), false)
        @Expect(IEEE754rUtils.isNaN(-1.0), false)
        @Expect(IEEE754rUtils.isNaN(1.7976931348623157e308), false)  // Float64.max
        @Expect(IEEE754rUtils.isNaN(-1.7976931348623157e308), false) // Float64.min
    }

    /**
     * 测试 Float64 isNaN 方法 - NaN 值
     */
    @TestCase
    func testIsNaNFloat64WithNaN() {
        let nan1 = 0.0 / 0.0
        let nan2 = nan1  // NaN无法直接比较,使用已有的NaN值

        @Expect(IEEE754rUtils.isNaN(nan1), true)
        @Expect(IEEE754rUtils.isNaN(nan2), true)
    }

    /**
     * 测试 Float32 isNaN 方法 - 正常值
     */
    @TestCase
    func testIsNaNFloat32WithNormalValue() {
        let f1: Float32 = 1.0
        let f2: Float32 = 0.0
        let f3: Float32 = -1.0
        let f4: Float32 = 3.4028234663852886e38  // Float32.max
        let f5: Float32 = -3.4028234663852886e38 // Float32.min
        @Expect(IEEE754rUtils.isNaN(f1), false)
        @Expect(IEEE754rUtils.isNaN(f2), false)
        @Expect(IEEE754rUtils.isNaN(f3), false)
        @Expect(IEEE754rUtils.isNaN(f4), false)
        @Expect(IEEE754rUtils.isNaN(f5), false)
    }

    /**
     * 测试 Float32 isNaN 方法 - NaN 值
     */
    @TestCase
    func testIsNaNFloat32WithNaN() {
        let nan1 = 0.0f32 / 0.0f32
        let nan2 = nan1  // 复用同一个NaN值

        @Expect(IEEE754rUtils.isNaN(nan1), true)
        @Expect(IEEE754rUtils.isNaN(nan2), true)
    }

    // ========== isInfinite 测试 ==========

    /**
     * 测试 Float64 isInfinite 方法 - 正无穷大
     */
    @TestCase
    func testIsInfiniteFloat64WithPositiveInfinity() {
        let posInf = 1.0 / 0.0

        @Expect(IEEE754rUtils.isInfinite(posInf), true)
    }

    /**
     * 测试 Float64 isInfinite 方法 - 负无穷大
     */
    @TestCase
    func testIsInfiniteFloat64WithNegativeInfinity() {
        let negInf = -1.0 / 0.0

        @Expect(IEEE754rUtils.isInfinite(negInf), true)
    }

    /**
     * 测试 Float64 isInfinite 方法 - 正常值
     */
    @TestCase
    func testIsInfiniteFloat64WithNormalValue() {
        @Expect(IEEE754rUtils.isInfinite(1.0), false)
        @Expect(IEEE754rUtils.isInfinite(0.0), false)
        @Expect(IEEE754rUtils.isInfinite(1.7976931348623157e308), false)  // Float64.max
    }

    /**
     * 测试 Float32 isInfinite 方法
     */
    @TestCase
    func testIsInfiniteFloat32() {
        let posInf = 1.0f32 / 0.0f32
        let negInf = -1.0f32 / 0.0f32

        @Expect(IEEE754rUtils.isInfinite(posInf), true)
        @Expect(IEEE754rUtils.isInfinite(negInf), true)
        @Expect(IEEE754rUtils.isInfinite(1.0f32), false)
    }

    // ========== compare 测试 ==========

    /**
     * 测试 Float64 compare 方法 - 正常值
     */
    @TestCase
    func testCompareFloat64WithNormalValues() {
        @Expect(IEEE754rUtils.compare(1.0, 2.0) < 0, true)
        @Expect(IEEE754rUtils.compare(2.0, 1.0) > 0, true)
        @Expect(IEEE754rUtils.compare(1.0, 1.0) == 0, true)
        @Expect(IEEE754rUtils.compare(-1.0, 1.0) < 0, true)
        @Expect(IEEE754rUtils.compare(0.0, -0.0) == 0, true)
    }

    /**
     * 测试 Float64 compare 方法 - NaN 情况
     */
    @TestCase
    func testCompareFloat64WithNaN() {
        let nan = 0.0 / 0.0
        let negInf = -1.0 / 0.0

        // NaN < 所有值
        @Expect(IEEE754rUtils.compare(nan, 1.0) < 0, true)
        @Expect(IEEE754rUtils.compare(1.0, nan) > 0, true)
        @Expect(IEEE754rUtils.compare(nan, negInf) < 0, true)

        // 两个 NaN 视为相等
        @Expect(IEEE754rUtils.compare(nan, nan) == 0, true)
    }

    /**
     * 测试 Float32 compare 方法
     */
    @TestCase
    func testCompareFloat32() {
        let nan = 0.0f32 / 0.0f32

        // 正常值比较
        @Expect(IEEE754rUtils.compare(1.0f32, 2.0f32) < 0, true)
        @Expect(IEEE754rUtils.compare(2.0f32, 1.0f32) > 0, true)
        @Expect(IEEE754rUtils.compare(1.0f32, 1.0f32) == 0, true)

        // NaN 比较
        @Expect(IEEE754rUtils.compare(nan, 1.0f32) < 0, true)
        @Expect(IEEE754rUtils.compare(1.0f32, nan) > 0, true)
        @Expect(IEEE754rUtils.compare(nan, nan) == 0, true)
    }

    // ========== Float64 min/max 测试 ==========

    /**
     * 测试 Float64 min 方法 - 正常值
     */
    @TestCase
    func testMinFloat64WithNormalValues() {
        @Expect(IEEE754rUtils.min(1.0, 2.0), 1.0)
        @Expect(IEEE754rUtils.min(2.0, 1.0), 1.0)
        @Expect(IEEE754rUtils.min(-1.0, 1.0), -1.0)
        @Expect(IEEE754rUtils.min(0.0, 0.0), 0.0)
    }

    /**
     * 测试 Float64 min 方法 - NaN 情况
     */
    @TestCase
    func testMinFloat64WithNaN() {
        let nan = 0.0 / 0.0

        // NaN < 所有值
        let result1 = IEEE754rUtils.min(nan, 1.0)
        let result2 = IEEE754rUtils.min(1.0, nan)

        @Expect(IEEE754rUtils.isNaN(result1), true)
        @Expect(IEEE754rUtils.isNaN(result2), true)
    }

    /**
     * 测试 Float64 min 方法 - 无穷大
     */
    @TestCase
    func testMinFloat64WithInfinity() {
        let negInf = -1.0 / 0.0
        let posInf = 1.0 / 0.0

        @Expect(IEEE754rUtils.min(negInf, 1.0), negInf)
        @Expect(IEEE754rUtils.min(posInf, 1.0), 1.0)
    }

    /**
     * 测试 Float64 max 方法 - 正常值
     */
    @TestCase
    func testMaxFloat64WithNormalValues() {
        @Expect(IEEE754rUtils.max(1.0, 2.0), 2.0)
        @Expect(IEEE754rUtils.max(2.0, 1.0), 2.0)
        @Expect(IEEE754rUtils.max(-1.0, 1.0), 1.0)
        @Expect(IEEE754rUtils.max(0.0, 0.0), 0.0)
    }

    /**
     * 测试 Float64 max 方法 - NaN 情况
     */
    @TestCase
    func testMaxFloat64WithNaN() {
        let nan = 0.0 / 0.0

        // 如果任一是 NaN,返回 NaN
        let result1 = IEEE754rUtils.max(nan, 1.0)
        let result2 = IEEE754rUtils.max(1.0, nan)

        @Expect(IEEE754rUtils.isNaN(result1), true)
        @Expect(IEEE754rUtils.isNaN(result2), true)
    }

    /**
     * 测试 Float64 max 方法 - 无穷大
     */
    @TestCase
    func testMaxFloat64WithInfinity() {
        let posInf = 1.0 / 0.0
        let negInf = -1.0 / 0.0

        @Expect(IEEE754rUtils.max(posInf, 1.0), posInf)
        @Expect(IEEE754rUtils.max(negInf, 1.0), 1.0)
    }

    /**
     * 测试 Float64 min 数组方法
     */
    @TestCase
    func testMinFloat64Array() {
        let arr1: Array<Float64> = [3.0, 1.0, 2.0]
        @Expect(IEEE754rUtils.min(arr1), 1.0)

        let arr2: Array<Float64> = [-1.0, -2.0, -3.0]
        @Expect(IEEE754rUtils.min(arr2), -3.0)

        // 包含负无穷大
        let negInf = -1.0 / 0.0
        let arr3: Array<Float64> = [1.0, negInf, 2.0]
        @Expect(IEEE754rUtils.min(arr3), negInf)
    }

    /**
     * 测试 Float64 max 数组方法
     */
    @TestCase
    func testMaxFloat64Array() {
        let arr1: Array<Float64> = [1.0, 3.0, 2.0]
        @Expect(IEEE754rUtils.max(arr1), 3.0)

        let arr2: Array<Float64> = [-1.0, -2.0, -3.0]
        @Expect(IEEE754rUtils.max(arr2), -1.0)

        // 包含正无穷大
        let posInf = 1.0 / 0.0
        let arr3: Array<Float64> = [1.0, posInf, 2.0]
        @Expect(IEEE754rUtils.max(arr3), posInf)
    }

    // ========== Float32 min/max 测试 ==========

    /**
     * 测试 Float32 min 方法
     */
    @TestCase
    func testMinFloat32() {
        @Expect(IEEE754rUtils.min(1.0f32, 2.0f32), 1.0f32)
        @Expect(IEEE754rUtils.min(2.0f32, 1.0f32), 1.0f32)
        @Expect(IEEE754rUtils.min(-1.0f32, 1.0f32), -1.0f32)

        // NaN 情况
        let nan = 0.0f32 / 0.0f32
        let result1 = IEEE754rUtils.min(nan, 1.0f32)
        @Expect(IEEE754rUtils.isNaN(result1), true)
    }

    /**
     * 测试 Float32 max 方法
     */
    @TestCase
    func testMaxFloat32() {
        @Expect(IEEE754rUtils.max(1.0f32, 2.0f32), 2.0f32)
        @Expect(IEEE754rUtils.max(2.0f32, 1.0f32), 2.0f32)
        @Expect(IEEE754rUtils.max(-1.0f32, 1.0f32), 1.0f32)

        // NaN 情况
        let nan = 0.0f32 / 0.0f32
        let result1 = IEEE754rUtils.max(nan, 1.0f32)
        @Expect(IEEE754rUtils.isNaN(result1), true)
    }

    /**
     * 测试 Float32 min 数组方法
     */
    @TestCase
    func testMinFloat32Array() {
        let arr1: Array<Float32> = [3.0f32, 1.0f32, 2.0f32]
        @Expect(IEEE754rUtils.min(arr1), 1.0f32)

        let arr2: Array<Float32> = [-1.0f32, -2.0f32, -3.0f32]
        @Expect(IEEE754rUtils.min(arr2), -3.0f32)
    }

    /**
     * 测试 Float32 max 数组方法
     */
    @TestCase
    func testMaxFloat32Array() {
        let arr1: Array<Float32> = [1.0f32, 3.0f32, 2.0f32]
        @Expect(IEEE754rUtils.max(arr1), 3.0f32)

        let arr2: Array<Float32> = [-1.0f32, -2.0f32, -3.0f32]
        @Expect(IEEE754rUtils.max(arr2), -1.0f32)
    }
}
