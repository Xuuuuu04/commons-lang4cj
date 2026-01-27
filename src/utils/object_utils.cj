package commons_lang4cj.utils

import std.convert.*
import std.reflect.*

/**
 * ObjectUtils 对象工具类
 *
 * 仓颉版本的 Apache Commons Lang ObjectUtils 工具类
 * 提供对象操作的静态方法集合
 *
 * 注意：仓颉使用 Option<T> 类型表示可能为空的值，而不是 null
 * 因此本类中的所有方法都使用 Option<T> 进行空值处理
 *
 * 功能包括：
 * - 空值处理（DefaultIfNull/IsNull/NotNull）
 * - 相等比较（Equal/NotEqual）
 * - 比较操作（Compare/Min/Max）
 * - 哈希码（Hash）
 * - 字符串表示（ToString/IdentityToString）
 * - 克隆（Clone/AllNull/AnyNull）
 *
 * @since 1.0.0
 */
public class ObjectUtils {
    // ========== Phase 1: 空值处理 ==========

    /**
     * 获取默认值
     *
     * 如果对象为 None，返回默认值；否则返回对象本身
     *
     * @param obj 待检查的对象
     * @param defaultValue 默认值
     * @return 对象或默认值
     *
     * 示例：
     * ```cangjie
     * let someVal: Option<Int64> = Some(42)
     * let noneVal: Option<Int64> = None
     * ObjectUtils.defaultIfNull(someVal, 0)  // 42
     * ObjectUtils.defaultIfNull(noneVal, 0)  // 0
     * ```
     */
    public static func defaultIfNull<T>(obj: Option<T>, defaultValue: T): T {
        obj ?? defaultValue
    }

    /**
     * 检查对象是否为 None
     *
     * @param obj 待检查的对象
     * @return 如果对象为 None 返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let someVal: Option<Int64> = Some(42)
     * let noneVal: Option<Int64> = None
     * ObjectUtils.isNull(someVal)  // false
     * ObjectUtils.isNull(noneVal)  // true
     * ```
     */
    public static func isNull<T>(obj: Option<T>): Bool {
        match (obj) {
            case None => true
            case _ => false
        }
    }

    /**
     * 检查对象是否不为 None
     *
     * @param obj 待检查的对象
     * @return 如果对象不为 None 返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let someVal: Option<Int64> = Some(42)
     * let noneVal: Option<Int64> = None
     * ObjectUtils.notNull(someVal)  // true
     * ObjectUtils.notNull(noneVal)  // false
     * ```
     */
    public static func notNull<T>(obj: Option<T>): Bool {
        !isNull(obj)
    }

    // ========== Phase 2: 相等比较 ==========

    /**
     * null 安全相等比较
     *
     * 比较两个对象是否相等，处理 None 值
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @return 如果两个对象相等或都为 None 返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let val1: Option<Int64> = Some(42)
     * let val2: Option<Int64> = Some(42)
     * let val3: Option<Int64> = None
     * ObjectUtils.equal(val1, val2)  // true
     * ObjectUtils.equal(val1, val3)  // false
     * ObjectUtils.equal(val3, val3)  // true
     * ```
     */
    public static func equal<T>(obj1: Option<T>, obj2: Option<T>): Bool where T <: Equatable<T> {
        if (isNull(obj1) && isNull(obj2)) {
            return true
        }
        if (isNull(obj1) || isNull(obj2)) {
            return false
        }
        // 使用 if-let 解构两个 Option
        if (let Some(v1) <- obj1) {
            if (let Some(v2) <- obj2) {
                return v1 == v2
            }
        }
        false
    }

    /**
     * null 安全不等比较
     *
     * 比较两个对象是否不相等，处理 None 值
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @return 如果两个对象不相等返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let val1: Option<Int64> = Some(42)
     * let val2: Option<Int64> = Some(43)
     * let val3: Option<Int64> = None
     * ObjectUtils.notEqual(val1, val2)  // true
     * ObjectUtils.notEqual(val1, val3)  // true
     * ObjectUtils.notEqual(val3, val3)  // false
     * ```
     */
    public static func notEqual<T>(obj1: Option<T>, obj2: Option<T>): Bool where T <: Equatable<T> {
        !equal(obj1, obj2)
    }

    // ========== Phase 3: 比较操作 ==========

