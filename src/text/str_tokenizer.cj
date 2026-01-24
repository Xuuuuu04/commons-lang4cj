package commons_lang4cj.text

import std.collection.*

/**
 * StrTokenizer 字符串分词器
 *
 * 仓颉版本的 Apache Commons Lang StrTokenizer 类
 * 提供灵活的字符串分词功能，支持自定义分隔符、引号处理等
 *
 * 主要特性：
 * - 支持自定义分隔符（字符串）
 * - 支持默认空白分隔符（空格、制表符、换行符等）
 * - 支持引号处理（忽略引号内的分隔符）
 * - 支持忽略空字符串
 * - 支持修剪 token 前后空白
 *
 * @since 1.0.0
 */
public class StrTokenizer {
    private var _input: String
    private var _delimiter: String
    private var _quote: Option<String>
    private var _ignoreEmpty: Bool
    private var _trimTokens: Bool
    private var _tokens: Option<Array<String>>
    private var _useDefaultWhitespaceDelimiter: Bool

    /**
     * 私有构造函数
     */
    private init(input: String, delimiter: String, quoteChar: Option<String>, ignoreEmpty: Bool, trimTokens: Bool, useDefaultWhitespace: Bool) {
        _input = input
        _delimiter = delimiter
        _quote = quoteChar
        _ignoreEmpty = ignoreEmpty
        _trimTokens = trimTokens
        _tokens = None
        _useDefaultWhitespaceDelimiter = useDefaultWhitespace
    }

    /**
     * 创建默认分词器
     * 使用默认空白字符作为分隔符，忽略空 token，修剪 token
     */
    public static func of(input: String): StrTokenizer {
        StrTokenizer(input, " ", Some("\""), true, true, true)
    }

    /**
     * 创建自定义分隔符的分词器
     * 使用指定字符串作为分隔符，忽略空 token，修剪 token
     */
    public static func of(input: String, delimiter: String): StrTokenizer {
        StrTokenizer(input, delimiter, Some("\""), true, true, false)
    }

    /**
     * 设置分隔符
     */
    public func setDelimiterChar(delimiter: String): StrTokenizer {
        _delimiter = delimiter
        _useDefaultWhitespaceDelimiter = false
        _tokens = None
        this
    }

    /**
     * 设置引号字符
     */
    public func setQuoteChar(quoteChar: String): StrTokenizer {
        _quote = Some(quoteChar)
        _tokens = None
        this
    }

    /**
     * 设置是否忽略空字符串
     */
    public func setIgnoreEmptyTokens(ignore: Bool): StrTokenizer {
        _ignoreEmpty = ignore
        _tokens = None
        this
    }

    /**
     * 设置是否修剪 token 前后空白
     */
    public func setTrimTokens(trim: Bool): StrTokenizer {
        _trimTokens = trim
        _tokens = None
        this
    }

    /**
     * 获取 token 数组
     */
    public func getTokenArray(): Array<String> {
        getTokenList()
    }

    /**
     * 获取 token 列表
     */
    public func getTokenList(): Array<String> {
        if (let Some(tokens) <- _tokens) {
            return tokens
        }

        let tokens = parseTokens()
        _tokens = Some(tokens)
        tokens
    }

    /**
     * 获取 token 数量
     */
    public func count(): Int64 {
        getTokenList().size
    }

    /**
     * 重置分词器的输入字符串
     */
    public func reset(input: String): StrTokenizer {
        _input = input
        _tokens = None
        this
    }

