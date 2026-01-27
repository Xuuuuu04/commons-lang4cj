package commons_lang4cj.utils

public class CharSequenceUtils {
    public static func indexOf(cs: String, search: String): Int64 {
        StringUtils.indexOf(cs, search)
    }

    public static func indexOf(cs: String, search: String, start: Int64): Int64 {
        StringUtils.indexOf(cs, search, start)
    }

    public static func lastIndexOf(cs: String, search: String): Int64 {
        StringUtils.lastIndexOf(cs, search)
    }

    public static func regionMatches(cs: String, ignoreCase: Bool, thisStart: Int64, substring: String, start: Int64, length: Int64): Bool {
        if (thisStart < 0 || start < 0 || length < 0) {
            return false
        }
        if (thisStart + length > cs.size || start + length > substring.size) {
            return false
        }
        let a = cs[thisStart..(thisStart + length)]
        let b = substring[start..(start + length)]
        if (ignoreCase) {
            StringUtils.lowerCase(a) == StringUtils.lowerCase(b)
        } else {
            a == b
        }
    }
}
