package commons_lang4cj.test.range

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.range.CharRange
import commons_lang4cj.range.NumberRange

/**
 * CharRange 单元测试
 *
 * 测试覆盖 CharRange 类的所有公共方法
 * 测试覆盖率目标：≥ 90%
 */
@Test
class CharRangeTest {
    /**
     * 测试 CharRange.of() 方法 - 基本字符范围
     */
    @TestCase
    func testOfBasic() {
        let range = CharRange.of(r'a', r'z')

        @Expect(range.getMinimum(), r'a')
        @Expect(range.getMaximum(), r'z')
    }

    /**
     * 测试 CharRange.of() 方法 - 反向范围（自动交换）
     */
    @TestCase
    func testOfReversed() {
        let range = CharRange.of(r'z', r'a')

        @Expect(range.getMinimum(), r'a')
        @Expect(range.getMaximum(), r'z')
    }

    /**
     * 测试 CharRange.of() 方法 - 数字字符范围
     */
    @TestCase
    func testOfDigits() {
        let range = CharRange.of(r'0', r'9')

        @Expect(range.getMinimum(), r'0')
        @Expect(range.getMaximum(), r'9')
    }

    /**
     * 测试 CharRange.is() 方法 - 单字符范围
     */
    @TestCase
    func testIs() {
        let range = CharRange.`is`(r'x')

        @Expect(range.getMinimum(), r'x')
        @Expect(range.getMaximum(), r'x')
    }

    /**
     * 测试 CharRange.of() 方法 - 大写字母范围
     */
    @TestCase
    func testOfUpperCase() {
        let range = CharRange.of(r'A', r'Z')

        @Expect(range.getMinimum(), r'A')
        @Expect(range.getMaximum(), r'Z')
    }

    /**
     * 测试 CharRange.of() 方法 - 小写字母范围
     */
    @TestCase
    func testOfLowerCase() {
        let range = CharRange.of(r'a', r'z')

        @Expect(range.getMinimum(), r'a')
        @Expect(range.getMaximum(), r'z')
    }

    /**
     * 测试 CharRange.fromString() 方法 - 有效字符串
     */
    @TestCase
    func testFromString() {
        let result = CharRange.fromString("a-z")
        @Expect(match (result) { case Some(range) => range.getMinimum() == r'a' && range.getMaximum() == r'z'; case None => false }, true)
    }

    /**
     * 测试 getMinimum() 方法
     */
    @TestCase
    func testGetMinimum() {
        let range = CharRange.of(r'a', r'z')

        @Expect(range.getMinimum(), r'a')
    }

    /**
     * 测试 getMaximum() 方法
     */
    @TestCase
    func testGetMaximum() {
        let range = CharRange.of(r'a', r'z')

        @Expect(range.getMaximum(), r'z')
    }

    /**
     * 测试 getChars() 方法
     */
    @TestCase
    func testGetChars() {
        let range = CharRange.of(r'a', r'z')

        let chars = range.getChars()

        @Expect(chars.size, 26)
        @Expect(chars[0], r'a')
        @Expect(chars[25], r'z')
    }

    /**
     * 测试 toArrayList() 方法
     */
    @TestCase
    func testToArrayList() {
        let range = CharRange.of(r'a', r'z')

        let list = range.toArrayList()

        @Expect(list.size, 26)
        @Expect(list[0], r'a')
        @Expect(list[25], r'z')
    }

    /**
     * 测试 getSize() 方法
     */
    @TestCase
    func testGetSize() {
        let range = CharRange.of(r'a', r'z')

        @Expect(range.getSize(), 26)
    }

    /**
     * 测试 toString() 方法 - 小写字母范围
     */
    @TestCase
    func testToStringLowerCase() {
        let range = CharRange.of(r'a', r'z')

        @Expect(range.toString(), "CharRange[a, z]")
    }

    /**
     * 测试 toString() 方法 - 数字范围
     */
    @TestCase
    func testToStringDigits() {
        let range = CharRange.of(r'0', r'9')

        @Expect(range.toString(), "CharRange[0, 9]")
    }

    /**
     * 测试 toString() 方法 - 单字符范围
     */
    @TestCase
    func testToStringSingle() {
        let range = CharRange.`is`(r'x')

        @Expect(range.toString(), "CharRange[x, x]")
    }

    /**
     * 测试 toString() 方法 - 反向范围（自动交换后）
     */
    @TestCase
    func testToStringReversed() {
        let range = CharRange.of(r'z', r'a')

        @Expect(range.toString(), "CharRange[a, z]")
    }

    /**
     * 测试特殊字符范围
     */
    @TestCase
    func testSpecialChars() {
        let range = CharRange.of(r'!', r'*')

        @Expect(range.getMinimum(), r'!')
        @Expect(range.getMaximum(), r'*')
    }

    /**
     * 测试 Unicode 字符范围
     */
    @TestCase
    func testUnicodeChars() {
        let range = CharRange.of(r'你', r'我')

        @Expect(range.getMinimum(), r'你')
        @Expect(range.getMaximum(), r'我')
    }

    /**
     * 测试相邻字符范围
     */
    @TestCase
    func testAdjacentChars() {
        let range = CharRange.of(r'a', r'b')

        @Expect(range.getMinimum(), r'a')
        @Expect(range.getMaximum(), r'b')
    }

    /**
     * 测试边界字符 - 最小可打印 ASCII
     */
    @TestCase
    func testBoundaryMinAscii() {
        let range = CharRange.of(r' ', r'~')

        @Expect(range.getMinimum(), r' ')
        @Expect(range.getMaximum(), r'~')
    }
}
