package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*


/**
 * MutableInt 测试类
 * 测试可变 Int64 包装器的所有功能
 */
@Test
class MutableIntTest {
    /**
     * 测试无参构造函数
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableInt = MutableInt()
        @Expect(mutableInt.getValue(), 0)
    }

    /**
     * 测试带 Int64 值的构造函数
     */
    @TestCase
    public func testConstructorWithValue() {
        let mutableInt = MutableInt(100)
        @Expect(mutableInt.getValue(), 100)
    }

    /**
     * 测试带 Number 的构造函数
     */
    @TestCase
    public func testConstructorWithNumber() {
        let mutableInt = MutableInt(MutableLong(200))
        @Expect(mutableInt.getValue(), 200)
    }

    /**
     * 测试从字符串构造 - 有效数字
     */
    @TestCase
    public func testConstructorFromStringValid() {
        let mutableInt = MutableInt("12345")
        @Expect(mutableInt.getValue(), 12345)
    }

    /**
     * 测试从字符串构造 - 负数
     */
    @TestCase
    public func testConstructorFromStringNegative() {
        let mutableInt = MutableInt("-9999")
        @Expect(mutableInt.getValue(), -9999)
    }

    /**
     * 测试从字符串构造 - 无效格式
     */
    @TestCase
    public func testConstructorFromStringInvalid() {
        try {
            let _ = MutableInt("abc")
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
        let mutableInt = MutableInt(42)
        @Expect(mutableInt.getValue(), 42)
    }

    /**
     * 测试 setValue(Int64) 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableInt = MutableInt(10)
        mutableInt.setValue(20)
        @Expect(mutableInt.getValue(), 20)
    }

    /**
     * 测试 setValue(Number) 方法
     */
    @TestCase
    public func testSetValueWithNumber() {
        let mutableInt = MutableInt(10)
        mutableInt.setValue(MutableLong(30))
        @Expect(mutableInt.getValue(), 30)
    }

    /**
     * 测试 add(Int64) 方法
     */
    @TestCase
    public func testAdd() {
        let mutableInt = MutableInt(10)
        mutableInt.add(5)
        @Expect(mutableInt.getValue(), 15)
    }

    /**
     * 测试 add(Number) 方法
     */
    @TestCase
    public func testAddWithNumber() {
        let mutableInt = MutableInt(10)
        mutableInt.add(MutableLong(15))
        @Expect(mutableInt.getValue(), 25)
    }

    /**
     * 测试 addAndGet 方法
     */
    @TestCase
    public func testAddAndGet() {
        let mutableInt = MutableInt(10)
        let result = mutableInt.addAndGet(5)
        @Expect(result, 15)
        @Expect(mutableInt.getValue(), 15)
    }

    /**
     * 测试 subtract 方法
     */
    @TestCase
    public func testSubtract() {
        let mutableInt = MutableInt(20)
        mutableInt.subtract(5)
        @Expect(mutableInt.getValue(), 15)
    }

    /**
     * 测试 subtract(Number) 方法
     */
    @TestCase
    public func testSubtractWithNumber() {
        let mutableInt = MutableInt(30)
        mutableInt.subtract(MutableLong(10))
        @Expect(mutableInt.getValue(), 20)
    }

    /**
     * 测试 increment 方法
     */
    @TestCase
    public func testIncrement() {
        let mutableInt = MutableInt(10)
        mutableInt.increment()
        @Expect(mutableInt.getValue(), 11)
    }

    /**
     * 测试 incrementAndGet 方法
     */
    @TestCase
    public func testIncrementAndGet() {
        let mutableInt = MutableInt(10)
        let result = mutableInt.incrementAndGet()
        @Expect(result, 11)
        @Expect(mutableInt.getValue(), 11)
    }

    /**
     * 测试 decrement 方法
     */
    @TestCase
    public func testDecrement() {
        let mutableInt = MutableInt(10)
        mutableInt.decrement()
        @Expect(mutableInt.getValue(), 9)
    }

    /**
     * 测试 decrementAndGet 方法
     */
    @TestCase
    public func testDecrementAndGet() {
        let mutableInt = MutableInt(10)
        let result = mutableInt.decrementAndGet()
        @Expect(result, 9)
        @Expect(mutableInt.getValue(), 9)
    }

    /**
     * 测试 getAndAdd 方法
     */
    @TestCase
    public func testGetAndAdd() {
        let mutableInt = MutableInt(10)
        let result = mutableInt.getAndAdd(5)
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableInt.getValue(), 15)  // 新值是 15
    }

