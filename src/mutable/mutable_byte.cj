package commons_lang4cj.mutable

import std.convert.*

/**
 * 可变的 Int8 包装器
 *
 * @since 1.0.0
 */
public open class MutableByte <: Number {
    private var _value: Int8 = 0

    public static const MIN_VALUE: Int8 = -128
    public static const MAX_VALUE: Int8 = 127

    public init() {
        _value = 0
    }

    public init(value: Int8) {
        _value = value
    }

    public init(value: Number) {
        let intValue = value.toInt()
        if (intValue < -128 || intValue > 127) {
            throw IllegalArgumentException("Value ${intValue} out of Int8 range")
        }
        _value = Int8(intValue)
    }

    public init(value: String) {
        if (let Some(v) <- Int64.tryParse(value)) {
            if (v < -128 || v > 127) {
                throw IllegalArgumentException("Value ${v} out of Int8 range")
            }
            _value = Int8(v)
        } else {
            throw IllegalArgumentException("Invalid byte format: ${value}")
        }
    }

    public func getValue(): Int8 {
        _value
    }

    public func setValue(value: Int8): Unit {
        _value = value
    }

    public func setValue(value: Number): Unit {
        let intValue = value.toInt()
        if (intValue < -128 || intValue > 127) {
            throw IllegalArgumentException("Value ${intValue} out of Int8 range")
        }
        _value = Int8(intValue)
    }

    public func increment(): MutableByte {
        _value = wrapToInt8(Int64(_value) + 1)
        this
    }

    public func incrementAndGet(): Int8 {
        increment()
        _value
    }

    public func getAndIncrement(): Int8 {
        let last = _value
        increment()
        last
    }

    public func decrement(): MutableByte {
        _value = wrapToInt8(Int64(_value) - 1)
        this
    }

    public func decrementAndGet(): Int8 {
        decrement()
        _value
    }

    public func getAndDecrement(): Int8 {
        let last = _value
        decrement()
        last
    }

    public func add(operand: Int8): MutableByte {
        _value = wrapToInt8(Int64(_value) + Int64(operand))
        this
    }

    public func add(operand: Number): MutableByte {
        _value = wrapToInt8(Int64(_value) + operand.toInt())
        this
    }

    public func addAndGet(operand: Int8): Int8 {
        add(operand)
        _value
    }

    public func addAndGet(operand: Number): Int8 {
        add(operand)
        _value
    }

    public func getAndAdd(operand: Int8): Int8 {
        let last = _value
        add(operand)
        last
    }

    public func getAndAdd(operand: Number): Int8 {
        let last = _value
        add(operand)
        last
    }

    public func subtract(operand: Int8): MutableByte {
        _value = wrapToInt8(Int64(_value) - Int64(operand))
        this
    }

    public func subtract(operand: Number): MutableByte {
        _value = wrapToInt8(Int64(_value) - operand.toInt())
        this
    }

    public func toInt(): Int64 {
        Int64(_value)
    }

    public func toFloat(): Float32 {
        Float32(_value)
    }

    public func toDouble(): Float64 {
        Float64(_value)
    }

    public func toString(): String {
        "${_value}"
    }

    public func hashCode(): Int64 {
        Int64(_value)
    }

    public func equals(obj: Option<Object>): Bool {
        match (obj) {
            case None => false
            case Some(other) => equals(other)
        }
    }

    public func equals(obj: Object): Bool {
        let otherOpt = obj as MutableByte
        match (otherOpt) {
            case None => false
            case Some(other) => _value == other._value
        }
    }

    public func compareTo(other: MutableByte): Int64 {
        if (_value < other._value) {
            -1
        } else if (_value > other._value) {
            1
        } else {
            0
        }
    }

    private func wrapToInt8(value: Int64): Int8 {
        let wrapped = ((value % 256) + 256) % 256
        if (wrapped >= 128) {
            Int8(wrapped - 256)
        } else {
            Int8(wrapped)
        }
    }
}
