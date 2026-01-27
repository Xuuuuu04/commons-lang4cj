package commons_lang4cj.text

import std.collection.*

public class CompositeFormat {
    private let _parser: (String) -> Option<Any>
    private let _formatter: (Any) -> String

    public init(parser: (String) -> Option<Any>, formatter: (Any) -> String) {
        _parser = parser
        _formatter = formatter
    }

    public func parseObject(source: String): Option<Any> {
        _parser(source)
    }

    public func format(obj: Any): String {
        _formatter(obj)
    }
}
