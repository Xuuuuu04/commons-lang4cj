package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*
import commons_lang4cj.mutable.IllegalArgumentException as IAE


/**
 * MutableDouble 测试类
 * 测试可变 Float64 包装器的所有功能
 */
@Test
class MutableDoubleTest {
    /**
     * 测试无参构造函数
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableDouble = MutableDouble()
        @Expect(mutableDouble.getValue(), 0.0)
    }

    /**
     * 测试带 Float64 值的构造函数
     */
    @TestCase
    public func testConstructorWithValue() {
        let mutableDouble = MutableDouble(100.5)
        @Expect(mutableDouble.getValue(), 100.5)
    }

    /**
     * 测试带 Number 的构造函数
     */
    @TestCase
    public func testConstructorWithNumber() {
        let mutableDouble = MutableDouble(MutableInt(200))
        @Expect(mutableDouble.getValue(), 200.0)
    }

    /**
     * 测试从字符串构造 - 有效数字
     */
    @TestCase
    public func testConstructorFromStringValid() {
        let mutableDouble = MutableDouble("123.456")
        @Expect(mutableDouble.getValue(), 123.456)
    }

    /**
     * 测试从字符串构造 - 负数
     */
    @TestCase
    public func testConstructorFromStringNegative() {
        let mutableDouble = MutableDouble("-99.99")
        @Expect(mutableDouble.getValue(), -99.99)
    }

    /**
     * 测试从字符串构造 - 科学计数法
     */
    @TestCase
    public func testConstructorFromStringScientific() {
        let mutableDouble = MutableDouble("1.5e2")
        @Expect(mutableDouble.getValue(), 150.0)
    }

