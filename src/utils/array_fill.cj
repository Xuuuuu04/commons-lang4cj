package commons_lang4cj.utils

public class ArrayFill {
    public static func fill<T>(array: Array<T>, value: T): Array<T> {
        let out = ArrayUtils.clone(array)
        ArrayUtils.fill(out, value)
        out
    }

    public static func fill<T>(array: Array<T>, value: T, startIndex: Int64, endIndex: Int64): Array<T> {
        let out = ArrayUtils.clone(array)
        ArrayUtils.fill(out, value, startIndex, endIndex)
        out
    }
}

