package commons_lang4cj.utils

import std.convert.*
import std.regex.*

/**
 * NumberUtils 数字工具类
 *
 * 仓颉版本的 Apache Commons Lang NumberUtils 工具类
 * 提供数字操作的静态方法集合
 *
 * 功能包括：
 * - 字符串转数字（ToInt/ToLong/ToFloat/ToDouble）
 * - 数字判断（IsDigits/IsNumber/IsParsable/IsCreatable）
 * - 比较操作（Compare/Min/Max）
 * - 范围检查（IsBetween/InRange）
 * - 类型转换（ToByte/ToShort/ToInt/ToLong/ToFloat）
 * - 额外实用方法（Clamp/IsEven/IsOdd/Sum/Max/Min）
 *
 * @since 1.0.0
 */
public class NumberUtils {
    /**
     * 字节数值范围
     */
    public static const BYTE_MIN_VALUE: Int64 = -128
    public static const BYTE_MAX_VALUE: Int64 = 127

    /**
     * 短整数数值范围
     */
    public static const SHORT_MIN_VALUE: Int64 = -32768
    public static const SHORT_MAX_VALUE: Int64 = 32767

    /**
     * 整数数值范围
     */
    public static const INT_MIN_VALUE: Int64 = -2147483648
    public static const INT_MAX_VALUE: Int64 = 2147483647

    // ========== Phase 1: 字符串转数字 ==========

    /**
     * 将字符串转换为整数
     *
     * 支持十进制、十六进制(0x开头)、八进制(0开头)格式
     *
     * @param str 待转换的字符串
     * @return 转换成功返回 Some(Int64)，失败返回 None
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toInt("123")       // Some(123)
     * NumberUtils.toInt("0xFF")      // Some(255)
     * NumberUtils.toInt("abc")       // None
     * NumberUtils.toInt("")          // None
     * ```
     */
    public static func toInt(str: String): Option<Int64> {
        if (str.size == 0) {
            return None
        }
        Int64.tryParse(str)
    }

    /**
     * 将字符串转换为整数（带默认值）
     *
     * @param str 待转换的字符串
     * @param defaultValue 转换失败时的默认值
     * @return 转换成功返回整数值，失败返回默认值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toInt("123", 0)    // 123
     * NumberUtils.toInt("abc", 0)    // 0
     * NumberUtils.toInt("", -1)      // -1
     * ```
     */
    public static func toInt(str: String, defaultValue: Int64): Int64 {
        match (toInt(str)) {
            case Some(v) => v
            case None => defaultValue
        }
    }

    /**
     * 将字符串转换为长整数
     *
     * @param str 待转换的字符串
     * @return 转换成功返回 Some(Int64)，失败返回 None
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toLong("12345678901234")  // Some(12345678901234)
     * NumberUtils.toLong("abc")             // None
     * ```
     */
    public static func toLong(str: String): Option<Int64> {
        if (str.size == 0) {
            return None
        }
        Int64.tryParse(str)
    }

    /**
     * 将字符串转换为浮点数
     *
     * @param str 待转换的字符串
     * @return 转换成功返回 Some(Float64)，失败返回 None
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toFloat("3.14")    // Some(3.14)
     * NumberUtils.toFloat("abc")     // None
     * ```
     */
    public static func toFloat(str: String): Option<Float64> {
        if (str.size == 0) {
            return None
        }
        Float64.tryParse(str)
    }

    /**
     * 将字符串转换为双精度浮点数
     *
     * @param str 待转换的字符串
     * @return 转换成功返回 Some(Float64)，失败返回 None
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toDouble("3.1415926535")  // Some(3.1415926535)
     * NumberUtils.toDouble("abc")           // None
     * ```
     */
    public static func toDouble(str: String): Option<Float64> {
        toFloat(str)
    }

    // ========== Phase 2: 数字判断 ==========

