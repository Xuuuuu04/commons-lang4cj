package commons_lang4cj.utils

import std.collection.*

/**
 * StringUtils 字符串工具类
 *
 * 仓颉版本的 Apache Commons Lang StringUtils 工具类
 * 提供字符串操作的静态方法集合
 *
 * 功能包括：
 * - 空值检查（IsEmpty/IsBlank/IsAlpha/IsNumeric/IsAlphanumeric）
 * - 截取与分割（Trim/Split/Join/LeftTrim/RightTrim）
 * - 查询与比较（Equals/Compare/Contains/IndexOf/LastIndexOf/StartsWith/EndsWith/CountMatches）
 * - 替换与删除（Replace/ReplaceOnce/Remove）
 * - 截取（Substring/Left/Right/Mid/SubstringBefore/SubstringAfter/SubstringBetween）
 * - 大小写转换（UpperCase/LowerCase/Capitalize/Uncapitalize/SwapCase）
 * - 填充与对齐（LeftPad/RightPad/Center/Repeat）
 * - 反转（Reverse/ReverseDelimited）
 *
 * @since 1.0.0
 */
public class StringUtils {
    /**
     * 空字符串常量
     */
    public static const EMPTY: String = ""

    /**
     * 索引未找到常量
     */
    public static const INDEX_NOT_FOUND: Int64 = -1

    // ========== Phase 1: 空值检查 ==========

    /**
     * 检查字符串是否为空
     *
     * 空字符串定义为：长度为 0 的字符串
     *
     * @param str 待检查的字符串
     * @return 如果字符串为空返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.isEmpty("")        // true
     * StringUtils.isEmpty(" ")       // false
     * StringUtils.isEmpty("hello")   // false
     * ```
     */
    public static func isEmpty(str: String): Bool {
        str.size == 0
    }

    /**
     * 检查字符串是否不为空
     *
     * @param str 待检查的字符串
     * @return 如果字符串不为空返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.isNotEmpty("")        // false
     * StringUtils.isNotEmpty(" ")       // true
     * StringUtils.isNotEmpty("hello")   // true
     * ```
     */
    public static func isNotEmpty(str: String): Bool {
        !isEmpty(str)
    }

    /**
     * 检查字符串是否为空白
     *
     * 空白字符串定义为：空字符串、全部由空白字符组成的字符串
     * 空白字符包括：空格、制表符、换行符等
     *
     * @param str 待检查的字符串
     * @return 如果字符串为空白返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.isBlank("")        // true
     * StringUtils.isBlank(" ")       // true
     * StringUtils.isBlank("\t\n")    // true
     * StringUtils.isBlank("hello")   // false
     * StringUtils.isBlank(" hello ") // false
     * ```
     */
    public static func isBlank(str: String): Bool {
        if (isEmpty(str)) {
            return true
        }

        // 检查每个字符是否为空白字符
        for (ch in str) {
            let rune = String.fromUtf8([ch])
            if (!isWhitespaceRune(rune)) {
                return false
            }
        }
        true
    }

    /**
     * 检查字符串是否不为空白
     *
     * @param str 待检查的字符串
     * @return 如果字符串不为空白返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.isNotBlank("")        // false
     * StringUtils.isNotBlank(" ")       // false
     * StringUtils.isNotBlank("\t\n")    // false
     * StringUtils.isNotBlank("hello")   // true
     * StringUtils.isNotBlank(" hello ") // true
     * ```
     */
    public static func isNotBlank(str: String): Bool {
        !isBlank(str)
    }

    // ========== Phase 2: 截取与分割 ==========

    /**
     * 去除字符串首尾的空白字符
     *
     * @param str 待处理的字符串
     * @return 去除首尾空白后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.trim("  hello  ")     // "hello"
     * StringUtils.trim("\thello\n")     // "hello"
     * StringUtils.trim("hello")         // "hello"
     * StringUtils.trim("  ")            // ""
     * ```
     */
    public static func trim(str: String): String {
        if (isEmpty(str)) {
            return str
        }

        var start = 0
        var end = str.size - 1

        // 找到第一个非空白字符
        while (start <= end) {
            let ch = String.fromUtf8([str[start]])
            if (!isWhitespaceRune(ch)) {
                break
            }
            start++
        }

        // 找到最后一个非空白字符
        while (end >= start) {
            let ch = String.fromUtf8([str[end]])
            if (!isWhitespaceRune(ch)) {
                break
            }
            end--
        }

        if (start > end) {
            return EMPTY
        }

        str[start..(end + 1)]
    }