    /**
     * null 安全比较
     *
     * 比较两个可比较对象的大小，None 被认为小于任何非 None 值
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @return 负数表示 obj1 < obj2，0 表示相等，正数表示 obj1 > obj2
     *
     * 示例：
     * ```cangjie
     * let val1: Option<Int64> = Some(42)
     * let val2: Option<Int64> = Some(43)
     * let val3: Option<Int64> = None
     * ObjectUtils.compare(val1, val2)  // -1
     * ObjectUtils.compare(val2, val1)  // 1
     * ObjectUtils.compare(val1, val1)  // 0
     * ObjectUtils.compare(val3, val1)  // -1 (None < any value)
     * ```
     */
    public static func compare<T>(obj1: Option<T>, obj2: Option<T>): Int64 where T <: Comparable<T> {
        if (isNull(obj1) && isNull(obj2)) {
            return 0
        }
        if (isNull(obj1)) {
            return -1  // None 小于任何非 None 值
        }
        if (isNull(obj2)) {
            return 1   // 任何非 None 值大于 None
        }
        // 两个都是 Some
        if (let Some(v1) <- obj1) {
            if (let Some(v2) <- obj2) {
                let cmp = v1.compare(v2)
                if (cmp == Ordering.LT) {
                    return -1
                } else if (cmp == Ordering.GT) {
                    return 1
                } else {
                    return 0
                }
            }
        }
        0
    }

    /**
     * 返回两个值中的较小值
     *
     * @param obj1 第一个值
     * @param obj2 第二个值
     * @return 较小的值
     *
     * 示例：
     * ```cangjie
     * ObjectUtils.min(42, 43)  // 42
     * ObjectUtils.min(43, 42)  // 42
     * ObjectUtils.min(42, 42)  // 42
     * ```
     */
    public static func min<T>(obj1: T, obj2: T): T where T <: Comparable<T> {
        match (obj1.compare(obj2)) {
            case Ordering.LT => obj1
            case Ordering.EQ => obj1
            case Ordering.GT => obj2
        }
    }

    /**
     * 返回两个值中的较大值
     *
     * @param obj1 第一个值
     * @param obj2 第二个值
     * @return 较大的值
     *
     * 示例：
     * ```cangjie
     * ObjectUtils.max(42, 43)  // 43
     * ObjectUtils.max(43, 42)  // 43
     * ObjectUtils.max(42, 42)  // 42
     * ```
     */
    public static func max<T>(obj1: T, obj2: T): T where T <: Comparable<T> {
        match (obj1.compare(obj2)) {
            case Ordering.LT => obj2
            case Ordering.EQ => obj1
            case Ordering.GT => obj1
        }
    }

    // ========== Phase 4: 哈希码 ==========

    /**
     * null 安全哈希码（Int64 版本）
     *
     * 获取对象的哈希码，None 返回 0
     *
     * @param obj 待计算哈希码的对象
     * @return 哈希码，None 返回 0
     *
     * 示例：
     * ```cangjie
     * let val: Option<Int64> = Some(42)
     * let noneVal: Option<Int64> = None
     * ObjectUtils.hash(val)      // 42
     * ObjectUtils.hash(noneVal)  // 0
     * ```
     */
    public static func hash(obj: Option<Int64>): Int64 {
        match (obj) {
            case None => 0
            case Some(v) => v
        }
    }

    /**
     * null 安全哈希码（String 版本）
     *
     * @param obj 待计算哈希码的对象
     * @return 哈希码
     */
    public static func hashString(obj: Option<String>): Int64 {
        match (obj) {
            case None => 0
            case Some(s) => calcStringHash(s)
        }
    }

    /**
     * 计算字符串哈希码（辅助方法）
     */
    private static func calcStringHash(s: String): Int64 {
        var hashValue: Int64 = 0
        for (ch in s) {
            hashValue = hashValue * 31 + Int64(ch)
        }
        hashValue
    }

    // ========== Phase 5: 字符串表示 ==========

    /**
     * null 安全 toString
     *
     * 获取对象的字符串表示，None 返回空字符串
     *
     * @param obj 待转换为字符串的对象
     * @return 字符串表示，None 返回空字符串
     *
     * 示例：
     * ```cangjie
     * let val: Option<Int64> = Some(42)
     * let noneVal: Option<Int64> = None
     * ObjectUtils.toString(val)      // "42"
     * ObjectUtils.toString(noneVal)  // ""
     * ```
     */
    public static func toString<T>(obj: Option<T>): String where T <: ToString {
        match (obj) {
            case None => ""
            case Some(v) => v.toString()
        }
    }

