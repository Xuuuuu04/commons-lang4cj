package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*
import commons_lang4cj.mutable.IllegalArgumentException as IAE


/**
 * MutableFloat 测试类
 * 测试可变 Float32 包装器的所有功能
 */
@Test
class MutableFloatTest {
    /**
     * 测试无参构造函数
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableFloat = MutableFloat()
        @Expect(mutableFloat.getValue(), 0.0)
    }

    /**
     * 测试带 Float32 值的构造函数
     */
    @TestCase
    public func testConstructorWithValue() {
        let mutableFloat = MutableFloat(100.5f32)
        @Expect(mutableFloat.getValue(), 100.5f32)
    }

    /**
     * 测试带 Number 的构造函数
     */
    @TestCase
    public func testConstructorWithNumber() {
        let mutableFloat = MutableFloat(MutableInt(200))
        @Expect(mutableFloat.getValue(), 200.0f32)
    }

    /**
     * 测试从字符串构造 - 有效数字
     */
    @TestCase
    public func testConstructorFromStringValid() {
        let mutableFloat = MutableFloat("123.456")
        @Expect(Float64(mutableFloat.getValue()), 123.45600128173828125)  // 接受Float32精度限制
    }

    /**
     * 测试从字符串构造 - 负数
     */
    @TestCase
    public func testConstructorFromStringNegative() {
        let mutableFloat = MutableFloat("-99.99")
        @Expect(Float64(mutableFloat.getValue()), -99.98999786376953125)  // 接受Float32精度限制
    }

    /**
     * 测试从字符串构造 - 无效格式
     */
    @TestCase
    public func testConstructorFromStringInvalid() {
        try {
            let _ = MutableFloat("abc")
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IAE) {
            @Expect(true, true)  // 期望抛出异常
        }
    }

    /**
     * 测试 getValue 方法
     */
    @TestCase
    public func testGetValue() {
        let mutableFloat = MutableFloat(42.5f32)
        @Expect(mutableFloat.getValue(), 42.5f32)
    }

    /**
     * 测试 setValue(Float32) 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableFloat = MutableFloat(10.5f32)
        mutableFloat.setValue(20.5f32)
        @Expect(mutableFloat.getValue(), 20.5f32)
    }

    /**
     * 测试 setValue(Number) 方法
     */
    @TestCase
    public func testSetValueWithNumber() {
        let mutableFloat = MutableFloat(10.5f32)
        mutableFloat.setValue(MutableInt(30))
        @Expect(mutableFloat.getValue(), 30.0f32)
    }

    /**
     * 测试 add(Float32) 方法
     */
    @TestCase
    public func testAdd() {
        let mutableFloat = MutableFloat(10.5f32)
        mutableFloat.add(5.5f32)
        @Expect(mutableFloat.getValue(), 16.0f32)
    }

    /**
     * 测试 add(Number) 方法
     */
    @TestCase
    public func testAddWithNumber() {
        let mutableFloat = MutableFloat(10.5f32)
        mutableFloat.add(MutableInt(15))
        @Expect(mutableFloat.getValue(), 25.5f32)
    }

    /**
     * 测试 addAndGet 方法
     */
    @TestCase
    public func testAddAndGet() {
        let mutableFloat = MutableFloat(10.5f32)
        let result = mutableFloat.addAndGet(5.5f32)
        @Expect(result, 16.0f32)
        @Expect(mutableFloat.getValue(), 16.0f32)
    }

    /**
     * 测试 subtract 方法
     */
    @TestCase
    public func testSubtract() {
        let mutableFloat = MutableFloat(20.5f32)
        mutableFloat.subtract(5.5f32)
        @Expect(mutableFloat.getValue(), 15.0f32)
    }

    /**
     * 测试 subtract(Number) 方法
     */
    @TestCase
    public func testSubtractWithNumber() {
        let mutableFloat = MutableFloat(30.5f32)
        mutableFloat.subtract(MutableInt(10))
        @Expect(mutableFloat.getValue(), 20.5f32)
    }

    /**
     * 测试 increment 方法
     */
    @TestCase
    public func testIncrement() {
        let mutableFloat = MutableFloat(10.5f32)
        mutableFloat.increment()
        @Expect(mutableFloat.getValue(), 11.5f32)
    }

    /**
     * 测试 incrementAndGet 方法
     */
    @TestCase
    public func testIncrementAndGet() {
        let mutableFloat = MutableFloat(10.5f32)
        let result = mutableFloat.incrementAndGet()
        @Expect(result, 11.5f32)
        @Expect(mutableFloat.getValue(), 11.5f32)
    }

    /**
     * 测试 decrement 方法
     */
    @TestCase
    public func testDecrement() {
        let mutableFloat = MutableFloat(10.5f32)
        mutableFloat.decrement()
        @Expect(mutableFloat.getValue(), 9.5f32)
    }

