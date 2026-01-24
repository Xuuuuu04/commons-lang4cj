package commons_lang4cj.utils

import std.regex.*

/**
 * Validate 参数验证工具类
 *
 * 仓颉版本的 Apache Commons Lang Validate 工具类
 * 提供参数验证的静态方法集合
 *
 * 验证原则：
 * - 无效的 None 参数抛出 NullPointerException（仓颉中为 NoneValueException）
 * - 非None 的无效参数抛出 IllegalArgumentException
 * - 无效的索引抛出 IndexOutOfBoundsException
 * - 无效的状态抛出 IllegalStateException
 *
 * 功能包括：
 * - 真值验证（IsTrue/IsFalse）
 * - 空值验证（NotNull/NotEmpty/NotBlank）
 * - 索引验证（ValidIndex）
 * - 范围验证（ExclusiveBetween/InclusiveBetween）
 * - 类型验证（IsInstanceOf）
 *
 * @since 1.0.0
 */
public class ValidateUtils {
    // 默认错误消息
    private static const DEFAULT_IS_TRUE_EX_MESSAGE: String = "The validated expression is false"
    private static const DEFAULT_IS_FALSE_EX_MESSAGE: String = "The validated expression is true"
    private static const DEFAULT_IS_NULL_EX_MESSAGE: String = "The validated object is null"
    private static const DEFAULT_NOT_EMPTY_ARRAY_EX_MESSAGE: String = "The validated array is empty"
    private static const DEFAULT_NOT_EMPTY_CHAR_SEQUENCE_EX_MESSAGE: String = "The validated character sequence is empty"
    private static const DEFAULT_NOT_BLANK_EX_MESSAGE: String = "The validated character sequence is blank"
    private static const DEFAULT_EXCLUSIVE_BETWEEN_EX_MESSAGE: String = "The value %d is not in the specified exclusive range of %d to %d"
    private static const DEFAULT_INCLUSIVE_BETWEEN_EX_MESSAGE: String = "The value %d is not in the specified inclusive range of %d to %d"

    // ========== Phase 1: 真值验证 ==========

    /**
     * 验证表达式为 true
     *
     * 如果表达式为 false，抛出异常
     *
     * @param value 待验证的表达式
     * @throws IllegalArgumentException 如果表达式为 false
     *
     * 示例：
     * ```cangjie
     * Validate.isTrue(true)   // 通过
     * Validate.isTrue(false)  // 抛出异常
     * ```
     */
    public static func isTrue(value: Bool): Unit {
        if (!value) {
            throw IllegalArgumentException(DEFAULT_IS_TRUE_EX_MESSAGE)
        }
    }

    /**
     * 验证表达式为 true，否则抛出带指定消息的异常
     *
     * @param value 待验证的表达式
     * @param message 错误消息
     * @throws IllegalArgumentException 如果表达式为 false
     *
     * 示例：
     * ```cangjie
     * Validate.isTrue(true, "错误")           // 通过
     * Validate.isTrue(false, "值必须为true")  // 抛出异常：值必须为true
     * ```
     */
    public static func isTrue(value: Bool, message: String): Unit {
        if (!value) {
            throw IllegalArgumentException(message)
        }
    }

    /**
     * 验证表达式为 false
     *
     * 如果表达式为 true，抛出异常
     *
     * @param value 待验证的表达式
     * @throws IllegalArgumentException 如果表达式为 true
     *
     * 示例：
     * ```cangjie
     * Validate.isFalse(false)  // 通过
     * Validate.isFalse(true)   // 抛出异常
     * ```
     */
    public static func isFalse(value: Bool): Unit {
        if (value) {
            throw IllegalArgumentException(DEFAULT_IS_FALSE_EX_MESSAGE)
        }
    }

