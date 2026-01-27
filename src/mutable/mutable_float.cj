package commons_lang4cj.mutable

import std.convert.*

/**
 * 可变的 Float32 包装器
 *
 * 此类提供了对 Float32 值的可变封装，支持各种算术运算和类型转换。
 * 与 Java 版本对应，使用 Float32 类型对应 Java 的 float 类型。
 *
 * 注意：
 * - 此类不是线程安全的，如需线程安全请使用 Mutex 或相关原子类。
 * - 浮点数比较受精度限制，使用 epsilon 进行比较。
 * - NaN 和 Infinity 有特殊处理逻辑。
 *
 * @since 1.0.0
 */
public open class MutableFloat <: Number {
    /** 可变的值 */
    private var _value: Float32 = 0.0

    /**
     * 构造一个默认值为零的 MutableFloat
     */
    public init() {
        _value = 0.0
    }

    /**
     * 用指定值构造新的 MutableFloat
     *
     * @param value 初始值
     */
    public init(value: Float32) {
        _value = value
    }

    /**
     * 用指定值构造新的 MutableFloat
     *
     * @param value 初始值，不能为空
     */
    public init(value: Number) {
        _value = value.toFloat()
    }

    /**
     * 通过解析字符串构造新的 MutableFloat
     *
     * @param value 要解析的字符串
     * @throws IllegalArgumentException 如果字符串无法解析为浮点数
     */
    public init(value: String) {
        match (Float32.tryParse(value)) {
            case Some(v) => _value = v
            case None => throw IllegalArgumentException("Invalid float format: ${value}")
        }
    }

