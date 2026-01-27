package commons_lang4cj.test.reflect

import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*
import commons_lang4cj.reflect.*

public class Person <: ToString {
    public var name: String
    public var age: Int64

    public init(name: String, age: Int64) {
        this.name = name
        this.age = age
    }

    public func toString(): String {
        "${name}:${age}"
    }
}

public class TypedPerson <: Typed {
    private let _literal: TypeLiteral

    public init(literal: TypeLiteral) {
        _literal = literal
    }

    public func getTypeLiteral(): TypeLiteral {
        _literal
    }
}

@Test
class ReflectRegistryTest {
    @TestCase
    func testConstructorFieldMethodRegistry() {
        let typeName = TypeInfo.of(Person("", 0)).qualifiedName

        ConstructorUtils.registerConstructor(typeName, 2, { args =>
            let n = match (args[0] as String) { case Some(s) => s case None => "" }
            let a = match (args[1] as Int64) { case Some(v) => v case None => 0 }
            Person(n, a)
        })

        FieldUtils.registerField(typeName, "name", { obj =>
            match (obj as Person) { case Some(p) => p.name case None => "" }
        }, { obj, value =>
            match (obj as Person) {
                case Some(p) =>
                    match (value as String) {
                        case Some(s) => p.name = s
                        case None => ()
                    }
                case None => ()
            }
        })

        MethodUtils.registerMethod(typeName, "greet", { obj, _ =>
            match (obj as Person) {
                case Some(p) => "hi ${p.name}"
                case None => ""
            }
        })

        let created = ConstructorUtils.invokeConstructor(typeName, "Bob", 5i64)
        @Expect(created.isSome(), true)
        let p = match (created) {
            case Some(v) =>
                match (v as Person) { case Some(pp) => pp case None => Person("", 0) }
            case None => Person("", 0)
        }

        @Expect(FieldUtils.readField(p, "name").isSome(), true)
        let n0 = match (FieldUtils.readField(p, "name")) {
            case Some(v) =>
                match (v as String) { case Some(s) => s case None => "" }
            case None => ""
        }
        @Expect(n0, "Bob")

        @Expect(FieldUtils.writeField(p, "name", "Alice"), true)
        let n1 = match (FieldUtils.readField(p, "name")) {
            case Some(v) =>
                match (v as String) { case Some(s) => s case None => "" }
            case None => ""
        }
        @Expect(n1, "Alice")

        let g = match (MethodUtils.invokeMethod(p, "greet")) {
            case Some(v) =>
                match (v as String) { case Some(s) => s case None => "" }
            case None => ""
        }
        @Expect(g, "hi Alice")
    }

    @TestCase
    func testTypeUtilsAssignableAndTyped() {
        let aName = TypeInfo.of(A()).qualifiedName
        let bName = TypeInfo.of(B()).qualifiedName
        @Expect(TypeUtils.isAssignable(bName, aName), true)
        @Expect(TypeUtils.distance(bName, aName), 1)

        let tp = TypedPerson(TypeLiteral.ofQualifiedName(aName))
        @Expect(tp.getTypeLiteral().getQualifiedName(), aName)
    }
}