    /**
     * 分割字符串
     *
     * @param str 待分割的字符串
     * @param separator 分隔符
     * @return 分割后的字符串数组
     *
     * 示例：
     * ```cangjie
     * StringUtils.split("a,b,c", ",")     // ["a", "b", "c"]
     * StringUtils.split("a,b,c", ",")     // ["a", "b", "c"]
     * StringUtils.split("a,,b", ",")      // ["a", "", "b"]
     * StringUtils.split("", ",")          // [""]
     * ```
     */
    public static func split(str: String, separator: String): Array<String> {
        split(str, separator, 0)
    }

    /**
     * 分割字符串（限制分割次数）
     *
     * @param str 待分割的字符串
     * @param separator 分隔符
     * @param maxSplit 最大分割次数，0 表示无限制
     * @return 分割后的字符串数组
     *
     * 示例：
     * ```cangjie
     * StringUtils.split("a,b,c", ",", 0)   // ["a", "b", "c"]
     * StringUtils.split("a,b,c", ",", 2)   // ["a", "b,c"]
     * StringUtils.split("a,b,c", ",", 1)   // ["a,b,c"]
     * ```
     */
    public static func split(str: String, separator: String, maxSplit: Int64): Array<String> {
        if (isEmpty(str)) {
            return [EMPTY]
        }

        if (isEmpty(separator)) {
            return [str]
        }

        let effectiveMaxSplits = if (maxSplit == 0) { -1 } else { maxSplit }
        str.split(separator, effectiveMaxSplits)
    }

    /**
     * 连接字符串数组
     *
     * @param elements 字符串数组
     * @param separator 分隔符
     * @return 连接后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.join(["a", "b", "c"], ",")  // "a,b,c"
     * StringUtils.join(["a", "b"], "-")       // "a-b"
     * StringUtils.join([], ",")               // ""
     * ```
     */
    public static func join(elements: Array<String>, separator: String): String {
        String.join(elements, delimiter: separator)
    }

    // ========== Phase 4: 查询与比较 ==========

    /**
     * 相等比较
     *
     * @param str1 第一个字符串
     * @param str2 第二个字符串
     * @return 如果相等返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.equals("hello", "hello")  // true
     * StringUtils.equals("hello", "HELLO")  // false
     * StringUtils.equals("", "")            // true
     * ```
     */
    public static func equals(str1: String, str2: String): Bool {
        str1 == str2
    }

    /**
     * 比较大小
     *
     * @param str1 第一个字符串
     * @param str2 第二个字符串
     * @return 如果 str1 < str2 返回负数，相等返回 0，str1 > str2 返回正数
     *
     * 示例：
     * ```cangjie
     * StringUtils.compare("a", "b")    // < 0
     * StringUtils.compare("b", "a")    // > 0
     * StringUtils.compare("a", "a")    // 0
     * ```
     */
    public static func compare(str1: String, str2: String): Int64 {
        match (str1.compare(str2)) {
            case Ordering.LT => -1
            case Ordering.EQ => 0
            case Ordering.GT => 1
        }
    }

    /**
     * 包含检查
     *
     * @param str 待检查的字符串
     * @param searchStr 搜索的字符串
     * @return 如果包含返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.contains("hello", "ell")  // true
     * StringUtils.contains("hello", "abc")  // false
     * StringUtils.contains("", "")          // true
     * ```
     */
    public static func contains(str: String, searchStr: String): Bool {
        str.contains(searchStr)
    }

    /**
     * 前缀检查
     *
     * @param str 待检查的字符串
     * @param prefix 前缀
     * @return 如果以 prefix 开头返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.startsWith("hello", "hel")  // true
     * StringUtils.startsWith("hello", "ell")  // false
     * StringUtils.startsWith("", "")          // true
     * ```
     */
    public static func startsWith(str: String, prefix: String): Bool {
        if (prefix.size > str.size) {
            return false
        }
        str[0..prefix.size] == prefix
    }

    /**
     * 后缀检查
     *
     * @param str 待检查的字符串
     * @param suffix 后缀
     * @return 如果以 suffix 结尾返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.endsWith("hello", "llo")  // true
     * StringUtils.endsWith("hello", "ell")  // false
     * StringUtils.endsWith("", "")          // true
     * ```
     */
    public static func endsWith(str: String, suffix: String): Bool {
        str.endsWith(suffix)
    }

    /**
     * 查找位置
     *
     * @param str 待搜索的字符串
     * @param searchStr 搜索的字符串
     * @return 第一次出现的位置，未找到返回 -1
     *
     * 示例：
     * ```cangjie
     * StringUtils.indexOf("hello", "ell")  // 1
     * StringUtils.indexOf("hello", "abc")  // -1
     * StringUtils.indexOf("hello", "")     // 0
     * ```
     */
    public static func indexOf(str: String, searchStr: String): Int64 {
        if (let Some(pos) <- str.indexOf(searchStr)) {
            pos
        } else {
            INDEX_NOT_FOUND
        }
    }

