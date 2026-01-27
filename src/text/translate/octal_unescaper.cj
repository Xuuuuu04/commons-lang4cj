package commons_lang4cj.text.translate

import std.collection.*

public class OctalUnescaper <: CharSequenceTranslator {
    public init() {
        super()
    }

    public override func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        if (index >= input.size) {
            return 0
        }
        if (input[index] != UInt8(92)) {
            return 0
        }
        if (index + 1 >= input.size) {
            return 0
        }
        var i = index + 1
        var digits: Int64 = 0
        var value: Int64 = 0
        while (i < input.size && digits < 3) {
            let b = input[i]
            if (b < UInt8(48) || b > UInt8(55)) {
                break
            }
            value = value * 8 + Int64(b - UInt8(48))
            digits += 1
            i += 1
        }
        if (digits == 0) {
            return 0
        }
        out.append(String.fromUtf8([UInt8(value & 0xFF)]))
        1 + digits
    }
}
