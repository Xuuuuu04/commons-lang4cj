package commons_lang4cj.text.translate

import std.collection.*

public abstract class CharSequenceTranslator {
    public init() {}

    public static func hex(codePoint: Int64): String {
        var v = UInt64(codePoint)
        var idx: Int64 = 16
        let buf = Array<UInt8>(16, { _ => UInt8(0) })
        let digits: String = "0123456789ABCDEF"

        if (v == 0) {
            idx -= 1
            buf[idx] = UInt8(48)
        } else {
            while (v > 0) {
                idx -= 1
                let d = Int64(v & UInt64(15))
                buf[idx] = digits[d]
                v = v >> 4
            }
        }

        let start = idx
        String.fromUtf8(Array<UInt8>(16 - start, { i => buf[start + i] }))
    }

    public func translate(input: String): String {
        let out = StringBuilder(input.size * 2)
        translate(input, out)
        out.toString()
    }

    public func translate(input: String, out: StringBuilder): Unit {
        var pos: Int64 = 0
        let len = input.size
        while (pos < len) {
            let consumed = translate(input, pos, out)
            if (consumed <= 0) {
                out.append(input[pos..pos + 1])
                pos += 1
                continue
            }
            pos += consumed
        }
    }

    public open func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        let _ = input
        let _ = index
        let _ = out
        0
    }

    public func `with`(translators: Array<CharSequenceTranslator>): CharSequenceTranslator {
        let list = ArrayList<CharSequenceTranslator>()
        list.add(this)
        for (t in translators) {
            list.add(t)
        }
        AggregateTranslator(list.toArray())
    }
}
