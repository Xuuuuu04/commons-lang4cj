package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*
import std.core.IllegalStateException as ISE


/**
 * MutableObject 测试类
 * 测试可变对象包装器的所有功能
 */
@Test
class MutableObjectTest {
    /**
     * 测试无参构造函数（未初始化）
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableObject = MutableObject<String>()
        @Expect(mutableObject.isSet(), false)
    }

    /**
     * 测试带值的构造函数
     */
    @TestCase
    public func testConstructorWithValue() {
        let mutableObject = MutableObject<String>("Hello")
        @Expect(mutableObject.isSet(), true)
        @Expect(mutableObject.getValue(), "Hello")
    }

    /**
     * 测试带 Int64 值的构造函数
     */
    @TestCase
    public func testConstructorWithInt() {
        let mutableObject = MutableObject<Int64>(42)
        @Expect(mutableObject.isSet(), true)
        @Expect(mutableObject.getValue(), 42)
    }

    /**
     * 测试 getValue 方法
     */
    @TestCase
    public func testGetValue() {
        let mutableObject = MutableObject<String>("World")
        @Expect(mutableObject.getValue(), "World")
    }

    /**
     * 测试 getValue - 未设置抛异常
     */
    @TestCase
    public func testGetValueNotSet() {
        let mutableObject = MutableObject<String>()
        try {
            let _ = mutableObject.getValue()
            @Expect(false, true)  // 不应该到达这里
        } catch (e: ISE) {
            @Expect(true, true)  // 期望抛出异常
        }
    }

    /**
     * 测试 setValue 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableObject = MutableObject<String>("Hello")
        mutableObject.setValue("World")
        @Expect(mutableObject.getValue(), "World")
    }

    /**
     * 测试 isSet 方法 - 已设置
     */
    @TestCase
    public func testIsSetTrue() {
        let mutableObject = MutableObject<String>("Hello")
        @Expect(mutableObject.isSet(), true)
    }

    /**
     * 测试 isSet 方法 - 未设置
     */
    @TestCase
    public func testIsSetFalse() {
        let mutableObject = MutableObject<String>()
        @Expect(mutableObject.isSet(), false)
    }

    /**
     * 测试 equals - 相等
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableObject<String>("Hello")
        let m2 = MutableObject<String>("Hello")
        @Expect(m1.equals(m2), true)
    }

    /**
     * 测试 equals - 不相等
     */
    @TestCase
    public func testEqualsNotEqual() {
        let m1 = MutableObject<String>("Hello")
        let m2 = MutableObject<String>("World")
        @Expect(m1.equals(m2), false)
    }

    /**
     * 测试 equals - 一个未设置
     */
    @TestCase
    public func testEqualsOneNotSet() {
        let m1 = MutableObject<String>("Hello")
        let m2 = MutableObject<String>()
        @Expect(m1.equals(m2), false)
    }

    /**
     * 测试 equals - 两个都未设置
     */
    @TestCase
    public func testEqualsBothNotSet() {
        let m1 = MutableObject<String>()
        let m2 = MutableObject<String>()
        @Expect(m1.equals(m2), true)
    }

    /**
     * 测试 hashCode - 已设置
     */
    @TestCase
    public func testHashCode() {
        let mutableObject = MutableObject<String>("Hello")
        let hash = mutableObject.hashCode()
        // String 实现了 Hashable，所以有哈希码
        @Expect(hash != 0, true)
    }

    /**
     * 测试 hashCode - 未设置
     */
    @TestCase
    public func testHashCodeNotSet() {
        let mutableObject = MutableObject<String>()
        @Expect(mutableObject.hashCode(), 0)
    }

    /**
     * 测试 toString - 已设置
     */
    @TestCase
    public func testToString() {
        let mutableObject = MutableObject<String>("Hello")
        @Expect(mutableObject.toString(), "Hello")
    }

