package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class RegExUtilsTest {
    @TestCase
    func testRemoveAllAndFirst() {
        @Expect(RegExUtils.removeAll("a1b2c3", #"\d"#), "abc")
        @Expect(RegExUtils.removeFirst("a1b2c3", #"\d"#), "ab2c3")
        @Expect(RegExUtils.removeAll("", #"\d"#), "")
        @Expect(RegExUtils.removeAll("a1", ""), "a1")
    }

    @TestCase
    func testReplaceAllAndFirst() {
        @Expect(RegExUtils.replaceAll("a1b2c3", #"\d"#, "_"), "a_b_c_")
        @Expect(RegExUtils.replaceFirst("a1b2c3", #"\d"#, "_"), "a_b2c3")
        @Expect(RegExUtils.replaceAll("", #"\d"#, "_"), "")
        @Expect(RegExUtils.replaceAll("a1", "", "_"), "a1")
    }
}

