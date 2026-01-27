package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class CharEncodingTest {
    @TestCase
    func testConstants() {
        @Expect(CharEncoding.UTF_8, "UTF-8")
        @Expect(CharEncoding.UTF_16, "UTF-16")
        @Expect(CharEncoding.UTF_16BE, "UTF-16BE")
        @Expect(CharEncoding.UTF_16LE, "UTF-16LE")
        @Expect(CharEncoding.ISO_8859_1, "ISO-8859-1")
        @Expect(CharEncoding.US_ASCII, "US-ASCII")
    }
}

