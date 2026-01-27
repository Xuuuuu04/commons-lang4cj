package commons_lang4cj.text

import std.collection.*
import commons_lang4cj.utils.StringUtils

public class FormattableUtils {
    private init() {}

    public static func toString(obj: Any): String {
        match (obj as ToString) {
            case Some(t) => t.toString()
            case None => "?"
        }
    }

    public static func appendPadded(out: StringBuilder, str: String, width: Int64, padChar: String) {
        if (width <= 0) {
            out.append(str)
            return
        }
        let padCount = width - str.size
        if (padCount <= 0) {
            out.append(str)
            return
        }
        var i: Int64 = 0
        while (i < padCount) {
            out.append(padChar)
            i += 1
        }
        out.append(str)
    }

    public static func truncate(str: String, maxWidth: Int64): String {
        if (maxWidth <= 0) {
            return ""
        }
        if (str.size <= maxWidth) {
            return str
        }
        str[0..maxWidth]
    }
}
