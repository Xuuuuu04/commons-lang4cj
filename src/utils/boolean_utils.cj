package commons_lang4cj.utils

/**
 * BooleanUtils - 布尔值操作工具类
 *
 * 提供布尔值（Bool）的各种操作，包括：
 * - 基本比较操作（isTrue, isFalse, isNotTrue, isNotFalse, negate）
 * - 字符串转换（toBoolean, toString 等）
 * - 整数转换（toInteger）
 * - 逻辑运算（and, or, xor, nand）
 * - 数组操作（对数组进行逻辑运算）
 * - 比较操作（compare）
 *
 * 本工具类适配仓颉语言特性，使用 Option<T> 处理可能的空值情况。
 *
 * @since 1.0.0
 */
public class BooleanUtils {
    /**
     * 字符串常量：表示 false
     */
    public static const FALSE: String = "false"

    /**
     * 字符串常量：表示 no
     */
    public static const NO: String = "no"

    /**
     * 字符串常量：表示 off
     */
    public static const OFF: String = "off"

    /**
     * 字符串常量：表示 on
     */
    public static const ON: String = "on"

    /**
     * 字符串常量：表示 true
     */
    public static const TRUE: String = "true"

    /**
     * 字符串常量：表示 yes
     */
    public static const YES: String = "yes"

    /**
     * 私有构造函数，防止实例化
     */
    private init() {}

    // ==================== 基本比较操作 ====================

    /**
     * 检查布尔值是否为 true
     *
     * <pre>
     *   BooleanUtils.isTrue(true)     = true
     *   BooleanUtils.isTrue(false)    = false
     * </pre>
     *
     * @param bool 要检查的布尔值
     * @return 如果布尔值为 true 则返回 true，否则返回 false
     */
    public static func isTrue(bool: Bool): Bool {
        bool
    }

    /**
     * 检查布尔值是否为 false
     *
     * <pre>
     *   BooleanUtils.isFalse(true)    = false
     *   BooleanUtils.isFalse(false)   = true
     * </pre>
     *
     * @param bool 要检查的布尔值
     * @return 如果布尔值为 false 则返回 true，否则返回 false
     */
    public static func isFalse(bool: Bool): Bool {
        !bool
    }

    /**
     * 检查布尔值是否不为 true（等同于 isFalse）
     *
     * <pre>
     *   BooleanUtils.isNotTrue(true)  = false
     *   BooleanUtils.isNotTrue(false) = true
     * </pre>
     *
     * @param bool 要检查的布尔值
     * @return 如果布尔值不为 true 则返回 true，否则返回 false
     */
    public static func isNotTrue(bool: Bool): Bool {
        !bool
    }

    /**
     * 检查布尔值是否不为 false（等同于 isTrue）
     *
     * <pre>
     *   BooleanUtils.isNotFalse(true)  = true
     *   BooleanUtils.isNotFalse(false) = false
     * </pre>
     *
     * @param bool 要检查的布尔值
     * @return 如果布尔值不为 false 则返回 true，否则返回 false
     */
    public static func isNotFalse(bool: Bool): Bool {
        bool
    }

    /**
     * 对布尔值取反
     *
     * <pre>
     *   BooleanUtils.negate(true)  = false
     *   BooleanUtils.negate(false) = true
     * </pre>
     *
     * @param bool 要取反的布尔值
     * @return 取反后的布尔值
     */
    public static func negate(bool: Bool): Bool {
        !bool
    }

    // ==================== 字符串转换 ====================

    /**
     * 将字符串转换为布尔值
     *
     * <p>支持以下字符串（忽略大小写）：</p>
     * <ul>
     *   <li>true 值: "true", "on", "yes", "y", "t", "1"</li>
     *   <li>false 值: "false", "off", "no", "n", "f", "0"</li>
     * </ul>
     *
     * <pre>
     *   BooleanUtils.toBoolean("true")   = true
     *   BooleanUtils.toBoolean("TRUE")   = true
     *   BooleanUtils.toBoolean("yes")    = true
     *   BooleanUtils.toBoolean("on")     = true
     *   BooleanUtils.toBoolean("1")      = true
     *   BooleanUtils.toBoolean("false")  = false
     *   BooleanUtils.toBoolean("no")     = false
     *   BooleanUtils.toBoolean("0")      = false
     *   BooleanUtils.toBoolean("invalid") = false
     * </pre>
     *
     * @param str 要转换的字符串
     * @return 如果字符串匹配 true 值则返回 true，否则返回 false
     */
    public static func toBoolean(str: String): Bool {
        match (toBooleanObject(str)) {
            case Some(v) => v
            case None => false
        }
    }

