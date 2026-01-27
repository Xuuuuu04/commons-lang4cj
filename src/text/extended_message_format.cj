package commons_lang4cj.text

import std.collection.*
import commons_lang4cj.utils.StringUtils

public class ExtendedMessageFormat {
    private let _pattern: String

    public init(pattern: String) {
        _pattern = pattern
    }

    public func getPattern(): String {
        _pattern
    }

    public func format(args: Array<Any>): String {
        var result = _pattern
        var i: Int64 = 0
        while (i < Int64(args.size)) {
            let key = "{${i}}"
            let value = match (args[Int64(i)] as ToString) {
                case Some(t) => t.toString()
                case None => "?"
            }
            result = StringUtils.replace(result, key, value)
            i += 1
        }
        result
    }
}
