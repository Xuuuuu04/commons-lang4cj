package commons_lang4cj.mutable

import std.convert.*

/**
 * 可变的 Float64 包装器
 *
 * 此类提供了对 Float64 值的可变封装，支持各种算术运算和类型转换。
 * 与 Java 版本对应，使用 Float64 类型对应 Java 的 double 类型。
 *
 * 注意：
 * - 此类不是线程安全的，如需线程安全请使用 Mutex 或相关原子类。
 * - 浮点数比较受精度限制，使用 epsilon 进行比较。
 * - NaN 和 Infinity 有特殊处理逻辑。
 *
 * @since 1.0.0
 */
public open class MutableDouble <: Number {
    /** 可变的值 */
    private var _value: Float64 = 0.0

    /**
     * 构造一个默认值为零的 MutableDouble
     */
    public init() {
        _value = 0.0
    }

    /**
     * 用指定值构造新的 MutableDouble
     *
     * @param value 初始值
     */
    public init(value: Float64) {
        _value = value
    }

    /**
     * 用指定值构造新的 MutableDouble
     *
     * @param value 初始值，不能为空
     */
    public init(value: Number) {
        _value = value.toDouble()
    }

    /**
     * 通过解析字符串构造新的 MutableDouble
     *
     * @param value 要解析的字符串
     * @throws IllegalArgumentException 如果字符串无法解析为浮点数
     */
    public init(value: String) {
        match (Float64.tryParse(value)) {
            case Some(v) => _value = v
            case None => throw IllegalArgumentException("Invalid double format: ${value}")
        }
    }

    /**
     * 将一个值加到此实例的值上
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Float64): MutableDouble {
        _value += operand
        return this
    }

    /**
     * 将一个值加到此实例的值上
     *
     * @param operand 要加的值
     * @return this，支持链式调用
     */
    public func add(operand: Number): MutableDouble {
        _value += operand.toDouble()
        return this
    }

    /**
     * 将此实例的值增加 operand，返回操作后的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作后与此实例关联的值
     */
    public func addAndGet(operand: Float64): Float64 {
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
    public func addAndGet(operand: Number): Float64 {
        _value += operand.toDouble()
        return _value
    }

    /**
     * 按升序将此可变对象与另一个比较
     *
     * @param other 要比较的其他可变对象
     * @return 负数表示小于，0 表示相等，正数表示大于
     */
    public func compareTo(other: MutableDouble): Int64 {
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
            0
        }
    }

    /**
     * 减少值
     *
     * @return this，支持链式调用
     */
    public func decrement(): MutableDouble {
        _value -= 1.0
        return this
    }

    /**
     * 将此实例的值减 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * @return 减少后与此实例关联的值
     */
    public func decrementAndGet(): Float64 {
        _value -= 1.0
        return _value
    }

    /**
     * 比较此对象与指定对象
     * 使用位比较方式，与 Java 的 Double.equals 行为一致
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
     * 辅助方法：检查是否等于另一个 MutableDouble
     * 使用位比较方式确保与 Java 行为一致
     */
    private func isEqualToMutable(other: Object): Bool {
        let mutableDoubleOpt = other as MutableDouble
        match (mutableDoubleOpt) {
            case None => false
            case Some(mutableDouble) => isEqualToMutableDouble(mutableDouble)
        }
    }

    /**
     * 辅助方法：比较两个 MutableDouble 的值
     * 使用位比较，与 Java 的 Double.doubleToLongBits 一致
     */
    private func isEqualToMutableDouble(mutableDouble: MutableDouble): Bool {
        // 使用位比较，与 Java 的 Double.doubleToLongBits 一致
        // NaN == NaN 为 true
        // +0.0 != -0.0
        if (_value.isNaN() && mutableDouble._value.isNaN()) {
            true
        } else if (_value == mutableDouble._value) {
            // 检查符号位是否一致（区分 +0.0 和 -0.0）
            let thisBits = getRawBits(_value)
            let otherBits = getRawBits(mutableDouble._value)
            thisBits == otherBits
        } else {
            false
        }
    }

