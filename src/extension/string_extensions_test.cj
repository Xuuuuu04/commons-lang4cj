package commons_lang4cj.extension

import std.unittest.*
import commons_lang4cj.utils.*

@Test
class StringExtensionsTest {
    @TestCase
    func testIsBlank() {
        let s1 = ""
        let s2 = " "
        let s3 = "abc"
        @Expect(s1.isBlank(), true)
        @Expect(s2.isBlank(), true)
        @Expect(s3.isBlank(), false)
    }

    @TestCase
    func testCapitalize() {
        let s1 = "abc"
        let s2 = "ABC"
        let s3 = ""
        @Expect(s1.capitalize(), "Abc")
        @Expect(s2.capitalize(), "ABC")
        @Expect(s3.capitalize(), "")
    }

    @TestCase
    func testAbbreviate() {
        let s = "abcdefg"
        @Expect(s.abbreviate(6), "abc...")
        @Expect(s.abbreviate(4), "a...")
        // Edge cases
        @Expect(s.abbreviate(10), "abcdefg")
    }

    @TestCase
    func testRotate() {
        let s = "abcdefg"
        @Expect(s.rotate(2), "fgabcde")
        @Expect(s.rotate(-2), "cdefgab")
        // Edge cases
        @Expect(s.rotate(0), "abcdefg")
        @Expect(s.rotate(7), "abcdefg")
        @Expect(s.rotate(9), "fgabcde") // 9 % 7 = 2
    }

    @TestCase
    func testChainedCalls() {
        let s = "  abc  "
        // trim() (std/ext) -> "abc"
        // capitalize() (ext) -> "Abc"
        // rotate(1) (ext) -> "cAb"
        @Expect(s.trim().capitalize().rotate(1), "cAb")

        let s2 = "hello"
        // upperCase() (ext) -> "HELLO"
        // rotate(2) (ext) -> "LOHEL"
        @Expect(s2.upperCase().rotate(2), "LOHEL")
    }
}