    /**
     * 最后出现位置
     *
     * @param str 待搜索的字符串
     * @param searchStr 搜索的字符串
     * @return 最后一次出现的位置，未找到返回 -1
     *
     * 示例：
     * ```cangjie
     * StringUtils.lastIndexOf("hello hello", "ell")  // 7
     * StringUtils.lastIndexOf("hello", "abc")         // -1
     * StringUtils.lastIndexOf("hello", "")            // 5
     * ```
     */
    public static func lastIndexOf(str: String, searchStr: String): Int64 {
        if (let Some(pos) <- str.lastIndexOf(searchStr)) {
            pos
        } else {
            INDEX_NOT_FOUND
        }
    }

    // ========== Phase 5: 替换与删除 ==========

    /**
     * 替换所有匹配
     *
     * @param str 原字符串
     * @param searchStr 搜索的字符串
     * @param replacement 替换的字符串
     * @return 替换后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.replace("hello", "l", "x")       // "hexxo"
     * StringUtils.replace("hello", "ell", "abc")   // "habco"
     * StringUtils.replace("hello", "xyz", "abc")   // "hello"
     * ```
     */
    public static func replace(str: String, searchStr: String, replacement: String): String {
        if (isEmpty(str) || isEmpty(searchStr)) {
            return str
        }

        var result = str
        var pos = indexOf(result, searchStr)
        while (pos != INDEX_NOT_FOUND) {
            result = result[0..pos] + replacement + result[(pos + searchStr.size)..]
            pos = indexOf(result, searchStr, pos + replacement.size)
        }
        result
    }

    /**
     * 替换第一个匹配
     *
     * @param str 原字符串
     * @param searchStr 搜索的字符串
     * @param replacement 替换的字符串
     * @return 替换后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.replaceOnce("hello", "l", "x")     // "hexlo"
     * StringUtils.replaceOnce("hello", "ell", "abc") // "habco"
     * StringUtils.replaceOnce("hello", "xyz", "abc") // "hello"
     * ```
     */
    public static func replaceOnce(str: String, searchStr: String, replacement: String): String {
        if (isEmpty(str) || isEmpty(searchStr)) {
            return str
        }

        let pos = indexOf(str, searchStr)
        if (pos == INDEX_NOT_FOUND) {
            return str
        }

        str[0..pos] + replacement + str[(pos + searchStr.size)..]
    }

    /**
     * 删除所有匹配
     *
     * @param str 原字符串
     * @param removeStr 要删除的字符串
     * @return 删除后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.remove("hello", "l")   // "heo"
     * StringUtils.remove("hello", "ell") // "ho"
     * StringUtils.remove("hello", "xyz") // "hello"
     * ```
     */
    public static func remove(str: String, removeStr: String): String {
        replace(str, removeStr, EMPTY)
    }

    /**
     * 查找位置（指定起始位置）
     *
     * @param str 待搜索的字符串
     * @param searchStr 搜索的字符串
     * @param startPos 起始位置
     * @return 第一次出现的位置，未找到返回 -1
     */
    public static func indexOf(str: String, searchStr: String, startPos: Int64): Int64 {
        if (startPos >= str.size) {
            return INDEX_NOT_FOUND
        }

        if (let Some(pos) <- str.indexOf(searchStr, startPos)) {
            pos
        } else {
            INDEX_NOT_FOUND
        }
    }

    // ========== Phase 7: 截取 ==========

    /**
     * 截取子串
     *
     * @param str 原字符串
     * @param start 起始位置
     * @return 截取后的子串
     *
     * 示例：
     * ```cangjie
     * StringUtils.substring("hello", 2)    // "llo"
     * StringUtils.substring("hello", 0)    // "hello"
     * StringUtils.substring("hello", 5)    // ""
     * ```
     */
    public static func substring(str: String, start: Int64): String {
        if (start < 0) {
            return str
        }
        if (start >= str.size) {
            return EMPTY
        }
        str[start..]
    }

    /**
     * 截取子串（指定范围）
     *
     * @param str 原字符串
     * @param start 起始位置
     * @param end 结束位置（不包含）
     * @return 截取后的子串
     *
     * 示例：
     * ```cangjie
     * StringUtils.substring("hello", 1, 4)    // "ell"
     * StringUtils.substring("hello", 0, 5)    // "hello"
     * StringUtils.substring("hello", 2, 2)    // ""
     * ```
     */
    public static func substring(str: String, start: Int64, end: Int64): String {
        if (start < 0) {
            return str[0..end]
        }
        if (start >= str.size) {
            return EMPTY
        }
        if (end > str.size) {
            return str[start..]
        }
        if (end <= start) {
            return EMPTY
        }
        str[start..end]
    }

