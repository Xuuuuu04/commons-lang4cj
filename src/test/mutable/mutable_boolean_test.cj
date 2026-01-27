package commons_lang4cj.test.mutable

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.mutable.*

/**
 * MutableBoolean 测试类
 * 测试可变布尔值包装器的所有功能
 */
@Test
class MutableBooleanTest {
    /**
     * 测试无参构造函数（默认 false）
     */
    @TestCase
    public func testConstructorNoArg() {
        let mutableBoolean = MutableBoolean()
        @Expect(mutableBoolean.getValue(), false)
    }

    /**
     * 测试带 Bool 值的构造函数 - true
     */
    @TestCase
    public func testConstructorWithTrue() {
        let mutableBoolean = MutableBoolean(true)
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试带 Bool 值的构造函数 - false
     */
    @TestCase
    public func testConstructorWithFalse() {
        let mutableBoolean = MutableBoolean(false)
        @Expect(mutableBoolean.getValue(), false)
    }

    /**
     * 测试从字符串构造 - "true"
     */
    @TestCase
    public func testConstructorFromStringTrue() {
        let mutableBoolean = MutableBoolean("true")
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试从字符串构造 - "false"
     */
    @TestCase
    public func testConstructorFromStringFalse() {
        let mutableBoolean = MutableBoolean("false")
        @Expect(mutableBoolean.getValue(), false)
    }

    /**
     * 测试从字符串构造 - 大小写变体
     */
    @TestCase
    public func testConstructorFromStringCaseInsensitive() {
        let m1 = MutableBoolean("True")
        let m2 = MutableBoolean("FALSE")
        let m3 = MutableBoolean("YES")
        let m4 = MutableBoolean("no")
        @Expect(m1.getValue(), true)
        @Expect(m2.getValue(), false)
        @Expect(m3.getValue(), true)
        @Expect(m4.getValue(), false)
    }

    /**
     * 测试从字符串构造 - 简写形式
     */
    @TestCase
    public func testConstructorFromStringShort() {
        let m1 = MutableBoolean("T")
        let m2 = MutableBoolean("f")
        let m3 = MutableBoolean("Y")
        let m4 = MutableBoolean("n")
        @Expect(m1.getValue(), true)
        @Expect(m2.getValue(), false)
        @Expect(m3.getValue(), true)
        @Expect(m4.getValue(), false)
    }

    /**
     * 测试从字符串构造 - 数字形式
     */
    @TestCase
    public func testConstructorFromStringNumeric() {
        let m1 = MutableBoolean("1")
        let m2 = MutableBoolean("0")
        @Expect(m1.getValue(), true)
        @Expect(m2.getValue(), false)
    }

    /**
     * 测试从字符串构造 - 无效格式
     */
    @TestCase
    public func testConstructorFromStringInvalid() {
        try {
            let _ = MutableBoolean("invalid")
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IllegalArgumentException) {
            @Expect(true, true)  // 期望抛出异常
        }
    }

    /**
     * 测试 getValue 方法
     */
    @TestCase
    public func testGetValue() {
        let mutableBoolean = MutableBoolean(true)
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试 setValue 方法
     */
    @TestCase
    public func testSetValue() {
        let mutableBoolean = MutableBoolean(false)
        mutableBoolean.setValue(true)
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试 and 方法
     */
    @TestCase
    public func testAnd() {
        let mutableBoolean = MutableBoolean(true)
        mutableBoolean.and(false)
        @Expect(mutableBoolean.getValue(), false)
    }

    /**
     * 测试 and 方法 - true && true
     */
    @TestCase
    public func testAndBothTrue() {
        let mutableBoolean = MutableBoolean(true)
        mutableBoolean.and(true)
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试 or 方法
     */
    @TestCase
    public func testOr() {
        let mutableBoolean = MutableBoolean(false)
        mutableBoolean.or(true)
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试 or 方法 - false || false
     */
    @TestCase
    public func testOrBothFalse() {
        let mutableBoolean = MutableBoolean(false)
        mutableBoolean.or(false)
        @Expect(mutableBoolean.getValue(), false)
    }

    /**
     * 测试 xor 方法
     */
    @TestCase
    public func testXor() {
        let mutableBoolean = MutableBoolean(true)
        mutableBoolean.xor(true)
        @Expect(mutableBoolean.getValue(), false)
    }

    /**
     * 测试 xor 方法 - true xor false
     */
    @TestCase
    public func testXorTrueFalse() {
        let mutableBoolean = MutableBoolean(true)
        mutableBoolean.xor(false)
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试 not 方法
     */
    @TestCase
    public func testNot() {
        let mutableBoolean = MutableBoolean(true)
        mutableBoolean.not()
        @Expect(mutableBoolean.getValue(), false)
    }

    /**
     * 测试 not 方法 - false -> true
     */
    @TestCase
    public func testNotFalse() {
        let mutableBoolean = MutableBoolean(false)
        mutableBoolean.not()
        @Expect(mutableBoolean.getValue(), true)
    }

    /**
     * 测试 isTrue 方法
     */
    @TestCase
    public func testIsTrue() {
        let mutableBoolean = MutableBoolean(true)
        @Expect(mutableBoolean.isTrue(), true)
    }

    /**
     * 测试 isTrue 方法 - false
     */
    @TestCase
    public func testIsTrueFalse() {
        let mutableBoolean = MutableBoolean(false)
        @Expect(mutableBoolean.isTrue(), false)
    }

    /**
     * 测试 isFalse 方法
     */
    @TestCase
    public func testIsFalse() {
        let mutableBoolean = MutableBoolean(false)
        @Expect(mutableBoolean.isFalse(), true)
    }

    /**
     * 测试 isFalse 方法 - true
     */
    @TestCase
    public func testIsFalseTrue() {
        let mutableBoolean = MutableBoolean(true)
        @Expect(mutableBoolean.isFalse(), false)
    }

    /**
     * 测试 toInt 方法 - true = 1
     */
    @TestCase
    public func testToIntTrue() {
        let mutableBoolean = MutableBoolean(true)
        @Expect(mutableBoolean.toInt(), 1)
    }

    /**
     * 测试 toInt 方法 - false = 0
     */
    @TestCase
    public func testToIntFalse() {
        let mutableBoolean = MutableBoolean(false)
        @Expect(mutableBoolean.toInt(), 0)
    }

    /**
     * 测试 toString 方法 - true
     */
    @TestCase
    public func testToStringTrue() {
        let mutableBoolean = MutableBoolean(true)
        @Expect(mutableBoolean.toString(), "true")
    }

    /**
     * 测试 toString 方法 - false
     */
    @TestCase
    public func testToStringFalse() {
        let mutableBoolean = MutableBoolean(false)
        @Expect(mutableBoolean.toString(), "false")
    }

    /**
     * 测试 equals - 相等
     */
    @TestCase
    public func testEquals() {
        let m1 = MutableBoolean(true)
        let m2 = MutableBoolean(true)
        @Expect(m1.equals(m2), true)
    }

    /**
     * 测试 equals - 不相等
     */
    @TestCase
    public func testEqualsNotEqual() {
        let m1 = MutableBoolean(true)
        let m2 = MutableBoolean(false)
        @Expect(m1.equals(m2), false)
    }

    /**
     * 测试 hashCode - true = 1231
     */
    @TestCase
    public func testHashCodeTrue() {
        let mutableBoolean = MutableBoolean(true)
        @Expect(mutableBoolean.hashCode(), 1231)
    }

    /**
     * 测试 hashCode - false = 1237
     */
    @TestCase
    public func testHashCodeFalse() {
        let mutableBoolean = MutableBoolean(false)
        @Expect(mutableBoolean.hashCode(), 1237)
    }

    /**
     * 测试 compare - false < true
     */
    @TestCase
    public func testCompareFalseLessThanTrue() {
        let m1 = MutableBoolean(false)
        let m2 = MutableBoolean(true)
        @Expect(m1.compare(m2), Ordering.LT)
    }

    /**
     * 测试 compare - true > false
     */
    @TestCase
    public func testCompareTrueGreaterThanFalse() {
        let m1 = MutableBoolean(true)
        let m2 = MutableBoolean(false)
        @Expect(m1.compare(m2), Ordering.GT)
    }

    /**
     * 测试 compare - 相等
     */
    @TestCase
    public func testCompareEqual() {
        let m1 = MutableBoolean(true)
        let m2 = MutableBoolean(true)
        @Expect(m1.compare(m2), Ordering.EQ)
    }

    /**
     * 测试工厂方法 of
     */
    @TestCase
    public func testOf() {
        let m1 = MutableBoolean.of(true)
        let m2 = MutableBoolean.of(false)
        @Expect(m1.getValue(), true)
        @Expect(m2.getValue(), false)
    }

    /**
     * 测试工厂方法 fromString - 有效值
     */
    @TestCase
    public func testFromStringValid() {
        let result = MutableBoolean.fromString("yes")
        @Expect(result.isSome(), true)
        if (let Some(m) <- result) {
            @Expect(m.getValue(), true)
        }
    }

    /**
     * 测试工厂方法 fromString - 无效值
     */
    @TestCase
    public func testFromStringInvalid() {
        let result = MutableBoolean.fromString("invalid")
        @Expect(result.isNone(), true)
    }

    /**
     * 测试链式调用
     */
    @TestCase
    public func testChaining() {
        let mutableBoolean = MutableBoolean(true)
        mutableBoolean.not()
        mutableBoolean.or(false)
        @Expect(mutableBoolean.getValue(), false)
    }
}
