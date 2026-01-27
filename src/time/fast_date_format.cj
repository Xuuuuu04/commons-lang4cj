package commons_lang4cj.time

import std.time.*

public class FastDateFormat {
    private let _printer: FastDatePrinter
    private let _parser: FastDateParser

    public init(pattern: String) {
        _printer = FastDatePrinter(pattern)
        _parser = FastDateParser(pattern)
    }

    public static func getInstance(pattern: String): FastDateFormat {
        FastDateFormat(pattern)
    }

    public func getPattern(): String {
        _printer.getPattern()
    }

    public func format(date: DateTime): String {
        _printer.format(date)
    }

    public func parse(str: String): DateTime {
        _parser.parse(str)
    }
}