    /**
     * 返回对象的身份字符串
     *
     * 格式为：类名@哈希码十六进制
     * None 返回空字符串
     *
     * @param obj 待获取身份字符串的对象
     * @return 身份字符串，None 返回空字符串
     *
     * 示例：
     * ```cangjie
     * let val: Option<String> = Some("hello")
     * let noneVal: Option<String> = None
     * ObjectUtils.identityToString(val)      // "String@2a" (示例)
     * ObjectUtils.identityToString(noneVal)  // ""
     * ```
     */
    public static func identityToString<T>(obj: Option<T>): String where T <: ToString {
        match (obj) {
            case None => ""
            case Some(v) => buildIdentityString(v)
        }
    }

    /**
     * 构建身份字符串（辅助方法）
     */
    private static func buildIdentityString<T>(v: T): String where T <: ToString {
        let typeName = getTypeName(v)
        let hashCode = match (v as Hashable) {
            case Some(h) => h.hashCode()
            case None => 0
        }
        let hexHash = toHexString(hashCode)
        "${typeName}@${hexHash}"
    }

    /**
     * 将整数转换为十六进制字符串
     *
     * @param value 整数值
     * @return 十六进制字符串
     */
    private static func toHexString(value: Int64): String {
        var u: UInt64
        if (value == -0x8000_0000_0000_0000) {
            u = 0x8000_0000_0000_0000u64
        } else {
            let absValue = if (value < 0) { -value } else { value }
            u = UInt64(absValue)
        }
        if (u == 0u64) {
            return "0"
        }

        let sb = StringBuilder(16)
        var shift: Int64 = 60
        var started = false
        while (shift >= 0) {
            let nibble = (u >> UInt64(shift)) & 0xFu64
            if (!started) {
                if (nibble == 0u64) {
                    shift -= 4
                    continue
                }
                started = true
            }

            let ascii = if (nibble < 10u64) {
                UInt32(48u8 + UInt8(nibble))
            } else {
                UInt32(87u8 + UInt8(nibble))
            }
            sb.append(Rune(ascii))
            shift -= 4
        }

        sb.toString()
    }

    // ========== Phase 6: 克隆与数组检查 ==========

    /**
     * 克隆对象
     *
     * 注意：仓颉没有内置的 Cloneable 接口
     * 此方法仅适用于实现了特定克隆方法的对象
     * 对于大多数情况，应使用值类型的复制语义
     *
     * @param obj 待克隆的对象
     * @return 克隆后的对象，如果对象不可克隆则返回自身
     *
     * 示例：
     * ```cangjie
     * // 对于值类型（如 struct），直接赋值即为克隆
     * let original = 42
     * let cloned = ObjectUtils.clone(original)
     * ```
     */
    public static func clone<T>(obj: T): T {
        // 仓颉中，值类型（struct）天然支持复制
        // 引用类型（class）需要实现克隆方法
        // 这里返回对象本身，实际克隆应由类型实现者提供
        obj
    }

    /**
     * 检查数组中的所有元素是否都为 None
     *
     * @param objs 待检查的对象数组
     * @return 如果所有元素都为 None 或数组为空返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let arr1 = [None, None]
     * let arr2 = [Some(42), None]
     * ObjectUtils.allNull(arr1)  // true
     * ObjectUtils.allNull(arr2)  // false
     * ObjectUtils.allNull([])    // true
     * ```
     */
    public static func allNull<T>(objs: Array<Option<T>>): Bool {
        for (obj in objs) {
            if (notNull(obj)) {
                return false
            }
        }
        true
    }

    /**
     * 检查数组中是否有任意元素为 None
     *
     * @param objs 待检查的对象数组
     * @return 如果有任意元素为 None 返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let arr1 = [Some(42), Some(43)]
     * let arr2 = [Some(42), None]
     * ObjectUtils.anyNull(arr1)  // false
     * ObjectUtils.anyNull(arr2)  // true
     * ObjectUtils.anyNull([])    // false
     * ```
     */
    public static func anyNull<T>(objs: Array<Option<T>>): Bool {
        for (obj in objs) {
            if (isNull(obj)) {
                return true
            }
        }
        false
    }

    // ========== 私有辅助方法 ==========

    /**
     * 获取对象的类型名称
     *
     * @param _ 对象（未使用，保留用于类型推断）
     * @return 类型名称
     */
    private static func getTypeName<T>(value: T): String {
        try {
            TypeInfo.of(value).name
        } catch (e: Exception) {
            "Object"
        }
    }

