package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class CharSequenceUtilsTest {
    @TestCase
    func testIndexOfAndLastIndexOf() {
        @Expect(CharSequenceUtils.indexOf("hello", "ell"), 1)
        @Expect(CharSequenceUtils.indexOf("hello", "ell", 2), -1)
        @Expect(CharSequenceUtils.lastIndexOf("hello hello", "ell"), 7)
    }

    @TestCase
    func testRegionMatches() {
        @Expect(CharSequenceUtils.regionMatches("Hello", false, 0, "He", 0, 2), true)
        @Expect(CharSequenceUtils.regionMatches("Hello", true, 0, "he", 0, 2), true)
        @Expect(CharSequenceUtils.regionMatches("Hello", false, 0, "he", 0, 2), false)
    }
}

