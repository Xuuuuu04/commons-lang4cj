package commons_lang4cj.utils

public class CharSetUtils {
    public static func delete(str: String, setStr: String): String {
        if (str.size == 0 || setStr.size == 0) {
            return str
        }
        let cs = CharSet.getInstance(setStr)
        var out = ""
        for (ch in str.toRuneArray()) {
            if (!cs.contains(ch)) {
                out += "${ch}"
            }
        }
        out
    }

    public static func keep(str: String, setStr: String): String {
        if (str.size == 0 || setStr.size == 0) {
            return ""
        }
        let cs = CharSet.getInstance(setStr)
        var out = ""
        for (ch in str.toRuneArray()) {
            if (cs.contains(ch)) {
                out += "${ch}"
            }
        }
        out
    }

    public static func squeeze(str: String, setStr: String): String {
        if (str.size == 0 || setStr.size == 0) {
            return str
        }
        let cs = CharSet.getInstance(setStr)
        let runes = str.toRuneArray()
        var out = ""
        var last: Option<Rune> = None
        for (ch in runes) {
            if (let Some(prev) <- last) {
                if (ch == prev && cs.contains(ch)) {
                    continue
                }
            }
            out += "${ch}"
            last = Some(ch)
        }
        out
    }

    public static func count(str: String, setStr: String): Int64 {
        if (str.size == 0 || setStr.size == 0) {
            return 0
        }
        let cs = CharSet.getInstance(setStr)
        var c: Int64 = 0
        for (ch in str.toRuneArray()) {
            if (cs.contains(ch)) {
                c++
            }
        }
        c
    }
}