    /**
     * 验证表达式为 false，否则抛出带指定消息的异常
     *
     * @param value 待验证的表达式
     * @param message 错误消息
     * @throws IllegalArgumentException 如果表达式为 true
     *
     * 示例：
     * ```cangjie
     * Validate.isFalse(false, "错误")            // 通过
     * Validate.isFalse(true, "值必须为false")  // 抛出异常
     * ```
     */
    public static func isFalse(value: Bool, message: String): Unit {
        if (value) {
            throw IllegalArgumentException(message)
        }
    }

    // ========== Phase 2: 空值验证 ==========

    /**
     * 验证对象非 None
     *
     * 如果对象为 None，抛出异常
     *
     * @param obj 待验证的对象
     * @return 对象本身（用于链式调用）
     * @throws IllegalArgumentException 如果对象为 None
     *
     * 示例：
     * ```cangjie
     * let val: Option<Int64> = Some(42)
     * let noneVal: Option<Int64> = None
     * Validate.notNull(val)      // 返回 Some(42)
     * Validate.notNull(noneVal)  // 抛出异常
     * ```
     */
    public static func notNull<T>(obj: Option<T>): T {
        match (obj) {
            case None => throw IllegalArgumentException(DEFAULT_IS_NULL_EX_MESSAGE)
            case Some(v) => v
        }
    }

    /**
     * 验证对象非 None，否则抛出带指定消息的异常
     *
     * @param obj 待验证的对象
     * @param message 错误消息
     * @return 对象本身（用于链式调用）
     * @throws IllegalArgumentException 如果对象为 None
     *
     * 示例：
     * ```cangjie
     * let val: Option<Int64> = Some(42)
     * let noneVal: Option<Int64> = None
     * Validate.notNull(val, "对象不能为空")      // 返回 Some(42)
     * Validate.notNull(noneVal, "对象不能为空")  // 抛出异常：对象不能为空
     * ```
     */
    public static func notNull<T>(obj: Option<T>, message: String): T {
        match (obj) {
            case None => throw IllegalArgumentException(message)
            case Some(v) => v
        }
    }

    /**
     * 验证数组非空
     *
     * @param array 待验证的数组
     * @return 数组本身（用于链式调用）
     * @throws IllegalArgumentException 如果数组为空
     *
     * 示例：
     * ```cangjie
     * let arr1 = [1, 2, 3]
     * let arr2: Array<Int64> = []
     * Validate.notEmpty(arr1)  // 返回 [1, 2, 3]
     * Validate.notEmpty(arr2)  // 抛出异常
     * ```
     */
    public static func notEmpty<T>(array: Array<T>): Array<T> {
        if (array.size == 0) {
            throw IllegalArgumentException(DEFAULT_NOT_EMPTY_ARRAY_EX_MESSAGE)
        }
        array
    }

    /**
     * 验证字符串数组非空
     *
     * @param array 待验证的字符串数组
     * @return 数组本身（用于链式调用）
     * @throws IllegalArgumentException 如果数组为空
     *
     * 示例：
     * ```cangjie
     * let arr1 = ["a", "b", "c"]
     * let arr2: Array<String> = []
     * Validate.notEmpty(arr1)  // 返回 ["a", "b", "c"]
     * Validate.notEmpty(arr2)  // 抛出异常
     * ```
     */
    public static func notEmpty(array: Array<String>): Array<String> {
        if (array.size == 0) {
            throw IllegalArgumentException(DEFAULT_NOT_EMPTY_ARRAY_EX_MESSAGE)
        }
        array
    }

    /**
     * 验证字符串非空
     *
     * @param str 待验证的字符串
     * @return 字符串本身（用于链式调用）
     * @throws IllegalArgumentException 如果字符串为空
     *
     * 示例：
     * ```cangjie
     * Validate.notEmpty("hello")  // 返回 "hello"
     * Validate.notEmpty("")       // 抛出异常
     * ```
     */
    public static func notEmpty(str: String): String {
        if (str.size == 0) {
            throw IllegalArgumentException(DEFAULT_NOT_EMPTY_CHAR_SEQUENCE_EX_MESSAGE)
        }
        str
    }

