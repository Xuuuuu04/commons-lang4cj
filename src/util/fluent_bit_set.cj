package commons_lang4cj.util

import std.collection.*

public class FluentBitSet {
    private let _bits: HashSet<Int64> = HashSet<Int64>()

    public init() {}

    public func set(index: Int64): FluentBitSet {
        if (index >= 0) {
            _bits.add(index)
        }
        this
    }

    public func clear(index: Int64): FluentBitSet {
        _bits.remove(index)
        this
    }

    public func get(index: Int64): Bool {
        _bits.contains(index)
    }

    public func cardinality(): Int64 {
        Int64(_bits.size)
    }

    public func and(other: FluentBitSet): FluentBitSet {
        let toRemove = ArrayList<Int64>()
        for (b in _bits) {
            if (!other._bits.contains(b)) {
                toRemove.add(b)
            }
        }
        for (b in toRemove) {
            _bits.remove(b)
        }
        this
    }

    public func or(other: FluentBitSet): FluentBitSet {
        for (b in other._bits) {
            _bits.add(b)
        }
        this
    }
}
