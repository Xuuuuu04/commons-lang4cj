package commons_lang4cj.builder

import std.collection.*
import commons_lang4cj.reflect.*

public struct DiffPair {
    public let left: String
    public let right: String

    public init(left: String, right: String) {
        this.left = left
        this.right = right
    }
}

public class ReflectionDiffBuilder {
    public static func diff(left: Any, right: Any): HashMap<String, DiffPair> {
        let map = HashMap<String, DiffPair>()
        let typeName = ReflectRegistry.getQualifiedName(left)
        if (typeName.size == 0) {
            return map
        }
        for (f in ReflectRegistry.listFields(typeName)) {
            let lv = safeToString(f.getter(left))
            let rv = safeToString(f.getter(right))
            if (lv != rv) {
                map[f.name] = DiffPair(lv, rv)
            }
        }
        map
    }

    private static func safeToString(value: Any): String {
        match (value as ToString) {
            case Some(s) => s.toString()
            case None => "?"
        }
    }
}
