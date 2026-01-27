package commons_lang4cj.reflect

import std.reflect.*

public class TypeUtils {
    public static func getQualifiedName(obj: Any): String {
        ReflectRegistry.getQualifiedName(obj)
    }

    public static func isAssignable(childQualifiedName: String, parentQualifiedName: String): Bool {
        if (childQualifiedName.size == 0 || parentQualifiedName.size == 0) {
            return false
        }
        if (childQualifiedName == parentQualifiedName) {
            return true
        }
        try {
            var current = ClassTypeInfo.get(childQualifiedName)
            while (true) {
                if (current.qualifiedName == parentQualifiedName) {
                    return true
                }
                match (current.superClass) {
                    case Some(sc) => current = sc
                    case None => return false
                }
            }
            false
        } catch (e: Exception) {
            false
        }
    }

    public static func isInstance(obj: Any, parentQualifiedName: String): Bool {
        let childName = getQualifiedName(obj)
        isAssignable(childName, parentQualifiedName)
    }

    public static func distance(childQualifiedName: String, parentQualifiedName: String): Int64 {
        if (childQualifiedName.size == 0 || parentQualifiedName.size == 0) {
            return -1
        }
        if (childQualifiedName == parentQualifiedName) {
            return 0
        }
        try {
            var current = ClassTypeInfo.get(childQualifiedName)
            var d: Int64 = 0
            while (true) {
                if (current.qualifiedName == parentQualifiedName) {
                    return d
                }
                match (current.superClass) {
                    case Some(sc) =>
                        current = sc
                        d++
                    case None => return -1
                }
            }
            -1
        } catch (e: Exception) {
            -1
        }
    }
}
