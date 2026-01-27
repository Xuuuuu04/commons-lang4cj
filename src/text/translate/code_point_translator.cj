package commons_lang4cj.text.translate

import std.collection.*

public abstract class CodePointTranslator <: CharSequenceTranslator {
    public init() {
        super()
    }

    public override func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        if (index >= input.size) {
            return 0
        }
        let codePoint = Int64(input[index])
        if (translate(codePoint, out)) {
            1
        } else {
            0
        }
    }

    public open func translate(codePoint: Int64, out: StringBuilder): Bool {
        let _ = codePoint
        let _ = out
        false
    }
}
