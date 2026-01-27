package commons_lang4cj.test.stream

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import commons_lang4cj.stream.*
import commons_lang4cj.tuple.*

@Test
class StreamsTest {
    @TestCase
    func testMapFilterFlatMapConcat() {
        let a = [1i64, 2i64, 3i64]
        let m = Streams.map<Int64, String>(a, { v => "${v}" })
        @Expect(m.size, 3)
        @Expect(m[0], "1")

        let f = Streams.filter<Int64>(a, { v => v % 2 == 1 })
        @Expect(f.size, 2)
        @Expect(f[0], 1i64)
        @Expect(f[1], 3i64)

        let fm = Streams.flatMap<Int64, Int64>(a, { v => [v, v] })
        @Expect(fm.size, 6)
        @Expect(fm[0], 1i64)
        @Expect(fm[1], 1i64)

        let c = Streams.concat<Int64>([1i64], [2i64, 3i64])
        @Expect(c.size, 3)
        @Expect(c[2], 3i64)
    }

    @TestCase
    func testIntStreamsAndCollectors() {
        let r = IntStreams.range(1i64, 4i64)
        @Expect(r.size, 3)
        @Expect(r[0], 1i64)
        @Expect(r[2], 3i64)

        let rc = IntStreams.rangeClosed(1i64, 3i64)
        @Expect(rc.size, 3)
        @Expect(IntStreams.sum(rc), 6i64)
        @Expect(IntStreams.average(rc).isSome(), true)

        let joined = LangCollectors.joining(["a", "b", "c"], ",", "[", "]")
        @Expect(joined, "[a,b,c]")

        let pairs = [Pair<String, Int64>("x", 1i64), Pair<String, Int64>("y", 2i64)]
        let m = LangCollectors.toHashMap<String, Int64>(pairs)
        @Expect(m.get("x").isSome(), true)
        let xv = match (m.get("x")) { case Some(v) => v case None => 0 }
        @Expect(xv, 1i64)
    }
}
