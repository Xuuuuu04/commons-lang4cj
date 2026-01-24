package commons_lang4cj.math

/**
 * IEEE754rUtils 浮点数工具类
 *
 * 本类提供符合 IEEE 754 标准的浮点数比较和工具方法。
 * 处理 NaN 和无穷大等特殊情况,提供可靠的最小值/最大值计算。
 *
 * 核心特性:
 * - 正确处理 NaN (Not a Number) 值
 * - 支持正负无穷大的比较
 * - 提供数组的最小值/最大值计算
 * - 符合 IEEE 754 标准的浮点数排序
 *
 * NaN 处理规则:
 * - NaN 小于所有其他值(包括负无穷大)
 * - NaN 不等于任何值(包括它自己)
 * - 比较方法中,多个 NaN 被视为相等
 *
 * @since 1.1.0
 */
public class IEEE754rUtils {
    /**
     * 私有构造函数,防止实例化
     * 所有方法都是静态的,不需要创建实例
     */
    private init() {}

    // ========== NaN 检查方法 ==========

    /**
     * 检查 Float64 值是否为 NaN (Not a Number)
     *
     * NaN 是 IEEE 754 标准中的特殊值,表示未定义或不可表示的结果。
     * NaN 的特殊性质: NaN 不等于任何值,包括它自己。
     *
     * @param value 要检查的值
     * @return 如果值是 NaN 返回 true,否则返回 false
     *
     * @example
     * // 检查 NaN
     * let result1 = IEEE754rUtils.isNaN(0.0 / 0.0)  // true
     * let result2 = IEEE754rUtils.isNaN(1.0)       // false
     */
    public static func isNaN(value: Float64): Bool {
        value != value
    }

    /**
     * 检查 Float32 值是否为 NaN (Not a Number)
     *
     * NaN 是 IEEE 754 标准中的特殊值,表示未定义或不可表示的结果。
     * NaN 的特殊性质: NaN 不等于任何值,包括它自己。
     *
     * @param value 要检查的值
     * @return 如果值是 NaN 返回 true,否则返回 false
     *
     * @example
     * // 检查 NaN
     * let result1 = IEEE754rUtils.isNaN(0.0f32 / 0.0f32)  // true
     * let result2 = IEEE754rUtils.isNaN(1.0f32)            // false
     */
    public static func isNaN(value: Float32): Bool {
        value != value
    }

    // ========== 无穷大检查方法 ==========

    /**
     * 检查 Float64 值是否为无穷大(正无穷大或负无穷大)
     *
     * IEEE 754 标准定义了正无穷大(∞)和负无穷大(-∞)两个特殊值。
     * 无穷大通常由除以零等操作产生。
     *
     * @param value 要检查的值
     * @return 如果值是正无穷大或负无穷大返回 true,否则返回 false
     *
     * @example
     * // 检查无穷大
     * let result1 = IEEE754rUtils.isInfinite(1.0 / 0.0)   // true (正无穷大)
     * let result2 = IEEE754rUtils.isInfinite(-1.0 / 0.0)  // true (负无穷大)
     * let result3 = IEEE754rUtils.isInfinite(1.0)        // false
     */
    public static func isInfinite(value: Float64): Bool {
        // 通过与 1.0/0.0 和 -1.0/0.0 比较来判断
        let posInf = 1.0 / 0.0
        let negInf = -1.0 / 0.0
        value == posInf || value == negInf
    }

    /**
     * 检查 Float32 值是否为无穷大(正无穷大或负无穷大)
     *
     * IEEE 754 标准定义了正无穷大(∞)和负无穷大(-∞)两个特殊值。
     * 无穷大通常由除以零等操作产生。
     *
     * @param value 要检查的值
     * @return 如果值是正无穷大或负无穷大返回 true,否则返回 false
     *
     * @example
     * // 检查无穷大
     * let result1 = IEEE754rUtils.isInfinite(1.0f32 / 0.0f32)   // true
     * let result2 = IEEE754rUtils.isInfinite(-1.0f32 / 0.0f32)  // true
     * let result3 = IEEE754rUtils.isInfinite(1.0f32)            // false
     */
    public static func isInfinite(value: Float32): Bool {
        // 通过与 1.0/0.0 和 -1.0/0.0 比较来判断
        let posInf = 1.0f32 / 0.0f32
        let negInf = -1.0f32 / 0.0f32
        value == posInf || value == negInf
    }

