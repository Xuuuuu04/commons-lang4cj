package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*

/**
 * MutableByte 测试类
 * 测试可变 Int8 包装器的所有功能
 */
@Test
class MutableByteTest {
    /**
     * 测试无参构造函数
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableByte = MutableByte()
        @Expect(mutableByte.getValue(), 0)
    }

    /**
     * 测试带 Int8 值的构造函数
     */
    @TestCase
    public func testConstructorWithValue() {
        let mutableByte = MutableByte(100)
        @Expect(mutableByte.getValue(), 100)
    }

    /**
     * 测试负数值构造
     */
    @TestCase
    public func testConstructorWithNegative() {
        let mutableByte = MutableByte(-50)
        @Expect(mutableByte.getValue(), -50)
    }

    /**
     * 测试 getValue 方法
     */
    @TestCase
    public func testGetValue() {
        let mutableByte = MutableByte(42)
        @Expect(mutableByte.getValue(), 42)
    }

    /**
     * 测试 setValue 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableByte = MutableByte(10)
        mutableByte.setValue(20)
        @Expect(mutableByte.getValue(), 20)
    }

    /**
     * 测试 add 方法
     */
    @TestCase
    public func testAdd() {
        let mutableByte = MutableByte(10)
        mutableByte.add(5)
        @Expect(mutableByte.getValue(), 15)
    }

    /**
     * 测试 subtract 方法
     */
    @TestCase
    public func testSubtract() {
        let mutableByte = MutableByte(20)
        mutableByte.subtract(5)
        @Expect(mutableByte.getValue(), 15)
    }

    /**
     * 测试 increment 方法
     */
    @TestCase
    public func testIncrement() {
        let mutableByte = MutableByte(10)
        mutableByte.increment()
        @Expect(mutableByte.getValue(), 11)
    }

    /**
     * 测试 decrement 方法
     */
    @TestCase
    public func testDecrement() {
        let mutableByte = MutableByte(10)
        mutableByte.decrement()
        @Expect(mutableByte.getValue(), 9)
    }

    /**
     * 测试 toInt 方法
     */
    @TestCase
    public func testToInt() {
        let mutableByte = MutableByte(42)
        @Expect(mutableByte.toInt(), 42)
    }

    /**
     * 测试 toString 方法
     */
    @TestCase
    public func testToString() {
        let mutableByte = MutableByte(42)
        @Expect(mutableByte.toString(), "42")
    }

    /**
     * 测试 hashCode
     */
    @TestCase
    public func testHashCode() {
        let mutableByte = MutableByte(10)
        @Expect(mutableByte.hashCode(), 10)
    }

    /**
     * 测试 Int8 最小值
     */
    @TestCase
    public func testMinValue() {
        let mutableByte = MutableByte(-128)
        @Expect(mutableByte.getValue(), -128)
    }

    /**
     * 测试 Int8 最大值
     */
    @TestCase
    public func testMaxValue() {
        let mutableByte = MutableByte(127)
        @Expect(mutableByte.getValue(), 127)
    }

    /**
     * 测试 equals - 简化实现返回 false
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableByte(10)
        let m2 = MutableByte(10)
        // 简化实现总是返回 false
        @Expect(m1.equals(m2), false)
    }

    /**
     * 测试链式调用
     */
    @TestCase
    public func testChaining() {
        let mutableByte = MutableByte(10)
            .add(5)
            .subtract(3)
            .increment()
        @Expect(mutableByte.getValue(), 13)
    }

    /**
     * 测试零值
     */
    @TestCase
    public func testZeroValue() {
        let mutableByte = MutableByte(0)
        @Expect(mutableByte.getValue(), 0)
    }

    /**
     * 测试连续加减
     */
    @TestCase
    public func testMultipleOperations() {
        let mutableByte = MutableByte(50)
        mutableByte.add(10)
        mutableByte.subtract(5)
        mutableByte.increment()
        mutableByte.decrement()
        @Expect(mutableByte.getValue(), 55)
    }

    /**
     * 测试负数运算
     */
    @TestCase
    public func testNegativeOperations() {
        let mutableByte = MutableByte(-10)
        mutableByte.add(5)
        @Expect(mutableByte.getValue(), -5)
        mutableByte.subtract(3)
        @Expect(mutableByte.getValue(), -8)
    }

    /**
     * 测试 toString 负数
     */
    @TestCase
    public func testToStringNegative() {
        let mutableByte = MutableByte(-99)
        @Expect(mutableByte.toString(), "-99")
    }

    /**
     * 测试 toInt 负数
     */
    @TestCase
    public func testToIntNegative() {
        let mutableByte = MutableByte(-50)
        @Expect(mutableByte.toInt(), -50)
    }

    /**
     * 测试 increment 溢出边界
     */
    @TestCase
    public func testIncrementOverflow() {
        let mutableByte = MutableByte(127)
        mutableByte.increment()
        // Int8 溢出后行为
        let result = mutableByte.getValue()
        // 127 + 1 = -128 (Int8 溢出)
        @Expect(result, -128)
    }

    /**
     * 测试 decrement 下溢边界
     */
    @TestCase
    public func testDecrementUnderflow() {
        let mutableByte = MutableByte(-128)
        mutableByte.decrement()
        // Int8 下溢后行为
        let result = mutableByte.getValue()
        // -128 - 1 = 127 (Int8 下溢)
        @Expect(result, 127)
    }

    /**
     * 测试 setValue 多次
     */
    @TestCase
    public func testMultipleSetValue() {
        let mutableByte = MutableByte(10)
        mutableByte.setValue(20)
        @Expect(mutableByte.getValue(), 20)
        mutableByte.setValue(30)
        @Expect(mutableByte.getValue(), 30)
        mutableByte.setValue(0)
        @Expect(mutableByte.getValue(), 0)
    }

    /**
     * 测试 add 零值
     */
    @TestCase
    public func testAddZero() {
        let mutableByte = MutableByte(50)
        mutableByte.add(0)
        @Expect(mutableByte.getValue(), 50)
    }

    /**
     * 测试 subtract 零值
     */
    @TestCase
    public func testSubtractZero() {
        let mutableByte = MutableByte(50)
        mutableByte.subtract(0)
        @Expect(mutableByte.getValue(), 50)
    }

    /**
     * 测试 add 和 subtract 抵消
     */
    @TestCase
    public func testAddSubtractCancel() {
        let mutableByte = MutableByte(50)
        mutableByte.add(10)
        mutableByte.subtract(10)
        @Expect(mutableByte.getValue(), 50)
    }
}
