package commons_lang4cj.text

import std.convert.*
import std.regex.*

/**
 * StringEscapeUtils 字符串转义工具类
 *
 * 仓颉版本的 Apache Commons Lang StringEscapeUtils 工具类
 * 提供各种格式的字符串转义和反转义功能
 *
 * 支持的格式包括：
 * - HTML/HTML4/XHTML
 * - XML
 * - JSON (RFC 8259)
 * - Java
 * - CSV (RFC 4180)
 *
 * 转义原则：
 * - 只转义必需的特殊字符
 * - 反转义时验证格式的合法性
 * - 保持性能优先
 *
 * @since 1.0.0
 */
public class StringEscapeUtils {
    // ========== HTML 转义/反转义 ==========

    /**
     * 转义 HTML 特殊字符
     *
     * 转义规则：
     * - & -> &amp;
     * - < -> &lt;
     * - > -> &gt;
     * - " -> &quot;
     * - ' -> &apos;
     *
     * @param input 待转义的字符串
     * @return 转义后的字符串
     */
    public static func escapeHtml(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("&", "&amp;")
        result = result.replace("<", "&lt;")
        result = result.replace(">", "&gt;")
        result = result.replace("\"", "&quot;")
        result = result.replace("'", "&apos;")
        result
    }

    /**
     * 反转义 HTML 实体
     *
     * 支持的实体：&amp;, &lt;, &gt;, &quot;, &apos;, &#39;, &#DDD;, &#xHHH;
     *
     * @param input 待反转义的字符串
     * @return 反转义后的字符串
     */
    public static func unescapeHtml(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("&quot;", "\"")
        result = result.replace("&apos;", "'")
        result = result.replace("&#39;", "'")
        result = result.replace("&lt;", "<")
        result = result.replace("&gt;", ">")
        result = result.replace("&amp;", "&")

        // Numeric entities: &#65; -> A
        let decimalPattern = Regex(#"&#\d+;"#)
        result = replaceAll(result, decimalPattern, { m: MatchData =>
            let fullStr = m.matchString()
            // Extract number part: remove "&#" (2 chars) and ";" (1 char)
            let numStr = fullStr[2..(fullStr.size - 1)]
            if (let Some(code) <- Int64.tryParse(numStr)) {
                try {
                    return Rune(UInt32(code)).toString()
                } catch (e: Exception) {
                    return fullStr
                }
            }
            fullStr
        })

        // Hex entities: &#x41; -> A
        let hexPattern = Regex(#"&#x[0-9a-fA-F]+;"#)
        result = replaceAll(result, hexPattern, { m: MatchData =>
            let fullStr = m.matchString()
            // Extract hex part: remove "&#x" (3 chars) and ";" (1 char)
            let hexStr = fullStr[3..(fullStr.size - 1)]
            try {
                // Parse hex manually since Int64.parse might not support 0x prefix by default in all versions
                let code = parseHex(hexStr)
                return Rune(UInt32(code)).toString()
            } catch (e: Exception) {
                return fullStr
            }
        })

        result
    }

    // Helper to parse hex string
    private static func parseHex(hex: String): Int64 {
        var res: Int64 = 0
        for (b in hex) {
            res = res * 16
            if (b >= 48u8 && b <= 57u8) { // 0-9
                res += Int64(b - 48u8)
            } else if (b >= 65u8 && b <= 70u8) { // A-F
                res += Int64(b - 55u8)
            } else if (b >= 97u8 && b <= 102u8) { // a-f
                res += Int64(b - 87u8)
            }
        }
        res
    }

    // Helper for regex replacement with lambda
    private static func replaceAll(input: String, regex: Regex, replacer: (MatchData) -> String): String {
        let sb = StringBuilder()
        var lastIdx = 0

        // Use findAll instead of deprecated matcher/find
        let matches = regex.findAll(input)

        for (m in matches) {
            let start = m.matchPosition(0).start
            let end = m.matchPosition(0).end
            sb.append(input[lastIdx..start])
            sb.append(replacer(m))
            lastIdx = end
        }

        sb.append(input[lastIdx..input.size])
        sb.toString()
    }

    // ========== XML 转义/反转义 ==========

    /**
     * 转义 XML 特殊字符
     *
     * 转义规则：
     * - & -> &amp;
     * - < -> &lt;
     * - > -> &gt;
     * - " -> &quot;
     * - ' -> &apos;
     *
     * @param input 待转义的字符串
     * @return 转义后的字符串
     */
    public static func escapeXml(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("&", "&amp;")
        result = result.replace("<", "&lt;")
        result = result.replace(">", "&gt;")
        result = result.replace("\"", "&quot;")
        result = result.replace("'", "&apos;")
        result
    }

    /**
     * 反转义 XML 实体
     *
     * 支持的实体：&amp;, &lt;, &gt;, &quot;, &apos;
     *
     * @param input 待反转义的字符串
     * @return 反转义后的字符串
     */
    public static func unescapeXml(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("&quot;", "\"")
        result = result.replace("&apos;", "'")
        result = result.replace("&lt;", "<")
        result = result.replace("&gt;", ">")
        result = result.replace("&amp;", "&")
        result
    }

    // ========== JSON 转义/反转义 ==========

    /**
     * 转义 JSON 字符串（RFC 8259 标准）
     *
     * 转义规则：
     * - " -> \"
     * - \ -> \\
     * - / -> \/
     * - \b -> \\b
     * - \f -> \\f
     * - \n -> \\n
     * - \r -> \\r
     * - \t -> \\t
     * - \n     *
     * @param input 待转义的字符串
     * @return 转义后的字符串
     */
    public static func escapeJson(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("\\", "\\\\")
        result = result.replace("\"", "\\\"")
        result = result.replace("/", "\\/")
        result = result.replace("\b", "\\b")
        result = result.replace("\f", "\\f")
        result = result.replace("\n", "\\n")
        result = result.replace("\r", "\\r")
        result = result.replace("\t", "\\t")
        result
    }

    /**
     * 反转义 JSON 字符串
     *
     * @param input 待反转义的字符串
     * @return 反转义后的字符串
     */
    public static func unescapeJson(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("\\t", "\t")
        result = result.replace("\\r", "\r")
        result = result.replace("\\n", "\n")
        result = result.replace("\\f", "\f")
        result = result.replace("\\b", "\b")
        result = result.replace("\\/", "/")
        result = result.replace("\\\"", "\"")
        result = result.replace("\\\\", "\\")

        // Unicode escapes: \u0041 -> A
        let unicodePattern = Regex(#"\\u[0-9a-fA-F]{4}"#)
        result = replaceAll(result, unicodePattern, { m: MatchData =>
            let fullStr = m.matchString()
            // Extract hex part: remove "\u" (2 chars)
            let hexStr = fullStr[2..]
            try {
                let code = parseHex(hexStr)
                // Handle null character specially if needed, but Rune(0) is valid
                return Rune(UInt32(code)).toString()
            } catch (e: Exception) {
                return fullStr
            }
        })

        result
    }

    // ========== Java 转义/反转义 ==========

    /**
     * 转义 Java 字符串字面量
     *
     * 转义规则：
     * - " -> \"
     * - \ -> \\
     * - \t -> \\t
     * - \n -> \\n
     * - \r -> \\r
     *
     * @param input 待转义的字符串
     * @return 转义后的字符串
     */
    public static func escapeJava(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("\\", "\\\\")
        result = result.replace("\"", "\\\"")
        result = result.replace("\t", "\\t")
        result = result.replace("\n", "\\n")
        result = result.replace("\r", "\\r")
        result
    }

    /**
     * 反转义 Java 字符串字面量
     *
     * @param input 待反转义的字符串
     * @return 反转义后的字符串
     */
    public static func unescapeJava(input: String): String {
        if (input.size == 0) {
            return input
        }

        var result = input
        result = result.replace("\\r", "\r")
        result = result.replace("\\n", "\n")
        result = result.replace("\\t", "\t")
        result = result.replace("\\\"", "\"")
        result = result.replace("\\\\", "\\")
        result
    }

    // ========== CSV 转义/反转义 ==========

    /**
     * 转义 CSV 字段（RFC 4180 标准）
     *
     * 转义规则：
     * - 如果包含逗号、双引号、换行符，则用双引号包围
     * - 字段内的双引号转义为两个双引号
     *
     * @param input 待转义的字符串
     * @return 转义后的字符串
     */
    public static func escapeCsv(input: String): String {
        if (input.size == 0) {
            return input
        }

        // 检查是否需要转义
        let needsQuoting = input.contains(",") ||
                          input.contains("\"") ||
                          input.contains("\n") ||
                          input.contains("\r")

        if (!needsQuoting) {
            return input
        }

        // 用双引号包围，并将内部的双引号转义为两个双引号
        var result = "\""
        result += input.replace("\"", "\"\"")
        result += "\""
        result
    }

    /**
     * 反转义 CSV 字段
     *
     * @param input 待反转义的字符串
     * @return 反转义后的字符串
     */
    public static func unescapeCsv(input: String): String {
        if (input.size == 0) {
            return input
        }

        // 如果没有用双引号包围，直接返回
        if (input.size < 2) {
            return input
        }

        let first = input[0]
        let last = input[input.size - 1]

        if (first != 34u8 || last != 34u8) {  // 34 is ASCII for "
            return input
        }

        // 去除外层双引号，并将两个连续双引号替换为一个双引号
        var result = input[1..(input.size - 1)]
        result = result.replace("\"\"", "\"")
        result
    }
}
