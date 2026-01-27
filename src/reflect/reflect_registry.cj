package commons_lang4cj.reflect

import std.collection.*
import std.reflect.*

public class ReflectField {
    public let name: String
    public let getter: (Any) -> Any
    public let setter: Option<(Any, Any) -> Unit>

    public init(name: String, getter: (Any) -> Any, setter: Option<(Any, Any) -> Unit>) {
        this.name = name
        this.getter = getter
        this.setter = setter
    }
}

public class ReflectMethod {
    public let name: String
    public let invoker: (Any, Array<Any>) -> Any

    public init(name: String, invoker: (Any, Array<Any>) -> Any) {
        this.name = name
        this.invoker = invoker
    }
}

public class ReflectConstructor {
    public let parameterCount: Int64
    public let invoker: (Array<Any>) -> Any

    public init(parameterCount: Int64, invoker: (Array<Any>) -> Any) {
        this.parameterCount = parameterCount
        this.invoker = invoker
    }
}

public class ReflectRegistry {
    private static var _fields: HashMap<String, HashMap<String, ReflectField>> = HashMap<String, HashMap<String, ReflectField>>()
    private static var _methods: HashMap<String, HashMap<String, ReflectMethod>> = HashMap<String, HashMap<String, ReflectMethod>>()
    private static var _constructors: HashMap<String, ArrayList<ReflectConstructor>> = HashMap<String, ArrayList<ReflectConstructor>>()

    public static func registerField(typeQualifiedName: String, fieldName: String, getter: (Any) -> Any): Unit {
        registerField(typeQualifiedName, fieldName, getter, None)
    }

    public static func registerField(typeQualifiedName: String, fieldName: String, getter: (Any) -> Any, setter: (Any, Any) -> Unit): Unit {
        registerField(typeQualifiedName, fieldName, getter, Some(setter))
    }

    private static func registerField(typeQualifiedName: String, fieldName: String, getter: (Any) -> Any, setter: Option<(Any, Any) -> Unit>): Unit {
        let map = getOrCreateFieldMap(typeQualifiedName)
        map[fieldName] = ReflectField(fieldName, getter, setter)
    }

    public static func registerMethod(typeQualifiedName: String, methodName: String, invoker: (Any, Array<Any>) -> Any): Unit {
        let map = getOrCreateMethodMap(typeQualifiedName)
        map[methodName] = ReflectMethod(methodName, invoker)
    }

    public static func registerConstructor(typeQualifiedName: String, parameterCount: Int64, invoker: (Array<Any>) -> Any): Unit {
        let list = getOrCreateConstructorList(typeQualifiedName)
        list.add(ReflectConstructor(parameterCount, invoker))
    }

    public static func findField(typeQualifiedName: String, fieldName: String): Option<ReflectField> {
        for (t in hierarchy(typeQualifiedName)) {
            match (_fields.get(t)) {
                case Some(m) =>
                    match (m.get(fieldName)) {
                        case Some(f) => return Some(f)
                        case None => ()
                    }
                case None => ()
            }
        }
        None
    }

    public static func findMethod(typeQualifiedName: String, methodName: String): Option<ReflectMethod> {
        for (t in hierarchy(typeQualifiedName)) {
            match (_methods.get(t)) {
                case Some(m) =>
                    match (m.get(methodName)) {
                        case Some(mm) => return Some(mm)
                        case None => ()
                    }
                case None => ()
            }
        }
        None
    }

    public static func findConstructor(typeQualifiedName: String, parameterCount: Int64): Option<ReflectConstructor> {
        match (_constructors.get(typeQualifiedName)) {
            case None => None
            case Some(list) =>
                for (c in list) {
                    if (c.parameterCount == parameterCount) {
                        return Some(c)
                    }
                }
                None
        }
    }

    public static func listFields(typeQualifiedName: String): ArrayList<ReflectField> {
        let out = ArrayList<ReflectField>()
        let seen = HashMap<String, Bool>()
        for (t in hierarchy(typeQualifiedName)) {
            match (_fields.get(t)) {
                case None => ()
                case Some(m) =>
                    for ((k, v) in m) {
                        if (!seen.contains(k)) {
                            seen[k] = true
                            out.add(v)
                        }
                    }
            }
        }
        out
    }

    public static func getQualifiedName(obj: Any): String {
        try {
            TypeInfo.of(obj).qualifiedName
        } catch (e: Exception) {
            ""
        }
    }

    private static func hierarchy(typeQualifiedName: String): ArrayList<String> {
        let list = ArrayList<String>()
        if (typeQualifiedName.size == 0) {
            return list
        }
        var current = typeQualifiedName
        while (true) {
            list.add(current)
            try {
                let ct = ClassTypeInfo.get(current)
                match (ct.superClass) {
                    case Some(sc) => current = sc.qualifiedName
                    case None => break
                }
            } catch (e: Exception) {
                break
            }
        }
        list
    }

    private static func getOrCreateFieldMap(typeQualifiedName: String): HashMap<String, ReflectField> {
        match (_fields.get(typeQualifiedName)) {
            case Some(m) => m
            case None =>
                let m = HashMap<String, ReflectField>()
                _fields[typeQualifiedName] = m
                m
        }
    }

    private static func getOrCreateMethodMap(typeQualifiedName: String): HashMap<String, ReflectMethod> {
        match (_methods.get(typeQualifiedName)) {
            case Some(m) => m
            case None =>
                let m = HashMap<String, ReflectMethod>()
                _methods[typeQualifiedName] = m
                m
        }
    }

    private static func getOrCreateConstructorList(typeQualifiedName: String): ArrayList<ReflectConstructor> {
        match (_constructors.get(typeQualifiedName)) {
            case Some(l) => l
            case None =>
                let l = ArrayList<ReflectConstructor>()
                _constructors[typeQualifiedName] = l
                l
        }
    }
}
