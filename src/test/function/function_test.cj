package commons_lang4cj.test.function

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.function.*

@Test
class FunctionTest {
    @TestCase
    func testTriFunction() {
        let f = object : TriFunction<Int64, Int64, Int64, Int64> {
            public func apply(a: Int64, b: Int64, c: Int64): Int64 {
                a + b + c
            }
        }
        @Expect(f.apply(1, 2, 3), 6)
    }

    @TestCase
    func testTriConsumer() {
        var acc: Int64 = 0
        let c = object : TriConsumer<Int64, Int64, Int64> {
            public func accept(a: Int64, b: Int64, c: Int64): Unit {
                acc = a + b + c
            }
        }
        c.accept(2, 3, 4)
        @Expect(acc, 9)
    }

    @TestCase
    func testToBooleanBiFunction() {
        let f = object : ToBooleanBiFunction<Int64, Int64> {
            public func applyAsBool(a: Int64, b: Int64): Bool {
                a < b
            }
        }
        @Expect(f.applyAsBool(1, 2), true)
        @Expect(f.applyAsBool(2, 1), false)
    }
}

