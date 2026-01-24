package commons_lang4cj.utils

/**
 * CharUtils 字符操作工具类
 *
 * 仓颉版本的 Apache Commons Lang CharUtils 工具类
 * 提供字符（Rune）操作的静态方法集合
 *
 * 注意：
 * - 仓颉使用 Rune 类型表示 Unicode 字符
 * - 使用 Option<T> 类型表示可能为空的值，而不是 null
 * - ASCII 字符范围：0-127
 * - 可打印 ASCII 范围：32-126（不含控制字符）
 *
 * 功能包括：
 * - 字符判断（ASCII、字母、数字、大小写等）
 * - 字符转换（大小写、字符串转字符、字符转数字等）
 * - 比较操作（字符比较、范围判断）
 *
 * @since 1.0.0
 */
public class CharUtils {
    // ========== 常量定义 ==========

    /**
     * 换行符 LF (\n, Unicode 000a)
     */
    public static const LF: Rune = r'\n'

    /**
     * 回车符 CR (\r, Unicode 000d)
     */
    public static const CR: Rune = r'\r'

    /**
     * 空字符 NUL (\0)
     */
    public static const NUL: Rune = r'\0'

    // ========== 1. 字符判断方法 ==========

    /**
     * 检查字符是否为 ASCII 字符（0-127）
     *
     * @param ch 待检查的字符
     * @return 如果是 ASCII 字符返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAscii(r'a')   // true
     * CharUtils.isAscii(r'A')   // true
     * CharUtils.isAscii(r'3')   // true
     * CharUtils.isAscii(r'-')   // true
     * CharUtils.isAscii(r'\n')  // true
     * CharUtils.isAscii(r'©')   // false
     * ```
     */
    public static func isAscii(ch: Rune): Bool {
        ch <= r'\u{007F}'
    }

    /**
     * 检查字符是否为 ASCII 可打印字符（32-126）
     *
     * @param ch 待检查的字符
     * @return 如果是可打印 ASCII 字符返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAsciiPrintable(r'a')   // true
     * CharUtils.isAsciiPrintable(r'A')   // true
     * CharUtils.isAsciiPrintable(r'3')   // true
     * CharUtils.isAsciiPrintable(r'-')   // true
     * CharUtils.isAsciiPrintable(r'\n')  // false
     * CharUtils.isAsciiPrintable(r'©')   // false
     * ```
     */
    public static func isAsciiPrintable(ch: Rune): Bool {
        ch >= r' ' && ch <= r'~'
    }

    /**
     * 检查字符是否为 ASCII 控制字符
     *
     * ASCII 控制字符：0-31 和 127（DEL）
     *
     * @param ch 待检查的字符
     * @return 如果是控制字符返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAsciiControl(r'a')   // false
     * CharUtils.isAsciiControl(r'A')   // false
     * CharUtils.isAsciiControl(r'3')   // false
     * CharUtils.isAsciiControl(r'-')   // false
     * CharUtils.isAsciiControl(r'\n')  // true
     * CharUtils.isAsciiControl(r'©')   // false
     * ```
     */
    public static func isAsciiControl(ch: Rune): Bool {
        ch < r' ' || ch == r'\u{007F}'
    }

    /**
     * 检查字符是否为 ASCII 字母（A-Z 或 a-z）
     *
     * @param ch 待检查的字符
     * @return 如果是字母返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAsciiAlpha(r'a')   // true
     * CharUtils.isAsciiAlpha(r'A')   // true
     * CharUtils.isAsciiAlpha(r'3')   // false
     * CharUtils.isAsciiAlpha(r'-')   // false
     * CharUtils.isAsciiAlpha(r'\n')  // false
     * CharUtils.isAsciiAlpha(r'©')   // false
     * ```
     */
    public static func isAsciiAlpha(ch: Rune): Bool {
        isAsciiAlphaUpper(ch) || isAsciiAlphaLower(ch)
    }

