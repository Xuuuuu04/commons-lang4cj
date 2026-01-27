package commons_lang4cj.test.builder

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.reflect.*
import commons_lang4cj.builder.*
import commons_lang4cj.reflect.*

public class RBPerson <: ToString {
    public let name: String
    public let age: Int64

    public init(name: String, age: Int64) {
        this.name = name
        this.age = age
    }

    public func toString(): String {
        "${name}:${age}"
    }
}

@Test
class ReflectionBuilderTest {
    @TestCase
    func testAnnotationUtilsEqualsHashToString() {
        let a = HashMap<String, String>()
        a["k"] = "v"
        let b = HashMap<String, String>()
        b["k"] = "v"
        @Expect(AnnotationUtils.equals(a, b), true)
        @Expect(AnnotationUtils.hashCode(a), AnnotationUtils.hashCode(b))
        let s = AnnotationUtils.toString("Anno", a)
        @Expect(s.contains("@Anno"), true)
        @Expect(s.contains("k=v"), true)
    }

    @TestCase
    func testReflectionToStringAndDiff() {
        let typeName = TypeInfo.of(RBPerson("", 0)).qualifiedName
        FieldUtils.registerField(typeName, "name", { obj =>
            match (obj as RBPerson) { case Some(p) => p.name case None => "" }
        })
        FieldUtils.registerField(typeName, "age", { obj =>
            match (obj as RBPerson) { case Some(p) => p.age case None => 0i64 }
        })

        let p1 = RBPerson("Bob", 1i64)
        let p2 = RBPerson("Bob", 2i64)

        let ts = ReflectionToStringBuilder.toString(p1)
        @Expect(ts.contains("name"), true)
        @Expect(ts.contains("Bob"), true)

        let diff = ReflectionDiffBuilder.diff(p1, p2)
        @Expect(diff.contains("age"), true)
        @Expect(diff.contains("name"), false)
    }
}

