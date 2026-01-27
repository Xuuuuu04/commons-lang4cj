package commons_lang4cj.text.translate

import std.collection.*

public open class UnicodeEscaper <: CodePointTranslator {
    private let _below: Int64
    private let _above: Int64
    private let _between: Bool

    public init(below: Int64, above: Int64, between: Bool) {
        super()
        _below = below
        _above = above
        _between = between
    }

    public static func below(codePoint: Int64): UnicodeEscaper {
        outsideOf(codePoint, 9223372036854775807)
    }

    public static func above(codePoint: Int64): UnicodeEscaper {
        outsideOf(0, codePoint)
    }

    public static func outsideOf(codePointLow: Int64, codePointHigh: Int64): UnicodeEscaper {
        UnicodeEscaper(codePointLow, codePointHigh, false)
    }

    public static func between(codePointLow: Int64, codePointHigh: Int64): UnicodeEscaper {
        UnicodeEscaper(codePointLow, codePointHigh, true)
    }

    public override func translate(codePoint: Int64, out: StringBuilder): Bool {
        let inRange = codePoint >= _below && codePoint <= _above
        if ((_between && !inRange) || (!_between && inRange)) {
            return false
        }
        out.append(toUtf16Escape(codePoint))
        true
    }

    protected func toUtf16Escape(codePoint: Int64): String {
        let hex = CharSequenceTranslator.hex(codePoint)
        if (hex.size >= 4) {
            "\\u${hex}"
        } else {
            let pad = StringBuilder(4)
            var i: Int64 = 0
            while (i < 4 - hex.size) {
                pad.append("0")
                i += 1
            }
            "\\u${pad.toString()}${hex}"
        }
    }
}