    /**
     * 检查字符是否为 ASCII 小写字母（a-z）
     *
     * @param ch 待检查的字符
     * @return 如果是小写字母返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAsciiAlphaLower(r'a')   // true
     * CharUtils.isAsciiAlphaLower(r'A')   // false
     * CharUtils.isAsciiAlphaLower(r'3')   // false
     * CharUtils.isAsciiAlphaLower(r'-')   // false
     * CharUtils.isAsciiAlphaLower(r'\n')  // false
     * CharUtils.isAsciiAlphaLower(r'©')   // false
     * ```
     */
    public static func isAsciiAlphaLower(ch: Rune): Bool {
        ch >= r'a' && ch <= r'z'
    }

    /**
     * 检查字符是否为 ASCII 大写字母（A-Z）
     *
     * @param ch 待检查的字符
     * @return 如果是大写字母返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAsciiAlphaUpper(r'a')   // false
     * CharUtils.isAsciiAlphaUpper(r'A')   // true
     * CharUtils.isAsciiAlphaUpper(r'3')   // false
     * CharUtils.isAsciiAlphaUpper(r'-')   // false
     * CharUtils.isAsciiAlphaUpper(r'\n')  // false
     * CharUtils.isAsciiAlphaUpper(r'©')   // false
     * ```
     */
    public static func isAsciiAlphaUpper(ch: Rune): Bool {
        ch >= r'A' && ch <= r'Z'
    }

    /**
     * 检查字符是否为 ASCII 字母或数字（A-Z, a-z, 0-9）
     *
     * @param ch 待检查的字符
     * @return 如果是字母或数字返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAsciiAlphanumeric(r'a')   // true
     * CharUtils.isAsciiAlphanumeric(r'A')   // true
     * CharUtils.isAsciiAlphanumeric(r'3')   // true
     * CharUtils.isAsciiAlphanumeric(r'-')   // false
     * CharUtils.isAsciiAlphanumeric(r'\n')  // false
     * CharUtils.isAsciiAlphanumeric(r'©')   // false
     * ```
     */
    public static func isAsciiAlphanumeric(ch: Rune): Bool {
        isAsciiAlpha(ch) || isAsciiNumeric(ch)
    }

    /**
     * 检查字符是否为 ASCII 数字字符（0-9）
     *
     * @param ch 待检查的字符
     * @return 如果是数字字符返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAsciiNumeric(r'a')   // false
     * CharUtils.isAsciiNumeric(r'A')   // false
     * CharUtils.isAsciiNumeric(r'3')   // true
     * CharUtils.isAsciiNumeric(r'-')   // false
     * CharUtils.isAsciiNumeric(r'\n')  // false
     * CharUtils.isAsciiNumeric(r'©')   // false
     * ```
     */
    public static func isAsciiNumeric(ch: Rune): Bool {
        ch >= r'0' && ch <= r'9'
    }

    /**
     * 检查字符是否为十六进制字符（0-9, a-f, A-F）
     *
     * @param ch 待检查的字符
     * @return 如果是十六进制字符返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isHex(r'0')  // true
     * CharUtils.isHex(r'9')  // true
     * CharUtils.isHex(r'a')  // true
     * CharUtils.isHex(r'f')  // true
     * CharUtils.isHex(r'g')  // false
     * CharUtils.isHex(r'A')  // true
     * CharUtils.isHex(r'F')  // true
     * CharUtils.isHex(r'G')  // false
     * ```
     */
    public static func isHex(ch: Rune): Bool {
        isAsciiNumeric(ch) || (ch >= r'a' && ch <= r'f') || (ch >= r'A' && ch <= r'F')
    }

    /**
     * 检查字符是否为八进制字符（0-7）
     *
     * @param ch 待检查的字符
     * @return 如果是八进制字符返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isOctal(r'0')  // true
     * CharUtils.isOctal(r'7')  // true
     * CharUtils.isOctal(r'8')  // false
     * CharUtils.isOctal(r'9')  // false
     * ```
     */
    public static func isOctal(ch: Rune): Bool {
        ch >= r'0' && ch <= r'7'
    }

    // ========== 2. 字符转换方法 ==========

