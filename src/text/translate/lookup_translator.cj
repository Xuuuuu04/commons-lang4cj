package commons_lang4cj.text.translate

import std.collection.*

public class LookupTranslator <: CharSequenceTranslator {
    private let _lookupMap: HashMap<String, String>
    private let _prefixSet: HashSet<UInt8>
    private let _shortest: Int64
    private let _longest: Int64

    public init(lookup: HashMap<String, String>) {
        super()
        _lookupMap = lookup
        _prefixSet = HashSet<UInt8>()
        var shortest: Int64 = 0
        var longest: Int64 = 0
        var first = true
        for ((k, _) in lookup) {
            if (k.size > 0) {
                _prefixSet.add(k[0])
                if (first) {
                    shortest = k.size
                    longest = k.size
                    first = false
                } else {
                    if (k.size < shortest) {
                        shortest = k.size
                    }
                    if (k.size > longest) {
                        longest = k.size
                    }
                }
            }
        }
        _shortest = shortest
        _longest = longest
    }

    public init(pairs: Array<Array<String>>) {
        this(buildLookupMap(pairs))
    }

    public override func translate(input: String, index: Int64, out: StringBuilder): Int64 {
        if (index >= input.size) {
            return 0
        }
        if (_prefixSet.size > 0 && !_prefixSet.contains(input[index])) {
            return 0
        }
        let max = minInt64(_longest, input.size - index)
        var i = max
        while (i >= _shortest && i > 0) {
            let sub = input[index..index + i]
            match (_lookupMap.get(sub)) {
                case Some(repl) =>
                    out.append(repl)
                    return i
                case None => ()
            }
            i -= 1
        }
        0
    }

    private static func minInt64(a: Int64, b: Int64): Int64 {
        if (a < b) { a } else { b }
    }

    private static func buildLookupMap(pairs: Array<Array<String>>): HashMap<String, String> {
        let m = HashMap<String, String>()
        for (p in pairs) {
            if (p.size >= 2) {
                m[p[0]] = p[1]
            }
        }
        m
    }
}
