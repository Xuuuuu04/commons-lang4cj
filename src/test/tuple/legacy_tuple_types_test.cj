package commons_lang4cj.test.tuple

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.tuple.*

@Test
class LegacyTupleTypesTest {
    @TestCase
    func testImmutablePairAndTriple() {
        let p = ImmutablePair<Int64, String>.of(1i64, "a")
        @Expect(p.getLeft(), 1i64)
        @Expect(p.getRight(), "a")

        let t = ImmutableTriple<Int64, String, Bool>.of(1i64, "b", true)
        @Expect(t.getLeft(), 1i64)
        @Expect(t.getMiddle(), "b")
        @Expect(t.getRight(), true)
    }

    @TestCase
    func testMutablePairAndTriple() {
        let p = MutablePair<Int64, String>.of(1i64, "a")
        p.setLeft(2i64)
        p.setRight("b")
        @Expect(p.getLeft(), 2i64)
        @Expect(p.getRight(), "b")

        let t = MutableTriple<Int64, String, Bool>.of(1i64, "b", true)
        t.setLeft(2i64)
        t.setMiddle("c")
        t.setRight(false)
        @Expect(t.getLeft(), 2i64)
        @Expect(t.getMiddle(), "c")
        @Expect(t.getRight(), false)
    }
}