    /**
     * 获取左边 N 个字符
     *
     * @param str 原字符串
     * @param len 字符数
     * @return 左边的字符
     *
     * 示例：
     * ```cangjie
     * StringUtils.left("hello", 2)    // "he"
     * StringUtils.left("hello", 10)   // "hello"
     * StringUtils.left("hello", 0)    // ""
     * ```
     */
    public static func left(str: String, len: Int64): String {
        if (len <= 0) {
            return EMPTY
        }
        if (len >= str.size) {
            return str
        }
        str[0..len]
    }

    /**
     * 获取右边 N 个字符
     *
     * @param str 原字符串
     * @param len 字符数
     * @return 右边的字符
     *
     * 示例：
     * ```cangjie
     * StringUtils.right("hello", 2)    // "lo"
     * StringUtils.right("hello", 10)   // "hello"
     * StringUtils.right("hello", 0)    // ""
     * ```
     */
    public static func right(str: String, len: Int64): String {
        if (len <= 0) {
            return EMPTY
        }
        if (len >= str.size) {
            return str
        }
        str[(str.size - len)..]
    }

    /**
     * 获取中间 N 个字符
     *
     * @param str 原字符串
     * @param pos 起始位置
     * @param len 字符数
     * @return 中间的字符
     *
     * 示例：
     * ```cangjie
     * StringUtils.mid("hello", 1, 2)    // "el"
     * StringUtils.mid("hello", 0, 5)    // "hello"
     * StringUtils.mid("hello", 2, 10)   // "llo"
     * ```
     */
    public static func mid(str: String, pos: Int64, len: Int64): String {
        if (pos < 0) {
            return EMPTY
        }
        if (pos >= str.size) {
            return EMPTY
        }
        let end = if (pos + len > str.size) { str.size } else { pos + len }
        str[pos..end]
    }

    // ========== Phase 9: 大小写转换 ==========

    /**
     * 转换为大写
     *
     * @param str 原字符串
     * @return 大写字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.upperCase("hello")    // "HELLO"
     * StringUtils.upperCase("HELLO")    // "HELLO"
     * StringUtils.upperCase("HeLLo")    // "HELLO"
     * StringUtils.upperCase("")         // ""
     * ```
     */
    public static func upperCase(str: String): String {
        if (isEmpty(str)) {
            return str
        }

        var result = StringBuilder()
        for (byte in str) {
            // ASCII 'a' 到 'z' 的范围是 0x61 到 0x7A
            // 转换为大写：减去 0x20
            if (byte >= 0x61u8 && byte <= 0x7Au8) {
                let upperByte: UInt8 = byte - 0x20u8
                result.append(String.fromUtf8([upperByte]))
            } else {
                result.append(String.fromUtf8([byte]))
            }
        }
        result.toString()
    }

    /**
     * 转换为小写
     *
     * @param str 原字符串
     * @return 小写字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.lowerCase("HELLO")    // "hello"
     * StringUtils.lowerCase("hello")    // "hello"
     * StringUtils.lowerCase("HeLLo")    // "hello"
     * StringUtils.lowerCase("")         // ""
     * ```
     */
    public static func lowerCase(str: String): String {
        if (isEmpty(str)) {
            return str
        }

        var result = StringBuilder()
        for (byte in str) {
            // ASCII 'A' 到 'Z' 的范围是 0x41 到 0x5A
            // 转换为小写：加上 0x20
            if (byte >= 0x41u8 && byte <= 0x5Au8) {
                let lowerByte: UInt8 = byte + 0x20u8
                result.append(String.fromUtf8([lowerByte]))
            } else {
                result.append(String.fromUtf8([byte]))
            }
        }
        result.toString()
    }

    /**
     * 首字母大写
     *
     * @param str 原字符串
     * @return 首字母大写的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.capitalize("hello")    // "Hello"
     * StringUtils.capitalize("HELLO")    // "HELLO"
     * StringUtils.capitalize("hello world")  // "hello world"
     * StringUtils.capitalize("")         // ""
     * StringUtils.capitalize("a")        // "A"
     * ```
     */
    public static func capitalize(str: String): String {
        if (isEmpty(str)) {
            return str
        }
        if (str.size == 1) {
            return upperCase(str)
        }

        // 获取首字符
        let first = str[0]
        // ASCII 'a' 到 'z' 的范围是 0x61 到 0x7A
        if (first >= 0x61u8 && first <= 0x7Au8) {
            // 小写转大写：减去 0x20
            let upperByte: UInt8 = first - 0x20u8
            let upperFirst = String.fromUtf8([upperByte])
            return upperFirst + str[1..]
        }
        str
    }

