package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class CharSetUtilsTest {
    @TestCase
    func testDeleteBasic() {
        @Expect(CharSetUtils.delete("hello", "el"), "ho")
        @Expect(CharSetUtils.delete("hello", ""), "hello")
        @Expect(CharSetUtils.delete("", "el"), "")
    }

    @TestCase
    func testDeleteRange() {
        @Expect(CharSetUtils.delete("abcXYZ123", "a-z"), "XYZ123")
        @Expect(CharSetUtils.delete("abcXYZ123", "^a-z"), "abc")
    }

    @TestCase
    func testKeepBasic() {
        @Expect(CharSetUtils.keep("hello", "el"), "ell")
        @Expect(CharSetUtils.keep("hello", ""), "")
        @Expect(CharSetUtils.keep("", "el"), "")
    }

    @TestCase
    func testSqueeze() {
        @Expect(CharSetUtils.squeeze("baallooon", "alo"), "balon")
        @Expect(CharSetUtils.squeeze("baallooon", "x"), "baallooon")
    }

    @TestCase
    func testCount() {
        @Expect(CharSetUtils.count("hello", "l"), 2)
        @Expect(CharSetUtils.count("hello", "x"), 0)
        @Expect(CharSetUtils.count("", "x"), 0)
    }
}

