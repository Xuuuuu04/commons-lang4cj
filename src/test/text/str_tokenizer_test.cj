package commons_lang4cj.test.text

import commons_lang4cj.text.*
import std.unittest.*
import std.unittest.testmacro.*

/**
 * StrTokenizer 测试类
 * 测试字符串分词功能
 */
@Test
class StrTokenizerTest {

    // ==================== 基础测试（6 个）====================

    @TestCase
    func testBasicSplit() {
        let tokenizer = StrTokenizer.of("a b c")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)
        @Expect(tokens[0], "a")
        @Expect(tokens[1], "b")
        @Expect(tokens[2], "c")
    }

    @TestCase
    func testCustomDelimiter() {
        let tokenizer = StrTokenizer.of("a,b,c", ",")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)
        @Expect(tokens[0], "a")
        @Expect(tokens[1], "b")
        @Expect(tokens[2], "c")
    }

    @TestCase
    func testEmptyInput() {
        let tokenizer = StrTokenizer.of("")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 0)
    }

    @TestCase
    func testSingleToken() {
        let tokenizer = StrTokenizer.of("single")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 1)
        @Expect(tokens[0], "single")
    }

    @TestCase
    func testCount() {
        let tokenizer = StrTokenizer.of("a b c d")
        @Expect(tokenizer.count(), 4)
    }

    @TestCase
    func testGetTokenArray() {
        let tokenizer = StrTokenizer.of("x y z")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)
        @Expect(tokens is Array<String>, true)
    }

    // ==================== 引号测试（4 个）====================

    @TestCase
    func testQuoteHandling() {
        let tokenizer = StrTokenizer.of("\"a b\" c")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 2)
        @Expect(tokens[0], "a b")
        @Expect(tokens[1], "c")
    }

    @TestCase
    func testQuoteWithDelimiter() {
        let tokenizer = StrTokenizer.of("\"a,b\", c", ",")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 2)
        @Expect(tokens[0], "a,b")
        @Expect(tokens[1], "c")
    }

    @TestCase
    func testMultipleQuotes() {
        let tokenizer = StrTokenizer.of("\"a\" \"b\" \"c\"")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)
        @Expect(tokens[0], "a")
        @Expect(tokens[1], "b")
        @Expect(tokens[2], "c")
    }

    @TestCase
    func testNestedQuotes() {
        let tokenizer = StrTokenizer.of("\"a 'b' c\" d")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 2)
        @Expect(tokens[0], "a 'b' c")
        @Expect(tokens[1], "d")
    }

    // ==================== 功能测试（6 个）====================

    @TestCase
    func testIgnoreEmptyTokens() {
        let tokenizer = StrTokenizer.of("a  b   c")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)  // 应该忽略空 token
    }

    @TestCase
    func testTrimTokens() {
        let tokenizer = StrTokenizer.of("  a  ,  b  ,  c  ", ",")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)
        @Expect(tokens[0], "a")
        @Expect(tokens[1], "b")
        @Expect(tokens[2], "c")
    }

    @TestCase
    func testChaining() {
        let tokenizer = StrTokenizer.of("a b c")
            .setDelimiterChar(",")
            .setQuoteChar("\"")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 1)  // 逗号分隔，所以只有一个 token
    }

    @TestCase
    func testReset() {
        let tokenizer = StrTokenizer.of("a b c")
        let tokens1 = tokenizer.getTokenArray()
        @Expect(tokens1.size, 3)

        tokenizer.reset("d e f")
        let tokens2 = tokenizer.getTokenArray()
        @Expect(tokens2.size, 3)
        @Expect(tokens2[0], "d")
    }

    @TestCase
    func testConsecutiveDelimiters() {
        let tokenizer = StrTokenizer.of("a,,b", ",")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 2)  // 忽略空 token
    }

    @TestCase
    func testDelimiterAtStart() {
        let tokenizer = StrTokenizer.of(",a,b,c", ",")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)
        @Expect(tokens[0], "a")
    }

    // ==================== 边界测试（4 个）====================

    @TestCase
    func testNullInput() {
        // 测试 None 输入不会导致异常
        // 由于 StrTokenizer.of() 需要非空字符串，这里测试默认行为
        let tokenizer = StrTokenizer.of("")
        @Expect(tokenizer.count(), 0)
    }

    @TestCase
    func testOnlyDelimiters() {
        let tokenizer = StrTokenizer.of(",,,", ",")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 0)  // 只有分隔符，没有有效 token
    }

    @TestCase
    func testOnlyQuotes() {
        let tokenizer = StrTokenizer.of("\"\"")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 1)
        @Expect(tokens[0], "")
    }

    @TestCase
    func testMixedWhitespace() {
        let tokenizer = StrTokenizer.of("a\tb  \nc")
        let tokens = tokenizer.getTokenArray()
        @Expect(tokens.size, 3)
        @Expect(tokens[0], "a")
        @Expect(tokens[1], "b")
        @Expect(tokens[2], "c")
    }
}