    /**
     * 首字母小写
     *
     * @param str 原字符串
     * @return 首字母小写的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.uncapitalize("Hello")    // "hello"
     * StringUtils.uncapitalize("HELLO")    // "hELLO"
     * StringUtils.uncapitalize("hello")    // "hello"
     * StringUtils.uncapitalize("")         // ""
     * StringUtils.uncapitalize("A")        // "a"
     * ```
     */
    public static func uncapitalize(str: String): String {
        if (isEmpty(str)) {
            return str
        }
        if (str.size == 1) {
            return lowerCase(str)
        }

        // 获取首字符
        let first = str[0]
        // ASCII 'A' 到 'Z' 的范围是 0x41 到 0x5A
        if (first >= 0x41u8 && first <= 0x5Au8) {
            // 大写转小写：加上 0x20
            let lowerByte: UInt8 = first + 0x20u8
            let lowerFirst = String.fromUtf8([lowerByte])
            return lowerFirst + str[1..]
        }
        str
    }

    /**
     * 大小写互换
     *
     * @param str 原字符串
     * @return 大小写互换后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.swapCase("Hello")    // "hELLO"
     * StringUtils.swapCase("HELLO")    // "hello"
     * StringUtils.swapCase("hello")    // "HELLO"
     * StringUtils.swapCase("")         // ""
     * ```
     */
    public static func swapCase(str: String): String {
        if (isEmpty(str)) {
            return str
        }

        var result = StringBuilder()
        for (byte in str) {
            // ASCII 'a' 到 'z' 的范围是 0x61 到 0x7A
            if (byte >= 0x61u8 && byte <= 0x7Au8) {
                // 小写转大写
                let upperByte: UInt8 = byte - 0x20u8
                result.append(String.fromUtf8([upperByte]))
            } else if (byte >= 0x41u8 && byte <= 0x5Au8) {
                // 大写转小写
                let lowerByte: UInt8 = byte + 0x20u8
                result.append(String.fromUtf8([lowerByte]))
            } else {
                // 非字母字符保持不变
                result.append(String.fromUtf8([byte]))
            }
        }
        result.toString()
    }

    // ========== Phase 10: 填充与对齐 ==========

    /**
     * 左填充（使用空格）
     *
     * @param str 原字符串
     * @param size 填充后的总长度
     * @return 左填充后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.leftPad("hello", 10)    // "     hello"
     * StringUtils.leftPad("hello", 3)     // "hello"
     * StringUtils.leftPad("", 5)          // "     "
     * ```
     */
    public static func leftPad(str: String, size: Int64): String {
        leftPad(str, size, r' ')
    }

    /**
     * 左填充（使用指定字符）
     *
     * @param str 原字符串
     * @param size 填充后的总长度
     * @param padChar 填充字符
     * @return 左填充后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.leftPad("hello", 10, r'*')    // "*****hello"
     * StringUtils.leftPad("hello", 3, r'*')     // "hello"
     * StringUtils.leftPad("", 5, r'*')          // "*****"
     * ```
     */
    public static func leftPad(str: String, size: Int64, padChar: Rune): String {
        if (str.size >= size) {
            return str
        }

        let padSize = size - str.size
        var padStr = StringBuilder()
        for (_ in 0..padSize) {
            padStr.append(padChar)
        }
        padStr.toString() + str
    }

    /**
     * 右填充（使用空格）
     *
     * @param str 原字符串
     * @param size 填充后的总长度
     * @return 右填充后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.rightPad("hello", 10)    // "hello     "
     * StringUtils.rightPad("hello", 3)     // "hello"
     * StringUtils.rightPad("", 5)          // "     "
     * ```
     */
    public static func rightPad(str: String, size: Int64): String {
        rightPad(str, size, r' ')
    }

    /**
     * 右填充（使用指定字符）
     *
     * @param str 原字符串
     * @param size 填充后的总长度
     * @param padChar 填充字符
     * @return 右填充后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.rightPad("hello", 10, r'*')    // "hello*****"
     * StringUtils.rightPad("hello", 3, r'*')     // "hello"
     * StringUtils.rightPad("", 5, r'*')          // "*****"
     * ```
     */
    public static func rightPad(str: String, size: Int64, padChar: Rune): String {
        if (str.size >= size) {
            return str
        }

        let padSize = size - str.size
        var padStr = StringBuilder()
        for (_ in 0..padSize) {
            padStr.append(padChar)
        }
        str + padStr.toString()
    }

