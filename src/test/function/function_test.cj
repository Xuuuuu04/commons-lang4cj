package commons_lang4cj.test.function

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.function.*
import commons_lang4cj.mutable.*

private class SumTriFunction <: TriFunction<Int64, Int64, Int64, Int64> {
    public func apply(a: Int64, b: Int64, c: Int64): Int64 {
        a + b + c
    }
}

private class SetAccTriConsumer <: TriConsumer<Int64, Int64, Int64> {
    private let _acc: MutableLong

    public init(acc: MutableLong) {
        _acc = acc
    }

    public func accept(a: Int64, b: Int64, c: Int64): Unit {
        _acc.setValue(a + b + c)
    }
}

private class LessThanBiFunction <: ToBooleanBiFunction<Int64, Int64> {
    public func applyAsBool(a: Int64, b: Int64): Bool {
        a < b
    }
}

@Test
class FunctionTest {
    @TestCase
    func testTriFunction() {
        let f = SumTriFunction()
        @Expect(f.apply(1, 2, 3), 6)
    }

    @TestCase
    func testTriConsumer() {
        let acc = MutableLong(0)
        let consumer = SetAccTriConsumer(acc)
        consumer.accept(2, 3, 4)
        @Expect(acc.getValue(), 9)
    }

    @TestCase
    func testToBooleanBiFunction() {
        let f = LessThanBiFunction()
        @Expect(f.applyAsBool(1, 2), true)
        @Expect(f.applyAsBool(2, 1), false)
    }
}