    /**
     * 测试 getAndIncrement 方法
     */
    @TestCase
    public func testGetAndIncrement() {
        let mutableInt = MutableInt(10)
        let result = mutableInt.getAndIncrement()
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableInt.getValue(), 11)  // 新值是 11
    }

    /**
     * 测试 getAndDecrement 方法
     */
    @TestCase
    public func testGetAndDecrement() {
        let mutableInt = MutableInt(10)
        let result = mutableInt.getAndDecrement()
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableInt.getValue(), 9)  // 新值是 9
    }

    /**
     * 测试 compareTo - 小于
     */
    @TestCase
    public func testCompareToLess() {
        let m1 = MutableInt(10)
        let m2 = MutableInt(20)
        @Expect(m1.compareTo(m2), -1)
    }

    /**
     * 测试 compareTo - 等于
     */
    @TestCase
    public func testCompareToEqual() {
        let m1 = MutableInt(10)
        let m2 = MutableInt(10)
        @Expect(m1.compareTo(m2), 0)
    }

    /**
     * 测试 compareTo - 大于
     */
    @TestCase
    public func testCompareToGreater() {
        let m1 = MutableInt(20)
        let m2 = MutableInt(10)
        @Expect(m1.compareTo(m2), 1)
    }

    /**
     * 测试 equals - 相等
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableInt(10)
        let m2 = MutableInt(10)
        @Expect(m1.equals(Some(m2)), true)
    }

    /**
     * 测试 equals - 不相等
     */
    @TestCase
    public func testEqualsNotEqual() {
        let m1 = MutableInt(10)
        let m2 = MutableInt(20)
        @Expect(m1.equals(Some(m2)), false)
    }

    /**
     * 测试 equals - None
     */
    @TestCase
    public func testEqualsWithNone() {
        let m1 = MutableInt(10)
        @Expect(m1.equals(None), false)
    }

    /**
     * 测试 hashCode
     */
    @TestCase
    public func testHashCode() {
        let m1 = MutableInt(10)
        let m2 = MutableInt(10)
        @Expect(m1.hashCode(), m2.hashCode())
        @Expect(m1.hashCode(), 10)
    }

    /**
     * 测试 toInt 方法
     */
    @TestCase
    public func testToInt() {
        let mutableInt = MutableInt(42)
        @Expect(mutableInt.toInt(), 42)
    }

    /**
     * 测试 toFloat 方法
     */
    @TestCase
    public func testToFloat() {
        let mutableInt = MutableInt(42)
        let result = mutableInt.toFloat()
        @Expect(Float64(result), 42.0)
    }

    /**
     * 测试 toDouble 方法
     */
    @TestCase
    public func testToDouble() {
        let mutableInt = MutableInt(42)
        @Expect(mutableInt.toDouble(), 42.0)
    }

    /**
     * 测试 toString 方法
     */
    @TestCase
    public func testToString() {
        let mutableInt = MutableInt(42)
        @Expect(mutableInt.toString(), "42")
    }

    /**
     * 测试链式调用
     */
    @TestCase
    public func testChaining() {
        let mutableInt = MutableInt(10)
            .add(5)
            .subtract(3)
            .increment()
        @Expect(mutableInt.getValue(), 13)
    }
}
