package commons_lang4cj.text.translate

import std.collection.*

public class UnicodeUnescaper <: CharSequenceTranslator {
    public init() {
        super()
    }

    public override func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        if (index + 1 >= input.size) {
            return 0
        }
        if (input[index] != UInt8(92) || input[index + 1] != UInt8(117)) {
            return 0
        }

        var i: Int64 = 2
        while (index + i < input.size && input[index + i] == UInt8(117)) {
            i += 1
        }
        if (index + i < input.size && input[index + i] == UInt8(43)) {
            i += 1
        }
        if (index + i + 4 > input.size) {
            return 0
        }
        let hexStr = input[index + i..index + i + 4]
        let vOpt = parseHex4(hexStr)
        match (vOpt) {
            case Some(v) =>
                out.append(String.fromUtf8([UInt8(v)]))
                i + 4
            case None => 0
        }
    }

    private func parseHex4(s: String): Option<Int64> {
        if (s.size != 4) {
            return None
        }
        var value: Int64 = 0
        var i: Int64 = 0
        while (i < 4) {
            let b = s[i]
            let digit = hexDigit(b)
            match (digit) {
                case Some(d) => value = value * 16 + d
                case None => return None
            }
            i += 1
        }
        Some(value)
    }

    private func hexDigit(b: UInt8): Option<Int64> {
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