    /**
     * 测试 decrementAndGet 方法
     */
    @TestCase
    public func testDecrementAndGet() {
        let mutableFloat = MutableFloat(10.5f32)
        let result = mutableFloat.decrementAndGet()
        @Expect(result, 9.5f32)
        @Expect(mutableFloat.getValue(), 9.5f32)
    }

    /**
     * 测试 getAndAdd 方法
     */
    @TestCase
    public func testGetAndAdd() {
        let mutableFloat = MutableFloat(10.5f32)
        let result = mutableFloat.getAndAdd(5.5f32)
        @Expect(result, 10.5f32)  // 返回旧值
        @Expect(mutableFloat.getValue(), 16.0f32)  // 新值是 16.0
    }

    /**
     * 测试 getAndIncrement 方法
     */
    @TestCase
    public func testGetAndIncrement() {
        let mutableFloat = MutableFloat(10.5f32)
        let result = mutableFloat.getAndIncrement()
        @Expect(result, 10.5f32)  // 返回旧值
        @Expect(mutableFloat.getValue(), 11.5f32)  // 新值是 11.5
    }

    /**
     * 测试 getAndDecrement 方法
     */
    @TestCase
    public func testGetAndDecrement() {
        let mutableFloat = MutableFloat(10.5f32)
        let result = mutableFloat.getAndDecrement()
        @Expect(result, 10.5f32)  // 返回旧值
        @Expect(mutableFloat.getValue(), 9.5f32)  // 新值是 9.5
    }

    /**
     * 测试 compareTo - 小于
     */
    @TestCase
    public func testCompareToLess() {
        let m1 = MutableFloat(10.5f32)
        let m2 = MutableFloat(20.5f32)
        @Expect(m1.compareTo(m2), -1)
    }

    /**
     * 测试 compareTo - 等于
     */
    @TestCase
    public func testCompareToEqual() {
        let m1 = MutableFloat(10.5f32)
        let m2 = MutableFloat(10.5f32)
        @Expect(m1.compareTo(m2), 0)
    }

    /**
     * 测试 compareTo - 大于
     */
    @TestCase
    public func testCompareToGreater() {
        let m1 = MutableFloat(20.5f32)
        let m2 = MutableFloat(10.5f32)
        @Expect(m1.compareTo(m2), 1)
    }

    /**
     * 测试 NaN 的比较
     */
    @TestCase
    public func testCompareToWithNaN() {
        let m1 = MutableFloat(10.5f32)
        let m2 = MutableFloat(Float32.NaN)
        @Expect(m1.compareTo(m2), -1)  // 正常数 < NaN
    }

    /**
     * 测试两个 NaN 的比较
     */
    @TestCase
    public func testCompareToBothNaN() {
        let m1 = MutableFloat(Float32.NaN)
        let m2 = MutableFloat(Float32.NaN)
        @Expect(m1.compareTo(m2), 0)  // NaN == NaN
    }

    /**
     * 测试 equals - 相等
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableFloat(10.5f32)
        let m2 = MutableFloat(10.5f32)
        @Expect(m1.equals(Some(m2)), true)
    }

    /**
     * 测试 equals - NaN 相等
     */
    @TestCase
    public func testEqualsWithNaN() {
        let m1 = MutableFloat(Float32.NaN)
        let m2 = MutableFloat(Float32.NaN)
        @Expect(m1.equals(Some(m2)), true)  // NaN == NaN
    }

    /**
     * 测试 isInfinite 方法
     */
    @TestCase
    public func testIsInfiniteFalse() {
        let mutableFloat = MutableFloat(10.5f32)
        @Expect(mutableFloat.isInfinite(), false)
    }

    /**
     * 测试 isNaN 方法
     */
    @TestCase
    public func testNaN() {
        let mutableFloat = MutableFloat(Float32.NaN)
        @Expect(mutableFloat.isNaN(), true)
    }

    /**
     * 测试 toInt 方法（截断小数）
     */
    @TestCase
    public func testToInt() {
        let mutableFloat = MutableFloat(42.9f32)
        @Expect(mutableFloat.toInt(), 42)
    }

    /**
     * 测试 toFloat 方法
     */
    @TestCase
    public func testToFloat() {
        let mutableFloat = MutableFloat(42.5f32)
        @Expect(mutableFloat.toFloat(), 42.5f32)
    }

    /**
     * 测试 toDouble 方法
     */
    @TestCase
    public func testToDouble() {
        let mutableFloat = MutableFloat(42.5f32)
        @Expect(mutableFloat.toDouble(), 42.5)
    }

    /**
     * 测试 toString 方法
     */
    @TestCase
    public func testToString() {
        let mutableFloat = MutableFloat(42.5f32)
        @Expect(mutableFloat.toString(), "42.5")
    }

    /**
     * 测试链式调用
     */
    @TestCase
    public func testChaining() {
        let mutableFloat = MutableFloat(10.0f32)
            .add(5.5f32)
            .subtract(3.5f32)
            .increment()
        @Expect(mutableFloat.getValue(), 13.0f32)
    }
}