    /**
     * 核心分词逻辑
     */
    private func parseTokens(): Array<String> {
        if (_input.size == 0) {
            return []
        }

        var tokens = ArrayList<String>()
        var sb = StringBuilder()
        var i: Int64 = 0
        let len = _input.size
        var inQuote = false
        var currentHasQuotes = false

        while (i < len) {
            // 1. Check for delimiter (only if not in quote)
            var matchedDelim = false
            var delimLen = 0

            if (!inQuote) {
                if (_useDefaultWhitespaceDelimiter) {
                    let b = _input[i]
                    // Space, Tab, LF, CR
                    if (b == 32u8 || b == 9u8 || b == 10u8 || b == 13u8) {
                        matchedDelim = true
                        delimLen = 1
                    }
                } else {
                    if (startsWith(_input, i, _delimiter)) {
                        matchedDelim = true
                        delimLen = _delimiter.size
                    }
                }
            }

            if (matchedDelim) {
                addToken(tokens, sb.toString(), currentHasQuotes)
                sb = StringBuilder() // reset
                currentHasQuotes = false
                i += delimLen
                continue
            }

            // 2. Check for quote
            var matchedQuote = false
            if (let Some(q) <- _quote) {
                if (startsWith(_input, i, q)) {
                    matchedQuote = true
                    // Check for escaped quote (doubled quote) inside quote
                    if (inQuote && startsWith(_input, i + q.size, q)) {
                        sb.append(q)
                        i += q.size * 2
                        currentHasQuotes = true
                        continue
                    }

                    // Toggle quote state
                    inQuote = !inQuote
                    currentHasQuotes = true
                    i += q.size
                    continue
                }
            }

            // 3. Regular character
            if (!matchedQuote) {
                let b = _input[i]
                let size = getUtf8CharSize(b)
                // Safety check
                if (i + size > len) {
                    sb.append(_input[i..len])
                    i = len
                } else {
                    sb.append(_input[i..i+size])
                    i += size
                }
            }
        }

        // Add last token
        addToken(tokens, sb.toString(), currentHasQuotes)

        return tokens.toArray()
    }

    private func addToken(list: ArrayList<String>, token: String, isQuoted: Bool) {
        var t = token
        if (_trimTokens) {
            t = trimWhitespace(t)
        }

        // Ignore empty if enabled, BUT keep empty if it was explicitly quoted (e.g. "")
        // If ignoreEmpty is true:
        // - "" -> ignored
        // - " " (trimmed) -> "" -> ignored
        // - "" (quoted) -> "" -> kept
        if (_ignoreEmpty && t.size == 0 && !isQuoted) {
            return
        }
        list.add(t)
    }

    private func startsWith(str: String, idx: Int64, prefix: String): Bool {
        if (idx + prefix.size > str.size) {
            return false
        }
        for (j in 0..prefix.size) {
            if (str[idx + j] != prefix[j]) {
                return false
            }
        }
        return true
    }

    private func getUtf8CharSize(b: UInt8): Int64 {
        if (b < 0x80) { return 1 }
        if ((b & 0xE0) == 0xC0) { return 2 }
        if ((b & 0xF0) == 0xE0) { return 3 }
        if ((b & 0xF8) == 0xF0) { return 4 }
        return 1
    }

    /**
     * 修剪字符串前后的空白
     */
    private func trimWhitespace(str: String): String {
        if (str.size == 0) {
            return str
        }

        var start: Int64 = 0
        var end: Int64 = str.size

        // Find first non-whitespace
        for (i in 0..str.size) {
            let ch = str[i]
            if (ch != 32u8 && ch != 9u8 && ch != 10u8 && ch != 13u8) {
                start = i
                break
            }
            if (i == str.size - 1) {
                return ""
            }
        }

        // Find last non-whitespace
        var j = str.size - 1
        while (j >= start) {
            let ch = str[j]
             if (ch != 32u8 && ch != 9u8 && ch != 10u8 && ch != 13u8) {
                end = j + 1
                break
            }
            j--
        }

        return str[start..end]
    }

    /**
     * 获取分词器的字符串表示
     */
    public func toString(): String {
        let quoteStr = match (_quote) {
            case Some(q) => q
            case None => "None"
        }
        "StrTokenizer(delimiter=${_delimiter}, quote=${quoteStr}, ignoreEmpty=${_ignoreEmpty}, trimTokens=${_trimTokens})"
    }
}
