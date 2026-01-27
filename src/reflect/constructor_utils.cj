package commons_lang4cj.reflect

public class ConstructorUtils {
    public static func registerConstructor(typeQualifiedName: String, parameterCount: Int64, invoker: (Array<Any>) -> Any): Unit {
        ReflectRegistry.registerConstructor(typeQualifiedName, parameterCount, invoker)
    }

    public static func invokeConstructor(typeQualifiedName: String): Option<Any> {
        invokeConstructor(typeQualifiedName, Array<Any>())
    }

    public static func invokeConstructor(typeQualifiedName: String, arg0: Any): Option<Any> {
        invokeConstructor(typeQualifiedName, [arg0])
    }

    public static func invokeConstructor(typeQualifiedName: String, arg0: Any, arg1: Any): Option<Any> {
        invokeConstructor(typeQualifiedName, [arg0, arg1])
    }

    public static func invokeConstructor(typeQualifiedName: String, arg0: Any, arg1: Any, arg2: Any): Option<Any> {
        invokeConstructor(typeQualifiedName, [arg0, arg1, arg2])
    }

    public static func invokeConstructor(typeQualifiedName: String, args: Array<Any>): Option<Any> {
        match (ReflectRegistry.findConstructor(typeQualifiedName, Int64(args.size))) {
            case None => None
            case Some(c) =>
                try {
                    Some(c.invoker(args))
                } catch (e: Exception) {
                    None
                }
        }
    }
}