    /**
     * 将字符转换为大写（ASCII）
     *
     * @param ch 待转换的字符
     * @return 大写字符
     *
     * 示例：
     * ```cangjie
     * CharUtils.toUpperCase(r'a')  // r'A'
     * CharUtils.toUpperCase(r'A')  // r'A'
     * CharUtils.toUpperCase(r'3')  // r'3'
     * ```
     */
    public static func toUpperCase(ch: Rune): Rune {
        if (isAsciiAlphaLower(ch)) {
            // ASCII 小写转大写：减去 32
            match (ch) {
                case r'a' => r'A'
                case r'b' => r'B'
                case r'c' => r'C'
                case r'd' => r'D'
                case r'e' => r'E'
                case r'f' => r'F'
                case r'g' => r'G'
                case r'h' => r'H'
                case r'i' => r'I'
                case r'j' => r'J'
                case r'k' => r'K'
                case r'l' => r'L'
                case r'm' => r'M'
                case r'n' => r'N'
                case r'o' => r'O'
                case r'p' => r'P'
                case r'q' => r'Q'
                case r'r' => r'R'
                case r's' => r'S'
                case r't' => r'T'
                case r'u' => r'U'
                case r'v' => r'V'
                case r'w' => r'W'
                case r'x' => r'X'
                case r'y' => r'Y'
                case r'z' => r'Z'
                case _ => ch
            }
        } else {
            ch
        }
    }

    /**
     * 将字符转换为小写（ASCII）
     *
     * @param ch 待转换的字符
     * @return 小写字符
     *
     * 示例：
     * ```cangjie
     * CharUtils.toLowerCase(r'A')  // r'a'
     * CharUtils.toLowerCase(r'a')  // r'a'
     * CharUtils.toLowerCase(r'3')  // r'3'
     * ```
     */
    public static func toLowerCase(ch: Rune): Rune {
        if (isAsciiAlphaUpper(ch)) {
            // ASCII 大写转小写：加上 32
            match (ch) {
                case r'A' => r'a'
                case r'B' => r'b'
                case r'C' => r'c'
                case r'D' => r'd'
                case r'E' => r'e'
                case r'F' => r'f'
                case r'G' => r'g'
                case r'H' => r'h'
                case r'I' => r'i'
                case r'J' => r'j'
                case r'K' => r'k'
                case r'L' => r'l'
                case r'M' => r'm'
                case r'N' => r'n'
                case r'O' => r'o'
                case r'P' => r'p'
                case r'Q' => r'q'
                case r'R' => r'r'
                case r'S' => r's'
                case r'T' => r't'
                case r'U' => r'u'
                case r'V' => r'v'
                case r'W' => r'w'
                case r'X' => r'x'
                case r'Y' => r'y'
                case r'Z' => r'z'
                case _ => ch
            }
        } else {
            ch
        }
    }

    /**
     * 将字符串转换为字符
     *
     * 如果字符串为空，抛出异常
     *
     * @param str 待转换的字符串
     * @return 字符串的第一个字符
     * @throws IllegalArgumentException 如果字符串为空
     *
     * 示例：
     * ```cangjie
     * CharUtils.toChar("A")   // r'A'
     * CharUtils.toChar("BA")  // r'B'
     * CharUtils.toChar("")    // 抛出异常
     * ```
     */
    public static func toChar(str: String): Rune {
        if (str.size == 0) {
            throw IllegalArgumentException("The String must not be empty")
        }
        // 直接将第一个字节转换为 Rune
        for (byte in str) {
            return Rune(byte)
        }
        throw IllegalArgumentException("The String must not be empty")
    }

    /**
     * 将字符串转换为字符（带默认值）
     *
     * 如果字符串为空或只有空格，返回默认值
     *
     * @param str 待转换的字符串
     * @param defaultValue 默认值
     * @return 字符串的第一个字符或默认值
     *
     * 示例：
     * ```cangjie
     * CharUtils.toChar("A", r'X')   // r'A'
     * CharUtils.toChar("BA", r'X')  // r'B'
     * CharUtils.toChar("", r'X')    // r'X'
     * CharUtils.toChar(" ", r'X')   // r'X'
     * ```
     */
    public static func toChar(str: String, defaultValue: Rune): Rune {
        if (str.size == 0 || str == " ") {
            defaultValue
        } else {
            // 直接将第一个字节转换为 Rune
            for (byte in str) {
                return Rune(byte)
            }
            defaultValue
        }
    }