    /**
     * 验证字符串非空白
     *
     * 空白字符串包括：空字符串、全部由空白字符组成的字符串
     *
     * @param str 待验证的字符串
     * @return 字符串本身（用于链式调用）
     * @throws IllegalArgumentException 如果字符串为空白
     *
     * 示例：
     * ```cangjie
     * Validate.notBlank("hello")     // 返回 "hello"
     * Validate.notBlank("")          // 抛出异常
     * Validate.notBlank("   ")       // 抛出异常
     * Validate.notBlank("  hello  ") // 返回 "  hello  "
     * ```
     */
    public static func notBlank(str: String): String {
        if (StringUtils.isBlank(str)) {
            throw IllegalArgumentException(DEFAULT_NOT_BLANK_EX_MESSAGE)
        }
        str
    }

    // ========== Phase 3: 索引验证 ==========

    /**
     * 验证索引有效
     *
     * 索引必须在 [0, size) 范围内
     *
     * @param index 待验证的索引
     * @param size 数组或集合的大小
     * @throws IndexOutOfBoundsException 如果索引无效
     *
     * 示例：
     * ```cangjie
     * Validate.validIndex(0, 5)  // 通过
     * Validate.validIndex(4, 5)  // 通过
     * Validate.validIndex(-1, 5) // 抛出异常
     * Validate.validIndex(5, 5)  // 抛出异常
     * ```
     */
    public static func validIndex(index: Int64, size: Int64): Unit {
        if (index < 0 || index >= size) {
            throw IndexOutOfBoundsException()
        }
    }

    /**
     * 验证数组索引有效
     *
     * @param array 待验证的数组
     * @param index 待验证的索引
     * @throws IndexOutOfBoundsException 如果索引无效
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3]
     * Validate.validIndex(arr, 0)  // 通过
     * Validate.validIndex(arr, 2)  // 通过
     * Validate.validIndex(arr, -1) // 抛出异常
     * Validate.validIndex(arr, 3)  // 抛出异常
     * ```
     */
    public static func validIndex<T>(array: Array<T>, index: Int64): Unit {
        if (index < 0 || index >= array.size) {
            throw IndexOutOfBoundsException()
        }
    }

    // ========== Phase 4: 范围验证 ==========

    /**
     * 验证值在范围内（不包含边界）
     *
     * 值必须满足：min < value < max
     *
     * @param min 最小值（不包含）
     * @param max 最大值（不包含）
     * @param value 待验证的值
     * @throws IllegalArgumentException 如果值不在范围内
     *
     * 示例：
     * ```cangjie
     * Validate.exclusiveBetween(5, 10, 7)  // 通过
     * Validate.exclusiveBetween(5, 10, 5)  // 抛出异常
     * Validate.exclusiveBetween(5, 10, 10) // 抛出异常
     * Validate.exclusiveBetween(5, 10, 4)  // 抛出异常
     * Validate.exclusiveBetween(5, 10, 11) // 抛出异常
     * ```
     */
    public static func exclusiveBetween(min: Int64, max: Int64, value: Int64): Unit {
        if (value <= min || value >= max) {
            throw IllegalArgumentException(
                formatString(DEFAULT_EXCLUSIVE_BETWEEN_EX_MESSAGE, [value, min, max])
            )
        }
    }

    /**
     * 验证值在范围内（包含边界）
     *
     * 值必须满足：min <= value <= max
     *
     * @param min 最小值（包含）
     * @param max 最大值（包含）
     * @param value 待验证的值
     * @throws IllegalArgumentException 如果值不在范围内
     *
     * 示例：
     * ```cangjie
     * Validate.inclusiveBetween(5, 10, 5)  // 通过
     * Validate.inclusiveBetween(5, 10, 7)  // 通过
     * Validate.inclusiveBetween(5, 10, 10) // 通过
     * Validate.inclusiveBetween(5, 10, 4)  // 抛出异常
     * Validate.inclusiveBetween(5, 10, 11) // 抛出异常
     * ```
     */
    public static func inclusiveBetween(min: Int64, max: Int64, value: Int64): Unit {
        if (value < min || value > max) {
            throw IllegalArgumentException(
                formatString(DEFAULT_INCLUSIVE_BETWEEN_EX_MESSAGE, [value, min, max])
            )
        }
    }