    // ========== 比较方法 ==========

    /**
     * 比较两个 Float64 值的大小
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 比较规则(符合 IEEE 754 标准):
     * - NaN < 负无穷大 < 负数 < 0.0 < 正数 < 正无穷大 < 其他 NaN
     *
     * @param a 第一个值
     * @param b 第二个值
     * @return 如果 a < b 返回负数; 如果 a > b 返回正数; 如果 a == b 返回 0
     *
     * @example
     * // 正常比较
     * let result1 = IEEE754rUtils.compare(1.0, 2.0)     // 负数
     * let result2 = IEEE754rUtils.compare(2.0, 1.0)     // 正数
     * let result3 = IEEE754rUtils.compare(1.0, 1.0)     // 0
     *
     * // NaN 比较
     * let nan = 0.0 / 0.0
     * let result4 = IEEE754rUtils.compare(nan, 1.0)    // 负数 (NaN < 所有值)
     * let result5 = IEEE754rUtils.compare(1.0, nan)    // 正数
     */
    public static func compare(a: Float64, b: Float64): Int64 {
        // 处理 NaN 情况
        if (isNaN(a)) {
            if (isNaN(b)) {
                // 两个都是 NaN,视为相等
                return 0
            }
            // a 是 NaN, b 不是, a < b
            return -1
        }
        if (isNaN(b)) {
            // b 是 NaN, a 不是, a > b
            return 1
        }

        // 正常比较
        if (a < b) {
            return -1
        } else if (a > b) {
            return 1
        } else {
            return 0
        }
    }

    /**
     * 比较两个 Float32 值的大小
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 比较规则(符合 IEEE 754 标准):
     * - NaN < 负无穷大 < 负数 < 0.0 < 正数 < 正无穷大 < 其他 NaN
     *
     * @param a 第一个值
     * @param b 第二个值
     * @return 如果 a < b 返回负数; 如果 a > b 返回正数; 如果 a == b 返回 0
     *
     * @example
     * // 正常比较
     * let result1 = IEEE754rUtils.compare(1.0f32, 2.0f32)  // 负数
     * let result2 = IEEE754rUtils.compare(2.0f32, 1.0f32)  // 正数
     * let result3 = IEEE754rUtils.compare(1.0f32, 1.0f32)  // 0
     *
     * // NaN 比较
     * let nan = 0.0f32 / 0.0f32
     * let result4 = IEEE754rUtils.compare(nan, 1.0f32)     // 负数
     * let result5 = IEEE754rUtils.compare(1.0f32, nan)     // 正数
     */
    public static func compare(a: Float32, b: Float32): Int64 {
        // 处理 NaN 情况
        if (isNaN(a)) {
            if (isNaN(b)) {
                // 两个都是 NaN,视为相等
                return 0
            }
            // a 是 NaN, b 不是, a < b
            return -1
        }
        if (isNaN(b)) {
            // b 是 NaN, a 不是, a > b
            return 1
        }

        // 正常比较
        if (a < b) {
            return -1
        } else if (a > b) {
            return 1
        } else {
            return 0
        }
    }

    // ========== Float64 最小值方法 ==========

    /**
     * 返回两个 Float64 值中的较小者
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 规则: NaN < 所有其他值(包括负无穷大)
     *
     * @param a 第一个值
     * @param b 第二个值
     * @return 较小的值
     *
     * @example
     * // 正常情况
     * let result1 = IEEE754rUtils.min(1.0, 2.0)  // 1.0
     * let result2 = IEEE754rUtils.min(2.0, 1.0)  // 1.0
     *
     * // NaN 情况
     * let nan = 0.0 / 0.0
     * let result3 = IEEE754rUtils.min(nan, 1.0)  // NaN (NaN < 所有值)
     * let result4 = IEEE754rUtils.min(1.0, nan)  // NaN
     *
     * // 无穷大情况
     * let result5 = IEEE754rUtils.min(Float64.negativeInfinity, 1.0)  // 负无穷大
     */
    public static func min(a: Float64, b: Float64): Float64 {
        // NaN < 所有值
        if (isNaN(a)) {
            return a
        }
        if (isNaN(b)) {
            return b
        }
        // 正常比较
        if (a <= b) {
            return a
        } else {
            return b
        }
    }