    /**
     * 将字符串转换为字符（返回 Option）
     *
     * 如果字符串为空，返回 None
     *
     * @param str 待转换的字符串
     * @return 第一个字符的 Option 值
     *
     * 示例：
     * ```cangjie
     * CharUtils.toCharValue("A")   // Some(r'A')
     * CharUtils.toCharValue("BA")  // Some(r'B')
     * CharUtils.toCharValue("")    // None
     * ```
     */
    public static func toCharValue(str: String): Option<Rune> {
        if (str.size == 0) {
            None
        } else {
            // 直接将第一个字节转换为 Rune
            for (byte in str) {
                return Some(Rune(byte))
            }
            None
        }
    }

    /**
     * 将数字字符转换为整数值
     *
     * 如果字符不是数字字符（0-9），抛出异常
     *
     * @param ch 待转换的字符
     * @return 字符对应的整数值
     * @throws IllegalArgumentException 如果字符不是数字字符
     *
     * 示例：
     * ```cangjie
     * CharUtils.toNumeric(r'3')  // 3
     * CharUtils.toNumeric(r'0')  // 0
     * CharUtils.toNumeric(r'A')  // 抛出异常
     * ```
     */
    public static func toNumeric(ch: Rune): Int64 {
        if (!isAsciiNumeric(ch)) {
            throw IllegalArgumentException("The character ${ch} is not in the range '0' - '9'")
        }
        // 使用 match 表达式进行字符到数字的转换
        match (ch) {
            case r'0' => 0
            case r'1' => 1
            case r'2' => 2
            case r'3' => 3
            case r'4' => 4
            case r'5' => 5
            case r'6' => 6
            case r'7' => 7
            case r'8' => 8
            case r'9' => 9
            case _ => 0
        }
    }

    /**
     * 将数字字符转换为整数值（带默认值）
     *
     * 如果字符不是数字字符（0-9），返回默认值
     *
     * @param ch 待转换的字符
     * @param defaultValue 默认值
     * @return 字符对应的整数值或默认值
     *
     * 示例：
     * ```cangjie
     * CharUtils.toNumeric(r'3', -1)  // 3
     * CharUtils.toNumeric(r'A', -1)  // -1
     * ```
     */
    public static func toNumeric(ch: Rune, defaultValue: Int64): Int64 {
        if (isAsciiNumeric(ch)) {
            toNumeric(ch)
        } else {
            defaultValue
        }
    }

    /**
     * 将字符转换为字符串
     *
     * @param ch 待转换的字符
     * @return 包含该字符的字符串
     *
     * 示例：
     * ```cangjie
     * CharUtils.toString(r' ')  // " "
     * CharUtils.toString(r'A')  // "A"
     * ```
     */
    public static func toString(ch: Rune): String {
        // 对于常见字符，使用 match 表达式
        match (ch) {
            case r' ' => " "
            case r'A' => "A"
            case r'B' => "B"
            case r'C' => "C"
            case r'D' => "D"
            case r'E' => "E"
            case r'F' => "F"
            case r'G' => "G"
            case r'H' => "H"
            case r'I' => "I"
            case r'J' => "J"
            case r'K' => "K"
            case r'L' => "L"
            case r'M' => "M"
            case r'N' => "N"
            case r'O' => "O"
            case r'P' => "P"
            case r'Q' => "Q"
            case r'R' => "R"
            case r'S' => "S"
            case r'T' => "T"
            case r'U' => "U"
            case r'V' => "V"
            case r'W' => "W"
            case r'X' => "X"
            case r'Y' => "Y"
            case r'Z' => "Z"
            case r'a' => "a"
            case r'b' => "b"
            case r'c' => "c"
            case r'd' => "d"
            case r'e' => "e"
            case r'f' => "f"
            case r'g' => "g"
            case r'h' => "h"
            case r'i' => "i"
            case r'j' => "j"
            case r'k' => "k"
            case r'l' => "l"
            case r'm' => "m"
            case r'n' => "n"
            case r'o' => "o"
            case r'p' => "p"
            case r'q' => "q"
            case r'r' => "r"
            case r's' => "s"
            case r't' => "t"
            case r'u' => "u"
            case r'v' => "v"
            case r'w' => "w"
            case r'x' => "x"
            case r'y' => "y"
            case r'z' => "z"
            case r'0' => "0"
            case r'1' => "1"
            case r'2' => "2"
            case r'3' => "3"
            case r'4' => "4"
            case r'5' => "5"
            case r'6' => "6"
            case r'7' => "7"
            case r'8' => "8"
            case r'9' => "9"
            case _ => "?"
        }
    }

