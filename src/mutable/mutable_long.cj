package commons_lang4cj.mutable

import std.convert.*

/**
 * 可变的 Int64 包装器
 *
 * 此类提供了对 Int64 值的可变封装，支持各种算术运算和类型转换。
 * 与原始的 Java 版本对应，使用 Int64 类型对应 Java 的 long 类型。
 *
 * 注意：此类不是线程安全的，如需线程安全请使用 Mutex 或 AtomicInt64。
 *
 * @since 1.0.0
 */
public open class MutableLong <: Number {
    /** 可变的值 */
    private var _value: Int64 = 0

    /**
     * 构造一个默认值为零的 MutableLong
     */
    public init() {
        _value = 0
    }

    /**
     * 用指定值构造新的 MutableLong
     *
     * @param value 初始值
     */
    public init(value: Int64) {
        _value = value
    }

    /**
     * 用指定值构造新的 MutableLong
     *
     * @param value 初始值，不能为空
     */
    public init(value: Number) {
        _value = value.toInt()
    }

    /**
     * 通过解析字符串构造新的 MutableLong
     *
     * @param value 要解析的字符串
     * @throws IllegalArgumentException 如果字符串无法解析为整数
     */
    public init(value: String) {
        match (Int64.tryParse(value)) {
            case Some(v) => _value = v
            case None => throw IllegalArgumentException("Invalid long format: ${value}")
        }
    }

    /**
     * 将一个值加到此实例的值上
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Int64): MutableLong {
        _value += operand
        return this
    }

    /**
     * 将一个值加到此实例的值上
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Number): MutableLong {
        _value += operand.toInt()
        return this
    }

    /**
     * 将此实例的值增加 operand，返回操作后的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作后与此实例关联的值
     */
    public func addAndGet(operand: Int64): Int64 {
        _value += operand
        return _value
    }

    /**
     * 将此实例的值增加 operand，返回操作后的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作后与此实例关联的值
     */
    public func addAndGet(operand: Number): Int64 {
        _value += operand.toInt()
        return _value
    }

    /**
     * 按升序将此可变对象与另一个比较
     *
     * @param other 要比较的其他可变对象
     * @return 负数表示小于，0 表示相等，正数表示大于
     */
    public func compareTo(other: MutableLong): Int64 {
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
     * @return this，支持链式调用
     */
    public func decrement(): MutableLong {
        _value--
        return this
    }

    /**
     * 将此实例的值减 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * @return 减少后与此实例关联的值
     */
    public func decrementAndGet(): Int64 {
        _value--
        return _value
    }

    /**
     * 比较此对象与指定对象
     * 当且仅当参数不为 None 且是包含相同 long 值的 MutableLong 对象时，结果为 true
     *
     * @param obj 要比较的对象
     * @return 如果对象相同则返回 true，否则返回 false
     */
    public func equals(obj: Option<Object>): Bool {
        match (obj) {
            case None => false
            case Some(other) => isEqualToMutable(other)
        }
    }

    /**
     * 辅助方法：检查是否等于另一个 MutableLong
     */
    private func isEqualToMutable(other: Object): Bool {
        let mutableLongOpt = other as MutableLong
        match (mutableLongOpt) {
            case None => false
            case Some(mutableLong) => _value == mutableLong._value
        }
    }

    /**
     * 将此实例的值增加 operand，返回操作前的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作前与此实例关联的值
     */
    public func getAndAdd(operand: Int64): Int64 {
        let last = _value
        _value += operand
        return last
    }

    /**
     * 将此实例的值增加 operand，返回操作前的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作前与此实例关联的值
     */
    public func getAndAdd(operand: Number): Int64 {
        let last = _value
        _value += operand.toInt()
        return last
    }

    /**
     * 将此实例的值减 1，返回操作前的值
     * 此方法不是线程安全的
     *
     * @return 减少前与此实例关联的值
     */
    public func getAndDecrement(): Int64 {
        let last = _value
        _value--
        return last
    }

    /**
     * 将此实例的值加 1，返回操作前的值
     * 此方法不是线程安全的
     *
     * @return 增加前与此实例关联的值
     */
    public func getAndIncrement(): Int64 {
        let last = _value
        _value++
        return last
    }

    /**
     * 获取值
     *
     * @return 当前值
     */
    public func getValue(): Int64 {
        _value
    }

    /**
     * 返回此可变对象的合适哈希码
     *
     * @return 合适的哈希码
     */
    public func hashCode(): Int64 {
        _value
    }

    /**
     * 增加值
     *
     * @return this，支持链式调用
     */
    public func increment(): MutableLong {
        _value++
        return this
    }

    /**
     * 将此实例的值加 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * @return 增加后与此实例关联的值
     */
    public func incrementAndGet(): Int64 {
        _value++
        return _value
    }

    /**
     * 设置值
     *
     * @param value 要设置的值
     */
    public func setValue(value: Int64): Unit {
        _value = value
    }

    /**
     * 从任何 Number 实例设置值
     *
     * @param value 要设置的值
     */
    public func setValue(value: Number): Unit {
        _value = value.toInt()
    }

    /**
     * 从此实例的值中减去一个值
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Int64): MutableLong {
        _value -= operand
        return this
    }

    /**
     * 从此实例的值中减去一个值
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Number): MutableLong {
        _value -= operand.toInt()
        return this
    }

    /**
     * 转换为 Int64
     *
     * @return 数值转换为 Int64 后的值
     */
    public func toInt(): Int64 {
        _value
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