    /**
     * 将字符串转换为布尔值（带默认值）
     *
     * <p>支持以下字符串（忽略大小写）：</p>
     * <ul>
     *   <li>true 值: "true", "on", "yes", "y", "t", "1"</li>
     *   <li>false 值: "false", "off", "no", "n", "f", "0"</li>
     * </ul>
     *
     * <pre>
     *   BooleanUtils.toBoolean("true", false)   = true
     *   BooleanUtils.toBoolean("invalid", false) = false
     *   BooleanUtils.toBoolean("invalid", true)  = true
     * </pre>
     *
     * @param str 要转换的字符串
     * @param defaultValue 当字符串无法匹配时的默认值
     * @return 如果字符串匹配 true/false 值则返回对应值，否则返回默认值
     */
    public static func toBoolean(str: String, defaultValue: Bool): Bool {
        match (toBooleanObject(str)) {
            case Some(v) => v
            case None => defaultValue
        }
    }

    /**
     * 将字符串转换为布尔值（返回 Option 类型）
     *
     * <p>支持以下字符串（忽略大小写）：</p>
     * <ul>
     *   <li>true 值: "true", "on", "yes", "y", "t", "1"</li>
     *   <li>false 值: "false", "off", "no", "n", "f", "0"</li>
     * </ul>
     *
     * <pre>
     *   BooleanUtils.toBooleanObject("true")   = Some(true)
     *   BooleanUtils.toBooleanObject("false")  = Some(false)
     *   BooleanUtils.toBooleanObject("invalid") = None
     * </pre>
     *
     * @param str 要转换的字符串
     * @return Some(true) 如果字符串匹配 true 值，Some(false) 如果匹配 false 值，None 如果不匹配
     */
    public static func toBooleanObject(str: String): Option<Bool> {
        if (str.size == 0) {
            return None
        }

        // 仓颉 1.0.4 没有 toLowercase()，使用等价比较
        // 手动实现不区分大小写的字符串比较

        // 检查 true 值（支持大小写）
        let isTrue = compareIgnoreCase(str, "true") ||
                     compareIgnoreCase(str, "on") ||
                     compareIgnoreCase(str, "yes") ||
                     compareIgnoreCase(str, "y") ||
                     compareIgnoreCase(str, "t") ||
                     str == "1"

        if (isTrue) {
            return Some(true)
        }

        // 检查 false 值（支持大小写）
        let isFalse = compareIgnoreCase(str, "false") ||
                      compareIgnoreCase(str, "off") ||
                      compareIgnoreCase(str, "no") ||
                      compareIgnoreCase(str, "n") ||
                      compareIgnoreCase(str, "f") ||
                      str == "0"

        if (isFalse) {
            return Some(false)
        }

        None
    }

    /**
     * 辅助方法：不区分大小写的字符串比较
     */
    private static func compareIgnoreCase(str1: String, str2: String): Bool {
        if (str1.size != str2.size) {
            return false
        }

        // 逐字节比较（ASCII 范围内）
        for (i in 0..str1.size) {
            let c1 = str1[i]
            let c2 = str2[i]

            // 转换为小写比较
            let lower1 = if (c1 >= 65u8 && c1 <= 90u8) { c1 + 32u8 } else { c1 }
            let lower2 = if (c2 >= 65u8 && c2 <= 90u8) { c2 + 32u8 } else { c2 }

            if (lower1 != lower2) {
                return false
            }
        }

        true
    }

    /**
     * 将布尔值转换为字符串 "true" 或 "false"
     *
     * <pre>
     *   BooleanUtils.toString(true)  = "true"
     *   BooleanUtils.toString(false) = "false"
     * </pre>
     *
     * @param bool 要转换的布尔值
     * @return "true" 或 "false"
     */
    public static func toString(bool: Bool): String {
        if (bool) {
            TRUE
        } else {
            FALSE
        }
    }

