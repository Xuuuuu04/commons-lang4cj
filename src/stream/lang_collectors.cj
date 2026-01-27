package commons_lang4cj.stream

import std.collection.*
import commons_lang4cj.tuple.*

public class LangCollectors {
    public static func toArrayList<T>(array: Array<T>): ArrayList<T> {
        Streams.toArrayList(array)
    }

    public static func toHashMap<K, V>(pairs: Array<Pair<K, V>>): HashMap<K, V> where K <: Hashable & Equatable<K> {
        let map = HashMap<K, V>()
        for (p in pairs) {
            map[p.getLeft()] = p.getRight()
        }
        map
    }

    public static func joining(array: Array<String>): String {
        joining(array, "", "", "")
    }

    public static func joining(array: Array<String>, delimiter: String): String {
        joining(array, delimiter, "", "")
    }

    public static func joining(array: Array<String>, delimiter: String, prefix: String, suffix: String): String {
        let sb = StringBuilder()
        sb.append(prefix)
        for ((i, s) in enumerate(array)) {
            if (i > 0) {
                sb.append(delimiter)
            }
            sb.append(s)
        }
        sb.append(suffix)
        sb.toString()
    }
}
