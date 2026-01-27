package commons_lang4cj.test.tuple

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.tuple.*

/**
 * Triple 结构体的单元测试
 *
 * 测试用例总数: 42
 * - 构造方法测试: 4
 * - 访问方法测试: 9
 * - toString 测试: 7
 * - with 方法测试: 9
 * - equals 测试: 6
 * - hashCode 测试: 7
 */
@Test
class TripleTest {
    /**
     * 测试 Triple 构造 - 基本类型
     */
    @TestCase
    func testConstructorBasic() {
        let triple = Triple(1, "middle", 2.0)
        @Expect(triple.getLeft(), 1)
        @Expect(triple.getMiddle(), "middle")
        @Expect(triple.getRight(), 2.0)
    }

    /**
     * 测试 Triple 构造 - 整数
     */
    @TestCase
    func testConstructorInt() {
        let triple = Triple(1, 2, 3)
        @Expect(triple.getLeft(), 1)
        @Expect(triple.getMiddle(), 2)
        @Expect(triple.getRight(), 3)
    }

    /**
     * 测试 Triple 构造 - 字符串
     */
    @TestCase
    func testConstructorString() {
        let triple = Triple("left", "middle", "right")
        @Expect(triple.getLeft(), "left")
        @Expect(triple.getMiddle(), "middle")
        @Expect(triple.getRight(), "right")
    }

    /**
     * 测试 Triple 构造 - 浮点数
     */
    @TestCase
    func testConstructorFloat() {
        let triple = Triple(1.1, 2.2, 3.3)
        @Expect(triple.getLeft(), 1.1)
        @Expect(triple.getMiddle(), 2.2)
        @Expect(triple.getRight(), 3.3)
    }

    /**
     * 测试 getLeft 方法
     */
    @TestCase
    func testGetLeft() {
        let triple = Triple(10, 20, 30)
        @Expect(triple.getLeft(), 10)
    }

    /**
     * 测试 getLeft 方法 - 字符串
     */
    @TestCase
    func testGetLeftString() {
        let triple = Triple("leftValue", "middle", "right")
        @Expect(triple.getLeft(), "leftValue")
    }

    /**
     * 测试 getLeft 方法 - 布尔值
     */
    @TestCase
    func testGetLeftBoolean() {
        let triple = Triple(true, false, true)
        @Expect(triple.getLeft(), true)
    }

    /**
     * 测试 getMiddle 方法
     */
    @TestCase
    func testGetMiddle() {
        let triple = Triple(10, 20, 30)
        @Expect(triple.getMiddle(), 20)
    }

    /**
     * 测试 getMiddle 方法 - 字符串
     */
    @TestCase
    func testGetMiddleString() {
        let triple = Triple("left", "middleValue", "right")
        @Expect(triple.getMiddle(), "middleValue")
    }

    /**
     * 测试 getMiddle 方法 - 布尔值
     */
    @TestCase
    func testGetMiddleBoolean() {
        let triple = Triple(false, true, false)
        @Expect(triple.getMiddle(), true)
    }

    /**
     * 测试 getRight 方法
     */
    @TestCase
    func testGetRight() {
        let triple = Triple(10, 20, 30)
        @Expect(triple.getRight(), 30)
    }

    /**
     * 测试 getRight 方法 - 字符串
     */
    @TestCase
    func testGetRightString() {
        let triple = Triple("left", "middle", "rightValue")
        @Expect(triple.getRight(), "rightValue")
    }

    /**
     * 测试 getRight 方法 - 布尔值
     */
    @TestCase
    func testGetRightBoolean() {
        let triple = Triple(false, true, false)
        @Expect(triple.getRight(), false)
    }

    /**
     * 测试 toString - 整数
     */
    @TestCase
    func testToStringInt() {
        let triple = Triple(1, 2, 3)
        let str = triple.toString()
        @Expect(str, "(1, 2, 3)")
    }

    /**
     * 测试 toString - 字符串
     */
    @TestCase
    func testToStringString() {
        let triple = Triple("left", "middle", "right")
        let str = triple.toString()
        @Expect(str, "(left, middle, right)")
    }