    /**
     * 居中对齐
     *
     * @param str 原字符串
     * @param size 填充后的总长度
     * @return 居中对齐后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.center("hello", 11)    // "   hello   "
     * StringUtils.center("hello", 10)    // " hello   "
     * StringUtils.center("hello", 3)     // "hello"
     * StringUtils.center("", 5)          // "     "
     * ```
     */
    public static func center(str: String, size: Int64): String {
        if (str.size >= size) {
            return str
        }

        let padSize = size - str.size
        let leftPadSize = padSize / 2
        let rightPadSize = padSize - leftPadSize

        leftPad(rightPad(str, str.size + rightPadSize, r' '), str.size + rightPadSize + leftPadSize, r' ')
    }

    /**
     * 重复字符串
     *
     * @param str 原字符串
     * @param repeatTimes 重复次数
     * @return 重复后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.repeat("a", 3)    // "aaa"
     * StringUtils.repeat("ab", 2)   // "abab"
     * StringUtils.repeat("a", 0)    // ""
     * StringUtils.repeat("", 3)     // ""
     * ```
     */
    public static func repeat(str: String, repeatTimes: Int64): String {
        if (isEmpty(str) || repeatTimes <= 0) {
            return EMPTY
        }

        var result = StringBuilder()
        for (_ in 0..repeatTimes) {
            result.append(str)
        }
        result.toString()
    }

    // ========== Phase 8: 反转 ==========

    /**
     * 反转字符串
     *
     * @param str 原字符串
     * @return 反转后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.reverse("hello")    // "olleh"
     * StringUtils.reverse("")         // ""
     * StringUtils.reverse("a")        // "a"
     * ```
     */
    public static func reverse(str: String): String {
        if (isEmpty(str) || str.size == 1) {
            return str
        }

        var result: Array<UInt8> = Array<UInt8>(str.size, repeat: 0u8)
        var j = 0
        var i = str.size - 1
        while (i >= 0) {
            result[j] = str[i]
            j++
            i--
        }
        String.fromUtf8(result)
    }

    /**
     * 反转分隔字符串
     *
     * @param str 原字符串
     * @param separator 分隔符
     * @return 反转分隔后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.reverseDelimited("a.b.c", ".")    // "c.b.a"
     * StringUtils.reverseDelimited("a-b-c", "-")    // "c-b-a"
     * StringUtils.reverseDelimited("hello", ".")    // "hello"
     * StringUtils.reverseDelimited("", ".")         // ""
     * ```
     */
    public static func reverseDelimited(str: String, separator: String): String {
        if (isEmpty(str)) {
            return str
        }

        let parts = split(str, separator)
        if (parts.size <= 1) {
            return str
        }

        // 使用 StringBuilder 构建结果
        var result = StringBuilder()
        var i = parts.size - 1
        while (i >= 0) {
            result.append(parts[i])
            if (i > 0) {
                result.append(separator)
            }
            i--
        }
        result.toString()
    }

    // ========== Phase 11: 其他实用方法 ==========

    /**
     * 统计子串出现次数
     *
     * @param str 原字符串
     * @param sub 要统计的子串
     * @return 出现次数
     *
     * 示例：
     * ```cangjie
     * StringUtils.countMatches("hello", "l")      // 2
     * StringUtils.countMatches("hello", "ll")     // 1
     * StringUtils.countMatches("hello", "x")      // 0
     * StringUtils.countMatches("", "a")           // 0
     * ```
     */
    public static func countMatches(str: String, sub: String): Int64 {
        if (isEmpty(str) || isEmpty(sub)) {
            return 0
        }

        var count = 0
        var pos = 0
        while (pos < str.size) {
            let found = indexOf(str, sub, pos)
            if (found == INDEX_NOT_FOUND) {
                break
            }
            count++
            pos = found + sub.size
        }
        count
    }

    /**
     * 去除字符串左侧空白
     *
     * @param str 原字符串
     * @return 去除左侧空白后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.leftTrim("  hello")     // "hello"
     * StringUtils.leftTrim("hello  ")     // "hello  "
     * StringUtils.leftTrim("\thello")     // "hello"
     * StringUtils.leftTrim("")            // ""
     * ```
     */
    public static func leftTrim(str: String): String {
        if (isEmpty(str)) {
            return str
        }

        var start = 0
        while (start < str.size) {
            let ch = String.fromUtf8([str[start]])
            if (!isWhitespaceRune(ch)) {
                break
            }
            start++
        }

        if (start >= str.size) {
            return EMPTY
        }
        str[start..]
    }

