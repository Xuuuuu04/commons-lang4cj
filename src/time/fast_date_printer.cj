package commons_lang4cj.time

import std.time.*

public class FastDatePrinter {
    private let _pattern: String

    public init(pattern: String) {
        _pattern = pattern
    }

    public func getPattern(): String {
        _pattern
    }

    public func format(date: DateTime): String {
        date.format(_pattern)
    }
}
