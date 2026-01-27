package commons_lang4cj.reflect

public class FieldUtils {
    public static func registerField(typeQualifiedName: String, fieldName: String, getter: (Any) -> Any): Unit {
        ReflectRegistry.registerField(typeQualifiedName, fieldName, getter)
    }

    public static func registerField(typeQualifiedName: String, fieldName: String, getter: (Any) -> Any, setter: (Any, Any) -> Unit): Unit {
        ReflectRegistry.registerField(typeQualifiedName, fieldName, getter, setter)
    }

    public static func readField(obj: Any, fieldName: String): Option<Any> {
        let typeName = ReflectRegistry.getQualifiedName(obj)
        if (typeName.size == 0) {
            return None
        }
        match (ReflectRegistry.findField(typeName, fieldName)) {
            case None => None
            case Some(f) =>
                try {
                    Some(f.getter(obj))
                } catch (e: Exception) {
                    None
                }
        }
    }

    public static func writeField(obj: Any, fieldName: String, value: Any): Bool {
        let typeName = ReflectRegistry.getQualifiedName(obj)
        if (typeName.size == 0) {
            return false
        }
        match (ReflectRegistry.findField(typeName, fieldName)) {
            case None => false
            case Some(f) =>
                match (f.setter) {
                    case None => false
                    case Some(setter) =>
                        try {
                            setter(obj, value)
                            true
                        } catch (e: Exception) {
                            false
                        }
                }
        }
    }
}
