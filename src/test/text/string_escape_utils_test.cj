package commons_lang4cj.test.text

import commons_lang4cj.text.*
import std.unittest.*
import std.unittest.testmacro.*

/**
 * StringEscapeUtils 测试类
 * 测试字符串转义和反转义功能
 */
@Test
class StringEscapeUtilsTest {

    // ==================== HTML 测试（6 个）====================

    @TestCase
    func testEscapeHtmlBasic() {
        let input = "<div>Hello</div>"
        let result = StringEscapeUtils.escapeHtml(input)
        @Expect(result.contains("&lt;"), true)
        @Expect(result.contains("&gt;"), true)
        @Expect(result.contains("<"), false)
        @Expect(result.contains(">"), false)
    }

    @TestCase
    func testEscapeHtmlQuotes() {
        let input = "\"quoted\" and 'single'"
        let result = StringEscapeUtils.escapeHtml(input)
        @Expect(result.contains("&quot;"), true)
        @Expect(result.contains("&apos;"), true)
    }

    @TestCase
    func testEscapeHtmlAmpersand() {
        let input = "Tom & Jerry"
        let result = StringEscapeUtils.escapeHtml(input)
        @Expect(result, "Tom &amp; Jerry")
    }

    @TestCase
    func testUnescapeHtml() {
        let input = "&lt;div&gt;"
        let result = StringEscapeUtils.unescapeHtml(input)
        @Expect(result, "<div>")
    }

    @TestCase
    func testUnescapeHtmlNumericEntity() {
        let input = "&#65;"
        let result = StringEscapeUtils.unescapeHtml(input)
        @Expect(result, "A")
    }

    @TestCase
    func testUnescapeHtmlHexEntity() {
        let input = "&#x41;"
        let result = StringEscapeUtils.unescapeHtml(input)
        @Expect(result, "A")
    }

    // ==================== XML 测试（4 个）====================

    @TestCase
    func testEscapeXml() {
        let input = "<tag>content</tag>"
        let result = StringEscapeUtils.escapeXml(input)
        @Expect(result.contains("&lt;"), true)
        @Expect(result.contains("&gt;"), true)
    }

    @TestCase
    func testEscapeXmlAll() {
        let input = "<tag attr=\"value\">'content' & more</tag>"
        let result = StringEscapeUtils.escapeXml(input)
        @Expect(result.contains("&lt;"), true)
        @Expect(result.contains("&gt;"), true)
        @Expect(result.contains("&quot;"), true)
        @Expect(result.contains("&apos;"), true)
        @Expect(result.contains("&amp;"), true)
    }

    @TestCase
    func testUnescapeXml() {
        let input = "&lt;tag&gt;&lt;/tag&gt;"
        let result = StringEscapeUtils.unescapeXml(input)
        @Expect(result, "<tag></tag>")
    }

    @TestCase
    func testUnescapeXmlApos() {
        let input = "&apos;quoted&apos;"
        let result = StringEscapeUtils.unescapeXml(input)
        @Expect(result, "'quoted'")
    }

    // ==================== JSON 测试（4 个）====================

    @TestCase
    func testEscapeJson() {
        let input = "{\"name\": \"value\"}"
        let result = StringEscapeUtils.escapeJson(input)
        @Expect(result.contains("\\\""), true)
    }

    @TestCase
    func testEscapeJsonQuotes() {
        let input = "\"quoted\""
        let result = StringEscapeUtils.escapeJson(input)
        @Expect(result, "\\\"quoted\\\"")
    }

    @TestCase
    func testUnescapeJson() {
        let input = "\\\"quoted\\\""
        let result = StringEscapeUtils.unescapeJson(input)
        @Expect(result, "\"quoted\"")
    }

    @TestCase
    func testUnescapeJsonUnicode() {
        let input = "\\u0041"
        let result = StringEscapeUtils.unescapeJson(input)
        @Expect(result, "A")
    }

    // ==================== Java 测试（4 个）====================

    @TestCase
    func testEscapeJava() {
        let input = "\t\n\r"
        let result = StringEscapeUtils.escapeJava(input)
        @Expect(result.contains("\\t"), true)
        @Expect(result.contains("\\n"), true)
        @Expect(result.contains("\\r"), true)
    }

    @TestCase
    func testEscapeNewline() {
        let input = "line1\nline2"
        let result = StringEscapeUtils.escapeJava(input)
        @Expect(result, "line1\\nline2")
    }

