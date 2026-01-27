package commons_lang4cj.util

import std.collection.*
import commons_lang4cj.text.StrTokenizer

public class IterableStringTokenizer {
    private let _tokens: Array<String>

    public init(tokenizer: StrTokenizer) {
        _tokens = tokenizer.getTokenArray()
    }

    public init(input: String, delimiter: String) {
        let t = StrTokenizer.of(input, delimiter)
        _tokens = t.getTokenArray()
    }

    public func toArray(): Array<String> {
        _tokens
    }
}