    /**
     * 测试从字符串构造 - 无效格式
     */
    @TestCase
    public func testConstructorFromStringInvalid() {
        try {
            let _ = MutableDouble("abc")
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
        let mutableDouble = MutableDouble(42.5)
        @Expect(mutableDouble.getValue(), 42.5)
    }

    /**
     * 测试 setValue(Float64) 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableDouble = MutableDouble(10.5)
        mutableDouble.setValue(20.5)
        @Expect(mutableDouble.getValue(), 20.5)
    }

    /**
     * 测试 setValue(Number) 方法
     */
    @TestCase
    public func testSetValueWithNumber() {
        let mutableDouble = MutableDouble(10.5)
        mutableDouble.setValue(MutableInt(30))
        @Expect(mutableDouble.getValue(), 30.0)
    }

    /**
     * 测试 add(Float64) 方法
     */
    @TestCase
    public func testAdd() {
        let mutableDouble = MutableDouble(10.5)
        mutableDouble.add(5.5)
        @Expect(mutableDouble.getValue(), 16.0)
    }

    /**
     * 测试 add(Number) 方法
     */
    @TestCase
    public func testAddWithNumber() {
        let mutableDouble = MutableDouble(10.5)
        mutableDouble.add(MutableInt(15))
        @Expect(mutableDouble.getValue(), 25.5)
    }

    /**
     * 测试 addAndGet 方法
     */
    @TestCase
    public func testAddAndGet() {
        let mutableDouble = MutableDouble(10.5)
        let result = mutableDouble.addAndGet(5.5)
        @Expect(result, 16.0)
        @Expect(mutableDouble.getValue(), 16.0)
    }

    /**
     * 测试 subtract 方法
     */
    @TestCase
    public func testSubtract() {
        let mutableDouble = MutableDouble(20.5)
        mutableDouble.subtract(5.5)
        @Expect(mutableDouble.getValue(), 15.0)
    }

    /**
     * 测试 subtract(Number) 方法
     */
    @TestCase
    public func testSubtractWithNumber() {
        let mutableDouble = MutableDouble(30.5)
        mutableDouble.subtract(MutableInt(10))
        @Expect(mutableDouble.getValue(), 20.5)
    }

    /**
     * 测试 increment 方法
     */
    @TestCase
    public func testIncrement() {
        let mutableDouble = MutableDouble(10.5)
        mutableDouble.increment()
        @Expect(mutableDouble.getValue(), 11.5)
    }

    /**
     * 测试 incrementAndGet 方法
     */
    @TestCase
    public func testIncrementAndGet() {
        let mutableDouble = MutableDouble(10.5)
        let result = mutableDouble.incrementAndGet()
        @Expect(result, 11.5)
        @Expect(mutableDouble.getValue(), 11.5)
    }

    /**
     * 测试 decrement 方法
     */
    @TestCase
    public func testDecrement() {
        let mutableDouble = MutableDouble(10.5)
        mutableDouble.decrement()
        @Expect(mutableDouble.getValue(), 9.5)
    }

    /**
     * 测试 decrementAndGet 方法
     */
    @TestCase
    public func testDecrementAndGet() {
        let mutableDouble = MutableDouble(10.5)
        let result = mutableDouble.decrementAndGet()
        @Expect(result, 9.5)
        @Expect(mutableDouble.getValue(), 9.5)
    }

    /**
     * 测试 getAndAdd 方法
     */
    @TestCase
    public func testGetAndAdd() {
        let mutableDouble = MutableDouble(10.5)
        let result = mutableDouble.getAndAdd(5.5)
        @Expect(result, 10.5)  // 返回旧值
        @Expect(mutableDouble.getValue(), 16.0)  // 新值是 16.0
    }

    /**
     * 测试 getAndIncrement 方法
     */
    @TestCase
    public func testGetAndIncrement() {
        let mutableDouble = MutableDouble(10.5)
        let result = mutableDouble.getAndIncrement()
        @Expect(result, 10.5)  // 返回旧值
        @Expect(mutableDouble.getValue(), 11.5)  // 新值是 11.5
    }

    /**
     * 测试 getAndDecrement 方法
     */
    @TestCase
    public func testGetAndDecrement() {
        let mutableDouble = MutableDouble(10.5)
        let result = mutableDouble.getAndDecrement()
        @Expect(result, 10.5)  // 返回旧值
        @Expect(mutableDouble.getValue(), 9.5)  // 新值是 9.5
    }

    /**
     * 测试 compareTo - 小于
     */
    @TestCase
    public func testCompareToLess() {
        let m1 = MutableDouble(10.5)
        let m2 = MutableDouble(20.5)
        @Expect(m1.compareTo(m2), -1)
    }

    /**
     * 测试 compareTo - 等于
     */
    @TestCase
    public func testCompareToEqual() {
        let m1 = MutableDouble(10.5)
        let m2 = MutableDouble(10.5)
        @Expect(m1.compareTo(m2), 0)
    }

    /**
     * 测试 compareTo - 大于
     */
    @TestCase
    public func testCompareToGreater() {
        let m1 = MutableDouble(20.5)
        let m2 = MutableDouble(10.5)
        @Expect(m1.compareTo(m2), 1)
    }

    /**
     * 测试 NaN 的比较
     */
    @TestCase
    public func testCompareToWithNaN() {
        let m1 = MutableDouble(10.5)
        let m2 = MutableDouble(Float64.NaN)
        @Expect(m1.compareTo(m2), -1)  // 正常数 < NaN
    }

    /**
     * 测试两个 NaN 的比较
     */
    @TestCase
    public func testCompareToBothNaN() {
        let m1 = MutableDouble(Float64.NaN)
        let m2 = MutableDouble(Float64.NaN)
        @Expect(m1.compareTo(m2), 0)  // NaN == NaN
    }

    /**
     * 测试 equals - 相等
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableDouble(10.5)
        let m2 = MutableDouble(10.5)
        @Expect(m1.equals(Some(m2)), true)
    }

    /**
     * 测试 equals - NaN 相等
     */
    @TestCase
    public func testEqualsWithNaN() {
        let m1 = MutableDouble(Float64.NaN)
        let m2 = MutableDouble(Float64.NaN)
        @Expect(m1.equals(Some(m2)), true)  // NaN == NaN
    }

    /**
     * 测试 isInfinite 方法
     */
    @TestCase
    public func testIsInfiniteFalse() {
        let mutableDouble = MutableDouble(10.5)
        @Expect(mutableDouble.isInfinite(), false)
    }

    /**
     * 测试 isNaN 方法
     */
    @TestCase
    public func testNaN() {
        let mutableDouble = MutableDouble(Float64.NaN)
        @Expect(mutableDouble.isNaN(), true)
    }

    /**
     * 测试 toInt 方法（截断小数）
     */
    @TestCase
    public func testToInt() {
        let mutableDouble = MutableDouble(42.9)
        @Expect(mutableDouble.toInt(), 42)
    }

    /**
     * 测试 toFloat 方法
     */
    @TestCase
    public func testToFloat() {
        let mutableDouble = MutableDouble(42.5)
        let result = mutableDouble.toFloat()
        @Expect(Float64(result), 42.5)
    }

    /**
     * 测试 toDouble 方法
     */
    @TestCase
    public func testToDouble() {
        let mutableDouble = MutableDouble(42.5)
        @Expect(mutableDouble.toDouble(), 42.5)
    }

    /**
     * 测试 toString 方法
     */
    @TestCase
    public func testToString() {
        let mutableDouble = MutableDouble(42.5)
        @Expect(mutableDouble.toString(), "42.5")
    }

    /**
     * 测试链式调用
     */
    @TestCase
    public func testChaining() {
        let mutableDouble = MutableDouble(10.0)
            .add(5.5)
            .subtract(3.5)
            .increment()
        @Expect(mutableDouble.getValue(), 13.0)
    }
}