    // ========== Phase 5: 类型验证 ==========

    /**
     * 检查对象是否为指定类型
     *
     * 注意：仓颉没有直接的 instanceof 操作符
     * 此方法通过模式匹配实现类型检查
     *
     * @param obj 待检查的对象
     * @return 如果对象为指定类型返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let val1: Option<String> = Some("hello")
     * let val2: Option<Int64> = Some(42)
     * Validate.isInstanceOf(val1, { s: String => true }, { _ => false })  // true
     * Validate.isInstanceOf(val2, { s: String => true }, { _ => false })  // false
     * ```
     */
    public static func isInstanceOf<T>(obj: Option<T>, typeCheck: (T) -> Bool, _: () -> Bool): Bool {
        match (obj) {
            case None => false
            case Some(v) => typeCheck(v)
        }
    }

    /**
     * 检查对象是否为指定类型并转换
     *
     * 如果对象不是指定类型，抛出异常
     *
     * @param obj 待检查的对象
     * @param message 错误消息
     * @param converter 转换函数
     * @return 转换后的对象
     * @throws IllegalArgumentException 如果对象不是指定类型
     *
     * 示例：
     * ```cangjie
     * let val1: Option<String> = Some("hello")
     * Validate.isInstanceOf(val1, "类型错误", { s => s })  // 返回 "hello"
     * ```
     */
    public static func isInstanceOf<T, R>(obj: Option<T>, message: String, converter: (T) -> R): R {
        match (obj) {
            case None => throw IllegalArgumentException(message)
            case Some(v) => converter(v)
        }
    }

    // ========== Phase 6: 正数与非负数验证 ==========

    /**
     * 验证值为正数
     *
     * @param value 待验证的值
     * @return 值本身（用于链式调用）
     * @throws IllegalArgumentException 如果值 <= 0
     *
     * 示例：
     * ```cangjie
     * Validate.positive(10)   // 返回 10
     * Validate.positive(0)    // 抛出异常
     * Validate.positive(-10)  // 抛出异常
     * ```
     */
    public static func positive(value: Int64): Int64 {
        if (value <= 0) {
            throw IllegalArgumentException("The value ${value} is not positive")
        }
        value
    }

    /**
     * 验证值为正数（带自定义消息）
     *
     * @param value 待验证的值
     * @param message 错误消息
     * @return 值本身
     * @throws IllegalArgumentException 如果值 <= 0
     */
    public static func positive(value: Int64, message: String): Int64 {
        if (value <= 0) {
            throw IllegalArgumentException(message)
        }
        value
    }

    /**
     * 验证值为非负数
     *
     * @param value 待验证的值
     * @return 值本身（用于链式调用）
     * @throws IllegalArgumentException 如果值 < 0
     *
     * 示例：
     * ```cangjie
     * Validate.notNegative(10)   // 返回 10
     * Validate.notNegative(0)    // 返回 0
     * Validate.notNegative(-10)  // 抛出异常
     * ```
     */
    public static func notNegative(value: Int64): Int64 {
        if (value < 0) {
            throw IllegalArgumentException("The value ${value} is negative")
        }
        value
    }

    /**
     * 验证值为非负数（带自定义消息）
     *
     * @param value 待验证的值
     * @param message 错误消息
     * @return 值本身
     * @throws IllegalArgumentException 如果值 < 0
     */
    public static func notNegative(value: Int64, message: String): Int64 {
        if (value < 0) {
            throw IllegalArgumentException(message)
        }
        value
    }

    // ========== Phase 7: 数组元素验证 ==========