    /**
     * 返回 Float64 数组中的最小值
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 如果数组为空,抛出异常。
     * 如果数组包含 NaN,返回 NaN。
     *
     * @param values Float64 值数组
     * @return 数组中的最小值
     * @throws IllegalArgumentException 如果数组为空或为 null
     *
     * @example
     * // 正常情况
     * let arr = [3.0, 1.0, 2.0]
     * let result1 = IEEE754rUtils.min(arr)  // 1.0
     *
     * // 包含 NaN
     * let arr2 = [1.0, 0.0 / 0.0, 2.0]
     * let result2 = IEEE754rUtils.min(arr2)  // NaN
     *
     * // 包含负无穷大
     * let arr3 = [1.0, Float64.negativeInfinity, 2.0]
     * let result3 = IEEE754rUtils.min(arr3)  // 负无穷大
     */
    public static func min(values: Array<Float64>): Float64 {
        if (values.size == 0) {
            throw IllegalArgumentException("Array cannot be empty")
        }

        var minVal = values[0]
        for (i in 1..values.size) {
            minVal = min(minVal, values[i])
        }
        return minVal
    }

    // ========== Float64 最大值方法 ==========

    /**
     * 返回两个 Float64 值中的较大者
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 规则: 如果任一值是 NaN,返回 NaN
     *
     * @param a 第一个值
     * @param b 第二个值
     * @return 较大的值
     *
     * @example
     * // 正常情况
     * let result1 = IEEE754rUtils.max(1.0, 2.0)  // 2.0
     * let result2 = IEEE754rUtils.max(2.0, 1.0)  // 2.0
     *
     * // NaN 情况
     * let nan = 0.0 / 0.0
     * let result3 = IEEE754rUtils.max(nan, 1.0)  // NaN
     * let result4 = IEEE754rUtils.max(1.0, nan)  // NaN
     *
     * // 无穷大情况
     * let result5 = IEEE754rUtils.max(Float64.positiveInfinity, 1.0)  // 正无穷大
     */
    public static func max(a: Float64, b: Float64): Float64 {
        // 如果任一是 NaN,返回 NaN
        if (isNaN(a)) {
            return a
        }
        if (isNaN(b)) {
            return b
        }
        // 正常比较
        if (a >= b) {
            return a
        } else {
            return b
        }
    }

    /**
     * 返回 Float64 数组中的最大值
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 如果数组为空,抛出异常。
     * 如果数组包含 NaN,返回 NaN。
     *
     * @param values Float64 值数组
     * @return 数组中的最大值
     * @throws IllegalArgumentException 如果数组为空或为 null
     *
     * @example
     * // 正常情况
     * let arr = [1.0, 3.0, 2.0]
     * let result1 = IEEE754rUtils.max(arr)  // 3.0
     *
     * // 包含 NaN
     * let arr2 = [1.0, 0.0 / 0.0, 2.0]
     * let result2 = IEEE754rUtils.max(arr2)  // NaN
     *
     * // 包含正无穷大
     * let arr3 = [1.0, Float64.positiveInfinity, 2.0]
     * let result3 = IEEE754rUtils.max(arr3)  // 正无穷大
     */
    public static func max(values: Array<Float64>): Float64 {
        if (values.size == 0) {
            throw IllegalArgumentException("Array cannot be empty")
        }

        var maxVal = values[0]
        for (i in 1..values.size) {
            maxVal = max(maxVal, values[i])
        }
        return maxVal
    }

    // ========== Float32 最小值方法 ==========

