package commons_lang4cj.mutable

import std.convert.*

/**
 * 可变的 Int16 包装器
 *
 * 此类提供了对 Int16 值的可变封装，支持各种算术运算和类型转换。
 * 与原始的 Java 版本不同，仓颉版本使用 Int16 而非 short，数值范围一致。
 *
 * 数值范围: -32768 ~ 32767
 *
 * 注意：此类不是线程安全的，如需线程安全请使用 Mutex 或 AtomicInt16。
 * 注意：此类的算术运算不检查溢出，溢出后将产生未定义结果。
 *
 * @since 1.0.0
 */
public open class MutableShort <: Number {
    /** 可变的值 */
    private var _value: Int16 = 0

    /** Int16 最小值: -32768 */
    public static const MIN_VALUE: Int16 = -32768

    /** Int16 最大值: 32767 */
    public static const MAX_VALUE: Int16 = 32767

    /**
     * 构造一个默认值为零的 MutableShort
     */
    public init() {
        _value = 0
    }

    /**
     * 用指定值构造新的 MutableShort
     *
     * @param value 初始值
     */
    public init(value: Int16) {
        _value = value
    }

    /**
     * 用指定值构造新的 MutableShort
     *
     * @param value 初始值，不能为空
     */
    public init(value: Number) {
        let intValue = value.toInt()
        // 内联范围检查
        if (intValue < -32768 || intValue > 32767) {
            throw IllegalArgumentException("Value ${intValue} out of Int16 range")
        }
        _value = Int16(intValue)
    }

    /**
     * 通过解析字符串构造新的 MutableShort
     *
     * @param value 要解析的字符串
     * @throws IllegalArgumentException 如果字符串无法解析为整数
     */
    public init(value: String) {
        match (Int16.tryParse(value)) {
            case Some(v) => _value = v
            case None => throw IllegalArgumentException("Invalid integer format: ${value}")
        }
    }

    /**
     * 将一个值加到此实例的值上
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Int16): MutableShort {
        _value += operand
        return this
    }

    /**
     * 将一个值加到此实例的值上
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Number): MutableShort {
        let intValue = operand.toInt()
        if (intValue < -32768 || intValue > 32767) {
            throw IllegalArgumentException("Value ${intValue} out of Int16 range")
        }
        _value += Int16(intValue)
        return this
    }

    /**
     * 将此实例的值增加 operand，返回操作后的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要加的量
     * @return 操作后与此实例关联的值
     */
    public func addAndGet(operand: Int16): Int16 {
        _value += operand
        return _value
    }

    /**
     * 将此实例的值增加 operand，返回操作后的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要加的量
     * @return 操作后与此实例关联的值
     */
    public func addAndGet(operand: Number): Int16 {
        let intValue = operand.toInt()
        if (intValue < -32768 || intValue > 32767) {
            throw IllegalArgumentException("Value ${intValue} out of Int16 range")
        }
        _value += Int16(intValue)
        return _value
    }

    /**
     * 按升序将此可变对象与另一个比较
     *
     * @param other 要比较的其他可变对象
     * @return 负数表示小于，0 表示相等，正数表示大于
     */
    public func compareTo(other: MutableShort): Int64 {
        if (_value < other._value) {
            -1
        } else if (_value > other._value) {
            1
        } else {
            0
        }
    }

    /**
     * 减少值
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @return this，支持链式调用
     */
    public func decrement(): MutableShort {
        _value--
        return this
    }

    /**
     * 将此实例的值减 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @return 减少后与此实例关联的值
     */
    public func decrementAndGet(): Int16 {
        _value--
        return _value
    }

    /**
     * 比较此对象与指定对象
     * 当且仅当参数不为 None 且是包含相同 short 值的 MutableShort 对象时，结果为 true
     *
     * @param obj 要比较的对象
     * @return 如果对象相同则返回 true，否则返回 false
     */
    public func equals(obj: Object): Bool {
        match (obj) {
            case ms: MutableShort => _value == ms._value
            case _ => false
        }
    }

    /**
     * 将此实例的值增加 operand，返回操作前的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要加的量
     * @return 操作前与此实例关联的值
     */
    public func getAndAdd(operand: Int16): Int16 {
        let last = _value
        _value += operand
        return last
    }

    /**
     * 将此实例的值增加 operand，返回操作前的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要加的量
     * @return 操作前与此实例关联的值
     */
    public func getAndAdd(operand: Number): Int16 {
        let last = _value
        let intValue = operand.toInt()
        if (intValue < -32768 || intValue > 32767) {
            throw IllegalArgumentException("Value ${intValue} out of Int16 range")
        }
        _value += Int16(intValue)
        return last
    }

    /**
     * 将此实例的值减 1，返回操作前的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @return 减少前与此实例关联的值
     */
    public func getAndDecrement(): Int16 {
        let last = _value
        _value--
        return last
    }

    /**
     * 将此实例的值加 1，返回操作前的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @return 增加前与此实例关联的值
     */
    public func getAndIncrement(): Int16 {
        let last = _value
        _value++
        return last
    }

    /**
     * 获取值
     *
     * @return 当前值
     */
    public func getValue(): Int16 {
        _value
    }

    /**
     * 返回此可变对象的合适哈希码
     *
     * @return 合适的哈希码
     */
    public func hashCode(): Int64 {
        Int64(_value)
    }

    /**
     * 增加值
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @return this，支持链式调用
     */
    public func increment(): MutableShort {
        _value++
        return this
    }

    /**
     * 将此实例的值加 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @return 增加后与此实例关联的值
     */
    public func incrementAndGet(): Int16 {
        _value++
        return _value
    }

    /**
     * 设置值
     *
     * @param value 要设置的值
     */
    public func setValue(value: Int16): Unit {
        _value = value
    }

    /**
     * 从任何 Number 实例设置值
     *
     * @param value 要设置的值
     */
    public func setValue(value: Number): Unit {
        let intValue = value.toInt()
        if (intValue < -32768 || intValue > 32767) {
            throw IllegalArgumentException("Value ${intValue} out of Int16 range")
        }
        _value = Int16(intValue)
    }

    /**
     * 从此实例的值中减去一个值
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Int16): MutableShort {
        _value -= operand
        return this
    }

    /**
     * 从此实例的值中减去一个值
     *
     * 注意：此方法不检查溢出，溢出后将产生未定义结果。
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Number): MutableShort {
        let intValue = operand.toInt()
        if (intValue < -32768 || intValue > 32767) {
            throw IllegalArgumentException("Value ${intValue} out of Int16 range")
        }
        _value -= Int16(intValue)
        return this
    }

    /**
     * 转换为 Int64
     *
     * @return 数值转换为 Int64 后的值
     */
    public func toInt(): Int64 {
        Int64(_value)
    }

    /**
     * 转换为 Float32
     *
     * @return 数值转换为 Float32 后的值
     */
    public func toFloat(): Float32 {
        Float32(_value)
    }

    /**
     * 转换为 Float64
     *
     * @return 数值转换为 Float64 后的值
     */
    public func toDouble(): Float64 {
        Float64(_value)
    }

    /**
     * 返回此可变对象的字符串值
     *
     * @return 可变值的字符串表示
     */
    public func toString(): String {
        "${_value}"
    }
}