    /**
     * 去除字符串右侧空白
     *
     * @param str 原字符串
     * @return 去除右侧空白后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.rightTrim("hello  ")    // "hello"
     * StringUtils.rightTrim("  hello")    // "  hello"
     * StringUtils.rightTrim("hello\t")    // "hello"
     * StringUtils.rightTrim("")           // ""
     * ```
     */
    public static func rightTrim(str: String): String {
        if (isEmpty(str)) {
            return str
        }

        var end = str.size - 1
        while (end >= 0) {
            let ch = String.fromUtf8([str[end]])
            if (!isWhitespaceRune(ch)) {
                break
            }
            end--
        }

        if (end < 0) {
            return EMPTY
        }
        str[0..(end + 1)]
    }

    /**
     * 截取分隔符之前的子串
     *
     * @param str 原字符串
     * @param separator 分隔符
     * @return 分隔符之前的子串
     *
     * 示例：
     * ```cangjie
     * StringUtils.substringBefore("hello@world", "@")    // "hello"
     * StringUtils.substringBefore("hello", "@")          // "hello"
     * StringUtils.substringBefore("@world", "@")         // ""
     * StringUtils.substringBefore("", "@")               // ""
     * ```
     */
    public static func substringBefore(str: String, separator: String): String {
        if (isEmpty(str) || isEmpty(separator)) {
            return str
        }

        let pos = indexOf(str, separator)
        if (pos == INDEX_NOT_FOUND) {
            return str
        }
        str[0..pos]
    }

    /**
     * 截取分隔符之后的子串
     *
     * @param str 原字符串
     * @param separator 分隔符
     * @return 分隔符之后的子串
     *
     * 示例：
     * ```cangjie
     * StringUtils.substringAfter("hello@world", "@")    // "world"
     * StringUtils.substringAfter("hello", "@")          // ""
     * StringUtils.substringAfter("@world", "@")         // "world"
     * StringUtils.substringAfter("", "@")               // ""
     * ```
     */
    public static func substringAfter(str: String, separator: String): String {
        if (isEmpty(str)) {
            return str
        }
        if (isEmpty(separator)) {
            return EMPTY
        }

        let pos = indexOf(str, separator)
        if (pos == INDEX_NOT_FOUND) {
            return EMPTY
        }
        str[(pos + separator.size)..]
    }

    /**
     * 截取两个分隔符之间的子串
     *
     * @param str 原字符串
     * @param open 开分隔符
     * @param close 闭分隔符
     * @return 分隔符之间的子串
     *
     * 示例：
     * ```cangjie
     * StringUtils.substringBetween("hello[world]", "[", "]")    // "world"
     * StringUtils.substringBetween("hello", "[", "]")           // ""
     * StringUtils.substringBetween("[hello]", "[", "]")         // "hello"
     * ```
     */
    public static func substringBetween(str: String, open: String, close: String): String {
        if (isEmpty(str) || isEmpty(open) || isEmpty(close)) {
            return EMPTY
        }

        let start = indexOf(str, open)
        if (start == INDEX_NOT_FOUND) {
            return EMPTY
        }

        let end = indexOf(str, close, start + open.size)
        if (end == INDEX_NOT_FOUND) {
            return EMPTY
        }

        str[(start + open.size)..end]
    }

    /**
     * 截取两个分隔符之间的子串（使用相同分隔符）
     *
     * @param str 原字符串
     * @param tag 分隔符
     * @return 分隔符之间的子串
     *
     * 示例：
     * ```cangjie
     * StringUtils.substringBetween("hello'world'", "'")    // "world"
     * StringUtils.substringBetween("hello", "'")           // ""
     * StringUtils.substringBetween("'hello'", "'")         // "hello"
     * ```
     */
    public static func substringBetween(str: String, tag: String): String {
        substringBetween(str, tag, tag)
    }

    /**
     * 检查字符串是否只包含字母字符
     *
     * @param str 待检查的字符串
     * @return 如果只包含字母返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.isAlpha("abc")      // true
     * StringUtils.isAlpha("abc123")   // false
     * StringUtils.isAlpha("")         // false
     * ```
     */
    public static func isAlpha(str: String): Bool {
        if (isEmpty(str)) {
            return false
        }

        for (byte in str) {
            // ASCII 'A' 到 'Z' 的范围是 0x41 到 0x5A
            // ASCII 'a' 到 'z' 的范围是 0x61 到 0x7A
            let isUpper = (byte >= 0x41 && byte <= 0x5A)
            let isLower = (byte >= 0x61 && byte <= 0x7A)
            if (!isUpper && !isLower) {
                return false
            }
        }
        true
    }

