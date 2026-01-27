package commons_lang4cj.utils

import std.sort.*

public class ArraySorter {
    public static func sort<T>(array: Array<T>) where T <: Comparable<T> {
        sort(array, stable: true, descending: false)
    }

    public static func sorted<T>(array: Array<T>) where T <: Comparable<T> {
        let out = ArrayUtils.clone(array)
        sort(out, stable: true, descending: false)
        out
    }
}
