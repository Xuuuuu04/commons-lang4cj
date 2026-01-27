package commons_lang4cj.stream

public class IntStreams {
    public static func range(startInclusive: Int64, endExclusive: Int64): Array<Int64> {
        if (endExclusive <= startInclusive) {
            return Array<Int64>()
        }
        let n = endExclusive - startInclusive
        Array<Int64>(n, { i => startInclusive + i })
    }

    public static func rangeClosed(startInclusive: Int64, endInclusive: Int64): Array<Int64> {
        if (endInclusive < startInclusive) {
            return Array<Int64>()
        }
        let n = endInclusive - startInclusive + 1
        Array<Int64>(n, { i => startInclusive + i })
    }

    public static func sum(array: Array<Int64>): Int64 {
        var s: Int64 = 0
        for (v in array) {
            s += v
        }
        s
    }

    public static func average(array: Array<Int64>): Option<Float64> {
        if (array.size == 0) {
            return None
        }
        Some(Float64(sum(array)) / Float64(array.size))
    }
}
