package commons_lang4cj.utils

public class Conversion {
    private init() {}

    private static let HEX_DIGITS: String = "0123456789abcdef"

    public static func intToHex(value: Int64, minWidth: Int64): String {
        var v = UInt64(value)
        var idx: Int64 = 16
        let buf = Array<UInt8>(16, { _ => UInt8(0) })

        if (v == 0) {
            idx -= 1
            buf[idx] = UInt8(48)
        } else {
            while (v > 0) {
                idx -= 1
                let d = Int64(v & UInt64(15))
                buf[idx] = HEX_DIGITS[d]
                v = v >> 4
            }
        }

        let start = idx
        let hex = String.fromUtf8(Array<UInt8>(16 - start, { i => buf[start + i] }))
        if (minWidth <= 0 || hex.size >= minWidth) {
            return hex
        }
        let sb = StringBuilder(minWidth)
        var i: Int64 = 0
        while (i < minWidth - hex.size) {
            sb.append("0")
            i += 1
        }
        sb.append(hex)
        sb.toString()
    }

    public static func hexToInt(hex: String): Option<Int64> {
        if (hex.size == 0) {
            return None
        }
        var value: Int64 = 0
        var i: Int64 = 0
        while (i < hex.size) {
            let d = hexDigit(hex[i])
            match (d) {
                case Some(v) => value = value * 16 + v
                case None => return None
            }
            i += 1
        }
        Some(value)
    }

    private static func hexDigit(b: UInt8): Option<Int64> {
        if (b >= UInt8(48) && b <= UInt8(57)) {
            return Some(Int64(b - UInt8(48)))
        }
        if (b >= UInt8(65) && b <= UInt8(70)) {
            return Some(Int64(b - UInt8(65) + UInt8(10)))
        }
        if (b >= UInt8(97) && b <= UInt8(102)) {
            return Some(Int64(b - UInt8(97) + UInt8(10)))
        }
        None
    }
}
