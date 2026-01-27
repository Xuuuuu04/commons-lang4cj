package commons_lang4cj.utils

import commons_lang4cj.range.*
import std.collection.*

public class CharSet {
    private let _inverted: Bool
    private let _ranges: Array<CharRange>

    private init(inverted: Bool, ranges: Array<CharRange>) {
        _inverted = inverted
        _ranges = ranges
    }

    public static func getInstance(setStr: String): CharSet {
        let runes = setStr.toRuneArray()
        if (runes.size == 0) {
            return CharSet(false, Array<CharRange>())
        }

        var inverted = false
        var index: Int64 = 0
        if (runes[0] == r'^') {
            inverted = true
            index = 1
        }

        let ranges = ArrayList<CharRange>()
        while (index < runes.size) {
            if (index + 2 < runes.size && runes[index + 1] == r'-') {
                ranges.add(CharRange.of(runes[index], runes[index + 2]))
                index += 3
            } else {
                ranges.add(CharRange.`is`(runes[index]))
                index += 1
            }
        }

        CharSet(inverted, ranges.toArray())
    }

    public func contains(ch: Rune): Bool {
        var contained = false
        for (r in _ranges) {
            if (UInt32(ch) >= UInt32(r.getMinimum()) && UInt32(ch) <= UInt32(r.getMaximum())) {
                contained = true
                break
            }
        }
        if (_inverted) {
            !contained
        } else {
            contained
        }
    }
}
