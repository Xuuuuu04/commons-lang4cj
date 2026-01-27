package commons_lang4cj.test.builder

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.builder.*

public class SelfRefNode <: Hashable & ToString {
    public let id: Int64
    public var next: Option<SelfRefNode> = None

    public init(id: Int64) {
        this.id = id
    }

    public func hashCode(): Int64 {
        id
    }

    public func toString(): String {
        let selfObj: Option<ToStringObject> = Some(ToStringObjectWrapper<SelfRefNode>(this))
        let b = ToStringBuilder(selfObj)
        let nextObj: Option<ToStringObject> = match (next) {
            case Some(n) => Some(ToStringObjectWrapper<SelfRefNode>(n))
            case None => None
        }
        b.append("next", nextObj)
        b.build()
    }
}

@Test
class ToStringBuilderTest {
    @TestCase
    func testCycleReferenceDoesNotRecurse() {
        let n = SelfRefNode(1)
        n.next = Some(n)

        let s1 = n.toString()
        @Expect(s1.contains("<SelfRefNode@1>"), true)

        let s2 = n.toString()
        @Expect(s2.contains("<SelfRefNode@1>"), true)
    }
}
