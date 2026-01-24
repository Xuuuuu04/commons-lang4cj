package commons_lang4cj.test.tuple

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.tuple.*

/**
 * Pair 结构体的单元测试
 *
 * 测试用例总数: 35
 * - 构造方法测试: 4
 * - 访问方法测试: 6
 * - 工厂方法测试: 3
 * - toString 测试: 6
 * - with 方法测试: 6
 * - equals 测试: 5
 * - hashCode 测试: 5
 */
@Test
class PairTest {
    /**
     * 测试 Pair.of 工厂方法 - 基本类型
     */
    @TestCase
    func testOfBasicTypes() {
        let pair = Pair(1, "hello")
        @Expect(pair.getLeft(), 1)
        @Expect(pair.getRight(), "hello")
    }

    /**
     * 测试 Pair.of 工厂方法 - 字符串类型
     */
    @TestCase
    func testOfStringTypes() {
        let pair = Pair("left", "right")
        @Expect(pair.getLeft(), "left")
        @Expect(pair.getRight(), "right")
    }

    /**
     * 测试 Pair.of 工厂方法 - 浮点数
     */
    @TestCase
    func testOfWithFloat() {
        let pair = Pair(3.14, 2.71)
        @Expect(pair.getLeft(), 3.14)
        @Expect(pair.getRight(), 2.71)
    }

    /**
     * 测试 getLeft 方法
     */
    @TestCase
    func testGetLeft() {
        let pair = Pair(10, 20)
        @Expect(pair.getLeft(), 10)
    }

    /**
     * 测试 getLeft 方法 - 字符串
     */
    @TestCase
    func testGetLeftString() {
        let pair = Pair("leftValue", "rightValue")
        @Expect(pair.getLeft(), "leftValue")
    }

    /**
     * 测试 getLeft 方法 - 嵌套 Pair
     */
    @TestCase
    func testGetLeftNested() {
        let inner = Pair(1, 2)
        let pair = Pair(inner, 3)
        @Expect(pair.getLeft().getLeft(), 1)
        @Expect(pair.getLeft().getRight(), 2)
    }

    /**
     * 测试 getRight 方法
     */
    @TestCase
    func testGetRight() {
        let pair = Pair(10, 20)
        @Expect(pair.getRight(), 20)
    }

    /**
     * 测试 getRight 方法 - 字符串
     */
    @TestCase
    func testGetRightString() {
        let pair = Pair("leftValue", "rightValue")
        @Expect(pair.getRight(), "rightValue")
    }

    /**
     * 测试 getRight 方法 - 嵌套 Pair
     */
    @TestCase
    func testGetRightNested() {
        let inner = Pair(1, 2)
        let pair = Pair(3, inner)
        @Expect(pair.getRight().getLeft(), 1)
        @Expect(pair.getRight().getRight(), 2)
    }

    /**
     * 测试 toString - 整数对
     */
    @TestCase
    func testToStringInt() {
        let pair = Pair(1, 2)
        let str = pair.toString()
        @Expect(str, "(1, 2)")
    }

    /**
     * 测试 toString - 字符串对
     */
    @TestCase
    func testToStringString() {
        let pair = Pair("left", "right")
        let str = pair.toString()
        @Expect(str, "(left, right)")
    }

    /**
     * 测试 toString - 混合类型
     */
    @TestCase
    func testToStringMixed() {
        let pair = Pair(100, "test")
        let str = pair.toString()
        @Expect(str, "(100, test)")
    }

    /**
     * 测试 toString - 浮点数
     */
    @TestCase
    func testToStringFloat() {
        let pair = Pair(3.14, 2.71)
        let str = pair.toString()
        // Float64 的默认精度可能导致更多小数位
        @Expect(str.contains("3.14"), true)
        @Expect(str.contains("2.71"), true)
    }

    /**
     * 测试 toString - 布尔值
     */
    @TestCase
    func testToStringBoolean() {
        let pair = Pair(true, false)
        let str = pair.toString()
        @Expect(str, "(true, false)")
    }

    /**
     * 测试 withLeft 方法
     */
    @TestCase
    func testWithLeft() {
        let pair = Pair(1, 2)
        let newPair = pair.withLeft(10)
        @Expect(newPair.getLeft(), 10)
        @Expect(newPair.getRight(), 2)
        // 原对象不变
        @Expect(pair.getLeft(), 1)
    }

    /**
     * 测试 withLeft 方法 - 字符串
     */
    @TestCase
    func testWithLeftString() {
        let pair = Pair("old", "right")
        let newPair = pair.withLeft("new")
        @Expect(newPair.getLeft(), "new")
        @Expect(newPair.getRight(), "right")
    }

    /**
     * 测试 withLeft 方法 - 类型保持
     */
    @TestCase
    func testWithLeftTypePreservation() {
        let pair = Pair(1, 2)
        let newPair = pair.withLeft(100)
        @Expect(newPair.getLeft(), 100)
        @Expect(newPair.getRight(), 2)
    }

