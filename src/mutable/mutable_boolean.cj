package commons_lang4cj.mutable

/**
 * 可变布尔值包装器
 *
 * 提供对 Bool 值的可变封装，支持逻辑运算和类型转换。
 * 适用于需要在闭包中修改外部布尔变量的场景。
 *
 * @since 1.0.0
 *
 * @example
 * ```cangjie
 * let mutableBool = MutableBoolean(true)
 * println(mutableBool.getValue())  // 输出: true
 * mutableBool.and(false)
 * println(mutableBool.getValue())  // 输出: false
 * ```
 */
public open class MutableBoolean <: Comparable<MutableBoolean> {
    /** 可变的布尔值 */
    private var _value: Bool = false

    /**
     * 构造一个默认值为 false 的 MutableBoolean
     */
    public init() {
        _value = false
    }

    /**
     * 用指定值构造新的 MutableBoolean
     *
     * @param value 初始布尔值
     */
    public init(value: Bool) {
        _value = value
    }

    /**
     * 通过解析字符串构造新的 MutableBoolean
     *
     * 支持宽松模式字符串解析，支持以下格式（不区分大小写）：
     * - true: "true", "t", "yes", "y", "1"
     * - false: "false", "f", "no", "n", "0"
     *
     * @param value 要解析的字符串
     * @throws IllegalArgumentException 如果字符串无法解析为布尔值
     */
    public init(value: String) {
        match (fromString(value)) {
            case Some(obj) => _value = obj.getValue()
            case None => throw IllegalArgumentException("Invalid boolean format: ${value}")
        }
    }

    /**
     * 获取当前布尔值
     *
     * @return 当前值
     */
    public func getValue(): Bool {
        _value
    }

    /**
     * 设置新的布尔值
     *
     * @param value 新值
     */
    public func setValue(value: Bool): Unit {
        _value = value
    }

    /**
     * 逻辑与运算：将当前值与指定值进行 AND 操作，结果保存到当前值
     *
     * @param value 要进行 AND 操作的值
     */
    public func and(value: Bool): Unit {
        _value = _value && value
    }

    /**
     * 逻辑或运算：将当前值与指定值进行 OR 操作，结果保存到当前值
     *
     * @param value 要进行 OR 操作的值
     */
    public func or(value: Bool): Unit {
        _value = _value || value
    }

    /**
     * 逻辑异或运算：将当前值与指定值进行 XOR 操作，结果保存到当前值
     *
     * @param value 要进行 XOR 操作的值
     */
    public func xor(value: Bool): Unit {
        _value = (_value && !value) || (!_value && value)
    }

    /**
     * 逻辑非运算：将当前值取反
     */
    public func not(): Unit {
        _value = !_value
    }

    /**
     * 判断当前值是否为 true
     *
     * @return true 如果当前值为 true
     */
    public func isTrue(): Bool {
        _value == true
    }

    /**
     * 判断当前值是否为 false
     *
     * @return true 如果当前值为 false
     */
    public func isFalse(): Bool {
        _value == false
    }

    /**
     * 转换为整数（true=1, false=0）
     *
     * @return 整数表示
     */
    public func toInt(): Int64 {
        if (_value) {
            1
        } else {
            0
        }
    }

    /**
     * 转换为字符串
     *
     * @return "true" 或 "false"
     */
    public func toString(): String {
        if (_value) {
            "true"
        } else {
            "false"
        }
    }

    /**
     * 相等性判断
     *
     * @param obj 要比较的对象
     * @return true 如果值相等
     */
    public func equals(obj: Object): Bool {
        // 仓颉不支持 === 操作符，直接进行类型转换和值比较
        match (obj) {
            case mb: MutableBoolean => _value == mb._value
            case _ => false
        }
    }

    /**
     * 计算哈希码
     *
     * @return 哈希码值（true=1231, false=1237，与 Java 一致）
     */
    public func hashCode(): Int64 {
        if (_value) {
            1231
        } else {
            1237
        }
    }

    /**
     * 比较两个 MutableBoolean 的大小
     *
     * false < true（false=0, true=1）
     *
     * @param other 要比较的对象
     * @return 负数表示小于，0 表示相等，正数表示大于
     */
    public func compare(other: MutableBoolean): Ordering {
        if (_value == other._value) {
            Ordering.EQ
        } else if (!_value && other._value) {
            Ordering.LT  // false < true
        } else {
            Ordering.GT  // true > false
        }
    }

    /**
     * 工厂方法：创建指定值的 MutableBoolean
     *
     * @param value 布尔值
     * @return 新创建的 MutableBoolean 实例
     */
    public static func of(value: Bool): MutableBoolean {
        MutableBoolean(value)
    }

    /**
     * 工厂方法：从字符串解析 MutableBoolean（宽松模式）
     *
     * 支持以下格式（不区分大小写）：
     * - true: "true", "t", "yes", "y", "1"
     * - false: "false", "f", "no", "n", "0"
     *
     * @param str 要解析的字符串
     * @return Some(MutableBoolean) 如果解析成功，None 如果失败
     */
    public static func fromString(str: String): Option<MutableBoolean> {
        // 不区分大小写的匹配
        match (str) {
            case "true" | "True" | "TRUE" | "t" | "T" | "yes" | "Yes" | "YES" | "y" | "Y" | "1" => Some(MutableBoolean(true))
            case "false" | "False" | "FALSE" | "f" | "F" | "no" | "No" | "NO" | "n" | "N" | "0" => Some(MutableBoolean(false))
            case _ => None
        }
    }
}
