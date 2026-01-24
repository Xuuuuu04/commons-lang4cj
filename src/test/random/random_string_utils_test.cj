package commons_lang4cj.test.random

import std.unittest.*
import commons_lang4cj.random.*

@Test
class RandomStringUtilsTest {
    @TestCase
    func testRandom() {
        let s = RandomStringUtils.random(10)
        @Expect(s.size, 10)
    }

    @TestCase
    func testRandomAlphabetic() {
        let s = RandomStringUtils.randomAlphabetic(10)
        @Expect(s.size, 10)
        for (b in s.toArray()) {
            let isLetter = (b >= 65 && b <= 90) || (b >= 97 && b <= 122)
            @Expect(isLetter)
        }
    }

    @TestCase
    func testRandomNumeric() {
        let s = RandomStringUtils.randomNumeric(10)
        @Expect(s.size, 10)
        for (b in s.toArray()) {
            let isDigit = (b >= 48 && b <= 57)
            @Expect(isDigit)
        }
    }

    @TestCase
    func testRandomAlphanumeric() {
        let s = RandomStringUtils.randomAlphanumeric(10)
        @Expect(s.size, 10)
        for (b in s.toArray()) {
            let isAlphaNum = (b >= 65 && b <= 90) || (b >= 97 && b <= 122) || (b >= 48 && b <= 57)
            @Expect(isAlphaNum)
        }
    }
}