    /**
     * 将布尔值转换为字符串 "on" 或 "off"
     *
     * <pre>
     *   BooleanUtils.toStringOnOff(true)  = "on"
     *   BooleanUtils.toStringOnOff(false) = "off"
     * </pre>
     *
     * @param bool 要转换的布尔值
     * @return "on" 或 "off"
     */
    public static func toStringOnOff(bool: Bool): String {
        if (bool) {
            ON
        } else {
            OFF
        }
    }

    /**
     * 将布尔值转换为字符串 "yes" 或 "no"
     *
     * <pre>
     *   BooleanUtils.toStringYesNo(true)  = "yes"
     *   BooleanUtils.toStringYesNo(false) = "no"
     * </pre>
     *
     * @param bool 要转换的布尔值
     * @return "yes" 或 "no"
     */
    public static func toStringYesNo(bool: Bool): String {
        if (bool) {
            YES
        } else {
            NO
        }
    }

    // ==================== 整数转换 ====================

    /**
     * 将整数转换为布尔值（非零为 true，零为 false）
     *
     * <pre>
     *   BooleanUtils.toBoolean(0) = false
     *   BooleanUtils.toBoolean(1) = true
     *   BooleanUtils.toBoolean(-1) = true
     *   BooleanUtils.toBoolean(2) = true
     * </pre>
     *
     * @param value 要转换的整数
     * @return 如果非零返回 true，否则返回 false
     */
    public static func toBoolean(value: Int64): Bool {
        value != 0
    }

    /**
     * 将布尔值转换为整数（true=1, false=0）
     *
     * <pre>
     *   BooleanUtils.toInteger(true)  = 1
     *   BooleanUtils.toInteger(false) = 0
     * </pre>
     *
     * @param bool 要转换的布尔值
     * @return 1 或 0
     */
    public static func toInteger(bool: Bool): Int64 {
        if (bool) {
            1
        } else {
            0
        }
    }

    // ==================== 逻辑运算 ====================

    /**
     * 对两个布尔值进行逻辑与运算
     *
     * <pre>
     *   BooleanUtils.and(true, true)    = true
     *   BooleanUtils.and(true, false)   = false
     *   BooleanUtils.and(false, true)   = false
     *   BooleanUtils.and(false, false)  = false
     * </pre>
     *
     * @param bool1 第一个布尔值
     * @param bool2 第二个布尔值
     * @return 逻辑与的结果
     */
    public static func and(bool1: Bool, bool2: Bool): Bool {
        bool1 && bool2
    }

    /**
     * 对两个布尔值进行逻辑或运算
     *
     * <pre>
     *   BooleanUtils.or(true, true)    = true
     *   BooleanUtils.or(true, false)   = true
     *   BooleanUtils.or(false, true)   = true
     *   BooleanUtils.or(false, false)  = false
     * </pre>
     *
     * @param bool1 第一个布尔值
     * @param bool2 第二个布尔值
     * @return 逻辑或的结果
     */
    public static func or(bool1: Bool, bool2: Bool): Bool {
        bool1 || bool2
    }

    /**
     * 对两个布尔值进行逻辑异或运算
     *
     * <pre>
     *   BooleanUtils.xor(true, true)    = false
     *   BooleanUtils.xor(true, false)   = true
     *   BooleanUtils.xor(false, true)   = true
     *   BooleanUtils.xor(false, false)  = false
     * </pre>
     *
     * @param bool1 第一个布尔值
     * @param bool2 第二个布尔值
     * @return 逻辑异或的结果
     */
    public static func xor(bool1: Bool, bool2: Bool): Bool {
        (bool1 && !bool2) || (!bool1 && bool2)
    }

    /**
     * 对两个布尔值进行与非运算（与运算后取反）
     *
     * <pre>
     *   BooleanUtils.nand(true, true)    = false
     *   BooleanUtils.nand(true, false)   = true
     *   BooleanUtils.nand(false, true)   = true
     *   BooleanUtils.nand(false, false)  = true
     * </pre>
     *
     * @param bool1 第一个布尔值
     * @param bool2 第二个布尔值
     * @return 与非运算的结果
     */
    public static func nand(bool1: Bool, bool2: Bool): Bool {
        !(bool1 && bool2)
    }

