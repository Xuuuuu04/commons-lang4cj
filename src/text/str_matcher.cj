package commons_lang4cj.text

import std.collection.*

public abstract class StrMatcher {
    public init() {}

    public open func isMatch(input: String, pos: Int64): Int64 {
        let _ = input
        let _ = pos
        0
    }

    public static func charMatcher(ch: UInt8): StrMatcher {
        CharStrMatcher(ch)
    }

    public static func stringMatcher(str: String): StrMatcher {
        StringStrMatcher(str)
    }

    public static func noneMatcher(): StrMatcher {
        NoneStrMatcher()
    }
}

private class NoneStrMatcher <: StrMatcher {
    public init() {
        super()
    }

    public override func isMatch(_: String, _: Int64): Int64 {
        0
    }
}

private class CharStrMatcher <: StrMatcher {
    private let _ch: UInt8

    public init(ch: UInt8) {
        super()
        _ch = ch
    }

    public override func isMatch(input: String, pos: Int64): Int64 {
        if (pos < 0 || pos >= input.size) {
            return 0
        }
        if (input[pos] == _ch) { 1 } else { 0 }
    }
}

private class StringStrMatcher <: StrMatcher {
    private let _str: String

    public init(str: String) {
        super()
        _str = str
    }

    public override func isMatch(input: String, pos: Int64): Int64 {
        if (_str.size == 0) {
            return 0
        }
        if (pos < 0 || pos + _str.size > input.size) {
            return 0
        }
        if (input[pos..pos + _str.size] == _str) { _str.size } else { 0 }
    }
}
