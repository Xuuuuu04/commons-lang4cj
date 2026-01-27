package commons_lang4cj.reflect

import std.collection.*

public class AnnotationUtils {
    public static func equals(left: HashMap<String, String>, right: HashMap<String, String>): Bool {
        if (left.size != right.size) {
            return false
        }
        for ((k, v) in left) {
            match (right.get(k)) {
                case None => return false
                case Some(rv) =>
                    if (rv != v) {
                        return false
                    }
            }
        }
        true
    }

    public static func hashCode(values: HashMap<String, String>): Int64 {
        var h: Int64 = 0
        for ((k, v) in values) {
            h += k.hashCode()
            h += v.hashCode()
        }
        h
    }

    public static func toString(annotationName: String, values: HashMap<String, String>): String {
        let sb = StringBuilder()
        sb.append("@")
        sb.append(annotationName)
        sb.append("(")
        var first = true
        for ((k, v) in values) {
            if (!first) {
                sb.append(", ")
            }
            first = false
            sb.append(k)
            sb.append("=")
            sb.append(v)
        }
        sb.append(")")
        sb.toString()
    }
}
