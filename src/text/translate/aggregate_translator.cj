package commons_lang4cj.text.translate

import std.collection.*

public class AggregateTranslator <: CharSequenceTranslator {
    private let _translators: Array<CharSequenceTranslator>

    public init(translators: Array<CharSequenceTranslator>) {
        super()
        _translators = translators
    }

    public override func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        for (t in _translators) {
            let consumed = t.translate(input, index, out)
            if (consumed > 0) {
                return consumed
            }
        }
        0
    }
}
