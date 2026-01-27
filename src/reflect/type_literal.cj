package commons_lang4cj.reflect

public class TypeLiteral {
    private let _qualifiedName: String

    public init(qualifiedName: String) {
        _qualifiedName = qualifiedName
    }

    public func getQualifiedName(): String {
        _qualifiedName
    }

    public func toString(): String {
        _qualifiedName
    }

    public static func of(obj: Any): TypeLiteral {
        TypeLiteral(ReflectRegistry.getQualifiedName(obj))
    }

    public static func ofQualifiedName(qualifiedName: String): TypeLiteral {
        TypeLiteral(qualifiedName)
    }
}
