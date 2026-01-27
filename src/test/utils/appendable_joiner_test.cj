package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class AppendableJoinerTest {
    @TestCase
    func testJoiner() {
        let j = AppendableJoiner(",").add("a").add("b").add("c")
        @Expect(j.toString(), "a,b,c")
    }

    @TestCase
    func testJoinerWithAffixes() {
        let j = AppendableJoiner(",", "[", "]").add("a").add("b")
        @Expect(j.toString(), "[a,b]")
    }
}