    /**
     * 验证数组不包含 None 元素
     *
     * @param array 待验证的数组
     * @return 数组本身（用于链式调用）
     * @throws IllegalArgumentException 如果数组包含 None 元素
     *
     * 示例：
     * ```cangjie
     * let arr1 = [Some(1), Some(2), Some(3)]
     * let arr2 = [Some(1), None, Some(3)]
     * Validate.noNullElements(arr1)  // 返回 arr1
     * Validate.noNullElements(arr2)  // 抛出异常
     * ```
     */
    public static func noNullElements<T>(array: Array<Option<T>>): Array<Option<T>> {
        for (elem in array) {
            if (let None <- elem) {
                throw IllegalArgumentException("Array contains None element")
            }
        }
        array
    }

    /**
     * 验证数组不包含 None 元素（带自定义消息）
     *
     * @param array 待验证的数组
     * @param message 错误消息
     * @return 数组本身
     * @throws IllegalArgumentException 如果数组包含 None 元素
     */
    public static func noNullElements<T>(array: Array<Option<T>>, message: String): Array<Option<T>> {
        for (elem in array) {
            if (let None <- elem) {
                throw IllegalArgumentException(message)
            }
        }
        array
    }

    /**
     * 验证数组不包含空元素
     *
     * @param array 待验证的字符串数组
     * @return 数组本身（用于链式调用）
     * @throws IllegalArgumentException 如果数组包含空字符串
     *
     * 示例：
     * ```cangjie
     * let arr1 = ["a", "b", "c"]
     * let arr2 = ["a", "", "c"]
     * Validate.noEmptyElements(arr1)  // 返回 arr1
     * Validate.noEmptyElements(arr2)  // 抛出异常
     * ```
     */
    public static func noEmptyElements(array: Array<String>): Array<String> {
        for (elem in array) {
            if (elem.size == 0) {
                throw IllegalArgumentException("Array contains empty string")
            }
        }
        array
    }

    /**
     * 验证数组不包含空元素（带自定义消息）
     *
     * @param array 待验证的字符串数组
     * @param message 错误消息
     * @return 数组本身
     * @throws IllegalArgumentException 如果数组包含空字符串
     */
    public static func noEmptyElements(array: Array<String>, message: String): Array<String> {
        for (elem in array) {
            if (elem.size == 0) {
                throw IllegalArgumentException(message)
            }
        }
        array
    }

    // ========== Phase 8: 状态验证 ==========

    /**
     * 验证状态表达式为 true
     *
     * 用于验证对象状态是否符合预期
     *
     * @param expression 待验证的表达式
     * @throws IllegalStateException 如果表达式为 false
     *
     * 示例：
     * ```cangjie
     * Validate.validState(true)   // 通过
     * Validate.validState(false)  // 抛出异常
     * ```
     */
    public static func validState(expression: Bool): Unit {
        if (!expression) {
            throw IllegalStateException("State is invalid")
        }
    }

    /**
     * 验证状态表达式为 true（带自定义消息）
     *
     * @param expression 待验证的表达式
     * @param message 错误消息
     * @throws IllegalStateException 如果表达式为 false
     *
     * 示例：
     * ```cangjie
     * Validate.validState(true, "状态有效")           // 通过
     * Validate.validState(false, "对象未初始化")  // 抛出异常
     * ```
     */
    public static func validState(expression: Bool, message: String): Unit {
        if (!expression) {
            throw IllegalStateException(message)
        }
    }

    /**
     * 验证参数为 true（状态验证版本）
     *
     * 与 isTrue 类似，但使用 IllegalStateException
     *
     * @param expression 待验证的表达式
     * @throws IllegalStateException 如果表达式为 false
     */
    public static func validStateTrue(expression: Bool): Unit {
        if (!expression) {
            throw IllegalStateException("The validated state is false")
        }
    }

    // ========== Phase 9: 匹配元素验证 ==========

