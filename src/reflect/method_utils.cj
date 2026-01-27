package commons_lang4cj.reflect

public class MethodUtils {
    public static func registerMethod(typeQualifiedName: String, methodName: String, invoker: (Any, Array<Any>) -> Any): Unit {
        ReflectRegistry.registerMethod(typeQualifiedName, methodName, invoker)
    }

    public static func invokeMethod(obj: Any, methodName: String): Option<Any> {
        invokeMethod(obj, methodName, Array<Any>())
    }

    public static func invokeMethod(obj: Any, methodName: String, arg0: Any): Option<Any> {
        invokeMethod(obj, methodName, [arg0])
    }

    public static func invokeMethod(obj: Any, methodName: String, arg0: Any, arg1: Any): Option<Any> {
        invokeMethod(obj, methodName, [arg0, arg1])
    }

    public static func invokeMethod(obj: Any, methodName: String, arg0: Any, arg1: Any, arg2: Any): Option<Any> {
        invokeMethod(obj, methodName, [arg0, arg1, arg2])
    }

    public static func invokeMethod(obj: Any, methodName: String, args: Array<Any>): Option<Any> {
        let typeName = ReflectRegistry.getQualifiedName(obj)
        if (typeName.size == 0) {
            return None
        }
        match (ReflectRegistry.findMethod(typeName, methodName)) {
            case None => None
            case Some(m) =>
                try {
                    Some(m.invoker(obj, args))
                } catch (e: Exception) {
                    None
                }
        }
    }
}