    // ========== Phase 7: 额外实用方法 ==========

    /**
     * 获取第一个非 None 值
     *
     * 从多个对象中返回第一个非 None 的值
     *
     * @param values 可选值数组
     * @return 第一个非 None 值，如果全部为 None 返回 None
     *
     * 示例：
     * ```cangjie
     * let arr = [None, Some(42), Some(100)]
     * ObjectUtils.firstNonNull(arr)  // Some(42)
     * ```
     */
    public static func firstNonNull<T>(values: Array<Option<T>>): Option<T> {
        for (value in values) {
            if (notNull(value)) {
                return value
            }
        }
        None
    }

    /**
     * 比较两个对象是否相等（支持自定义比较器）
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @param comparator 比较器函数
     * @return 如果比较器返回 0 表示相等
     *
     * 示例：
     * ```cangjie
     * let cmp = { (a: Int64, b: Int64) => (a - b) }
     * ObjectUtils.compareWith(10, 10, cmp)  // true
     * ObjectUtils.compareWith(10, 20, cmp)  // false
     * ```
     */
    public static func compareWith<T>(obj1: T, obj2: T, comparator: (T, T) -> Int64): Bool {
        comparator(obj1, obj2) == 0
    }

    /**
     * 介值比较（使用自定义比较器）
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @param comparator 比较器函数
     * @return 比较结果（负数/0/正数）
     *
     * 示例：
     * ```cangjie
     * let cmp = { (a: Int64, b: Int64) => (a - b) }
     * ObjectUtils.medianCompare(10, 20, cmp)  // < 0
     * ```
     */
    public static func medianCompare<T>(obj1: T, obj2: T, comparator: (T, T) -> Int64): Int64 {
        comparator(obj1, obj2)
    }

    /**
     * 检查对象是否为指定类型
     *
     * @param obj 待检查的对象
     * @return 如果类型匹配返回 true
     *
     * 示例：
     * ```cangjie
     * let str: Option<String> = Some("hello")
     * let num: Option<Int64> = Some(42)
     * ObjectUtils.isType(str, { x: String => true }, { _ => false })  // true
     * ```
     */
    public static func isType<T>(obj: Option<T>, typeChecker: (T) -> Bool, _: () -> Bool): Bool {
        match (obj) {
            case None => false
            case Some(v) => typeChecker(v)
        }
    }

    /**
     * 检查对象是否为字符串类型
     */
    public static func isString(obj: Option<String>): Bool {
        match (obj) {
            case None => false
            case Some(_) => true
        }
    }

    /**
     * 检查对象是否为数字类型（Int64）
     */
    public static func isInt64(obj: Option<Int64>): Bool {
        match (obj) {
            case None => false
            case Some(_) => true
        }
    }

    /**
     * 检查对象是否为浮点类型（Float64）
     */
    public static func isFloat64(obj: Option<Float64>): Bool {
        match (obj) {
            case None => false
            case Some(_) => true
        }
    }

    /**
     * 检查对象是否为数字（Int64 或 Float64）
     *
     * 由于仓颉不支持联合类型，此方法简化为只检查 Int64
     */
    public static func isNumber(obj: Option<Int64>): Bool {
        isInt64(obj)
    }

    public static func isNumber(obj: Option<Any>): Bool {
        match (obj) {
            case None => false
            case Some(v) =>
                (v as Int8).isSome() ||
                (v as Int16).isSome() ||
                (v as Int32).isSome() ||
                (v as Int64).isSome() ||
                (v as IntNative).isSome() ||
                (v as UInt8).isSome() ||
                (v as UInt16).isSome() ||
                (v as UInt32).isSome() ||
                (v as UInt64).isSome() ||
                (v as UIntNative).isSome() ||
                (v as Float16).isSome() ||
                (v as Float32).isSome() ||
                (v as Float64).isSome()
        }
    }

    /**
     * 如果对象为 None 则抛出异常
     *
     * @param obj 待检查的对象
     * @return 非None 的对象
     * @throws IllegalArgumentException 如果对象为 None
     *
     * 示例：
     * ```cangjie
     * let val: Option<Int64> = Some(42)
     * ObjectUtils.requireNonNull(val)  // 42
     * ```
     */
    public static func requireNonNull<T>(obj: Option<T>): T {
        match (obj) {
            case None => throw IllegalArgumentException("Object cannot be None")
            case Some(v) => v
        }
    }