    // ==================== 数组操作 ====================

    /**
     * 对布尔数组进行全部与运算（所有元素都为 true 才返回 true）
     *
     * <pre>
     *   BooleanUtils.and([true, true, true])    = true
     *   BooleanUtils.and([true, false, true])   = false
     *   BooleanUtils.and([false, false, false])  = false
     *   BooleanUtils.and([])                    = true  (空数组返回 true)
     * </pre>
     *
     * @param array 布尔数组
     * @return 如果所有元素都为 true 则返回 true，否则返回 false
     */
    public static func and(array: Array<Bool>): Bool {
        if (array.size == 0) {
            return true  // 空数组返回 true（与运算的单位元）
        }

        for (elem in array) {
            if (!elem) {
                return false
            }
        }
        true
    }

    /**
     * 对布尔数组进行全部或运算（任意元素为 true 即返回 true）
     *
     * <pre>
     *   BooleanUtils.or([true, true, true])    = true
     *   BooleanUtils.or([true, false, true])   = true
     *   BooleanUtils.or([false, false, false])  = false
     *   BooleanUtils.or([])                    = false  (空数组返回 false)
     * </pre>
     *
     * @param array 布尔数组
     * @return 如果任意元素为 true 则返回 true，否则返回 false
     */
    public static func or(array: Array<Bool>): Bool {
        if (array.size == 0) {
            return false  // 空数组返回 false（或运算的单位元）
        }

        for (elem in array) {
            if (elem) {
                return true
            }
        }
        false
    }

    /**
     * 对布尔数组进行全部异或运算（true 的个数为奇数时返回 true）
     *
     * <pre>
     *   BooleanUtils.xor([true, true])           = false
     *   BooleanUtils.xor([true, false])          = true
     *   BooleanUtils.xor([false, false])         = false
     *   BooleanUtils.xor([true, true, true])     = true
     *   BooleanUtils.xor([true, false, false])   = true
     *   BooleanUtils.xor([])                     = false  (空数组返回 false)
     * </pre>
     *
     * @param array 布尔数组
     * @return 如果 true 的个数为奇数则返回 true，否则返回 false
     */
    public static func xor(array: Array<Bool>): Bool {
        if (array.size == 0) {
            return false  // 空数组返回 false
        }

        var result = false
        for (elem in array) {
            result = result != elem  // XOR 操作
        }
        result
    }

    /**
     * 统计数组中 true 的数量
     *
     * <pre>
     *   BooleanUtils.countTrue([true, false, true]) = 2
     *   BooleanUtils.countTrue([false, false])       = 0
     *   BooleanUtils.countTrue([true, true])         = 2
     * </pre>
     *
     * @param array 布尔数组
     * @return true 的数量
     */
    public static func countTrue(array: Array<Bool>): Int64 {
        var count = 0
        for (elem in array) {
            if (elem) {
                count++
            }
        }
        count
    }

    /**
     * 统计数组中 false 的数量
     *
     * <pre>
     *   BooleanUtils.countFalse([true, false, true]) = 1
     *   BooleanUtils.countFalse([false, false])       = 2
     *   BooleanUtils.countFalse([true, true])         = 0
     * </pre>
     *
     * @param array 布尔数组
     * @return false 的数量
     */
    public static func countFalse(array: Array<Bool>): Int64 {
        var count = 0
        for (elem in array) {
            if (!elem) {
                count++
            }
        }
        count
    }

    // ==================== 比较操作 ====================

    /**
     * 比较两个布尔值（false < true）
     *
     * <pre>
     *   BooleanUtils.compare(true, true)    = 0
     *   BooleanUtils.compare(false, false)  = 0
     *   BooleanUtils.compare(true, false)   = 1 (true > false)
     *   BooleanUtils.compare(false, true)   = -1 (false < true)
     * </pre>
     *
     * @param bool1 第一个布尔值
     * @param bool2 第二个布尔值
     * @return 0 如果相等，负数如果 bool1 < bool2，正数如果 bool1 > bool2
     */
    public static func compare(bool1: Bool, bool2: Bool): Int64 {
        if (bool1 == bool2) {
            0
        } else if (bool1) {
            1
        } else {
            -1
        }
    }
}