    /**
     * 测试 toString - 未设置
     */
    @TestCase
    public func testToStringNotSet() {
        let mutableObject = MutableObject<String>()
        @Expect(mutableObject.toString(), "MutableObject[value not set]")
    }

    /**
     * 测试多次 setValue
     */
    @TestCase
    public func testMultipleSetValue() {
        let mutableObject = MutableObject<String>("Hello")
        @Expect(mutableObject.getValue(), "Hello")
        mutableObject.setValue("World")
        @Expect(mutableObject.getValue(), "World")
        mutableObject.setValue("Cangjie")
        @Expect(mutableObject.getValue(), "Cangjie")
    }

    /**
     * 测试 Int64 类型的 MutableObject
     */
    @TestCase
    public func testInt64Type() {
        let mutableObject = MutableObject<Int64>(42)
        @Expect(mutableObject.getValue(), 42)
        mutableObject.setValue(100)
        @Expect(mutableObject.getValue(), 100)
    }

    /**
     * 测试 Float64 类型的 MutableObject
     */
    @TestCase
    public func testFloat64Type() {
        let mutableObject = MutableObject<Float64>(3.14)
        @Expect(mutableObject.getValue(), 3.14)
        mutableObject.setValue(2.71)
        @Expect(mutableObject.getValue(), 2.71)
    }

    /**
     * 测试 Bool 类型的 MutableObject
     */
    @TestCase
    public func testBoolType() {
        let mutableObject = MutableObject<Bool>(true)
        @Expect(mutableObject.getValue(), true)
        mutableObject.setValue(false)
        @Expect(mutableObject.getValue(), false)
    }

    /**
     * 测试设置空字符串
     */
    @TestCase
    public func testEmptyString() {
        let mutableObject = MutableObject<String>("")
        @Expect(mutableObject.getValue(), "")
        @Expect(mutableObject.isSet(), true)
    }

    /**
     * 测试设置零值
     */
    @TestCase
    public func testZeroValue() {
        let mutableObject = MutableObject<Int64>(0)
        @Expect(mutableObject.getValue(), 0)
        @Expect(mutableObject.isSet(), true)
    }

    /**
     * 测试从未设置到设置
     */
    @TestCase
    public func testFromNotSetToSet() {
        let mutableObject = MutableObject<String>()
        @Expect(mutableObject.isSet(), false)
        mutableObject.setValue("Hello")
        @Expect(mutableObject.isSet(), true)
        @Expect(mutableObject.getValue(), "Hello")
    }

    /**
     * 测试从设置到未设置（无法直接重置为 None）
     */
    @TestCase
    public func testCannotResetToNone() {
        let mutableObject = MutableObject<String>("Hello")
        // MutableObject 没有 resetToNone 方法，只能设置新值
        mutableObject.setValue("World")
        @Expect(mutableObject.isSet(), true)
        @Expect(mutableObject.getValue(), "World")
    }

    /**
     * 测试不同类型的 MutableObject
     */
    @TestCase
    public func testDifferentTypes() {
        let m1 = MutableObject<String>("Hello")
        let m2 = MutableObject<Int64>(42)
        let m3 = MutableObject<Bool>(true)

        @Expect(m1.getValue(), "Hello")
        @Expect(m2.getValue(), 42)
        @Expect(m3.getValue(), true)
    }

    /**
     * 测试 hashCode 一致性
     */
    @TestCase
    public func testHashCodeConsistency() {
        let m1 = MutableObject<String>("Hello")
        let m2 = MutableObject<String>("Hello")
        @Expect(m1.hashCode(), m2.hashCode())
    }

    /**
     * 测试 equals 类型一致性
     */
    @TestCase
    public func testEqualsTypeConsistency() {
        let m1 = MutableObject<String>("42")
        let m2 = MutableObject<Int64>(42)
        // 不同类型不相等（即使 toString 结果相同）
        @Expect(m1.equals(m2), false)
    }
}