    /**
     * 如果对象为 None 则抛出异常（带自定义消息）
     *
     * @param obj 待检查的对象
     * @param message 错误消息
     * @return 非None 的对象
     * @throws IllegalArgumentException 如果对象为 None
     */
    public static func requireNonNull<T>(obj: Option<T>, message: String): T {
        match (obj) {
            case None => throw IllegalArgumentException(message)
            case Some(v) => v
        }
    }

    /**
     * 对象比较（使用 Comparable 接口）
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @return 比较结果
     *
     * 示例：
     * ```cangjie
     * ObjectUtils.compareTo(10, 20)  // < 0
     * ObjectUtils.compareTo(20, 10)  // > 0
     * ObjectUtils.compareTo(10, 10)  // 0
     * ```
     */
    public static func compareTo<T>(obj1: T, obj2: T): Int64 where T <: Comparable<T> {
        match (obj1.compare(obj2)) {
            case Ordering.LT => -1
            case Ordering.EQ => 0
            case Ordering.GT => 1
        }
    }

    /**
     * 检查数组是否包含 null 元素
     *
     * @param array 待检查的数组
     * @return 如果数组包含 None 元素返回 true
     *
     * 示例：
     * ```cangjie
     * let arr1 = [Some(1), Some(2), Some(3)]
     * let arr2 = [Some(1), None, Some(3)]
     * ObjectUtils.containsNull(arr1)  // false
     * ObjectUtils.containsNull(arr2)  // true
     * ```
     */
    public static func containsNull<T>(array: Array<Option<T>>): Bool {
        for (elem in array) {
            if (isNull(elem)) {
                return true
            }
        }
        false
    }

    /**
     * 过滤掉数组中的 None 元素
     *
     * @param array 待过滤的数组
     * @return 只包含非None 元素的数组
     *
     * 示例：
     * ```cangjie
     * let arr = [Some(1), None, Some(3), None]
     * ObjectUtils.filterNonNull(arr)  // [Some(1), Some(3)]
     * ```
     */
    public static func filterNonNull<T>(array: Array<Option<T>>): Array<Option<T>> {
        // 计算非 None 元素的数量
        var count = 0
        for (elem in array) {
            if (notNull(elem)) {
                count++
            }
        }
        // 使用 Array 构造器创建新数组
        if (count == 0) {
            return Array<Option<T>>()
        }
        Array<Option<T>>(count, { index =>
            var current = 0
            for (elem in array) {
                if (notNull(elem)) {
                    if (current == index) {
                        return elem
                    }
                    current++
                }
            }
            array[0]  // 不应该到达这里
        })
    }

    /**
     * 检查对象是否为数组
     *
     * @param obj 待检查的对象
     * @return 如果是数组返回 true
     */
    public static func isArray(obj: Option<Any>): Bool {
        match (obj) {
            case Some(v) =>
                try {
                    let ty = TypeInfo.of(v)
                    ty.name == "Array" || ty.name == "VArray" || ty.qualifiedName.contains("Array")
                } catch (e: Exception) {
                    false
                }
            case _ => false
        }
    }

    /**
     * 安全地将对象转换为指定类型
     *
     * @param obj 待转换的对象
     * @param converter 转换函数
     * @return 转换后的对象，失败返回 None
     *
     * 示例：
     * ```cangjie
     * let val: Option<String> = Some("hello")
     * ObjectUtils.safeCast(val, { x: String => Some(x) }, { _ => None })  // Some("hello")
     * ```
     */
    public static func safeCast<T, R>(obj: Option<T>, converter: (T) -> Option<R>, _: () -> Option<R>): Option<R> {
        match (obj) {
            case None => None
            case Some(v) => converter(v)
        }
    }

    /**
     * 检查两个对象是否引用相等（指针相等）
     *
     * 注意：仓颉中值类型使用 == 比较值
     * 引用类型（class）使用 === 比较引用
     *
     * @param obj1 第一个对象
     * @param obj2 第二个对象
     * @return 是否引用相等
     */
    public static func isSame<T>(obj1: Option<T>, obj2: Option<T>): Bool where T <: Equatable<T> {
        if (isNull(obj1) && isNull(obj2)) {
            return true
        }
        if (isNull(obj1) || isNull(obj2)) {
            return false
        }
        // 两个都是 Some，使用 equal 方法
        equal(obj1, obj2)
    }
}
