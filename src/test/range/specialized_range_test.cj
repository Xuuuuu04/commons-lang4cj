package commons_lang4cj.test.range

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.range.*

@Test
class SpecializedRangeTest {
    @TestCase
    func testIntegerAndLongRangeBasics() {
        let r = IntegerRange.of(3i64, 1i64)
        @Expect(r.getMinimum(), 1i64)
        @Expect(r.getMaximum(), 3i64)
        @Expect(r.contains(2i64), true)

        let lr = LongRange.isSingle(5i64)
        @Expect(lr.contains(5i64), true)
        @Expect(lr.contains(4i64), false)
    }

    @TestCase
    func testDoubleRangeIntersection() {
        let a = DoubleRange.of(0.0, 2.0)
        let b = DoubleRange.of(1.0, 3.0)
        let inter = a.intersectionWith(b)
        @Expect(inter.isSome(), true)
        match (inter) {
            case Some(r) =>
                @Expect(r.getMinimum(), 1.0)
                @Expect(r.getMaximum(), 2.0)
            case None => ()
        }
    }
}

