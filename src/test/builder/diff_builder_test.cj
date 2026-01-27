package commons_lang4cj.test.builder

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.builder.*

public class DBPerson <: ToString {
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
class DiffBuilderTest {
    @TestCase
    func testDiffBuilderBasic() {
        let left = DBPerson("a", 1i64)
        let right = DBPerson("a", 2i64)

        let b = DiffBuilderConfig<DBPerson>()
            .setLeft(left)
            .setRight(right)
            .build()
            .append("name", left.name, right.name)
            .append("age", left.age, right.age)

        let r = b.build()
        @Expect(r.getNumberOfDiffs() > 0, true)
        @Expect(r.toString().contains("age"), true)
        @Expect(r.toString().contains("differs from"), true)
    }

    @TestCase
    func testToStringStylesInstantiate() {
        let _ = StandardToStringStyle()
        let _ = RecursiveToStringStyle()
        let _ = MultilineRecursiveToStringStyle()
    }
}