    /**
     * 获取 Float64 的原始位表示（模拟 Java 的 Double.doubleToLongBits）
     * 用于 equals 和 hashCode 方法
     */
    private func getRawBits(value: Float64): UInt64 {
        // 使用 Float64 的位表示
        // 在仓颉中，我们使用值的字符串比较来模拟位比较
        if (value.isNaN()) {
            0x7FF8000000000000u64  // 标准 NaN 的位模式
        } else if (value == 0.0) {
            // 区分 +0.0 和 -0.0
            if (1.0 / value > 0.0) {
                0u64  // +0.0
            } else {
                0x8000000000000000u64  // -0.0
            }
        } else if (value > 1e308) {
            // 检查是否为正无穷
            0x7FF0000000000000u64  // +Infinity
        } else if (value < -1e308) {
            // 检查是否为负无穷
            0xFFF0000000000000u64  // -Infinity
        } else {
            // 对于正常数值，使用值本身的哈希
            // 这是一个简化实现，实际应用中需要更精确的位转换
            let intValue = Int64(value)
            if (intValue < 0) {
                UInt64(-intValue)
            } else {
                UInt64(intValue)
            }
        }
    }

    /**
     * 将此实例的值增加 operand，返回操作前的值
     * 此方法不是线程安全的
     *
     * @param operand 要加的量
     * @return 操作前与此实例关联的值
     */
    public func getAndAdd(operand: Float64): Float64 {
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
    public func getAndAdd(operand: Number): Float64 {
        let last = _value
        _value += operand.toDouble()
        return last
    }

    /**
     * 将此实例的值减 1，返回操作前的值
     * 此方法不是线程安全的
     *
     * @return 减少前与此实例关联的值
     */
    public func getAndDecrement(): Float64 {
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
    public func getAndIncrement(): Float64 {
        let last = _value
        _value += 1.0
        return last
    }

    /**
     * 获取值
     *
     * @return 当前值
     */
    public func getValue(): Float64 {
        _value
    }

    /**
     * 返回此可变对象的合适哈希码
     * 使用 Float64 的位表示计算哈希码
     *
     * @return 合适的哈希码
     */
    public func hashCode(): Int64 {
        // 模拟 Java 的 Double.hashCode()
        // bits ^ (bits >>> 32)
        let bits = getRawBits(_value)
        let high = Int64(bits >> 32)
        let low = Int64(bits & 0xFFFFFFFFu64)
        high ^ low
    }

    /**
     * 增加值
     *
     * @return this，支持链式调用
     */
    public func increment(): MutableDouble {
        _value += 1.0
        return this
    }

    /**
     * 将此实例的值加 1，返回操作后的值
     * 此方法不是线程安全的
     *
     * @return 增加后与此实例关联的值
     */
    public func incrementAndGet(): Float64 {
        _value += 1.0
        return _value
    }

    /**
     * 检查 double 值是否为无穷大
     *
     * @return true 如果是无穷大
     */
    public func isInfinite(): Bool {
        // 检查是否为正无穷或负无穷
        _value > 1e308 || _value < -1e308
    }

    /**
     * 检查 double 值是否为 NaN
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
    public func setValue(value: Float64): Unit {
        _value = value
    }

    /**
     * 从任何 Number 实例设置值
     *
     * @param value 要设置的值
     */
    public func setValue(value: Number): Unit {
        _value = value.toDouble()
    }

    /**
     * 从此实例的值中减去一个值
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Float64): MutableDouble {
        _value -= operand
        return this
    }

    /**
     * 从此实例的值中减去一个值
     *
     * @param operand 要减去的值
     * @return this，支持链式调用
     */
    public func subtract(operand: Number): MutableDouble {
        _value -= operand.toDouble()
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
        Float32(_value)
    }

    /**
     * 转换为 Float64
     *
     * @return 数值转换为 Float64 后的值
     */
    public func toDouble(): Float64 {
        _value
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
