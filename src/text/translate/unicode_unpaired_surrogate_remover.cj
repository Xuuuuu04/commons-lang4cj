package commons_lang4cj.text.translate

import std.collection.*

public class UnicodeUnpairedSurrogateRemover <: CharSequenceTranslator {
    public init() {
        super()
    }

    public override func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        if (index >= input.size) {
            return 0
        }
        let b = input[index]
        if ((b >= UInt8(0xD8) && b <= UInt8(0xDB)) || (b >= UInt8(0xDC) && b <= UInt8(0xDF))) {
            return 1
        }
        0
    }
}
