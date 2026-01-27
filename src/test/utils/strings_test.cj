package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class StringsTest {
    @TestCase
    func testCaseSensitiveEquals() {
        @Expect(Strings.CS.equals("a", "a"), true)
        @Expect(Strings.CS.equals("a", "A"), false)
    }

    @TestCase
    func testCaseInsensitiveEquals() {
        @Expect(Strings.CI.equals("a", "A"), true)
    }

    @TestCase
    func testContainsStartsEnds() {
        @Expect(Strings.CS.contains("Abc", "b"), true)
        @Expect(Strings.CI.contains("Abc", "b"), true)
        @Expect(Strings.CS.startsWith("Abc", "A"), true)
        @Expect(Strings.CI.startsWith("Abc", "a"), true)
        @Expect(Strings.CS.endsWith("Abc", "c"), true)
        @Expect(Strings.CI.endsWith("Abc", "C"), true)
    }
}

