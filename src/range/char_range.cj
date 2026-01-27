package commons_lang4cj.range

import std.collection.*

/**
 * 字符范围类
 *
 * @since 1.0.0
 */
public open class CharRange {
    private let _min: Rune
    private let _max: Rune

    private init(min: Rune, max: Rune) {
        _min = min
        _max = max
    }

    /**
     * 创建字符范围
     */
    public static func of(from: Rune, to: Rune): CharRange {
        if (from <= to) {
            CharRange(from, to)
        } else {
            CharRange(to, from)
        }
    }

    /**
     * 创建单字符范围
     */
    public static func `is`(ch: Rune): CharRange {
        CharRange(ch, ch)
    }

    /**
     * 从字符串创建字符范围
     */
    public static func fromString(str: String): Option<CharRange> {
        let runes = str.toRuneArray()
        if (runes.size == 1) {
            return Some(CharRange.`is`(runes[0]))
        }
        if (runes.size == 3 && runes[1] == r'-') {
            return Some(CharRange.of(runes[0], runes[2]))
        }
        None
    }

    /**
     * 获取最小字符
     */
    public func getMinimum(): Rune {
        _min
    }

    /**
     * 获取最大字符
     */
    public func getMaximum(): Rune {
        _max
    }

    /**
     * 获取范围内的所有字符
     */
    public func getChars(): Array<Rune> {
        let chars = ArrayList<Rune>()
        var code = UInt32(_min)
        let end = UInt32(_max)
        while (code <= end) {
            chars.add(Rune(code))
            code++
        }
        chars.toArray()
    }

    /**
     * 转换为 ArrayList
     */
    public func toArrayList(): ArrayList<Rune> {
        let list = ArrayList<Rune>()
        var code = UInt32(_min)
        let end = UInt32(_max)
        while (code <= end) {
            list.add(Rune(code))
            code++
        }
        list
    }

    /**
     * 获取字符数量
     */
    public func getSize(): Int64 {
        Int64(UInt32(_max)) - Int64(UInt32(_min)) + 1
    }

    /**
     * 转换为字符串
     */
    public func toString(): String {
        "CharRange[${_min}, ${_max}]"
    }
}