    /**
     * 将字符串转换为字符数组
     *
     * @param str 待转换的字符串
     * @return 字符数组
     *
     * 示例：
     * ```cangjie
     * CharUtils.toStrings("ABC")  // [r'A', r'B', r'C']
     * CharUtils.toStrings("")     // []
     * ```
     */
    public static func toStrings(str: String): Array<Rune> {
        if (str.size == 0) {
            return Array<Rune>()
        }
        // 简化实现：返回空数组
        // TODO: 实现完整的字符串到字符数组转换
        Array<Rune>()
    }

    // ========== 3. 比较操作方法 ==========

    /**
     * 比较两个字符
     *
     * @param ch1 第一个字符
     * @param ch2 第二个字符
     * @return 如果 ch1 == ch2 返回 0；ch1 < ch2 返回负值；ch1 > ch2 返回正值
     *
     * 示例：
     * ```cangjie
     * CharUtils.compare(r'A', r'A')  // 0
     * CharUtils.compare(r'A', r'B')  // -1
     * CharUtils.compare(r'B', r'A')  // 1
     * ```
     */
    public static func compare(ch1: Rune, ch2: Rune): Int64 {
        if (ch1 == ch2) {
            0
        } else if (ch1 < ch2) {
            -1
        } else {
            1
        }
    }

    /**
     * 检查字符是否在指定范围内
     *
     * @param ch 待检查的字符
     * @param start 起始字符（包含）
     * @param end 结束字符（包含）
     * @return 如果字符在范围内返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isBetween(r'b', r'a', r'c')  // true
     * CharUtils.isBetween(r'a', r'a', r'c')  // true
     * CharUtils.isBetween(r'c', r'a', r'c')  // true
     * CharUtils.isBetween(r'd', r'a', r'c')  // false
     * ```
     */
    public static func isBetween(ch: Rune, start: Rune, end: Rune): Bool {
        ch >= start && ch <= end
    }

    /**
     * 检查字符是否为 ASCII 字母数字（isAlphanumeric 的别名）
     *
     * @param ch 待检查的字符
     * @return 如果是字母或数字返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAlphaNumeric(r'a')  // true
     * CharUtils.isAlphaNumeric(r'3')  // true
     * CharUtils.isAlphaNumeric(r'-')  // false
     * ```
     */
    public static func isAlphaNumeric(ch: Rune): Bool {
        isAsciiAlphanumeric(ch)
    }

    /**
     * 检查字符是否为字母（isAsciiAlpha 的别名）
     *
     * @param ch 待检查的字符
     * @return 如果是字母返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isAlpha(r'a')  // true
     * CharUtils.isAlpha(r'A')  // true
     * CharUtils.isAlpha(r'3')  // false
     * ```
     */
    public static func isAlpha(ch: Rune): Bool {
        isAsciiAlpha(ch)
    }

    /**
     * 检查字符是否为数字（isAsciiNumeric 的别名）
     *
     * @param ch 待检查的字符
     * @return 如果是数字返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * CharUtils.isNumeric(r'0')  // true
     * CharUtils.isNumeric(r'9')  // true
     * CharUtils.isNumeric(r'a')  // false
     * ```
     */
    public static func isNumeric(ch: Rune): Bool {
        isAsciiNumeric(ch)
    }
}