    /**
     * 检查字符串是否全为数字字符
     *
     * 只包含 0-9 的字符
     *
     * @param str 待检查的字符串
     * @return 如果全为数字字符返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.isDigits("123")    // true
     * NumberUtils.isDigits("12.3")   // false
     * NumberUtils.isDigits("-123")   // false
     * NumberUtils.isDigits("")       // false
     * ```
     */
    public static func isDigits(str: String): Bool {
        if (str.size == 0) {
            return false
        }

        // String 是 Collection<Byte>，遍历时得到的是 UInt8 (Byte)
        for (byte in str) {
            // 判断是否在 '0'-'9' 范围内 (ASCII 48-57)
            if (byte < 48u8 || byte > 57u8) {
                return false
            }
        }
        true
    }

    /**
     * 检查字符串是否为有效数字
     *
     * 支持格式：整数、小数、负数、科学计数法
     *
     * @param str 待检查的字符串
     * @return 如果是有效数字返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.isNumber("123")      // true
     * NumberUtils.isNumber("-123")     // true
     * NumberUtils.isNumber("12.3")     // true
     * NumberUtils.isNumber("1.23e10")  // true
     * NumberUtils.isNumber("abc")      // false
     * ```
     */
    public static func isNumber(str: String): Bool {
        if (str.size == 0) {
            return false
        }

        // 使用正则表达式匹配数字格式
        // 支持的格式：整数、小数、负数、科学计数法
        let pattern = Regex(#"^[-+]?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$"#)
        pattern.matches(str)
    }

    /**
     * 检查字符串是否可解析为数字
     *
     * @param str 待检查的字符串
     * @return 如果可解析返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.isParsable("123")    // true
     * NumberUtils.isParsable("12.3")   // true
     * NumberUtils.isParsable("abc")    // false
     * ```
     */
    public static func isParsable(str: String): Bool {
        if (str.size == 0) {
            return false
        }

        // 尝试解析为整数或浮点数
        match (toInt(str)) {
            case Some(_) => return true
            case None => ()
        }
        match (toFloat(str)) {
            case Some(_) => return true
            case None => ()
        }
        false
    }

    /**
     * 检查字符串是否可创建为数字对象
     *
     * @param str 待检查的字符串
     * @return 如果可创建返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.isCreatable("123")    // true
     * NumberUtils.isCreatable("12.3")   // true
     * NumberUtils.isCreatable("abc")    // false
     * ```
     */
    public static func isCreatable(str: String): Bool {
        isParsable(str)
    }

    // ========== Phase 3: 比较操作 ==========

    /**
     * 比较两个整数
     *
     * @param x 第一个整数
     * @param y 第二个整数
     * @return 如果 x < y 返回负数，x == y 返回 0，x > y 返回正数
     *
     * 示例：
     * ```cangjie
     * NumberUtils.compare(1, 2)    // -1
     * NumberUtils.compare(2, 2)    // 0
     * NumberUtils.compare(3, 2)    // 1
     * ```
     */
    public static func compare(x: Int64, y: Int64): Int64 {
        if (x < y) {
            return -1
        } else if (x > y) {
            return 1
        } else {
            return 0
        }
    }

    /**
     * 比较两个浮点数
     *
     * @param x 第一个浮点数
     * @param y 第二个浮点数
     * @return 如果 x < y 返回负数，x == y 返回 0，x > y 返回正数
     *
     * 示例：
     * ```cangjie
     * NumberUtils.compare(1.5, 2.5)  // -1
     * NumberUtils.compare(2.5, 2.5)  // 0
     * NumberUtils.compare(3.5, 2.5)  // 1
     * ```
     */
    public static func compare(x: Float64, y: Float64): Int64 {
        if (x < y) {
            return -1
        } else if (x > y) {
            return 1
        } else {
            return 0
        }
    }

    /**
     * 返回两个整数中较小的一个
     *
     * @param x 第一个整数
     * @param y 第二个整数
     * @return 较小的整数值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.min(1, 2)  // 1
     * NumberUtils.min(5, 3)  // 3
     * ```
     */
    public static func min(x: Int64, y: Int64): Int64 {
        if (x < y) { x } else { y }
    }

    /**
     * 返回两个整数中较大的一个
     *
     * @param x 第一个整数
     * @param y 第二个整数
     * @return 较大的整数值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.max(1, 2)  // 2
     * NumberUtils.max(5, 3)  // 5
     * ```
     */
    public static func max(x: Int64, y: Int64): Int64 {
        if (x > y) { x } else { y }
    }

    // ========== Phase 4: 范围检查 ==========

    /**
     * 检查值是否在指定范围内
     *
     * @param value 待检查的值
     * @param min 最小值
     * @param max 最大值
     * @return 如果在范围内返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.isBetween(5, 1, 10)   // true
     * NumberUtils.isBetween(0, 1, 10)   // false
     * NumberUtils.isBetween(11, 1, 10)  // false
     * ```
     */
    public static func isBetween(value: Int64, min: Int64, max: Int64): Bool {
        value > min && value < max
    }

    /**
     * 检查值是否在指定范围内（包含边界）
     *
     * @param value 待检查的值
     * @param min 最小值
     * @param max 最大值
     * @return 如果在范围内返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.inRange(5, 1, 10)   // true
     * NumberUtils.inRange(1, 1, 10)   // true
     * NumberUtils.inRange(10, 1, 10)  // true
     * NumberUtils.inRange(0, 1, 10)   // false
     * ```
     */
    public static func inRange(value: Int64, min: Int64, max: Int64): Bool {
        value >= min && value <= max
    }

    // ========== Phase 5: 类型转换 ==========

    /**
     * 将整数转换为字节
     *
     * 如果超出字节范围，返回最近的有效值
     *
     * @param value 整数值
     * @return 字节值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toByte(100)    // 100
     * NumberUtils.toByte(200)    // 127 (最大值)
     * NumberUtils.toByte(-200)   // -128 (最小值)
     * ```
     */
    public static func toByte(value: Int64): Int8 {
        if (value > BYTE_MAX_VALUE) {
            return 127i8  // Int8 最大值
        } else if (value < BYTE_MIN_VALUE) {
            return -128i8  // Int8 最小值
        } else {
            // 安全的转换范围，使用 Int8 构造函数直接转换
            Int8(value)
        }
    }

    /**
     * 将整数转换为短整数
     *
     * 如果超出短整数范围，返回最近的有效值
     *
     * @param value 整数值
     * @return 短整数值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toShort(1000)    // 1000
     * NumberUtils.toShort(40000)   // 32767 (最大值)
     * NumberUtils.toShort(-40000)  // -32768 (最小值)
     * ```
     */
    public static func toShort(value: Int64): Int16 {
        if (value > SHORT_MAX_VALUE) {
            return 32767i16  // Int16 最大值
        } else if (value < SHORT_MIN_VALUE) {
            return -32768i16  // Int16 最小值
        } else {
            // 安全的转换范围，使用 Int16 构造函数直接转换
            Int16(value)
        }
    }

    /**
     * 将浮点数转换为整数
     *
     * 截断小数部分，不进行四舍五入
     *
     * @param value 浮点数值
     * @return 整数值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toInt(3.14)    // 3
     * NumberUtils.toInt(-3.14)   // -3
     * NumberUtils.toInt(3.99)    // 3
     * ```
     */
    public static func toInt(value: Float64): Int64 {
        // 使用 Int64 构造函数截断浮点数
        Int64(value)
    }

    /**
     * 将整数转换为长整数
     *
     * 在仓颉中，整数和长整数都是 Int64，此方法保持 API 一致性
     *
     * @param value 整数值
     * @return 长整数值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toLong(123)  // 123
     * ```
     */
    public static func toLong(value: Int64): Int64 {
        value
    }

    /**
     * 将整数转换为浮点数
     *
     * @param value 整数值
     * @return 浮点数值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.toFloat(123)  // 123.0
     * ```
     */
    public static func toFloat(value: Int64): Float64 {
        // 使用 Float64 构造函数转换整数为浮点数
        Float64(value)
    }

    // ========== Phase 6: 额外实用方法 ==========

    /**
     * 限制值在指定范围内
     *
     * 如果值小于最小值，返回最小值
     * 如果值大于最大值，返回最大值
     * 否则返回原值
     *
     * @param value 待限制的值
     * @param min 最小值
     * @param max 最大值
     * @return 限制后的值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.clamp(5, 1, 10)    // 5
     * NumberUtils.clamp(0, 1, 10)    // 1
     * NumberUtils.clamp(11, 1, 10)   // 10
     * ```
     */
    public static func clamp(value: Int64, min: Int64, max: Int64): Int64 {
        if (value < min) {
            min
        } else if (value > max) {
            max
        } else {
            value
        }
    }

    /**
     * 检查整数是否为偶数
     *
     * @param value 待检查的整数值
     * @return 如果是偶数返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.isEven(2)    // true
     * NumberUtils.isEven(3)    // false
     * NumberUtils.isEven(0)    // true
     * NumberUtils.isEven(-2)   // true
     * ```
     */
    public static func isEven(value: Int64): Bool {
        value % 2 == 0
    }

    /**
     * 检查整数是否为奇数
     *
     * @param value 待检查的整数值
     * @return 如果是奇数返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * NumberUtils.isOdd(2)    // false
     * NumberUtils.isOdd(3)    // true
     * NumberUtils.isOdd(0)    // false
     * NumberUtils.isOdd(-3)   // true
     * ```
     */
    public static func isOdd(value: Int64): Bool {
        value % 2 != 0
    }

    /**
     * 计算整数数组的和
     *
     * @param array 整数数组
     * @return 数组所有元素的和
     *
     * 示例：
     * ```cangjie
     * NumberUtils.sum([1, 2, 3, 4, 5])  // 15
     * NumberUtils.sum([])                // 0
     * ```
     */
    public static func sum(array: Array<Int64>): Int64 {
        var total: Int64 = 0
        for (item in array) {
            total += item
        }
        total
    }

    /**
     * 返回整数数组的最大值
     *
     * @param array 整数数组
     * @return 数组中的最大值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.max([1, 5, 3, 9, 2])  // 9
     * ```
     */
    public static func max(array: Array<Int64>): Int64 {
        if (array.size == 0) {
            throw Exception("Cannot get max of empty array")
        }

        var maxValue = array[0]
        for (i in 1..array.size) {
            if (array[i] > maxValue) {
                maxValue = array[i]
            }
        }
        maxValue
    }

    /**
     * 返回整数数组的最小值
     *
     * @param array 整数数组
     * @return 数组中的最小值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.min([1, 5, 3, 9, 2])  // 1
     * ```
     */
    public static func min(array: Array<Int64>): Int64 {
        if (array.size == 0) {
            throw Exception("Cannot get min of empty array")
        }

        var minValue = array[0]
        for (i in 1..array.size) {
            if (array[i] < minValue) {
                minValue = array[i]
            }
        }
        minValue
    }

    /**
     * 计算整数数组的平均值
     *
     * @param array 整数数组
     * @return 数组所有元素的平均值
     *
     * 示例：
     * ```cangjie
     * NumberUtils.average([1, 2, 3, 4, 5])  // 3.0
     * ```
     */
    public static func average(array: Array<Int64>): Float64 {
        if (array.size == 0) {
            throw Exception("Cannot calculate average of empty array")
        }

        let total = sum(array)
        // 使用 Float64 构造函数转换
        let totalFloat = Float64(total)
        let sizeFloat = Float64(array.size)
        totalFloat / sizeFloat
    }
}
