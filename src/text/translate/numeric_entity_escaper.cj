package commons_lang4cj.text.translate

import std.collection.*

public class NumericEntityEscaper <: CodePointTranslator {
    private let _below: Int64
    private let _above: Int64
    private let _between: Bool

    public init(below: Int64, above: Int64, between: Bool) {
        super()
        _below = below
        _above = above
        _between = between
    }

    public static func below(codePoint: Int64): NumericEntityEscaper {
        outsideOf(codePoint, 9223372036854775807)
    }

    public static func above(codePoint: Int64): NumericEntityEscaper {
        outsideOf(0, codePoint)
    }

    public static func outsideOf(codePointLow: Int64, codePointHigh: Int64): NumericEntityEscaper {
        NumericEntityEscaper(codePointLow, codePointHigh, false)
    }

    public static func between(codePointLow: Int64, codePointHigh: Int64): NumericEntityEscaper {
        NumericEntityEscaper(codePointLow, codePointHigh, true)
    }

    public override func translate(codePoint: Int64, out: StringBuilder): Bool {
        let inRange = codePoint >= _below && codePoint <= _above
        if ((_between && !inRange) || (!_between && inRange)) {
            return false
        }
        out.append("&#")
        out.append(codePoint.toString())
        out.append(";")
        true
    }
}
