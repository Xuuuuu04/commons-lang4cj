package commons_lang4cj.text

import std.collection.*

public class StrBuilder {
    private var _sb: StringBuilder

    public init() {
        _sb = StringBuilder()
    }

    public init(capacity: Int64) {
        _sb = StringBuilder(capacity)
    }

    public init(str: String) {
        _sb = StringBuilder(str.size)
        _sb.append(str)
    }

    public func length(): Int64 {
        Int64(_sb.toString().size)
    }

    public func clear(): StrBuilder {
        _sb = StringBuilder()
        this
    }

    public func append(str: String): StrBuilder {
        _sb.append(str)
        this
    }

    public func append(ch: UInt8): StrBuilder {
        _sb.append(String.fromUtf8([ch]))
        this
    }

    public func toString(): String {
        _sb.toString()
    }
}