    /**
     * 测试 toString - 混合类型
     */
    @TestCase
    func testToStringMixed() {
        let triple = Triple(100, "test", 3.14)
        let str = triple.toString()
        @Expect(str.contains("100"), true)
        @Expect(str.contains("test"), true)
        @Expect(str.contains("3.14"), true)
    }

    /**
     * 测试 toString - 浮点数
     */
    @TestCase
    func testToStringFloat() {
        let triple = Triple(1.1, 2.2, 3.3)
        let str = triple.toString()
        @Expect(str.contains("1.1"), true)
        @Expect(str.contains("2.2"), true)
        @Expect(str.contains("3.3"), true)
    }

    /**
     * 测试 toString - 布尔值
     */
    @TestCase
    func testToStringBoolean() {
        let triple = Triple(true, false, true)
        let str = triple.toString()
        @Expect(str, "(true, false, true)")
    }

    /**
     * 测试 toString - 空字符串
     */
    @TestCase
    func testToStringEmpty() {
        let triple = Triple("", "", "")
        let str = triple.toString()
        @Expect(str, "(, , )")
    }

    /**
     * 测试 withLeft 方法
     */
    @TestCase
    func testWithLeft() {
        let triple = Triple(1, 2, 3)
        let newTriple = triple.withLeft(10)
        @Expect(newTriple.getLeft(), 10)
        @Expect(newTriple.getMiddle(), 2)
        @Expect(newTriple.getRight(), 3)
        // 原对象不变
        @Expect(triple.getLeft(), 1)
    }

    /**
     * 测试 withLeft 方法 - 字符串
     */
    @TestCase
    func testWithLeftString() {
        let triple = Triple("old", "middle", "right")
        let newTriple = triple.withLeft("new")
        @Expect(newTriple.getLeft(), "new")
        @Expect(newTriple.getMiddle(), "middle")
        @Expect(newTriple.getRight(), "right")
    }

    /**
     * 测试 withMiddle 方法
     */
    @TestCase
    func testWithMiddle() {
        let triple = Triple(1, 2, 3)
        let newTriple = triple.withMiddle(20)
        @Expect(newTriple.getLeft(), 1)
        @Expect(newTriple.getMiddle(), 20)
        @Expect(newTriple.getRight(), 3)
        // 原对象不变
        @Expect(triple.getMiddle(), 2)
    }

    /**
     * 测试 withMiddle 方法 - 字符串
     */
    @TestCase
    func testWithMiddleString() {
        let triple = Triple("left", "old", "right")
        let newTriple = triple.withMiddle("new")
        @Expect(newTriple.getLeft(), "left")
        @Expect(newTriple.getMiddle(), "new")
        @Expect(newTriple.getRight(), "right")
    }

    /**
     * 测试 withRight 方法
     */
    @TestCase
    func testWithRight() {
        let triple = Triple(1, 2, 3)
        let newTriple = triple.withRight(30)
        @Expect(newTriple.getLeft(), 1)
        @Expect(newTriple.getMiddle(), 2)
        @Expect(newTriple.getRight(), 30)
        // 原对象不变
        @Expect(triple.getRight(), 3)
    }

    /**
     * 测试 withRight 方法 - 字符串
     */
    @TestCase
    func testWithRightString() {
        let triple = Triple("left", "middle", "old")
        let newTriple = triple.withRight("new")
        @Expect(newTriple.getLeft(), "left")
        @Expect(newTriple.getMiddle(), "middle")
        @Expect(newTriple.getRight(), "new")
    }

    /**
     * 测试 withLeft 和 withMiddle 链式调用
     */
    @TestCase
    func testWithLeftAndMiddleChained() {
        let triple = Triple(1i64, 2i64, 3i64)
        let t1 = triple.withLeft(10i64)
        let newTriple = t1.withMiddle(20i64)
        @Expect(newTriple.getLeft(), 10i64)
        @Expect(newTriple.getMiddle(), 20i64)
        @Expect(newTriple.getRight(), 3i64)
    }