    /**
     * 检查字符串是否只包含数字字符
     *
     * @param str 待检查的字符串
     * @return 如果只包含数字返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.isNumeric("123")     // true
     * StringUtils.isNumeric("123abc")  // false
     * StringUtils.isNumeric("")        // false
     * ```
     */
    public static func isNumeric(str: String): Bool {
        if (isEmpty(str)) {
            return false
        }

        for (byte in str) {
            // ASCII '0' 到 '9' 的范围是 0x30 到 0x39
            if (byte < 0x30 || byte > 0x39) {
                return false
            }
        }
        true
    }

    /**
     * 检查字符串是否只包含字母和数字
     *
     * @param str 待检查的字符串
     * @return 如果只包含字母和数字返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * StringUtils.isAlphanumeric("abc123")   // true
     * StringUtils.isAlphanumeric("abc-123")  // false
     * StringUtils.isAlphanumeric("")         // false
     * ```
     */
    public static func isAlphanumeric(str: String): Bool {
        if (isEmpty(str)) {
            return false
        }

        for (byte in str) {
            // 检查是否为字母
            let isUpper = (byte >= 0x41 && byte <= 0x5A)
            let isLower = (byte >= 0x61 && byte <= 0x7A)
            let isAlpha = isUpper || isLower

            // 检查是否为数字
            let isNumeric = (byte >= 0x30 && byte <= 0x39)

            if (!isAlpha && !isNumeric) {
                return false
            }
        }
        true
    }

    // ========== Phase 12: 缩略与旋转 ==========

    /**
     * 缩略字符串
     *
     * @param str 原字符串
     * @param maxWidth 最大宽度
     * @return 缩略后的字符串
     * @throws IllegalArgumentException 如果 maxWidth < 4
     *
     * 示例：
     * ```cangjie
     * StringUtils.abbreviate("abcdefg", 6)    // "abc..."
     * StringUtils.abbreviate("abcdefg", 7)    // "abcdefg"
     * StringUtils.abbreviate("abcdefg", 4)    // "a..."
     * StringUtils.abbreviate("", 4)           // ""
     * ```
     */
    public static func abbreviate(str: String, maxWidth: Int64): String {
        if (isEmpty(str)) {
            return str
        }
        if (maxWidth < 4) {
            throw IllegalArgumentException("Minimum abbreviation width is 4")
        }
        if (str.size <= maxWidth) {
            return str
        }
        str[0..(maxWidth - 3)] + "..."
    }

    /**
     * 旋转字符串
     *
     * @param str 原字符串
     * @param shift 移动位数（正数向右移，负数向左移）
     * @return 旋转后的字符串
     *
     * 示例：
     * ```cangjie
     * StringUtils.rotate("abcdefg", 2)    // "fgabcde"
     * StringUtils.rotate("abcdefg", -2)   // "cdefgab"
     * StringUtils.rotate("abcdefg", 0)    // "abcdefg"
     * ```
     */
    public static func rotate(str: String, shift: Int64): String {
        if (isEmpty(str)) {
            return str
        }

        let runes = str.toRuneArray()
        let len = runes.size
        if (len == 0 || shift == 0) {
            return str
        }

        // 计算实际位移
        var s = shift % len
        if (s < 0) {
            s += len
        }

        if (s == 0) {
            return str
        }

        // 右移 s 位
        // 原索引 i -> 新索引 (i + s) % len
        // 或者：
        // 右移 s 位 = 把最后 s 个元素移到前面
        // 部分1：runes[(len-s)..len]
        // 部分2：runes[0..(len-s)]

        var result = StringBuilder()

        // 拼接后半部分（移到前面的）
        for (i in (len - s)..len) {
            result.append(runes[i])
        }

        // 拼接前半部分（移到后面的）
        for (i in 0..(len - s)) {
            result.append(runes[i])
        }

        result.toString()
    }

    // ========== 私有辅助方法 ==========

    /**
     * 判断单个字符是否为空白字符
     *
     * @param rune 单个字符的字符串表示
     * @return 如果是空白字符返回 true，否则返回 false
     */
    private static func isWhitespaceRune(rune: String): Bool {
        // 空白字符：空格(0x20)、制表符(0x09)、换行符(0x0A)、回车符(0x0D)、垂直制表符(0x0B)、换页符(0x0C)
        if (rune.size == 0) {
            return false
        }

        let byte = rune[0]
        byte == 0x20 || byte == 0x09 || byte == 0x0A || byte == 0x0D || byte == 0x0B || byte == 0x0C
    }
}
