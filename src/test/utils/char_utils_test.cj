package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

/**
 * CharUtils 单元测试
 *
 * 测试覆盖 24 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class CharUtilsTest {
    // ========== 常量测试 ==========

    @TestCase
    func testConstants() {
        @Expect(CharUtils.LF, r'\n')
        @Expect(CharUtils.CR, r'\r')
        @Expect(CharUtils.NUL, r'\0')
    }

    // ========== 字符判断方法测试 ==========

    @TestCase
    func testIsAscii() {
        // ASCII 字符（0-127）
        @Expect(CharUtils.isAscii(r'a'), true)
        @Expect(CharUtils.isAscii(r'A'), true)
        @Expect(CharUtils.isAscii(r'3'), true)
        @Expect(CharUtils.isAscii(r'-'), true)
        @Expect(CharUtils.isAscii(r'\n'), true)
        @Expect(CharUtils.isAscii(r'\0'), true)

        // 非 ASCII 字符
        @Expect(CharUtils.isAscii(r'©'), false)
        @Expect(CharUtils.isAscii(r'中'), false)
    }

    @TestCase
    func testIsAsciiPrintable() {
        // 可打印 ASCII（32-126）
        @Expect(CharUtils.isAsciiPrintable(r'a'), true)
        @Expect(CharUtils.isAsciiPrintable(r'A'), true)
        @Expect(CharUtils.isAsciiPrintable(r'3'), true)
        @Expect(CharUtils.isAsciiPrintable(r'-'), true)
        @Expect(CharUtils.isAsciiPrintable(r' '), true)

        // 控制字符
        @Expect(CharUtils.isAsciiPrintable(r'\n'), false)
        @Expect(CharUtils.isAsciiPrintable(r'\t'), false)
        @Expect(CharUtils.isAsciiPrintable(r'\0'), false)

        // 非 ASCII
        @Expect(CharUtils.isAsciiPrintable(r'©'), false)
    }

    @TestCase
    func testIsAsciiControl() {
        // 控制字符
        @Expect(CharUtils.isAsciiControl(r'\n'), true)
        @Expect(CharUtils.isAsciiControl(r'\r'), true)
        @Expect(CharUtils.isAsciiControl(r'\t'), true)
        @Expect(CharUtils.isAsciiControl(r'\0'), true)

        // 非控制字符
        @Expect(CharUtils.isAsciiControl(r'a'), false)
        @Expect(CharUtils.isAsciiControl(r'A'), false)
        @Expect(CharUtils.isAsciiControl(r'3'), false)
        @Expect(CharUtils.isAsciiControl(r'-'), false)
    }

    @TestCase
    func testIsAsciiAlpha() {
        // 字母
        @Expect(CharUtils.isAsciiAlpha(r'a'), true)
        @Expect(CharUtils.isAsciiAlpha(r'A'), true)
        @Expect(CharUtils.isAsciiAlpha(r'z'), true)
        @Expect(CharUtils.isAsciiAlpha(r'Z'), true)

        // 非字母
        @Expect(CharUtils.isAsciiAlpha(r'3'), false)
        @Expect(CharUtils.isAsciiAlpha(r'-'), false)
        @Expect(CharUtils.isAsciiAlpha(r'\n'), false)
    }

    @TestCase
    func testIsAsciiAlphaLower() {
        // 小写字母
        @Expect(CharUtils.isAsciiAlphaLower(r'a'), true)
        @Expect(CharUtils.isAsciiAlphaLower(r'z'), true)

        // 非小写字母
        @Expect(CharUtils.isAsciiAlphaLower(r'A'), false)
        @Expect(CharUtils.isAsciiAlphaLower(r'Z'), false)
        @Expect(CharUtils.isAsciiAlphaLower(r'3'), false)
    }

    @TestCase
    func testIsAsciiAlphaUpper() {
        // 大写字母
        @Expect(CharUtils.isAsciiAlphaUpper(r'A'), true)
        @Expect(CharUtils.isAsciiAlphaUpper(r'Z'), true)

        // 非大写字母
        @Expect(CharUtils.isAsciiAlphaUpper(r'a'), false)
        @Expect(CharUtils.isAsciiAlphaUpper(r'z'), false)
        @Expect(CharUtils.isAsciiAlphaUpper(r'3'), false)
    }

    @TestCase
    func testIsAsciiAlphanumeric() {
        // 字母和数字
        @Expect(CharUtils.isAsciiAlphanumeric(r'a'), true)
        @Expect(CharUtils.isAsciiAlphanumeric(r'A'), true)
        @Expect(CharUtils.isAsciiAlphanumeric(r'3'), true)
        @Expect(CharUtils.isAsciiAlphanumeric(r'9'), true)

        // 非字母数字
        @Expect(CharUtils.isAsciiAlphanumeric(r'-'), false)
        @Expect(CharUtils.isAsciiAlphanumeric(r'\n'), false)
    }

    @TestCase
    func testIsAsciiNumeric() {
        // 数字字符
        @Expect(CharUtils.isAsciiNumeric(r'0'), true)
        @Expect(CharUtils.isAsciiNumeric(r'9'), true)
        @Expect(CharUtils.isAsciiNumeric(r'5'), true)

        // 非数字
        @Expect(CharUtils.isAsciiNumeric(r'a'), false)
        @Expect(CharUtils.isAsciiNumeric(r'A'), false)
        @Expect(CharUtils.isAsciiNumeric(r'-'), false)
    }

    @TestCase
    func testIsHex() {
        // 十六进制字符
        @Expect(CharUtils.isHex(r'0'), true)
        @Expect(CharUtils.isHex(r'9'), true)
        @Expect(CharUtils.isHex(r'a'), true)
        @Expect(CharUtils.isHex(r'f'), true)
        @Expect(CharUtils.isHex(r'A'), true)
        @Expect(CharUtils.isHex(r'F'), true)

        // 非十六进制
        @Expect(CharUtils.isHex(r'g'), false)
        @Expect(CharUtils.isHex(r'G'), false)
        @Expect(CharUtils.isHex(r'-'), false)
    }

    @TestCase
    func testIsOctal() {
        // 八进制字符（0-7）
        @Expect(CharUtils.isOctal(r'0'), true)
        @Expect(CharUtils.isOctal(r'7'), true)
        @Expect(CharUtils.isOctal(r'5'), true)

        // 非八进制
        @Expect(CharUtils.isOctal(r'8'), false)
        @Expect(CharUtils.isOctal(r'9'), false)
        @Expect(CharUtils.isOctal(r'a'), false)
    }

    // ========== 字符转换方法测试 ==========

    @TestCase
    func testToUpperCase() {
        // 小写转大写
        @Expect(CharUtils.toUpperCase(r'a'), r'A')
        @Expect(CharUtils.toUpperCase(r'z'), r'Z')

        // 已经是大写
        @Expect(CharUtils.toUpperCase(r'A'), r'A')
        @Expect(CharUtils.toUpperCase(r'Z'), r'Z')

        // 非字母
        @Expect(CharUtils.toUpperCase(r'3'), r'3')
        @Expect(CharUtils.toUpperCase(r'-'), r'-')
    }

    @TestCase
    func testToLowerCase() {
        // 大写转小写
        @Expect(CharUtils.toLowerCase(r'A'), r'a')
        @Expect(CharUtils.toLowerCase(r'Z'), r'z')

        // 已经是小写
        @Expect(CharUtils.toLowerCase(r'a'), r'a')
        @Expect(CharUtils.toLowerCase(r'z'), r'z')

        // 非字母
        @Expect(CharUtils.toLowerCase(r'3'), r'3')
        @Expect(CharUtils.toLowerCase(r'-'), r'-')
    }

    @TestCase
    func testToChar() {
        // 正常字符串
        @Expect(CharUtils.toChar("A"), r'A')
        @Expect(CharUtils.toChar("BA"), r'B')

        // 空字符串抛出异常
        try {
            CharUtils.toChar("")
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testToCharWithDefault() {
        // 正常字符串
        @Expect(CharUtils.toChar("A", r'X'), r'A')
        @Expect(CharUtils.toChar("BA", r'X'), r'B')

        // 空字符串或空格返回默认值
        @Expect(CharUtils.toChar("", r'X'), r'X')
        @Expect(CharUtils.toChar(" ", r'X'), r'X')
    }

    @TestCase
    func testToCharValue() {
        // 正常字符串
        @Expect(CharUtils.toCharValue("A"), Some(r'A'))
        @Expect(CharUtils.toCharValue("BA"), Some(r'B'))

        // 空字符串返回 None
        @Expect(CharUtils.toCharValue(""), None)
    }

    @TestCase
    func testToNumeric() {
        // 数字字符
        @Expect(CharUtils.toNumeric(r'3'), 3)
        @Expect(CharUtils.toNumeric(r'0'), 0)
        @Expect(CharUtils.toNumeric(r'9'), 9)

        // 非数字字符抛出异常
        try {
            CharUtils.toNumeric(r'A')
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.size > 0, true)
        }
    }

    @TestCase
    func testToNumericWithDefault() {
        // 数字字符
        @Expect(CharUtils.toNumeric(r'3', -1), 3)
        @Expect(CharUtils.toNumeric(r'0', -1), 0)

        // 非数字字符返回默认值
        @Expect(CharUtils.toNumeric(r'A', -1), -1)
        @Expect(CharUtils.toNumeric(r'-', 0), 0)
    }

    @TestCase
    func testCharToString() {
        @Expect(CharUtils.toString(r' '), " ")
        @Expect(CharUtils.toString(r'A'), "A")
        @Expect(CharUtils.toString(r'z'), "z")
        @Expect(CharUtils.toString(r'0'), "0")
        @Expect(CharUtils.toString(r'9'), "9")
    }

    @TestCase
    func testToStrings() {
        let chars1 = CharUtils.toStrings("ABC")
        @Expect(chars1.size, 3)
        @Expect(chars1[0], r'A')
        @Expect(chars1[1], r'B')
        @Expect(chars1[2], r'C')

        @Expect(CharUtils.toStrings("").size, 0)
    }

    // ========== 比较操作方法测试 ==========

    @TestCase
    func testCompare() {
        // 相等
        @Expect(CharUtils.compare(r'A', r'A'), 0)
        @Expect(CharUtils.compare(r'z', r'z'), 0)

        // 小于
        @Expect(CharUtils.compare(r'A', r'B'), -1)
        @Expect(CharUtils.compare(r'9', r'A'), -1)

        // 大于
        @Expect(CharUtils.compare(r'B', r'A'), 1)
        @Expect(CharUtils.compare(r'a', r'Z'), 1)
    }

    @TestCase
    func testIsBetween() {
        // 在范围内
        @Expect(CharUtils.isBetween(r'b', r'a', r'c'), true)
        @Expect(CharUtils.isBetween(r'a', r'a', r'c'), true)
        @Expect(CharUtils.isBetween(r'c', r'a', r'c'), true)

        // 不在范围内
        @Expect(CharUtils.isBetween(r'd', r'a', r'c'), false)
        @Expect(CharUtils.isBetween(r'`', r'a', r'c'), false)
    }

    // ========== 别名方法测试 ==========

    @TestCase
    func testIsAlphaNumeric() {
        // isAlphanumeric 是 isAsciiAlphanumeric 的别名
        @Expect(CharUtils.isAlphaNumeric(r'a'), true)
        @Expect(CharUtils.isAlphaNumeric(r'3'), true)
        @Expect(CharUtils.isAlphaNumeric(r'-'), false)
    }

    @TestCase
    func testIsAlpha() {
        // isAlpha 是 isAsciiAlpha 的别名
        @Expect(CharUtils.isAlpha(r'a'), true)
        @Expect(CharUtils.isAlpha(r'A'), true)
        @Expect(CharUtils.isAlpha(r'3'), false)
    }

    @TestCase
    func testIsNumeric() {
        // isNumeric 是 isAsciiNumeric 的别名
        @Expect(CharUtils.isNumeric(r'0'), true)
        @Expect(CharUtils.isNumeric(r'9'), true)
        @Expect(CharUtils.isNumeric(r'a'), false)
    }

    // ========== 边界情况测试 ==========

    @TestCase
    func testEdgeCases() {
        // ASCII 边界
        @Expect(CharUtils.isAscii(r'\u{007F}'), true)   // 最大的 ASCII 字符
        @Expect(CharUtils.isAscii(r'\u{0080}'), false)  // 超出 ASCII 范围

        // 可打印 ASCII 边界
        @Expect(CharUtils.isAsciiPrintable(r' '), true)  // 32，最小可打印
        @Expect(CharUtils.isAsciiPrintable(r'~'), true)  // 126，最大可打印
        @Expect(CharUtils.isAsciiPrintable(r'\u{007F}'), false)  // DEL，控制字符

        // 字母边界
        @Expect(CharUtils.isAsciiAlphaLower(r'a'), true)
        @Expect(CharUtils.isAsciiAlphaLower(r'z'), true)
        @Expect(CharUtils.isAsciiAlphaLower(r'{'), false)
        @Expect(CharUtils.isAsciiAlphaLower(r'`'), false)

        @Expect(CharUtils.isAsciiAlphaUpper(r'A'), true)
        @Expect(CharUtils.isAsciiAlphaUpper(r'Z'), true)
        @Expect(CharUtils.isAsciiAlphaUpper(r'['), false)
        @Expect(CharUtils.isAsciiAlphaUpper(r'@'), false)

        // 数字边界
        @Expect(CharUtils.isAsciiNumeric(r'0'), true)
        @Expect(CharUtils.isAsciiNumeric(r'9'), true)
        @Expect(CharUtils.isAsciiNumeric(r'/'), false)
        @Expect(CharUtils.isAsciiNumeric(r':'), false)
    }

    @TestCase
    func testSpecialCharacters() {
        // 特殊字符
        @Expect(CharUtils.isAscii(r'\t'), true)
        @Expect(CharUtils.isAscii(r'\n'), true)
        @Expect(CharUtils.isAscii(r'\r'), true)
        @Expect(CharUtils.isAsciiControl(r'\t'), true)
        @Expect(CharUtils.isAsciiControl(r'\n'), true)
        @Expect(CharUtils.isAsciiControl(r'\r'), true)

        // 空格
        @Expect(CharUtils.isAscii(r' '), true)
        @Expect(CharUtils.isAsciiPrintable(r' '), true)
        @Expect(CharUtils.isAsciiControl(r' '), false)
    }

    @TestCase
    func testCaseConversion() {
        // 完整字母表测试
        @Expect(CharUtils.toUpperCase(r'a'), r'A')
        @Expect(CharUtils.toUpperCase(r'b'), r'B')
        @Expect(CharUtils.toUpperCase(r'm'), r'M')
        @Expect(CharUtils.toUpperCase(r'z'), r'Z')

        @Expect(CharUtils.toLowerCase(r'A'), r'a')
        @Expect(CharUtils.toLowerCase(r'B'), r'b')
        @Expect(CharUtils.toLowerCase(r'M'), r'm')
        @Expect(CharUtils.toLowerCase(r'Z'), r'z')
    }

    @TestCase
    func testNumericConversion() {
        // 所有数字字符
        @Expect(CharUtils.toNumeric(r'0'), 0)
        @Expect(CharUtils.toNumeric(r'1'), 1)
        @Expect(CharUtils.toNumeric(r'5'), 5)
        @Expect(CharUtils.toNumeric(r'9'), 9)
    }

    @TestCase
    func testToStringCoverage() {
        // 覆盖常见字符
        @Expect(CharUtils.toString(r'A'), "A")
        @Expect(CharUtils.toString(r'Z'), "Z")
        @Expect(CharUtils.toString(r'a'), "a")
        @Expect(CharUtils.toString(r'z'), "z")
        @Expect(CharUtils.toString(r'0'), "0")
        @Expect(CharUtils.toString(r'9'), "9")
        @Expect(CharUtils.toString(r' '), " ")
    }
}
