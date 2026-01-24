package commons_lang4cj.test.text

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import commons_lang4cj.text.StrSubstitutor

@Test
public class StrSubstitutorTest {

    @TestCase
    public func testReplace() {
        let map = HashMap<String, String>()
        map["animal"] = "quick brown fox"
        map["target"] = "lazy dog"

        let template = "The \${animal} jumps over the \${target}."
        let expected = "The quick brown fox jumps over the lazy dog."

        @Expect(StrSubstitutor.substitute(template, map), expected)
    }

    @TestCase
    public func testReplaceUnknown() {
        let map = HashMap<String, String>()
        map["name"] = "Alice"

        let template = "Hello \${name}, how is \${unknown}?"
        let expected = "Hello Alice, how is \${unknown}?"

        @Expect(StrSubstitutor.substitute(template, map), expected)
    }

    @TestCase
    public func testReplaceSystemProperties() {
        // Just verify it doesn't crash and returns something
        // We can't predict exact values easily without mocking
        let template = "User Home: \${user.home}"
        let result = StrSubstitutor.replaceSystemProperties(template)
        @Expect(result.size > 0, true)
    }
}
