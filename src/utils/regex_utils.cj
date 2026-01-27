package commons_lang4cj.utils

import std.regex.*

public class RegExUtils {
    public static func removeAll(text: String, regex: String): String {
        if (text.size == 0 || regex.size == 0) {
            return text
        }
        let r = Regex(regex)
        r.replaceAll(text, "")
    }

    public static func removeFirst(text: String, regex: String): String {
        if (text.size == 0 || regex.size == 0) {
            return text
        }
        let r = Regex(regex)
        r.replace(text, "")
    }

    public static func replaceAll(text: String, regex: String, replacement: String): String {
        if (text.size == 0 || regex.size == 0) {
            return text
        }
        let r = Regex(regex)
        r.replaceAll(text, replacement)
    }

    public static func replaceFirst(text: String, regex: String, replacement: String): String {
        if (text.size == 0 || regex.size == 0) {
            return text
        }
        let r = Regex(regex)
        r.replace(text, replacement)
    }
}

