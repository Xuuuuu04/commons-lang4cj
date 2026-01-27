package commons_lang4cj.stream

import std.collection.*

public class Streams {
    public static func of<T>(array: Array<T>): Array<T> {
        array
    }

    public static func map<T, R>(array: Array<T>, mapper: (T) -> R): Array<R> {
        Array<R>(array.size, { i => mapper(array[i]) })
    }

    public static func filter<T>(array: Array<T>, predicate: (T) -> Bool): Array<T> {
        var count = 0
        for (v in array) {
            if (predicate(v)) {
                count++
            }
        }
        Array<T>(count, { idx =>
            var current = 0
            for (v in array) {
                if (predicate(v)) {
                    if (current == idx) {
                        return v
                    }
                    current++
                }
            }
            array[0]
        })
    }

    public static func flatMap<T, R>(array: Array<T>, mapper: (T) -> Array<R>): Array<R> {
        let mapped = ArrayList<Array<R>>()
        var total: Int64 = 0
        for (v in array) {
            let r = mapper(v)
            mapped.add(r)
            total += Int64(r.size)
        }
        let totalCount = total
        Array<R>(totalCount, { idx =>
            var offset: Int64 = 0
            for (chunk in mapped) {
                let chunkSize = Int64(chunk.size)
                if (idx < offset + chunkSize) {
                    return chunk[idx - offset]
                }
                offset += chunkSize
            }
            mapped[0][0]
        })
    }

    public static func concat<T>(left: Array<T>, right: Array<T>): Array<T> {
        Array<T>(left.size + right.size, { i =>
            if (i < left.size) {
                left[i]
            } else {
                right[i - left.size]
            }
        })
    }

    public static func anyMatch<T>(array: Array<T>, predicate: (T) -> Bool): Bool {
        for (v in array) {
            if (predicate(v)) {
                return true
            }
        }
        false
    }

    public static func allMatch<T>(array: Array<T>, predicate: (T) -> Bool): Bool {
        for (v in array) {
            if (!predicate(v)) {
                return false
            }
        }
        true
    }

    public static func forEach<T>(array: Array<T>, consumer: (T) -> Unit): Unit {
        for (v in array) {
            consumer(v)
        }
    }

    public static func toArrayList<T>(array: Array<T>): ArrayList<T> {
        let list = ArrayList<T>()
        for (v in array) {
            list.add(v)
        }
        list
    }
}
