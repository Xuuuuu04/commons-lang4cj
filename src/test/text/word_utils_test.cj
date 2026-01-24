package commons_lang4cj.test.text

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.text.WordUtils

@Test
public class WordUtilsTest {

    @TestCase
    public func testWrap() {
        let s1 = "Here is one line of text that is going to be wrapped after 20 columns."
        let actual1 = WordUtils.wrap(s1, 20)
        @Expect(actual1,
            "Here is one line of\ntext that is going\nto be wrapped after\n20 columns.")

        let actual2 = WordUtils.wrap(s1, 20, "\n", true)
        @Expect(actual2,
            "Here is one line of\ntext that is going\nto be wrapped after\n20 columns.")

        let s2 = "Click here to jump to the commons website - http://commons.apache.org"
        let actual3 = WordUtils.wrap(s2, 20, "\n", false)
        @Expect(actual3,
            "Click here to jump\nto the commons\nwebsite -\nhttp://commons.apache.org")

        let actual4 = WordUtils.wrap(s2, 20, "\n", true)
        @Expect(actual4,
            "Click here to jump\nto the commons\nwebsite -\nhttp://commons.apach\ne.org")
    }

    @TestCase
    public func testCapitalize() {
        @Expect(WordUtils.capitalize(""), "")
        @Expect(WordUtils.capitalize("i am FINE"), "I Am FINE")

        let cap3 = WordUtils.capitalize("i am_FINE", Some([r'_']))
        @Expect(cap3, "I am_FINE")

        let cap4 = WordUtils.capitalize("i am_fine", Some([r'_']))
        @Expect(cap4, "I am_Fine")
    }

    @TestCase
    public func testUncapitalize() {
        @Expect(WordUtils.uncapitalize(""), "")
        @Expect(WordUtils.uncapitalize("I Am FINE"), "i am fINE")
        @Expect(WordUtils.uncapitalize("I Am_FINE", Some([r'_'])), "I Am_fINE")
    }

    @TestCase
    public func testInitials() {
        @Expect(WordUtils.initials(""), "")
        @Expect(WordUtils.initials("I Am FINE"), "IAF")

        let init3 = WordUtils.initials("I Am_FINE", Some([r'_']))
        @Expect(init3, "IF")

        let init4 = WordUtils.initials("Ben John Lee", None)
        @Expect(init4, "BJL")

        let init5 = WordUtils.initials("Ben J.Lee", Some([r' ', r'.']))
        @Expect(init5, "BJL")
    }

    @TestCase
    public func testSwapCase() {
        @Expect(WordUtils.swapCase("The dog has a BONE"), "tHE DOG HAS A bone")
    }
}
