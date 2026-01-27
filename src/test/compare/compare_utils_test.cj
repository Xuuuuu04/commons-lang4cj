package commons_lang4cj.test.compare

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.compare.*

@Test
class CompareUtilsTest {
    @TestCase
    func testComparableUtilsBuilder() {
        @Expect(ComparableUtils.`is`(2i64).between(1i64, 3i64), true)
        @Expect(ComparableUtils.`is`(2i64).betweenExclusive(1i64, 3i64), true)
        @Expect(ComparableUtils.`is`(1i64).betweenExclusive(1i64, 3i64), false)
        @Expect(ComparableUtils.`is`(2i64).greaterThan(1i64), true)
        @Expect(ComparableUtils.`is`(2i64).lessThanOrEqualTo(2i64), true)
    }

    @TestCase
    func testComparableUtilsPredicates() {
        let p = ComparableUtils.between(1i64, 3i64)
        @Expect(p(2i64), true)
        @Expect(p(4i64), false)

        let ge2 = ComparableUtils.ge(2i64)
        @Expect(ge2(2i64), true)
        @Expect(ge2(1i64), false)
    }

    @TestCase
    func testObjectToStringComparator() {
        @Expect(ObjectToStringComparator.compare("a", "b") < 0, true)
        @Expect(ObjectToStringComparator.compare(1i64, 1i64) == 0, true)
    }
}

