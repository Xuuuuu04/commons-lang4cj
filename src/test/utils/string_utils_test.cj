package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

/**
 * StringUtils 单元测试类
 *
 * 测试覆盖所有 46 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class StringUtilsTest {
    // ========== Phase 1: 空值检查测试 ==========

    @TestCase
    func testIsEmpty() {
        // 空字符串
        @Expect(StringUtils.isEmpty(""), true)

        // 非空字符串
        @Expect(StringUtils.isEmpty("a"), false)
        @Expect(StringUtils.isEmpty("hello"), false)

        // 只有空格的字符串不算空
        @Expect(StringUtils.isEmpty(" "), false)
        @Expect(StringUtils.isEmpty("  "), false)
        @Expect(StringUtils.isEmpty("  hello  "), false)
    }

    @TestCase
    func testIsNotEmpty() {
        // 空字符串
        @Expect(StringUtils.isNotEmpty(""), false)

        // 非空字符串
        @Expect(StringUtils.isNotEmpty("a"), true)
        @Expect(StringUtils.isNotEmpty("hello"), true)
        @Expect(StringUtils.isNotEmpty(" "), true)
        @Expect(StringUtils.isNotEmpty("  "), true)
    }

    @TestCase
    func testIsBlank() {
        // 空字符串
        @Expect(StringUtils.isBlank(""), true)

        // 只有空白字符
        @Expect(StringUtils.isBlank(" "), true)
        @Expect(StringUtils.isBlank("  "), true)
        @Expect(StringUtils.isBlank("\t"), true)
        @Expect(StringUtils.isBlank("\n"), true)
        @Expect(StringUtils.isBlank("\r"), true)
        @Expect(StringUtils.isBlank("  \t\n  "), true)

        // 有非空白字符
        @Expect(StringUtils.isBlank("a"), false)
        @Expect(StringUtils.isBlank(" hello "), false)
        @Expect(StringUtils.isBlank("hello"), false)
    }

    @TestCase
    func testIsNotBlank() {
        // 空字符串和空白字符串
        @Expect(StringUtils.isNotBlank(""), false)
        @Expect(StringUtils.isNotBlank(" "), false)
        @Expect(StringUtils.isNotBlank("\t\n"), false)

        // 有内容
        @Expect(StringUtils.isNotBlank("a"), true)
        @Expect(StringUtils.isNotBlank(" hello "), true)
        @Expect(StringUtils.isNotBlank("hello"), true)
    }

    // ========== Phase 2: 截取与分割测试 ==========

    @TestCase
    func testTrim() {
        // 去除首尾空格
        @Expect(StringUtils.trim("  hello  "), "hello")
        @Expect(StringUtils.trim("\thello\n"), "hello")
        @Expect(StringUtils.trim("hello"), "hello")

        // 全是空白
        @Expect(StringUtils.trim("  "), "")
        @Expect(StringUtils.trim("\t\n"), "")

        // 空字符串
        @Expect(StringUtils.trim(""), "")

        // 单侧空白
        @Expect(StringUtils.trim("  hello"), "hello")
        @Expect(StringUtils.trim("hello  "), "hello")
    }

    @TestCase
    func testSplit() {
        // 基本分割
        let result1 = StringUtils.split("a,b,c", ",")
        @Expect(result1.size, 3)
        @Expect(result1[0], "a")
        @Expect(result1[1], "b")
        @Expect(result1[2], "c")

        // 空元素
        let result2 = StringUtils.split("a,,b", ",")
        @Expect(result2.size, 3)
        @Expect(result2[1], "")

        // 空字符串
        let result3 = StringUtils.split("", ",")
        @Expect(result3.size, 1)
        @Expect(result3[0], "")

        // 无分隔符
        let result4 = StringUtils.split("hello", ",")
        @Expect(result4.size, 1)
        @Expect(result4[0], "hello")
    }

    @TestCase
    func testJoin() {
        // 基本连接
        @Expect(StringUtils.join(["a", "b", "c"], ","), "a,b,c")

        // 单个元素
        @Expect(StringUtils.join(["a"], ","), "a")

        // 空数组
        @Expect(StringUtils.join([], ","), "")

        // 不同分隔符
        @Expect(StringUtils.join(["a", "b"], "-"), "a-b")
        @Expect(StringUtils.join(["a", "b"], " "), "a b")
    }

    // ========== Phase 3: 大小写转换测试 ==========

    @TestCase
    func testUpperCase() {
        // 基本转换
        @Expect(StringUtils.upperCase("hello"), "HELLO")
        @Expect(StringUtils.upperCase("HELLO"), "HELLO")
        @Expect(StringUtils.upperCase("HeLLo"), "HELLO")

        // 空字符串
        @Expect(StringUtils.upperCase(""), "")

        // 数字和特殊字符
        @Expect(StringUtils.upperCase("123"), "123")
        @Expect(StringUtils.upperCase("hello123"), "HELLO123")
        @Expect(StringUtils.upperCase("hello-world"), "HELLO-WORLD")
    }

    @TestCase
    func testLowerCase() {
        // 基本转换
        @Expect(StringUtils.lowerCase("HELLO"), "hello")
        @Expect(StringUtils.lowerCase("hello"), "hello")
        @Expect(StringUtils.lowerCase("HeLLo"), "hello")

        // 空字符串
        @Expect(StringUtils.lowerCase(""), "")

        // 数字和特殊字符
        @Expect(StringUtils.lowerCase("123"), "123")
        @Expect(StringUtils.lowerCase("HELLO123"), "hello123")
        @Expect(StringUtils.lowerCase("HELLO-WORLD"), "hello-world")
    }

    @TestCase
    func testCapitalize() {
        // 基本转换
        @Expect(StringUtils.capitalize("hello"), "Hello")
        @Expect(StringUtils.capitalize("HELLO"), "HELLO")
        @Expect(StringUtils.capitalize("hELLO"), "HELLO")

        // 空字符串和单字符
        @Expect(StringUtils.capitalize(""), "")
        @Expect(StringUtils.capitalize("a"), "A")
        @Expect(StringUtils.capitalize("A"), "A")

        // 已大写
        @Expect(StringUtils.capitalize("Hello"), "Hello")

        // 空格开头
        @Expect(StringUtils.capitalize(" hello"), " hello")
    }

    @TestCase
    func testUncapitalize() {
        // 基本转换
        @Expect(StringUtils.uncapitalize("Hello"), "hello")
        @Expect(StringUtils.uncapitalize("HELLO"), "hELLO")
        @Expect(StringUtils.uncapitalize("hello"), "hello")

        // 空字符串和单字符
        @Expect(StringUtils.uncapitalize(""), "")
        @Expect(StringUtils.uncapitalize("A"), "a")
        @Expect(StringUtils.uncapitalize("a"), "a")

        // 已小写
        @Expect(StringUtils.uncapitalize("hello"), "hello")
    }

    @TestCase
    func testSwapCase() {
        // 基本转换
        @Expect(StringUtils.swapCase("Hello"), "hELLO")
        @Expect(StringUtils.swapCase("HELLO"), "hello")
        @Expect(StringUtils.swapCase("hello"), "HELLO")

        // 空字符串
        @Expect(StringUtils.swapCase(""), "")

        // 混合
        @Expect(StringUtils.swapCase("HeLLo WoRLd"), "hEllO wOrlD")

        // 数字和特殊字符不变
        @Expect(StringUtils.swapCase("hello123"), "HELLO123")
        @Expect(StringUtils.swapCase("hello-world"), "HELLO-WORLD")
    }

    // ========== Phase 4: 查询与比较测试 ==========

    @TestCase
    func testEquals() {
        // 相等
        @Expect(StringUtils.equals("hello", "hello"), true)
        @Expect(StringUtils.equals("", ""), true)

        // 不相等
        @Expect(StringUtils.equals("hello", "HELLO"), false)
        @Expect(StringUtils.equals("hello", "world"), false)
        @Expect(StringUtils.equals("", "hello"), false)
    }

    @TestCase
    func testCompare() {
        // 小于
        @Expect(StringUtils.compare("a", "b") < 0, true)
        @Expect(StringUtils.compare("A", "a") < 0, true)

        // 大于
        @Expect(StringUtils.compare("b", "a") > 0, true)
        @Expect(StringUtils.compare("a", "A") > 0, true)

        // 相等
        @Expect(StringUtils.compare("a", "a"), 0)
        @Expect(StringUtils.compare("", ""), 0)
    }

    @TestCase
    func testContains() {
        // 包含
        @Expect(StringUtils.contains("hello", "ell"), true)
        @Expect(StringUtils.contains("hello", "hello"), true)
        @Expect(StringUtils.contains("hello", ""), true)

        // 不包含
        @Expect(StringUtils.contains("hello", "abc"), false)
        @Expect(StringUtils.contains("hello", "xyz"), false)
        @Expect(StringUtils.contains("", "a"), false)
    }

    @TestCase
    func testStartsWith() {
        // 匹配
        @Expect(StringUtils.startsWith("hello", "hel"), true)
        @Expect(StringUtils.startsWith("hello", "h"), true)
        @Expect(StringUtils.startsWith("hello", "hello"), true)
        @Expect(StringUtils.startsWith("", ""), true)

        // 不匹配
        @Expect(StringUtils.startsWith("hello", "ell"), false)
        @Expect(StringUtils.startsWith("hello", "world"), false)
        @Expect(StringUtils.startsWith("hello", "hello world"), false)
    }

    @TestCase
    func testEndsWith() {
        // 匹配
        @Expect(StringUtils.endsWith("hello", "llo"), true)
        @Expect(StringUtils.endsWith("hello", "o"), true)
        @Expect(StringUtils.endsWith("hello", "hello"), true)
        @Expect(StringUtils.endsWith("", ""), true)

        // 不匹配
        @Expect(StringUtils.endsWith("hello", "ell"), false)
        @Expect(StringUtils.endsWith("hello", "world"), false)
        @Expect(StringUtils.endsWith("hello", "hello world"), false)
    }

    @TestCase
    func testIndexOf() {
        // 找到
        @Expect(StringUtils.indexOf("hello", "ell"), 1)
        @Expect(StringUtils.indexOf("hello", "h"), 0)
        @Expect(StringUtils.indexOf("hello", "o"), 4)
        @Expect(StringUtils.indexOf("hello", ""), 0)

        // 未找到
        @Expect(StringUtils.indexOf("hello", "abc"), StringUtils.INDEX_NOT_FOUND)
        @Expect(StringUtils.indexOf("", "a"), StringUtils.INDEX_NOT_FOUND)
    }

    @TestCase
    func testLastIndexOf() {
        // 找到
        @Expect(StringUtils.lastIndexOf("hello hello", "ell"), 7)
        @Expect(StringUtils.lastIndexOf("hello", "l"), 3)
        @Expect(StringUtils.lastIndexOf("hello", ""), 5)

        // 未找到
        @Expect(StringUtils.lastIndexOf("hello", "abc"), StringUtils.INDEX_NOT_FOUND)
        @Expect(StringUtils.lastIndexOf("", "a"), StringUtils.INDEX_NOT_FOUND)
    }

    // ========== Phase 5: 替换与删除测试 ==========

    @TestCase
    func testReplace() {
        // 基本替换
        @Expect(StringUtils.replace("hello", "l", "x"), "hexxo")
        @Expect(StringUtils.replace("hello", "ell", "abc"), "habco")

        // 未找到
        @Expect(StringUtils.replace("hello", "xyz", "abc"), "hello")

        // 多次替换
        @Expect(StringUtils.replace("hello", "l", ""), "heo")

        // 空字符串
        @Expect(StringUtils.replace("", "a", "b"), "")
        @Expect(StringUtils.replace("hello", "", "x"), "hello")
    }

    @TestCase
    func testReplaceOnce() {
        // 基本替换
        @Expect(StringUtils.replaceOnce("hello", "l", "x"), "hexlo")
        @Expect(StringUtils.replaceOnce("hello", "ell", "abc"), "habco")

        // 未找到
        @Expect(StringUtils.replaceOnce("hello", "xyz", "abc"), "hello")

        // 只替换第一个
        @Expect(StringUtils.replaceOnce("hello", "l", ""), "helo")
    }

    @TestCase
    func testRemove() {
        // 基本删除
        @Expect(StringUtils.remove("hello", "l"), "heo")
        @Expect(StringUtils.remove("hello", "ell"), "ho")

        // 未找到
        @Expect(StringUtils.remove("hello", "xyz"), "hello")

        // 删除所有
        @Expect(StringUtils.remove("aaa", "a"), "")
    }

    // ========== Phase 6: 填充与对齐测试 ==========

    @TestCase
    func testLeftPad() {
        // 基本填充（使用空格）
        @Expect(StringUtils.leftPad("hello", 10), "     hello")

        // 不需要填充
        @Expect(StringUtils.leftPad("hello", 3), "hello")
        @Expect(StringUtils.leftPad("hello", 5), "hello")

        // 空字符串
        @Expect(StringUtils.leftPad("", 5), "     ")

        // 使用自定义字符
        @Expect(StringUtils.leftPad("hello", 10, r'*'), "*****hello")
        @Expect(StringUtils.leftPad("hello", 10, r'0'), "00000hello")
    }

    @TestCase
    func testRightPad() {
        // 基本填充（使用空格）
        @Expect(StringUtils.rightPad("hello", 10), "hello     ")

        // 不需要填充
        @Expect(StringUtils.rightPad("hello", 3), "hello")
        @Expect(StringUtils.rightPad("hello", 5), "hello")

        // 空字符串
        @Expect(StringUtils.rightPad("", 5), "     ")

        // 使用自定义字符
        @Expect(StringUtils.rightPad("hello", 10, r'*'), "hello*****")
        @Expect(StringUtils.rightPad("hello", 10, r'0'), "hello00000")
    }

    @TestCase
    func testCenter() {
        // 基本居中
        // hello(5) -> size 11 -> pad 6 -> left 3, right 3 -> "   hello   "
        @Expect(StringUtils.center("hello", 11), "   hello   ")
        // hello(5) -> size 10 -> pad 5 -> left 2, right 3 -> "  hello   "
        @Expect(StringUtils.center("hello", 10), "  hello   ")

        // 不需要填充
        @Expect(StringUtils.center("hello", 3), "hello")

        // 空字符串
        @Expect(StringUtils.center("", 5), "     ")
    }

    @TestCase
    func testRepeat() {
        // 基本重复
        @Expect(StringUtils.repeat("a", 3), "aaa")
        @Expect(StringUtils.repeat("ab", 2), "abab")

        // 边界情况
        @Expect(StringUtils.repeat("a", 0), "")
        @Expect(StringUtils.repeat("", 3), "")
        @Expect(StringUtils.repeat("a", 1), "a")
    }

    // ========== Phase 7: 截取测试 ==========

    @TestCase
    func testSubstringOneParam() {
        // 基本截取
        @Expect(StringUtils.substring("hello", 2), "llo")
        @Expect(StringUtils.substring("hello", 0), "hello")

        // 边界情况
        @Expect(StringUtils.substring("hello", 5), "")
        @Expect(StringUtils.substring("hello", 10), "")
    }

    @TestCase
    func testSubstringTwoParams() {
        // 基本截取
        @Expect(StringUtils.substring("hello", 1, 4), "ell")
        @Expect(StringUtils.substring("hello", 0, 5), "hello")

        // 边界情况
        @Expect(StringUtils.substring("hello", 2, 2), "")
        @Expect(StringUtils.substring("hello", 2, 10), "llo")
    }

    @TestCase
    func testLeft() {
        // 基本截取
        @Expect(StringUtils.left("hello", 2), "he")
        @Expect(StringUtils.left("hello", 3), "hel")

        // 边界情况
        @Expect(StringUtils.left("hello", 0), "")
        @Expect(StringUtils.left("hello", 10), "hello")
        @Expect(StringUtils.left("", 5), "")
    }

    @TestCase
    func testRight() {
        // 基本截取
        @Expect(StringUtils.right("hello", 2), "lo")
        @Expect(StringUtils.right("hello", 3), "llo")

        // 边界情况
        @Expect(StringUtils.right("hello", 0), "")
        @Expect(StringUtils.right("hello", 10), "hello")
        @Expect(StringUtils.right("", 5), "")
    }

    @TestCase
    func testMid() {
        // 基本截取
        @Expect(StringUtils.mid("hello", 1, 2), "el")
        @Expect(StringUtils.mid("hello", 0, 5), "hello")

        // 超出长度
        @Expect(StringUtils.mid("hello", 2, 10), "llo")

        // 边界情况
        @Expect(StringUtils.mid("hello", -1, 2), "")
        @Expect(StringUtils.mid("hello", 10, 2), "")
    }

    // ========== Phase 8: 反转测试 ==========

    @TestCase
    func testReverse() {
        // 基本反转
        @Expect(StringUtils.reverse("hello"), "olleh")

        // 边界情况
        @Expect(StringUtils.reverse(""), "")
        @Expect(StringUtils.reverse("a"), "a")
        @Expect(StringUtils.reverse("ab"), "ba")
    }

    @TestCase
    func testReverseDelimited() {
        // 基本反转
        @Expect(StringUtils.reverseDelimited("a.b.c", "."), "c.b.a")
        @Expect(StringUtils.reverseDelimited("a-b-c", "-"), "c-b-a")

        // 无分隔符
        @Expect(StringUtils.reverseDelimited("hello", "."), "hello")

        // 空字符串
        @Expect(StringUtils.reverseDelimited("", "."), "")
    }

    // ========== Phase 9: 其他实用方法测试 ==========

    @TestCase
    func testCountMatches() {
        // 基本统计
        @Expect(StringUtils.countMatches("hello", "l"), 2)
        @Expect(StringUtils.countMatches("hello", "ll"), 1)

        // 未找到
        @Expect(StringUtils.countMatches("hello", "x"), 0)

        // 空字符串
        @Expect(StringUtils.countMatches("", "a"), 0)
        @Expect(StringUtils.countMatches("hello", ""), 0)
    }

    @TestCase
    func testLeftTrim() {
        // 基本去除
        @Expect(StringUtils.leftTrim("  hello"), "hello")
        @Expect(StringUtils.leftTrim("hello  "), "hello  ")

        // 特殊空白字符
        @Expect(StringUtils.leftTrim("\thello"), "hello")
        @Expect(StringUtils.leftTrim("\nhello"), "hello")

        // 空字符串
        @Expect(StringUtils.leftTrim(""), "")
        @Expect(StringUtils.leftTrim("  "), "")
    }

    @TestCase
    func testRightTrim() {
        // 基本去除
        @Expect(StringUtils.rightTrim("hello  "), "hello")
        @Expect(StringUtils.rightTrim("  hello"), "  hello")

        // 特殊空白字符
        @Expect(StringUtils.rightTrim("hello\t"), "hello")
        @Expect(StringUtils.rightTrim("hello\n"), "hello")

        // 空字符串
        @Expect(StringUtils.rightTrim(""), "")
        @Expect(StringUtils.rightTrim("  "), "")
    }

    @TestCase
    func testSubstringBefore() {
        // 基本截取
        @Expect(StringUtils.substringBefore("hello@world", "@"), "hello")

        // 未找到分隔符
        @Expect(StringUtils.substringBefore("hello", "@"), "hello")

        // 在开头
        @Expect(StringUtils.substringBefore("@world", "@"), "")

        // 空字符串
        @Expect(StringUtils.substringBefore("", "@"), "")
    }

    @TestCase
    func testSubstringAfter() {
        // 基本截取
        @Expect(StringUtils.substringAfter("hello@world", "@"), "world")

        // 未找到分隔符
        @Expect(StringUtils.substringAfter("hello", "@"), "")

        // 在开头
        @Expect(StringUtils.substringAfter("@world", "@"), "world")

        // 空字符串
        @Expect(StringUtils.substringAfter("", "@"), "")
    }

    @TestCase
    func testSubstringBetweenTwoTags() {
        // 基本截取
        @Expect(StringUtils.substringBetween("hello[world]", "[", "]"), "world")

        // 未找到
        @Expect(StringUtils.substringBetween("hello", "[", "]"), "")

        // 在开头和结尾
        @Expect(StringUtils.substringBetween("[hello]", "[", "]"), "hello")

        // 空字符串
        @Expect(StringUtils.substringBetween("", "[", "]"), "")
    }

    @TestCase
    func testSubstringBetweenOneTag() {
        // 基本截取
        @Expect(StringUtils.substringBetween("hello'world'", "'"), "world")

        // 未找到
        @Expect(StringUtils.substringBetween("hello", "'"), "")

        // 在开头和结尾
        @Expect(StringUtils.substringBetween("'hello'", "'"), "hello")
    }

    @TestCase
    func testIsAlpha() {
        // 纯字母
        @Expect(StringUtils.isAlpha("abc"), true)
        @Expect(StringUtils.isAlpha("ABC"), true)
        @Expect(StringUtils.isAlpha("AbCd"), true)

        // 非纯字母
        @Expect(StringUtils.isAlpha("abc123"), false)
        @Expect(StringUtils.isAlpha("123"), false)
        @Expect(StringUtils.isAlpha(""), false)
        @Expect(StringUtils.isAlpha("abc def"), false)
    }

    @TestCase
    func testIsNumeric() {
        // 纯数字
        @Expect(StringUtils.isNumeric("123"), true)
        @Expect(StringUtils.isNumeric("0"), true)

        // 非纯数字
        @Expect(StringUtils.isNumeric("123abc"), false)
        @Expect(StringUtils.isNumeric("abc"), false)
        @Expect(StringUtils.isNumeric(""), false)
        @Expect(StringUtils.isNumeric("12.3"), false)
    }

    @TestCase
    func testIsAlphanumeric() {
        // 字母和数字组合
        @Expect(StringUtils.isAlphanumeric("abc123"), true)
        @Expect(StringUtils.isAlphanumeric("123abc"), true)
        @Expect(StringUtils.isAlphanumeric("abc"), true)
        @Expect(StringUtils.isAlphanumeric("123"), true)

        // 非字母数字
        @Expect(StringUtils.isAlphanumeric("abc-123"), false)
        @Expect(StringUtils.isAlphanumeric(""), false)
        @Expect(StringUtils.isAlphanumeric("abc 123"), false)
    }

    // ========== Phase 12: 缩略与旋转测试 ==========

    @TestCase
    func testAbbreviate() {
        // 基本缩略
        @Expect(StringUtils.abbreviate("abcdefg", 6), "abc...")
        @Expect(StringUtils.abbreviate("abcdefg", 7), "abcdefg")
        @Expect(StringUtils.abbreviate("abcdefg", 8), "abcdefg")
        @Expect(StringUtils.abbreviate("abcdefg", 4), "a...")

        // 边界测试
        // width = 4 (min allowed)
        @Expect(StringUtils.abbreviate("abcdefg", 4), "a...")

        // width = length (must be >= 4)
        @Expect(StringUtils.abbreviate("abcd", 4), "abcd")

        // width > length
        @Expect(StringUtils.abbreviate("abc", 10), "abc")

        // 空字符串
        @Expect(StringUtils.abbreviate("", 4), "")

        // 异常情况
        @ExpectThrows[IllegalArgumentException](StringUtils.abbreviate("abc", 3))
    }

    @TestCase
    func testAbbreviateExtended() {
        let str = "abcdefghij" // length 10

        // maxWidth = 4
        @Expect(StringUtils.abbreviate(str, 4), "a...")

        // maxWidth = 5
        @Expect(StringUtils.abbreviate(str, 5), "ab...")

        // maxWidth = length
        @Expect(StringUtils.abbreviate(str, 10), str)

        // maxWidth > length
        @Expect(StringUtils.abbreviate(str, 100), str)

        // maxWidth just enough for ellipsis
        // If str is "abc", len 3, maxWidth 4 -> "abc" (since len <= maxWidth)
        @Expect(StringUtils.abbreviate("abc", 4), "abc")
    }

    @TestCase
    func testRotate() {
        // 右移
        @Expect(StringUtils.rotate("abcdefg", 2), "fgabcde")
        @Expect(StringUtils.rotate("abcdefg", 7), "abcdefg")
        @Expect(StringUtils.rotate("abcdefg", 9), "fgabcde")

        // 左移
        @Expect(StringUtils.rotate("abcdefg", -2), "cdefgab")
        @Expect(StringUtils.rotate("abcdefg", -7), "abcdefg")
        @Expect(StringUtils.rotate("abcdefg", -9), "cdefgab")

        // 不移
        @Expect(StringUtils.rotate("abcdefg", 0), "abcdefg")
        @Expect(StringUtils.rotate("", 2), "")

        // Unicode 支持
        @Expect(StringUtils.rotate("你好世界", 1), "界你好世")

        // Emoji 测试
        let emojiStr = "AB😊CD"
        // Rotate 1 -> "DAB😊C"
        @Expect(StringUtils.rotate(emojiStr, 1), "DAB😊C")
        // Rotate 2 -> "CDAB😊"
        @Expect(StringUtils.rotate(emojiStr, 2), "CDAB😊")
    }

    @TestCase
    func testRotateExtended() {
        let str = "abcdefg"

        // 1. Shift > length
        @Expect(StringUtils.rotate(str, 8), "gabcdef") // 8 % 7 = 1
        @Expect(StringUtils.rotate(str, 14), "abcdefg") // 14 % 7 = 0

        // 2. Shift negative large
        @Expect(StringUtils.rotate(str, -8), "bcdefga") // -8 % 7 = -1 -> left 1

        // 3. Empty string
        @Expect(StringUtils.rotate("", 5), "")

        // 4. Shift = 0
        @Expect(StringUtils.rotate(str, 0), "abcdefg")

        // 5. Shift = length
        @Expect(StringUtils.rotate(str, 7), "abcdefg")

        // 6. Single char
        @Expect(StringUtils.rotate("a", 100), "a")
    }

    // ========== 常量测试 ==========

    @TestCase
    func testConstants() {
        @Expect(StringUtils.EMPTY, "")
        @Expect(StringUtils.INDEX_NOT_FOUND, -1)
    }
}
