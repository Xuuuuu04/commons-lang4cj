package commons_lang4cj.builder

import std.reflect.*
import commons_lang4cj.reflect.*

public class AnyToStringObject <: ToStringObject {
    private let _value: Any

    public init(value: Any) {
        _value = value
    }

    public func getClassName(): String {
        try {
            TypeInfo.of(_value).name
        } catch (e: Exception) {
            "Unknown"
        }
    }

    public func getIdentityHashCode(): UInt64 {
        match (_value as Hashable) {
            case Some(h) =>
                let hc = h.hashCode()
                if (hc >= 0) {
                    UInt64(hc)
                } else {
                    UInt64(-(hc + 1)) + 1u64
                }
            case None => 0u64
        }
    }

    public func toString(): String {
        match (_value as ToString) {
            case Some(s) => s.toString()
            case None => "?"
        }
    }
}

public class ReflectionToStringBuilder {
    public static func toString(obj: Any): String {
        toString(obj, None)
    }

    public static func toString(obj: Any, style: Option<ToStringStyle>): String {
        let typeName = ReflectRegistry.getQualifiedName(obj)
        let b = ToStringBuilder(Some(AnyToStringObject(obj)), style)
        if (typeName.size == 0) {
            return b.build()
        }
        for (f in ReflectRegistry.listFields(typeName)) {
            let v = f.getter(obj)
            b.append(f.name, Some(AnyToStringObject(v)))
        }
        b.build()
    }
}
