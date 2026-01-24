package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

/**
 * ObjectUtils 单元测试
 *
 * 测试覆盖 31 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class ObjectUtilsTest {
    // ========== Phase 1: 空值处理测试 ==========

    @TestCase
    func testDefaultIfNull() {
        // Some 值返回自身
        let someVal: Option<Int64> = Some(42)
        @Expect(ObjectUtils.defaultIfNull(someVal, 0), 42)

        // None 返回默认值
        let noneVal: Option<Int64> = None
        @Expect(ObjectUtils.defaultIfNull(noneVal, 0), 0)
        @Expect(ObjectUtils.defaultIfNull(noneVal, 100), 100)

        // String 类型
        let someStr: Option<String> = Some("hello")
        let noneStr: Option<String> = None
        @Expect(ObjectUtils.defaultIfNull(someStr, "default"), "hello")
        @Expect(ObjectUtils.defaultIfNull(noneStr, "default"), "default")
    }

    @TestCase
    func testIsNull() {
        // Some 值返回 false
        let someVal: Option<Int64> = Some(42)
        @Expect(ObjectUtils.isNull(someVal), false)

        // None 返回 true
        let noneVal: Option<Int64> = None
        @Expect(ObjectUtils.isNull(noneVal), true)

        // String 类型
        let someStr: Option<String> = Some("hello")
        let noneStr: Option<String> = None
        @Expect(ObjectUtils.isNull(someStr), false)
        @Expect(ObjectUtils.isNull(noneStr), true)
    }

    @TestCase
    func testNotNull() {
        // Some 值返回 true
        let someVal: Option<Int64> = Some(42)
        @Expect(ObjectUtils.notNull(someVal), true)

        // None 返回 false
        let noneVal: Option<Int64> = None
        @Expect(ObjectUtils.notNull(noneVal), false)

        // String 类型
        let someStr: Option<String> = Some("hello")
        let noneStr: Option<String> = None
        @Expect(ObjectUtils.notNull(someStr), true)
        @Expect(ObjectUtils.notNull(noneStr), false)
    }

    // ========== Phase 2: 相等比较测试 ==========

    @TestCase
    func testEqual() {
        // 两个相等的 Some 值
        let val1: Option<Int64> = Some(42)
        let val2: Option<Int64> = Some(42)
        @Expect(ObjectUtils.equal(val1, val2), true)

        // 两个不等的 Some 值
        let val3: Option<Int64> = Some(42)
        let val4: Option<Int64> = Some(43)
        @Expect(ObjectUtils.equal(val3, val4), false)

        // 两个 None
        let val5: Option<Int64> = None
        let val6: Option<Int64> = None
        @Expect(ObjectUtils.equal(val5, val6), true)

        // 一个 None，一个 Some
        let val7: Option<Int64> = None
        let val8: Option<Int64> = Some(42)
        @Expect(ObjectUtils.equal(val7, val8), false)

        // String 类型
        let str1: Option<String> = Some("hello")
        let str2: Option<String> = Some("hello")
        let str3: Option<String> = Some("world")
        @Expect(ObjectUtils.equal(str1, str2), true)
        @Expect(ObjectUtils.equal(str1, str3), false)
    }

    @TestCase
    func testNotEqual() {
        // 两个相等的 Some 值
        let val1: Option<Int64> = Some(42)
        let val2: Option<Int64> = Some(42)
        @Expect(ObjectUtils.notEqual(val1, val2), false)

        // 两个不等的 Some 值
        let val3: Option<Int64> = Some(42)
        let val4: Option<Int64> = Some(43)
        @Expect(ObjectUtils.notEqual(val3, val4), true)

        // 两个 None
        let val5: Option<Int64> = None
        let val6: Option<Int64> = None
        @Expect(ObjectUtils.notEqual(val5, val6), false)

        // 一个 None，一个 Some
        let val7: Option<Int64> = None
        let val8: Option<Int64> = Some(42)
        @Expect(ObjectUtils.notEqual(val7, val8), true)
    }

    // ========== Phase 3: 比较操作测试 ==========

    @TestCase
    func testCompare() {
        // 两个相等的 Some 值
        let val1: Option<Int64> = Some(42)
        let val2: Option<Int64> = Some(42)
        @Expect(ObjectUtils.compare(val1, val2), 0)

        // 第一个小于第二个
        let val3: Option<Int64> = Some(42)
        let val4: Option<Int64> = Some(43)
        @Expect(ObjectUtils.compare(val3, val4), -1)

        // 第一个大于第二个
        let val5: Option<Int64> = Some(43)
        let val6: Option<Int64> = Some(42)
        @Expect(ObjectUtils.compare(val5, val6), 1)

        // 第一个是 None，第二个是 Some（None < any）
        let val7: Option<Int64> = None
        let val8: Option<Int64> = Some(42)
        @Expect(ObjectUtils.compare(val7, val8), -1)

        // 第一个是 Some，第二个是 None（any > None）
        let val9: Option<Int64> = Some(42)
        let val10: Option<Int64> = None
        @Expect(ObjectUtils.compare(val9, val10), 1)

        // 两个都是 None
        let val11: Option<Int64> = None
        let val12: Option<Int64> = None
        @Expect(ObjectUtils.compare(val11, val12), 0)
    }

    @TestCase
    func testMin() {
        @Expect(ObjectUtils.min(42, 43), 42)
        @Expect(ObjectUtils.min(43, 42), 42)
        @Expect(ObjectUtils.min(42, 42), 42)
        @Expect(ObjectUtils.min(-10, 10), -10)
        @Expect(ObjectUtils.min(0, 0), 0)
    }

    @TestCase
    func testMax() {
        @Expect(ObjectUtils.max(42, 43), 43)
        @Expect(ObjectUtils.max(43, 42), 43)
        @Expect(ObjectUtils.max(42, 42), 42)
        @Expect(ObjectUtils.max(-10, 10), 10)
        @Expect(ObjectUtils.max(0, 0), 0)
    }

    // ========== Phase 4: 哈希码测试 ==========

    @TestCase
    func testHash() {
        // Some 值返回值本身
        let val: Option<Int64> = Some(42)
        @Expect(ObjectUtils.hash(val), 42)

        // None 返回 0
        let noneVal: Option<Int64> = None
        @Expect(ObjectUtils.hash(noneVal), 0)

        // 不同值
        let val2: Option<Int64> = Some(0)
        @Expect(ObjectUtils.hash(val2), 0)

        let val3: Option<Int64> = Some(100)
        @Expect(ObjectUtils.hash(val3), 100)
    }

    @TestCase
    func testHashString() {
        // Some 字符串值返回哈希码
        let val: Option<String> = Some("hello")
        let hash = ObjectUtils.hashString(val)
        @Expect(hash > 0, true)

        // None 返回 0
        let noneVal: Option<String> = None
        @Expect(ObjectUtils.hashString(noneVal), 0)

        // 空字符串
        let emptyStr: Option<String> = Some("")
        @Expect(ObjectUtils.hashString(emptyStr), 0)
    }

    // ========== Phase 5: 字符串表示测试 ==========

    @TestCase
    func testToString() {
        // Some 值返回字符串表示
        let val: Option<Int64> = Some(42)
        @Expect(ObjectUtils.toString(val), "42")

        // None 返回空字符串
        let noneVal: Option<Int64> = None
        @Expect(ObjectUtils.toString(noneVal), "")

        // String 类型
        let strVal: Option<String> = Some("hello")
        @Expect(ObjectUtils.toString(strVal), "hello")

        // Float64 类型
        let floatVal: Option<Float64> = Some(3.14)
        @Expect(ObjectUtils.toString(floatVal), "3.140000")
    }

    @TestCase
    func testIdentityToString() {
        // Some 值返回身份字符串
        let val: Option<String> = Some("hello")
        let identity = ObjectUtils.identityToString(val)
        @Expect(identity.size > 0, true)

        // None 返回空字符串
        let noneVal: Option<String> = None
        @Expect(ObjectUtils.identityToString(noneVal), "")
    }

    // ========== Phase 6: 克隆与数组检查测试 ==========

    @TestCase
    func testClone() {
        // 值类型直接返回
        let val = 42
        @Expect(ObjectUtils.clone(val), 42)

        let str = "hello"
        @Expect(ObjectUtils.clone(str), "hello")
    }

    @TestCase
    func testAllNull() {
        // 所有元素都是 None
        let arr1: Array<Option<Int64>> = [None, None, None]
        @Expect(ObjectUtils.allNull(arr1), true)

        // 空数组返回 true
        let arr2 = Array<Option<Int64>>()
        @Expect(ObjectUtils.allNull(arr2), true)

        // 有非 None 元素
        let arr3: Array<Option<Int64>> = [Some(42), None]
        @Expect(ObjectUtils.allNull(arr3), false)

        let arr4: Array<Option<Int64>> = [None, Some(42)]
        @Expect(ObjectUtils.allNull(arr4), false)

        let arr5 = [Some(42), Some(43)]
        @Expect(ObjectUtils.allNull(arr5), false)
    }

    @TestCase
    func testAnyNull() {
        // 所有元素都是 None
        let arr1: Array<Option<Int64>> = [None, None, None]
        @Expect(ObjectUtils.anyNull(arr1), true)

        // 空数组返回 false
        let arr2 = Array<Option<Int64>>()
        @Expect(ObjectUtils.anyNull(arr2), false)

        // 有 None 元素
        let arr3: Array<Option<Int64>> = [Some(42), None]
        @Expect(ObjectUtils.anyNull(arr3), true)

        // 没有 None 元素
        let arr4 = [Some(42), Some(43)]
        @Expect(ObjectUtils.anyNull(arr4), false)
    }

    // ========== Phase 7: 额外实用方法测试 ==========

    @TestCase
    func testFirstNonNull() {
        // 第一个非 None 值
        let arr1: Array<Option<Int64>> = [None, Some(42), Some(100)]
        @Expect(ObjectUtils.firstNonNull(arr1), Some(42))

        // 所有都是 None
        let arr2: Array<Option<Int64>> = [None, None]
        @Expect(ObjectUtils.firstNonNull(arr2), None)

        // 空数组
        let arr3 = Array<Option<Int64>>()
        @Expect(ObjectUtils.firstNonNull(arr3), None)

        // 第一个就是非 None
        let arr4: Array<Option<Int64>> = [Some(100), None]
        @Expect(ObjectUtils.firstNonNull(arr4), Some(100))
    }

    @TestCase
    func testCompareWith() {
        let cmp = { a: Int64, b: Int64 => a - b }
        @Expect(ObjectUtils.compareWith(10, 10, cmp), true)
        @Expect(ObjectUtils.compareWith(10, 20, cmp), false)
        @Expect(ObjectUtils.compareWith(20, 10, cmp), false)
    }

    @TestCase
    func testMedianCompare() {
        let cmp = { a: Int64, b: Int64 => a - b }
        @Expect(ObjectUtils.medianCompare(10, 20, cmp) < 0, true)
        @Expect(ObjectUtils.medianCompare(20, 10, cmp) > 0, true)
        @Expect(ObjectUtils.medianCompare(10, 10, cmp), 0)
    }

    @TestCase
    func testIsType() {
        let str: Option<String> = Some("hello")
        let num: Option<Int64> = Some(42)
        let noneVal: Option<String> = None

        // 测试 String 类型
        @Expect(ObjectUtils.isType(str, { _ => true }, { => false }), true)
        @Expect(ObjectUtils.isType(noneVal, { _ => true }, { => false }), false)

        // 测试 Int64 类型（需要显式类型参数）
        @Expect(ObjectUtils.isType<Int64>(num, { _ => true }, { => false }), true)
    }

    @TestCase
    func testIsString() {
        let str: Option<String> = Some("hello")
        let noneVal: Option<String> = None

        @Expect(ObjectUtils.isString(str), true)
        @Expect(ObjectUtils.isString(noneVal), false)
    }

    @TestCase
    func testIsInt64() {
        let num: Option<Int64> = Some(42)
        let noneVal: Option<Int64> = None

        @Expect(ObjectUtils.isInt64(num), true)
        @Expect(ObjectUtils.isInt64(noneVal), false)
    }

    @TestCase
    func testIsFloat64() {
        let num: Option<Float64> = Some(3.14)
        let noneVal: Option<Float64> = None

        @Expect(ObjectUtils.isFloat64(num), true)
        @Expect(ObjectUtils.isFloat64(noneVal), false)
    }

    @TestCase
    func testIsNumber() {
        let num: Option<Int64> = Some(42)
        let noneVal: Option<Int64> = None

        @Expect(ObjectUtils.isNumber(num), true)
        @Expect(ObjectUtils.isNumber(noneVal), false)
    }

    @TestCase
    func testRequireNonNull() {
        // Some 值返回值本身
        let val: Option<Int64> = Some(42)
        @Expect(ObjectUtils.requireNonNull(val), 42)

        // None 抛出异常
        let noneVal: Option<Int64> = None
        try {
            ObjectUtils.requireNonNull(noneVal)
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testRequireNonNullWithMessage() {
        // Some 值返回值本身
        let val: Option<Int64> = Some(42)
        @Expect(ObjectUtils.requireNonNull(val, "对象不能为空"), 42)

        // None 抛出带自定义消息的异常
        let noneVal: Option<Int64> = None
        try {
            ObjectUtils.requireNonNull(noneVal, "对象不能为空")
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "对象不能为空")
        }
    }

    @TestCase
    func testCompareTo() {
        @Expect(ObjectUtils.compareTo(10, 20) < 0, true)
        @Expect(ObjectUtils.compareTo(20, 10) > 0, true)
        @Expect(ObjectUtils.compareTo(10, 10), 0)
    }

    @TestCase
    func testContainsNull() {
        let arr1 = [Some(1), Some(2), Some(3)]
        let arr2: Array<Option<Int64>> = [Some(1), None, Some(3)]
        let arr3 = Array<Option<Int64>>()

        @Expect(ObjectUtils.containsNull(arr1), false)
        @Expect(ObjectUtils.containsNull(arr2), true)
        @Expect(ObjectUtils.containsNull(arr3), false)
    }

    @TestCase
    func testFilterNonNull() {
        // 过滤掉 None 元素
        let arr1: Array<Option<Int64>> = [Some(1), None, Some(3), None]
        let filtered1 = ObjectUtils.filterNonNull(arr1)
        @Expect(filtered1.size, 2)
        @Expect(filtered1[0], Some(1))
        @Expect(filtered1[1], Some(3))

        // 没有 None 元素
        let arr2 = [Some(1), Some(2), Some(3)]
        let filtered2 = ObjectUtils.filterNonNull(arr2)
        @Expect(filtered2.size, 3)

        // 全部是 None
        let arr3: Array<Option<Int64>> = [None, None]
        let filtered3 = ObjectUtils.filterNonNull(arr3)
        @Expect(filtered3.size, 0)

        // 空数组
        let arr4 = Array<Option<Int64>>()
        let filtered4 = ObjectUtils.filterNonNull(arr4)
        @Expect(filtered4.size, 0)
    }

    @TestCase
    func testIsArray() {
        let val: Option<Int64> = Some(42)
        let noneVal: Option<Int64> = None

        // 简化实现：Some 返回 true，None 返回 false
        @Expect(ObjectUtils.isArray(val), true)
        @Expect(ObjectUtils.isArray(noneVal), false)
    }

    @TestCase
    func testSafeCast() {
        let val: Option<String> = Some("hello")
        let noneVal: Option<String> = None

        // 成功转换
        let result1 = ObjectUtils.safeCast(val, { s: String => Some(s.size) }, { => None })
        @Expect(result1, Some(5))

        // None 输入
        let result2 = ObjectUtils.safeCast(noneVal, { s: String => Some(s.size) }, { => None })
        @Expect(result2, None)

        // 转换失败
        let result3 = ObjectUtils.safeCast<String, Int64>(val, { _ => None }, { => None })
        @Expect(result3, None)
    }

    @TestCase
    func testIsSame() {
        // 两个相等的 Some 值
        let val1: Option<Int64> = Some(42)
        let val2: Option<Int64> = Some(42)
        @Expect(ObjectUtils.isSame(val1, val2), true)

        // 两个不等的 Some 值
        let val3: Option<Int64> = Some(42)
        let val4: Option<Int64> = Some(43)
        @Expect(ObjectUtils.isSame(val3, val4), false)

        // 两个 None
        let val5: Option<Int64> = None
        let val6: Option<Int64> = None
        @Expect(ObjectUtils.isSame(val5, val6), true)

        // 一个 None，一个 Some
        let val7: Option<Int64> = None
        let val8: Option<Int64> = Some(42)
        @Expect(ObjectUtils.isSame(val7, val8), false)
    }
}
