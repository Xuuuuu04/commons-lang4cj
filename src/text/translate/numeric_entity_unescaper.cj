package commons_lang4cj.text.translate

import std.collection.*
import std.convert.*

public class NumericEntityUnescaper <: CharSequenceTranslator {
    public init() {
        super()
    }

    public override func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        if (index + 2 >= input.size) {
            return 0
        }
        if (input[index] != UInt8(38) || input[index + 1] != UInt8(35)) {
            return 0
        }
        var start = index + 2
        var isHex = false
        if (start < input.size && (input[start] == UInt8(120) || input[start] == UInt8(88))) {
            isHex = true
            start += 1
        }
        if (start >= input.size) {
            return 0
        }
        var end = start
        while (end < input.size && isHexDigit(input[end], isHex)) {
            end += 1
        }
        if (end == start) {
            return 0
        }
        var semi = false
        if (end < input.size && input[end] == UInt8(59)) {
            semi = true
        }
        let valueOpt = if (isHex) { parseHex(input[start..end]) } else { parseDec(input[start..end]) }
        match (valueOpt) {
            case Some(v) =>
                out.append(String.fromUtf8([UInt8(v & 0xFF)]))
                (end - index) + (if (semi) { 1 } else { 0 })
            case None => 0
        }
    }

    private func isHexDigit(b: UInt8, allowHex: Bool): Bool {
        if (b >= UInt8(48) && b <= UInt8(57)) {
            return true
        }
        if (!allowHex) {
            return false
        }
        (b >= UInt8(65) && b <= UInt8(70)) || (b >= UInt8(97) && b <= UInt8(102))
    }

    private func parseDec(s: String): Option<Int64> {
        Int64.tryParse(s)
    }

    private func parseHex(s: String): Option<Int64> {
        var value: Int64 = 0
        var i: Int64 = 0
        while (i < s.size) {
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
