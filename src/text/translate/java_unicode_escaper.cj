package commons_lang4cj.text.translate

public class JavaUnicodeEscaper <: UnicodeEscaper {
    public init(below: Int64, above: Int64, between: Bool) {
        super(below, above, between)
    }

    public static func above(codePoint: Int64): JavaUnicodeEscaper {
        outsideOf(0, codePoint)
    }

    public static func below(codePoint: Int64): JavaUnicodeEscaper {
        outsideOf(codePoint, 9223372036854775807)
    }

    public static func between(codePointLow: Int64, codePointHigh: Int64): JavaUnicodeEscaper {
        JavaUnicodeEscaper(codePointLow, codePointHigh, true)
    }

    public static func outsideOf(codePointLow: Int64, codePointHigh: Int64): JavaUnicodeEscaper {
        JavaUnicodeEscaper(codePointLow, codePointHigh, false)
    }
}