    /**
     * 返回两个 Float32 值中的较小者
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 规则: NaN < 所有其他值(包括负无穷大)
     *
     * @param a 第一个值
     * @param b 第二个值
     * @return 较小的值
     *
     * @example
     * // 正常情况
     * let result1 = IEEE754rUtils.min(1.0f32, 2.0f32)  // 1.0f32
     * let result2 = IEEE754rUtils.min(2.0f32, 1.0f32)  // 1.0f32
     *
     * // NaN 情况
     * let nan = 0.0f32 / 0.0f32
     * let result3 = IEEE754rUtils.min(nan, 1.0f32)     // NaN
     * let result4 = IEEE754rUtils.min(1.0f32, nan)     // NaN
     */
    public static func min(a: Float32, b: Float32): Float32 {
        // NaN < 所有值
        if (isNaN(a)) {
            return a
        }
        if (isNaN(b)) {
            return b
        }
        // 正常比较
        if (a <= b) {
            return a
        } else {
            return b
        }
    }

    /**
     * 返回 Float32 数组中的最小值
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 如果数组为空,抛出异常。
     * 如果数组包含 NaN,返回 NaN。
     *
     * @param values Float32 值数组
     * @return 数组中的最小值
     * @throws IllegalArgumentException 如果数组为空或为 null
     *
     * @example
     * // 正常情况
     * let arr = [3.0f32, 1.0f32, 2.0f32]
     * let result1 = IEEE754rUtils.min(arr)  // 1.0f32
     *
     * // 包含 NaN
     * let arr2 = [1.0f32, 0.0f32 / 0.0f32, 2.0f32]
     * let result2 = IEEE754rUtils.min(arr2)  // NaN
     */
    public static func min(values: Array<Float32>): Float32 {
        if (values.size == 0) {
            throw IllegalArgumentException("Array cannot be empty")
        }

        var minVal = values[0]
        for (i in 1..values.size) {
            minVal = min(minVal, values[i])
        }
        return minVal
    }

    // ========== Float32 最大值方法 ==========

    /**
     * 返回两个 Float32 值中的较大者
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 规则: 如果任一值是 NaN,返回 NaN
     *
     * @param a 第一个值
     * @param b 第二个值
     * @return 较大的值
     *
     * @example
     * // 正常情况
     * let result1 = IEEE754rUtils.max(1.0f32, 2.0f32)  // 2.0f32
     * let result2 = IEEE754rUtils.max(2.0f32, 1.0f32)  // 2.0f32
     *
     * // NaN 情况
     * let nan = 0.0f32 / 0.0f32
     * let result3 = IEEE754rUtils.max(nan, 1.0f32)     // NaN
     * let result4 = IEEE754rUtils.max(1.0f32, nan)     // NaN
     */
    public static func max(a: Float32, b: Float32): Float32 {
        // 如果任一是 NaN,返回 NaN
        if (isNaN(a)) {
            return a
        }
        if (isNaN(b)) {
            return b
        }
        // 正常比较
        if (a >= b) {
            return a
        } else {
            return b
        }
    }

    /**
     * 返回 Float32 数组中的最大值
     *
     * 本方法正确处理 NaN 和无穷大等特殊情况。
     * 如果数组为空,抛出异常。
     * 如果数组包含 NaN,返回 NaN。
     *
     * @param values Float32 值数组
     * @return 数组中的最大值
     * @throws IllegalArgumentException 如果数组为空或为 null
     *
     * @example
     * // 正常情况
     * let arr = [1.0f32, 3.0f32, 2.0f32]
     * let result1 = IEEE754rUtils.max(arr)  // 3.0f32
     *
     * // 包含 NaN
     * let arr2 = [1.0f32, 0.0f32 / 0.0f32, 2.0f32]
     * let result2 = IEEE754rUtils.max(arr2)  // NaN
     */
    public static func max(values: Array<Float32>): Float32 {
        if (values.size == 0) {
            throw IllegalArgumentException("Array cannot be empty")
        }

        var maxVal = values[0]
        for (i in 1..values.size) {
            maxVal = max(maxVal, values[i])
        }
        return maxVal
    }
}