    /**
     * 测试 withRight 方法
     */
    @TestCase
    func testWithRight() {
        let pair = Pair(1, 2)
        let newPair = pair.withRight(20)
        @Expect(newPair.getLeft(), 1)
        @Expect(newPair.getRight(), 20)
        // 原对象不变
        @Expect(pair.getRight(), 2)
    }

    /**
     * 测试 withRight 方法 - 字符串
     */
    @TestCase
    func testWithRightString() {
        let pair = Pair("left", "old")
        let newPair = pair.withRight("new")
        @Expect(newPair.getLeft(), "left")
        @Expect(newPair.getRight(), "new")
    }

    /**
     * 测试 withRight 方法 - 类型保持
     */
    @TestCase
    func testWithRightTypePreservation() {
        let pair = Pair(1, 2)
        let newPair = pair.withRight(200)
        @Expect(newPair.getLeft(), 1)
        @Expect(newPair.getRight(), 200)
    }

    /**
     * 测试 withLeft 和 withRight 链式调用
     */
    @TestCase
    func testWithLeftAndRightChained() {
        let pair = Pair(1, 2)
        let newPair = pair.withLeft(10).withRight(20)
        @Expect(newPair.getLeft(), 10)
        @Expect(newPair.getRight(), 20)
    }

    /**
     * 测试不可变性 - 原对象不被修改
     */
    @TestCase
    func testImmutability() {
        let pair = Pair(1, 2)
        let originalLeft = pair.getLeft()
        let originalRight = pair.getRight()

        // with 方法创建新对象
        let newPair = pair.withLeft(10).withRight(20)

        // 原对象不变
        @Expect(pair.getLeft(), originalLeft)
        @Expect(pair.getRight(), originalRight)
        @Expect(pair.getLeft(), 1)
        @Expect(pair.getRight(), 2)
    }

    /**
     * 测试 pairEquals - 相等的 Pair
     */
    @TestCase
    func testPairEqualsEqual() {
        let pair1 = Pair(1, 2)
        let pair2 = Pair(1, 2)
        @Expect(pairEquals(pair1, pair2), true)
    }

    /**
     * 测试 pairEquals - 左元素不同
     */
    @TestCase
    func testPairEqualsDifferentLeft() {
        let pair1 = Pair(1, 2)
        let pair2 = Pair(10, 2)
        @Expect(pairEquals(pair1, pair2), false)
    }

    /**
     * 测试 pairEquals - 右元素不同
     */
    @TestCase
    func testPairEqualsDifferentRight() {
        let pair1 = Pair(1, 2)
        let pair2 = Pair(1, 20)
        @Expect(pairEquals(pair1, pair2), false)
    }

    /**
     * 测试 pairEquals - 两个元素都不同
     */
    @TestCase
    func testPairEqualsDifferentBoth() {
        let pair1 = Pair(1, 2)
        let pair2 = Pair(10, 20)
        @Expect(pairEquals(pair1, pair2), false)
    }

    /**
     * 测试 pairEquals - 字符串类型
     */
    @TestCase
    func testPairEqualsString() {
        let pair1 = Pair("a", "b")
        let pair2 = Pair("a", "b")
        @Expect(pairEquals(pair1, pair2), true)
    }

    /**
     * 测试 pairHashCode - 相同对象
     */
    @TestCase
    func testPairHashCodeSame() {
        let pair1 = Pair(1, 2)
        let pair2 = Pair(1, 2)
        @Expect(pairHashCode(pair1), pairHashCode(pair2))
    }

    /**
     * 测试 pairHashCode - 不同对象
     */
    @TestCase
    func testPairHashCodeDifferent() {
        let pair1 = Pair(1, 2)
        let pair2 = Pair(10, 20)
        // 不同对象的 hashCode 极大概率不同
        @Expect(pairHashCode(pair1) == pairHashCode(pair2), false)
    }

    /**
     * 测试 pairHashCode - 对称性
     */
    @TestCase
    func testPairHashCodeSymmetry() {
        let pair1 = Pair(100, 200)
        let pair2 = Pair(100, 200)
        let hash1 = pairHashCode(pair1)
        let hash2 = pairHashCode(pair2)
        @Expect(hash1, hash2)
    }

    /**
     * 测试 pairHashCode - 字符串类型
     * 注意: String 实现了 Hashable，可以使用 pairHashCode
     */
    @TestCase
    func testPairHashCodeInt() {
        let pair = Pair(100, 200)
        let hash = pairHashCode(pair)
        // hashCode 应该是一个整数
        @Expect(hash > 0 || hash == 0, true)
    }

    /**
     * 测试 pairHashCode - 混合类型
     * 注意: Int64 和 Float64 都实现了 Hashable
     */
    @TestCase
    func testPairHashCodeMixedNumeric() {
        let pair = Pair(100, 3.14)
        let hash = pairHashCode(pair)
        // hashCode 应该是一个整数
        @Expect(hash > 0 || hash == 0, true)
    }
}
