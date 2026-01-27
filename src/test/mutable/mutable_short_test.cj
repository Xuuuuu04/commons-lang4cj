package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*


/**
 * MutableShort 测试类
 * 测试可变 Int16 包装器的所有功能
 */
@Test
class MutableShortTest {
    /**
     * 测试无参构造函数
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableShort = MutableShort()
        @Expect(mutableShort.getValue(), 0)
    }

    /**
     * 测试带 Int16 值的构造函数
     */
    @TestCase
    public func testConstructorWithValue() {
        let mutableShort = MutableShort(100)
        @Expect(mutableShort.getValue(), 100)
    }

    /**
     * 测试带 Number 的构造函数
     */
    @TestCase
    public func testConstructorWithNumber() {
        let mutableShort = MutableShort(MutableInt(200))
        @Expect(mutableShort.getValue(), 200)
    }

    /**
     * 测试从字符串构造 - 有效数字
     */
    @TestCase
    public func testConstructorFromStringValid() {
        let mutableShort = MutableShort("12345")
        @Expect(mutableShort.getValue(), 12345)
    }

    /**
     * 测试从字符串构造 - 负数
     */
    @TestCase
    public func testConstructorFromStringNegative() {
        let mutableShort = MutableShort("-9999")
        @Expect(mutableShort.getValue(), -9999)
    }

    /**
     * 测试从字符串构造 - 无效格式
     */
    @TestCase
    public func testConstructorFromStringInvalid() {
        try {
            let _ = MutableShort("abc")
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
        let mutableShort = MutableShort(42)
        @Expect(mutableShort.getValue(), 42)
    }

    /**
     * 测试 setValue(Int16) 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableShort = MutableShort(10)
        mutableShort.setValue(20)
        @Expect(mutableShort.getValue(), 20)
    }

    /**
     * 测试 setValue(Number) 方法
     */
    @TestCase
    public func testSetValueWithNumber() {
        let mutableShort = MutableShort(10)
        mutableShort.setValue(MutableInt(30))
        @Expect(mutableShort.getValue(), 30)
    }

    /**
     * 测试 add(Int16) 方法
     */
    @TestCase
    public func testAdd() {
        let mutableShort = MutableShort(10)
        mutableShort.add(5)
        @Expect(mutableShort.getValue(), 15)
    }

    /**
     * 测试 add(Number) 方法
     */
    @TestCase
    public func testAddWithNumber() {
        let mutableShort = MutableShort(10)
        mutableShort.add(MutableInt(15))
        @Expect(mutableShort.getValue(), 25)
    }

    /**
     * 测试 addAndGet 方法
     */
    @TestCase
    public func testAddAndGet() {
        let mutableShort = MutableShort(10)
        let result = mutableShort.addAndGet(5)
        @Expect(result, 15)
        @Expect(mutableShort.getValue(), 15)
    }

    /**
     * 测试 subtract 方法
     */
    @TestCase
    public func testSubtract() {
        let mutableShort = MutableShort(20)
        mutableShort.subtract(5)
        @Expect(mutableShort.getValue(), 15)
    }

    /**
     * 测试 subtract(Number) 方法
     */
    @TestCase
    public func testSubtractWithNumber() {
        let mutableShort = MutableShort(30)
        mutableShort.subtract(MutableInt(10))
        @Expect(mutableShort.getValue(), 20)
    }

    /**
     * 测试 increment 方法
     */
    @TestCase
    public func testIncrement() {
        let mutableShort = MutableShort(10)
        mutableShort.increment()
        @Expect(mutableShort.getValue(), 11)
    }

    /**
     * 测试 incrementAndGet 方法
     */
    @TestCase
    public func testIncrementAndGet() {
        let mutableShort = MutableShort(10)
        let result = mutableShort.incrementAndGet()
        @Expect(result, 11)
        @Expect(mutableShort.getValue(), 11)
    }

    /**
     * 测试 decrement 方法
     */
    @TestCase
    public func testDecrement() {
        let mutableShort = MutableShort(10)
        mutableShort.decrement()
        @Expect(mutableShort.getValue(), 9)
    }

    /**
     * 测试 decrementAndGet 方法
     */
    @TestCase
    public func testDecrementAndGet() {
        let mutableShort = MutableShort(10)
        let result = mutableShort.decrementAndGet()
        @Expect(result, 9)
        @Expect(mutableShort.getValue(), 9)
    }

    /**
     * 测试 getAndAdd 方法
     */
    @TestCase
    public func testGetAndAdd() {
        let mutableShort = MutableShort(10)
        let result = mutableShort.getAndAdd(5)
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableShort.getValue(), 15)  // 新值是 15
    }

