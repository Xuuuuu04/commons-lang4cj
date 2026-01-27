package commons_lang4cj.utils

import std.collection.*

public class AppendableJoiner {
    private let _delimiter: String
    private let _prefix: String
    private let _suffix: String
    private let _values: ArrayList<String>

    public init(delimiter: String) {
        _delimiter = delimiter
        _prefix = ""
        _suffix = ""
        _values = ArrayList<String>()
    }

    public init(delimiter: String, prefix: String, suffix: String) {
        _delimiter = delimiter
        _prefix = prefix
        _suffix = suffix
        _values = ArrayList<String>()
    }

    public func add(value: String): AppendableJoiner {
        _values.add(value)
        this
    }

    public func toString(): String {
        var out = _prefix
        for (i in 0.._values.size) {
            if (i > 0) {
                out += _delimiter
            }
            out += _values[i]
        }
        out + _suffix
    }
}

