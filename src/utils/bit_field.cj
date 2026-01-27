package commons_lang4cj.utils

public class BitField {
    private let _mask: Int64
    private let _shift: Int64

    public init(mask: Int64) {
        if (mask == 0) {
            throw IllegalArgumentException("mask must not be 0")
        }
        _mask = mask
        _shift = BitField.calculateShift(mask)
    }

    public func getRawValue(holder: Int64): Int64 {
        holder & _mask
    }

    public func getValue(holder: Int64): Int64 {
        (holder & _mask) >> _shift
    }

    public func isSet(holder: Int64): Bool {
        (holder & _mask) != 0
    }

    public func isAllSet(holder: Int64): Bool {
        (holder & _mask) == _mask
    }

    public func set(holder: Int64): Int64 {
        holder | _mask
    }

    public func clear(holder: Int64): Int64 {
        holder & (_mask ^ -1)
    }

    public func setRawValue(holder: Int64, value: Int64): Int64 {
        (holder & (_mask ^ -1)) | (value & _mask)
    }

    public func setValue(holder: Int64, value: Int64): Int64 {
        let shifted = (value << _shift) & _mask
        (holder & (_mask ^ -1)) | shifted
    }

    private static func calculateShift(mask: Int64): Int64 {
        var shift: Int64 = 0
        var m = mask
        while ((m & 1) == 0) {
            shift++
            m = m >> 1
        }
        shift
    }
}
