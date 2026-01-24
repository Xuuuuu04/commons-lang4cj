package commons_lang4cj.test.text

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.text.similarity.LevenshteinDistance

@Test
public class LevenshteinDistanceTest {

    private let distance = LevenshteinDistance.getDefaultInstance()

    @TestCase
    public func testSimple() {
        @Expect(distance.apply("", ""), 0)
        @Expect(distance.apply("", "a"), 1)
        @Expect(distance.apply("aaapppp", ""), 7)
        @Expect(distance.apply("frog", "fog"), 1)
        @Expect(distance.apply("fly", "ant"), 3)
        @Expect(distance.apply("elephant", "hippo"), 7)
        @Expect(distance.apply("hippo", "elephant"), 7)
        @Expect(distance.apply("hippo", "zzzzzzzz"), 8)
        @Expect(distance.apply("hello", "hallo"), 1)
    }

    @TestCase
    public func testThreshold() {
        @Expect(distance.apply("hello", "hallo", 2), 1)
        @Expect(distance.apply("hello", "hallo", 0), -1)
        @Expect(distance.apply("hello", "hallo", 1), 1)
        @Expect(distance.apply("fly", "ant", 3), 3)
        @Expect(distance.apply("fly", "ant", 2), -1)
    }
}