    /**
     * 验证字符串匹配正则表达式
     *
     * @param str 待验证的字符串
     * @param pattern 正则表达式模式
     * @return 字符串本身（用于链式调用）
     * @throws IllegalArgumentException 如果字符串不匹配
     *
     * 示例：
     * ```cangjie
     * Validate.matchesPattern("abc123", #"^\w+$"#)  // 返回 "abc123"
     * Validate.matchesPattern("abc-123", #"^\w+$"#) // 抛出异常
     * ```
     */
    public static func matchesPattern(str: String, pattern: String): String {
        let regex = Regex(pattern)
        if (!regex.matches(str)) {
            throw IllegalArgumentException("String does not match pattern")
        }
        str
    }

    /**
     * 验证字符串长度在指定范围内
     *
     * @param str 待验证的字符串
     * @param minLength 最小长度
     * @param maxLength 最大长度
     * @return 字符串本身（用于链式调用）
     * @throws IllegalArgumentException 如果长度不在范围内
     *
     * 示例：
     * ```cangjie
     * Validate.length("hello", 1, 10)  // 返回 "hello"
     * Validate.length("", 1, 10)      // 抛出异常
     * Validate.length("hello", 1, 3)  // 抛出异常
     * ```
     */
    public static func length(str: String, minLength: Int64, maxLength: Int64): String {
        if (str.size < minLength || str.size > maxLength) {
            throw IllegalArgumentException("Length must be between ${minLength} and ${maxLength}")
        }
        str
    }

    /**
     * 验证数字在指定范围内（使用 Comparable）
     *
     * @param value 待验证的值
     * @param min 最小值
     * @param max 最大值
     * @return 值本身
     * @throws IllegalArgumentException 如果值不在范围内
     *
     * 示例：
     * ```cangjie
     * Validate.inclusiveBetweenComparable(5, 1, 10)  // 返回 5
     * Validate.inclusiveBetweenComparable(0, 1, 10)  // 抛出异常
     * Validate.inclusiveBetweenComparable(11, 1, 10) // 抛出异常
     * ```
     */
    public static func inclusiveBetweenComparable<T>(value: T, min: T, max: T): T
        where T <: Comparable<T> {
        if (value.compare(min) == Ordering.LT || value.compare(max) == Ordering.GT) {
            throw IllegalArgumentException("Value not in range")
        }
        value
    }

    /**
     * 验证数字在指定范围外（不包含边界）
     *
     * @param value 待验证的值
     * @param min 最小值
     * @param max 最大值
     * @return 值本身
     * @throws IllegalArgumentException 如果值在范围内
     *
     * 示例：
     * ```cangjie
     * Validate.exclusiveOutside(5, 10, 20)  // 抛出异常
     * Validate.exclusiveOutside(5, 1, 10)   // 抛出异常
     * Validate.exclusiveOutside(0, 10, 20)  // 返回 0
     * Validate.exclusiveOutside(25, 10, 20) // 返回 25
     * ```
     */
    public static func exclusiveOutside(value: Int64, min: Int64, max: Int64): Int64 {
        if (value >= min && value <= max) {
            throw IllegalArgumentException("Value is in the specified exclusive range")
        }
        value
    }

    /**
     * 验证两个对象相等
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @throws IllegalArgumentException 如果对象不相等
     *
     * 示例：
     * ```cangjie
     * Validate.equal(10, 10)  // 通过
     * Validate.equal(10, 20)  // 抛出异常
     * ```
     */
    public static func equal<T>(obj1: T, obj2: T): Unit where T <: Equatable<T> {
        if (obj1 != obj2) {
            throw IllegalArgumentException("Objects are not equal")
        }
    }

    /**
     * 验证两个对象不相等
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @throws IllegalArgumentException 如果对象相等
     *
     * 示例：
     * ```cangjie
     * Validate.notEqual(10, 20)  // 通过
     * Validate.notEqual(10, 10)  // 抛出异常
     * ```
     */
    public static func notEqual<T>(obj1: T, obj2: T): Unit where T <: Equatable<T> {
        if (obj1 == obj2) {
            throw IllegalArgumentException("Objects are equal")
        }
    }

