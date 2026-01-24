package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*
import commons_lang4cj.mutable.IllegalArgumentException as IAE


/**
 * MutableLong 测试类
 * 测试可变 Int64 包装器的所有功能（对应 Java 的 long 类型）
 */
@Test
class MutableLongTest {
    /**
     * 测试无参构造函数
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableLong = MutableLong()
        @Expect(mutableLong.getValue(), 0)
    }

    /**
     * 测试带 Int64 值的构造函数
     */
    @TestCase
    public func testConstructorWithValue() {
        let mutableLong = MutableLong(100)
        @Expect(mutableLong.getValue(), 100)
    }

    /**
     * 测试带 Number 的构造函数
     */
    @TestCase
    public func testConstructorWithNumber() {
        let mutableLong = MutableLong(MutableInt(200))
        @Expect(mutableLong.getValue(), 200)
    }

    /**
     * 测试从字符串构造 - 有效数字
     */
    @TestCase
    public func testConstructorFromStringValid() {
        let mutableLong = MutableLong("123456789012")
        @Expect(mutableLong.getValue(), 123456789012)
    }

    /**
     * 测试从字符串构造 - 负数
     */
    @TestCase
    public func testConstructorFromStringNegative() {
        let mutableLong = MutableLong("-9999999999")
        @Expect(mutableLong.getValue(), -9999999999)
    }

    /**
     * 测试从字符串构造 - 无效格式
     */
    @TestCase
    public func testConstructorFromStringInvalid() {
        try {
            let _ = MutableLong("invalid")
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
        let mutableLong = MutableLong(42)
        @Expect(mutableLong.getValue(), 42)
    }

    /**
     * 测试 setValue(Int64) 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableLong = MutableLong(10)
        mutableLong.setValue(20)
        @Expect(mutableLong.getValue(), 20)
    }

    /**
     * 测试 setValue(Number) 方法
     */
    @TestCase
    public func testSetValueWithNumber() {
        let mutableLong = MutableLong(10)
        mutableLong.setValue(MutableInt(30))
        @Expect(mutableLong.getValue(), 30)
    }

    /**
     * 测试 add(Int64) 方法
     */
    @TestCase
    public func testAdd() {
        let mutableLong = MutableLong(10)
        mutableLong.add(5)
        @Expect(mutableLong.getValue(), 15)
    }

    /**
     * 测试 add(Number) 方法
     */
    @TestCase
    public func testAddWithNumber() {
        let mutableLong = MutableLong(10)
        mutableLong.add(MutableInt(15))
        @Expect(mutableLong.getValue(), 25)
    }

    /**
     * 测试 addAndGet 方法
     */
    @TestCase
    public func testAddAndGet() {
        let mutableLong = MutableLong(10)
        let result = mutableLong.addAndGet(5)
        @Expect(result, 15)
        @Expect(mutableLong.getValue(), 15)
    }

    /**
     * 测试 subtract 方法
     */
    @TestCase
    public func testSubtract() {
        let mutableLong = MutableLong(20)
        mutableLong.subtract(5)
        @Expect(mutableLong.getValue(), 15)
    }

    /**
     * 测试 subtract(Number) 方法
     */
    @TestCase
    public func testSubtractWithNumber() {
        let mutableLong = MutableLong(30)
        mutableLong.subtract(MutableInt(10))
        @Expect(mutableLong.getValue(), 20)
    }

    /**
     * 测试 increment 方法
     */
    @TestCase
    public func testIncrement() {
        let mutableLong = MutableLong(10)
        mutableLong.increment()
        @Expect(mutableLong.getValue(), 11)
    }

    /**
     * 测试 incrementAndGet 方法
     */
    @TestCase
    public func testIncrementAndGet() {
        let mutableLong = MutableLong(10)
        let result = mutableLong.incrementAndGet()
        @Expect(result, 11)
        @Expect(mutableLong.getValue(), 11)
    }

    /**
     * 测试 decrement 方法
     */
    @TestCase
    public func testDecrement() {
        let mutableLong = MutableLong(10)
        mutableLong.decrement()
        @Expect(mutableLong.getValue(), 9)
    }

    /**
     * 测试 decrementAndGet 方法
     */
    @TestCase
    public func testDecrementAndGet() {
        let mutableLong = MutableLong(10)
        let result = mutableLong.decrementAndGet()
        @Expect(result, 9)
        @Expect(mutableLong.getValue(), 9)
    }

    /**
     * 测试 getAndAdd 方法
     */
    @TestCase
    public func testGetAndAdd() {
        let mutableLong = MutableLong(10)
        let result = mutableLong.getAndAdd(5)
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableLong.getValue(), 15)  // 新值是 15
    }

