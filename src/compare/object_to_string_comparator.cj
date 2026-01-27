package commons_lang4cj.compare

import commons_lang4cj.utils.StringUtils

public class ObjectToStringComparator {
    private init() {}

    public static func compare(left: Any, right: Any): Int64 {
        StringUtils.compare(toSafeString(left), toSafeString(right))
    }

    private static func toSafeString(value: Any): String {
        match (value as ToString) {
            case Some(s) => s.toString()
            case None => "?"
        }
    }
}
