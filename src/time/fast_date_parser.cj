package commons_lang4cj.time

import std.time.*

public class FastDateParser {
    private let _pattern: String

    public init(pattern: String) {
        _pattern = pattern
    }

    public func getPattern(): String {
        _pattern
    }

    public func parse(str: String): DateTime {
        DateTime.parse(str, _pattern)
    }
}