    /**
     * 验证整数是偶数
     *
     * @param value 待验证的值
     * @return 值本身
     * @throws IllegalArgumentException 如果值不是偶数
     *
     * 示例：
     * ```cangjie
     * Validate.even(10)  // 返回 10
     * Validate.even(11)  // 抛出异常
     * ```
     */
    public static func even(value: Int64): Int64 {
        if (value % 2 != 0) {
            throw IllegalArgumentException("Value is not even")
        }
        value
    }

    /**
     * 验证整数是奇数
     *
     * @param value 待验证的值
     * @return 值本身
     * @throws IllegalArgumentException 如果值不是奇数
     *
     * 示例：
     * ```cangjie
     * Validate.odd(11)  // 返回 11
     * Validate.odd(10)  // 抛出异常
     * ```
     */
    public static func odd(value: Int64): Int64 {
        if (value % 2 == 0) {
            throw IllegalArgumentException("Value is not odd")
        }
        value
    }

    /**
     * 验证值在集合中
     *
     * @param element 待验证的元素
     * @param collection 集合
     * @return 元素本身
     * @throws IllegalArgumentException 如果元素不在集合中
     *
     * 示例：
     * ```cangjie
     * let validValues = [1, 2, 3, 4, 5]
     * Validate.isIn(3, validValues)  // 返回 3
     * Validate.isIn(10, validValues) // 抛出异常
     * ```
     */
    public static func isIn<T>(element: T, collection: Array<T>): T where T <: Equatable<T> {
        if (!collection.contains(element)) {
            throw IllegalArgumentException("Element not in collection")
        }
        element
    }

    /**
     * 验证值不在集合中
     *
     * @param element 待验证的元素
     * @param collection 集合
     * @return 元素本身
     * @throws IllegalArgumentException 如果元素在集合中
     *
     * 示例：
     * ```cangjie
     * let invalidValues = [1, 2, 3]
     * Validate.isNotIn(5, invalidValues)  // 返回 5
     * Validate.isNotIn(2, invalidValues)  // 抛出异常
     * ```
     */
    public static func isNotIn<T>(element: T, collection: Array<T>): T where T <: Equatable<T> {
        if (collection.contains(element)) {
            throw IllegalArgumentException("Element is in collection")
        }
        element
    }

    // ========== 私有辅助方法 ==========

    /**
     * 格式化字符串
     *
     * @param format 格式字符串
     * @param args 参数列表
     * @return 格式化后的字符串
     */
    private static func formatString(format: String, args: Array<Int64>): String {
        // 简化的字符串格式化实现
        var result = format
        var index = 0
        for (arg in args) {
            let placeholder = "%d"
            let pos = indexOf(result, placeholder)
            if (pos >= 0 && index < args.size) {
                let before = substring(result, 0, pos)
                let after = substring(result, pos + 2, result.size)
                result = before + arg.toString() + after
            }
            index++
        }
        result
    }

    /**
     * 查找子字符串位置
     *
     * @param str 字符串
     * @param sub 子字符串
     * @return 位置，未找到返回 -1
     */
    private static func indexOf(str: String, sub: String): Int64 {
        if (sub.size == 0) {
            return 0
        }
        if (str.size < sub.size) {
            return -1
        }
        for (i in 0..(str.size - sub.size + 1)) {
            let subStr = substring(str, i, i + sub.size)
            if (subStr == sub) {
                return i
            }
        }
        -1
    }

    /**
     * 截取子字符串
     *
     * @param str 字符串
     * @param start 起始位置
     * @param end 结束位置
     * @return 子字符串
     */
    private static func substring(str: String, start: Int64, end: Int64): String {
        if (start >= end) {
            return ""
        }
        if (start >= str.size) {
            return ""
        }
        if (end > str.size) {
            return substring(str, start, str.size)
        }
        var result = ""
        var count = 0
        for (ch in str) {
            if (count >= start && count < end) {
                result += String.fromUtf8([ch])
            }
            count++
            if (count >= end) {
                break
            }
        }
        result
    }
}