    /**
     * 测试 getAndIncrement 方法
     */
    @TestCase
    public func testGetAndIncrement() {
        let mutableShort = MutableShort(10)
        let result = mutableShort.getAndIncrement()
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableShort.getValue(), 11)  // 新值是 11
    }

    /**
     * 测试 getAndDecrement 方法
     */
    @TestCase
    public func testGetAndDecrement() {
        let mutableShort = MutableShort(10)
        let result = mutableShort.getAndDecrement()
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableShort.getValue(), 9)  // 新值是 9
    }

    /**
     * 测试 compareTo - 小于
     */
    @TestCase
    public func testCompareToLess() {
        let m1 = MutableShort(10)
        let m2 = MutableShort(20)
        @Expect(m1.compareTo(m2), -1)
    }

    /**
     * 测试 compareTo - 等于
     */
    @TestCase
    public func testCompareToEqual() {
        let m1 = MutableShort(10)
        let m2 = MutableShort(10)
        @Expect(m1.compareTo(m2), 0)
    }

    /**
     * 测试 compareTo - 大于
     */
    @TestCase
    public func testCompareToGreater() {
        let m1 = MutableShort(20)
        let m2 = MutableShort(10)
        @Expect(m1.compareTo(m2), 1)
    }

    /**
     * 测试 equals - 相等
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableShort(10)
        let m2 = MutableShort(10)
        @Expect(m1.equals(m2), true)
    }

    /**
     * 测试 equals - 不相等
     */
    @TestCase
    public func testEqualsNotEqual() {
        let m1 = MutableShort(10)
        let m2 = MutableShort(20)
        @Expect(m1.equals(m2), false)
    }

    /**
     * 测试 hashCode
     */
    @TestCase
    public func testHashCode() {
        let m1 = MutableShort(10)
        let m2 = MutableShort(10)
        @Expect(m1.hashCode(), m2.hashCode())
        @Expect(m1.hashCode(), 10)
    }

    /**
     * 测试 toInt 方法
     */
    @TestCase
    public func testToInt() {
        let mutableShort = MutableShort(42)
        @Expect(mutableShort.toInt(), 42)
    }

    /**
     * 测试 toFloat 方法
     */
    @TestCase
    public func testToFloat() {
        let mutableShort = MutableShort(42)
        let result = mutableShort.toFloat()
        @Expect(Float64(result), 42.0)
    }

    /**
     * 测试 toDouble 方法
     */
    @TestCase
    public func testToDouble() {
        let mutableShort = MutableShort(42)
        @Expect(mutableShort.toDouble(), 42.0)
    }

    /**
     * 测试 toString 方法
     */
    @TestCase
    public func testToString() {
        let mutableShort = MutableShort(42)
        @Expect(mutableShort.toString(), "42")
    }

    /**
     * 测试 MIN_VALUE 常量
     */
    @TestCase
    public func testMinValue() {
        @Expect(MutableShort.MIN_VALUE, -32768)
    }

    /**
     * 测试 MAX_VALUE 常量
     */
    @TestCase
    public func testMaxValue() {
        @Expect(MutableShort.MAX_VALUE, 32767)
    }

    /**
     * 测试链式调用
     */
    @TestCase
    public func testChaining() {
        let mutableShort = MutableShort(10)
            .add(5)
            .subtract(3)
            .increment()
        @Expect(mutableShort.getValue(), 13)
    }
}