    /**
     * 测试 getAndIncrement 方法
     */
    @TestCase
    public func testGetAndIncrement() {
        let mutableLong = MutableLong(10)
        let result = mutableLong.getAndIncrement()
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableLong.getValue(), 11)  // 新值是 11
    }

    /**
     * 测试 getAndDecrement 方法
     */
    @TestCase
    public func testGetAndDecrement() {
        let mutableLong = MutableLong(10)
        let result = mutableLong.getAndDecrement()
        @Expect(result, 10)  // 返回旧值
        @Expect(mutableLong.getValue(), 9)  // 新值是 9
    }

    /**
     * 测试 compareTo - 小于
     */
    @TestCase
    public func testCompareToLess() {
        let m1 = MutableLong(10)
        let m2 = MutableLong(20)
        @Expect(m1.compareTo(m2), -1)
    }

    /**
     * 测试 compareTo - 等于
     */
    @TestCase
    public func testCompareToEqual() {
        let m1 = MutableLong(10)
        let m2 = MutableLong(10)
        @Expect(m1.compareTo(m2), 0)
    }

    /**
     * 测试 compareTo - 大于
     */
    @TestCase
    public func testCompareToGreater() {
        let m1 = MutableLong(20)
        let m2 = MutableLong(10)
        @Expect(m1.compareTo(m2), 1)
    }

    /**
     * 测试 equals - 相等
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableLong(10)
        let m2 = MutableLong(10)
        @Expect(m1.equals(Some(m2)), true)
    }

    /**
     * 测试 equals - 不相等
     */
    @TestCase
    public func testEqualsNotEqual() {
        let m1 = MutableLong(10)
        let m2 = MutableLong(20)
        @Expect(m1.equals(Some(m2)), false)
    }

    /**
     * 测试 hashCode
     */
    @TestCase
    public func testHashCode() {
        let m1 = MutableLong(10)
        let m2 = MutableLong(10)
        @Expect(m1.hashCode(), m2.hashCode())
        @Expect(m1.hashCode(), 10)
    }

    /**
     * 测试 toInt 方法
     */
    @TestCase
    public func testToInt() {
        let mutableLong = MutableLong(42)
        @Expect(mutableLong.toInt(), 42)
    }

    /**
     * 测试 toFloat 方法
     */
    @TestCase
    public func testToFloat() {
        let mutableLong = MutableLong(42)
        let result = mutableLong.toFloat()
        @Expect(Float64(result), 42.0)
    }

    /**
     * 测试 toDouble 方法
     */
    @TestCase
    public func testToDouble() {
        let mutableLong = MutableLong(42)
        @Expect(mutableLong.toDouble(), 42.0)
    }

    /**
     * 测试 toString 方法
     */
    @TestCase
    public func testToString() {
        let mutableLong = MutableLong(42)
        @Expect(mutableLong.toString(), "42")
    }

    /**
     * 测试大数值
     */
    @TestCase
    public func testLargeValue() {
        let mutableLong = MutableLong(9223372036854775807)  // Int64.MAX_VALUE
        @Expect(mutableLong.getValue(), 9223372036854775807)
    }

    /**
     * 测试链式调用
     */
    @TestCase
    public func testChaining() {
        let mutableLong = MutableLong(10)
            .add(5)
            .subtract(3)
            .increment()
        @Expect(mutableLong.getValue(), 13)
    }
}