    @TestCase
    func testUnescapeJava() {
        let input = "line1\\nline2"
        let result = StringEscapeUtils.unescapeJava(input)
        @Expect(result.contains("\n"), true)
    }

    @TestCase
    func testUnescapeJavaMixed() {
        let input = "\\t\\n\\r"
        let result = StringEscapeUtils.unescapeJava(input)
        @Expect(result, "\t\n\r")
    }

    // ==================== CSV 测试（4 个）====================

    @TestCase
    func testEscapeCsvWithComma() {
        let input = "value,with,commas"
        let result = StringEscapeUtils.escapeCsv(input)
        @Expect(result.startsWith("\""), true)
        @Expect(result.endsWith("\""), true)
    }

    @TestCase
    func testEscapeCsvWithQuote() {
        let input = "value\"with\"quotes"
        let result = StringEscapeUtils.escapeCsv(input)
        @Expect(result.contains("\"\""), true)
    }

    @TestCase
    func testEscapeCsvWithNewline() {
        let input = "value\nwith\nnewlines"
        let result = StringEscapeUtils.escapeCsv(input)
        @Expect(result.startsWith("\""), true)
        @Expect(result.endsWith("\""), true)
    }

    @TestCase
    func testUnescapeCsv() {
        let input = "\"value,with,commas\""
        let result = StringEscapeUtils.unescapeCsv(input)
        @Expect(result.contains(","), true)
        @Expect(result.startsWith("v"), true)
        @Expect(result.endsWith("s"), true)
    }

    // ==================== 边界测试（8 个）====================

    @TestCase
    func testEscapeEmpty() {
        let input = ""
        let result = StringEscapeUtils.escapeHtml(input)
        @Expect(result, "")
    }

    @TestCase
    func testUnescapeEmpty() {
        let input = ""
        let result = StringEscapeUtils.unescapeHtml(input)
        @Expect(result, "")
    }

    @TestCase
    func testEscapeNull() {
        // 测试空字符串
        let result = StringEscapeUtils.escapeHtml("")
        @Expect(result, "")
    }

    @TestCase
    func testUnescapeMultiple() {
        let input = "&lt;&amp;&gt;"
        let result = StringEscapeUtils.unescapeHtml(input)
        @Expect(result, "<&>")
    }

    @TestCase
    func testEscapeChinese() {
        let input = "中文测试"
        let result = StringEscapeUtils.escapeHtml(input)
        @Expect(result, "中文测试")  // 中文不应被转义
    }

    @TestCase
    func testUnescapePartial() {
        let input = "&lt;div&"  // 不完整的实体
        let result = StringEscapeUtils.unescapeHtml(input)
        @Expect(result.contains("&lt;"), false)
    }

    @TestCase
    func testEscapeAlreadyEscaped() {
        let input = "&lt;"
        let result = StringEscapeUtils.escapeHtml(input)
        @Expect(result.contains("&amp;"), true)  // & 应该被转义
    }

    @TestCase
    func testUnescapeInvalid() {
        let input = "&invalid;"
        let result = StringEscapeUtils.unescapeHtml(input)
        @Expect(result.contains("&invalid;"), true)  // 无效实体应保持原样
    }

    // ==================== 增强测试 (Task B) ====================

    @TestCase
    func testUnescapeJsonUnicodeChinese() {
        // \u4e2d -> 中
        let input = "\\u4e2d\\u6587"
        let result = StringEscapeUtils.unescapeJson(input)
        @Expect(result, "中文")
    }

    @TestCase
    func testUnescapeJsonMixed() {
        // abc\u0041xyz -> abcAxyz
        let input = "abc\\u0041xyz"
        let result = StringEscapeUtils.unescapeJson(input)
        @Expect(result, "abcAxyz")
    }

    @TestCase
    func testUnescapeJsonInvalidUnicode() {
        // \uGGGG -> Should remain \uGGGG (not hex)
        let input = "\\uGGGG"
        let result = StringEscapeUtils.unescapeJson(input)
        @Expect(result, "\\uGGGG")
    }

    @TestCase
    func testUnescapeJsonIncompleteUnicode() {
        // \u004 -> Should remain \u004
        let input = "\\u004"
        let result = StringEscapeUtils.unescapeJson(input)
        @Expect(result, "\\u004")
    }

    @TestCase
    func testUnescapeJsonNullChar() {
        // \u0000 -> null char (size should be 1, but might act weird in print)
        let input = "\\u0000"
        let result = StringEscapeUtils.unescapeJson(input)
        @Expect(result.size, 1)
        let r = result[0]
        @Expect(Int64(r), 0)
    }
}