    /**
     * 将一个值加到此实例的值上
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Float32): MutableFloat {
        _value += operand
        return this
    }

    /**
     * 将一个值加到此实例的值上
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Number): MutableFloat {
        _value += operand.toFloat()
        return this
    }

    /**
     * 将此实例的值增加 operand，返回操作后的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作后与此实例关联的值
     */
    public func addAndGet(operand: Float32): Float32 {
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
    public func addAndGet(operand: Number): Float32 {
        _value += operand.toFloat()
        return _value
    }

    /**
     * 按升序将此可变对象与另一个比较
     *
     * @param other 要比较的其他可变对象
     * @return 负数表示小于，0 表示相等，正数表示大于
     */
    public func compareTo(other: MutableFloat): Int64 {
        if (isNaN()) {
            if (other.isNaN()) {
                0
            } else {
                1
            }
        } else if (other.isNaN()) {
            -1
        } else if (_value < other._value) {
            -1
        } else if (_value > other._value) {
            1
        } else {
            compareSignedBits(toIntBits(_value), toIntBits(other._value))
        }
    }

    private func compareSignedBits(a: UInt32, b: UInt32): Int64 {
        let aa = a ^ 0x80000000u32
        let bb = b ^ 0x80000000u32
        if (aa < bb) {
            -1
        } else if (aa > bb) {
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
    public func decrement(): MutableFloat {
        _value -= 1.0
        return this
    }

    /**
     * 将此实例的值减 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * @return 减少后与此实例关联的值
     */
    public func decrementAndGet(): Float32 {
        _value -= 1.0
        return _value
    }

    /**
     * 比较此对象与指定对象
     * 使用位比较方式，与 Java 的 Float.equals 行为一致
     * 对于 NaN 和 +/-0.0 有特殊处理
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
     * 辅助方法：检查是否等于另一个 MutableFloat
     * 使用位比较方式确保与 Java 行为一致
     */
    private func isEqualToMutable(other: Object): Bool {
        let mutableFloatOpt = other as MutableFloat
        match (mutableFloatOpt) {
            case None => false
            case Some(mutableFloat) => isEqualToMutableFloat(mutableFloat)
        }
    }

    /**
     * 辅助方法：比较两个 MutableFloat 的值
     * 使用位比较，与 Java 的 Float.floatToIntBits 一致
     */
    private func isEqualToMutableFloat(mutableFloat: MutableFloat): Bool {
        toIntBits(_value) == toIntBits(mutableFloat._value)
    }

    /**
     * 获取 Float32 的原始位表示（模拟 Java 的 Float.floatToIntBits）
     * 用于 equals 和 hashCode 方法
     */
    private func toIntBits(value: Float32): UInt32 {
        if (value.isNaN()) {
            0x7FC00000u32
        } else {
            value.toBits()
        }
    }

    /**
     * 将此实例的值增加 operand，返回操作前的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作前与此实例关联的值
     */
    public func getAndAdd(operand: Float32): Float32 {
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
    public func getAndAdd(operand: Number): Float32 {
        let last = _value
        _value += operand.toFloat()
        return last
    }

    /**
     * 将此实例的值减 1，返回操作前的值
     * 此方法不是线程安全的
     *
     * @return 减少前与此实例关联的值
     */
    public func getAndDecrement(): Float32 {
        let last = _value
        _value -= 1.0
        return last
    }

    /**
     * 将此实例的值加 1，返回操作前的值
     * 此方法不是线程安全的
     *
     * @return 增加前与此实例关联的值
     */
    public func getAndIncrement(): Float32 {
        let last = _value
        _value += 1.0
        return last
    }

    /**
     * 获取值
     *
     * @return 当前值
     */
    public func getValue(): Float32 {
        _value
    }

    /**
     * 返回此可变对象的合适哈希码
     * 使用 Float32 的位表示计算哈希码
     *
     * @return 合适的哈希码
     */
    public func hashCode(): Int64 {
        // 模拟 Java 的 Float.hashCode()
        // floatToIntBits(value)
        Int64(toIntBits(_value))
    }

    /**
     * 增加值
     *
     * @return this，支持链式调用
     */
    public func increment(): MutableFloat {
        _value += 1.0
        return this
    }

    /**
     * 将此实例的值加 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * @return 增加后与此实例关联的值
     */
    public func incrementAndGet(): Float32 {
        _value += 1.0
        return _value
    }

    /**
     * 检查 float 值是否为无穷大
     *
     * @return true 如果是无穷大
     */
    public func isInfinite(): Bool {
        _value.isInf()
    }

    /**
     * 检查 float 值是否为 NaN
     *
     * @return true 如果是 NaN
     */
    public func isNaN(): Bool {
        _value.isNaN()
    }

    /**
     * 设置值
     *
     * @param value 要设置的值
     */
    public func setValue(value: Float32): Unit {
        _value = value
    }

    /**
     * 从任何 Number 实例设置值
     *
     * @param value 要设置的值
     */
    public func setValue(value: Number): Unit {
        _value = value.toFloat()
    }

    /**
     * 从此实例的值中减去一个值
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Float32): MutableFloat {
        _value -= operand
        return this
    }

    /**
     * 从此实例的值中减去一个值
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Number): MutableFloat {
        _value -= operand.toFloat()
        return this
    }

    /**
     * 转换为 Int64
     *
     * @return 数值转换为 Int64 后的值（截断小数部分）
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
        _value
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
        let s = "${_value}"
        // 去除尾随的0和小数点
        if (s.contains(".")) {
            var endIdx = s.size
            // 从后往前找,去除尾随的0
            while (endIdx > 0 && s.size > endIdx - 1) {
                let charCode = if (endIdx > 0) { s[endIdx - 1] } else { 0u8 }
                if (charCode != 0u8 && charCode == 48u8) { // 48 是 '0' 的 ASCII 码
                    endIdx--
                } else {
                    break
                }
            }
            // 如果最后是小数点,也去除
            if (endIdx > 0 && s.size > endIdx - 1) {
                let charCode = s[endIdx - 1]
                if (charCode == 46u8) { // 46 是 '.' 的 ASCII 码
                    endIdx--
                }
            }
            s[0..endIdx]
        } else {
            s
        }
    }
}