    /**
     * 测试 withLeft、withMiddle 和 withRight 链式调用
     */
    @TestCase
    func testWithAllChained() {
        let triple = Triple(1i64, 2i64, 3i64)
        let t1 = triple.withLeft(10i64)
        let t2 = t1.withMiddle(20i64)
        let newTriple = t2.withRight(30i64)
        @Expect(newTriple.getLeft(), 10i64)
        @Expect(newTriple.getMiddle(), 20i64)
        @Expect(newTriple.getRight(), 30i64)
    }

    /**
     * 测试不可变性 - 原对象不被修改
     */
    @TestCase
    func testImmutability() {
        let triple = Triple(1i64, 2i64, 3i64)
        let originalLeft = triple.getLeft()
        let originalMiddle = triple.getMiddle()
        let originalRight = triple.getRight()

        // with 方法创建新对象
        let t1 = triple.withLeft(10i64)
        let t2 = t1.withMiddle(20i64)
        let newTriple = t2.withRight(30i64)

        // 原对象不变
        @Expect(triple.getLeft(), originalLeft)
        @Expect(triple.getMiddle(), originalMiddle)
        @Expect(triple.getRight(), originalRight)
        @Expect(triple.getLeft(), 1i64)
        @Expect(triple.getMiddle(), 2i64)
        @Expect(triple.getRight(), 3i64)
    }

    /**
     * 测试 tripleEquals - 相等的 Triple
     */
    @TestCase
    func testTripleEqualsEqual() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(1, 2, 3)
        @Expect(tripleEquals(triple1, triple2), true)
    }

    /**
     * 测试 tripleEquals - 左元素不同
     */
    @TestCase
    func testTripleEqualsDifferentLeft() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(10, 2, 3)
        @Expect(tripleEquals(triple1, triple2), false)
    }

    /**
     * 测试 tripleEquals - 中间元素不同
     */
    @TestCase
    func testTripleEqualsDifferentMiddle() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(1, 20, 3)
        @Expect(tripleEquals(triple1, triple2), false)
    }

    /**
     * 测试 tripleEquals - 右元素不同
     */
    @TestCase
    func testTripleEqualsDifferentRight() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(1, 2, 30)
        @Expect(tripleEquals(triple1, triple2), false)
    }

    /**
     * 测试 tripleEquals - 所有元素都不同
     */
    @TestCase
    func testTripleEqualsDifferentAll() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(10, 20, 30)
        @Expect(tripleEquals(triple1, triple2), false)
    }

    /**
     * 测试 tripleEquals - 字符串类型
     */
    @TestCase
    func testTripleEqualsString() {
        let triple1 = Triple("a", "b", "c")
        let triple2 = Triple("a", "b", "c")
        @Expect(tripleEquals(triple1, triple2), true)
    }

    /**
     * 测试 tripleHashCode - 相同对象
     */
    @TestCase
    func testTripleHashCodeSame() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(1, 2, 3)
        @Expect(tripleHashCode(triple1), tripleHashCode(triple2))
    }

    /**
     * 测试 tripleHashCode - 不同对象
     */
    @TestCase
    func testTripleHashCodeDifferent() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(10, 20, 30)
        // 不同对象的 hashCode 极大概率不同
        @Expect(tripleHashCode(triple1) == tripleHashCode(triple2), false)
    }

    /**
     * 测试 tripleHashCode - 对称性
     */
    @TestCase
    func testTripleHashCodeSymmetry() {
        let triple1 = Triple(100, 200, 300)
        let triple2 = Triple(100, 200, 300)
        let hash1 = tripleHashCode(triple1)
        let hash2 = tripleHashCode(triple2)
        @Expect(hash1, hash2)
    }

    /**
     * 测试 tripleHashCode - 整数类型
     */
    @TestCase
    func testTripleHashCodeInt() {
        let triple = Triple(100, 200, 300)
        let hash = tripleHashCode(triple)
        // hashCode 应该是一个整数
        @Expect(hash > 0 || hash == 0, true)
    }

    /**
     * 测试 tripleHashCode - 顺序敏感性
     */
    @TestCase
    func testTripleHashCodeOrderSensitive() {
        let triple1 = Triple(1, 2, 3)
        let triple2 = Triple(3, 2, 1)
        // 不同顺序的 Triple 应该有不同的 hashCode
        @Expect(tripleHashCode(triple1) == tripleHashCode(triple2), false)
    }
}
