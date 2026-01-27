package commons_lang4cj.reflect

import std.reflect.*

public class InheritanceUtils {
    public static func distance(child: Any, parentQualifiedName: String): Int64 {
        if (parentQualifiedName.size == 0) {
            return -1
        }
        let childName = TypeInfo.of(child).qualifiedName
        if (childName == parentQualifiedName) {
            return 0
        }

        var current = ClassTypeInfo.get(childName)
        var d: Int64 = 0
        while (true) {
            if (current.qualifiedName == parentQualifiedName) {
                return d
            }
            if (let Some(sc) <- current.superClass) {
                current = sc
                d++
            } else {
                return -1
            }
        }
        return -1
    }

    public static func isSubclassOf(child: Any, parentQualifiedName: String): Bool {
        distance(child, parentQualifiedName) >= 0
    }
}
