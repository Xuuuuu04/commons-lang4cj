package commons_lang4cj.test.random

import std.unittest.*
import commons_lang4cj.random.*

@Test
public class RandomUtilsTest {

    @TestCase
    public func testNextLongRange() {
        let start: Int64 = 100
        let end: Int64 = 200
        for (i in 0..100) {
            let val = RandomUtils.nextLong(start, end)
            @Expect(val >= start && val < end, true)
        }
    }

    @TestCase
    public func testNextIntRange() {
        let start: Int32 = 100
        let end: Int32 = 200
        for (i in 0..100) {
            let val = RandomUtils.nextInt(start, end)
            @Expect(val >= start && val < end, true)
        }
    }

    @TestCase
    public func testNextIntDistribution() {
        // Test small range [0, 10) for 100 times
        let start: Int32 = 0
        let end: Int32 = 10
        for (_ in 0..100) {
            let val = RandomUtils.nextInt(start, end)
            @Expect(val >= 0 && val < 10, true)
        }
    }

    @TestCase
    public func testNextLongDistribution() {
        // Test small range [0, 5) for 100 times
        let start: Int64 = 0
        let end: Int64 = 5
        for (_ in 0..100) {
            let val = RandomUtils.nextLong(start, end)
            @Expect(val >= 0 && val < 5, true)
        }
    }

    @TestCase
    public func testNextDoubleRange() {
        let start: Float64 = 1.5
        let end: Float64 = 2.5
        for (i in 0..100) {
            let val = RandomUtils.nextDouble(start, end)
            @Expect(val >= start && val < end, true)
        }
    }

    @TestCase
    public func testNextBytes() {
        let count: Int64 = 10
        let bytes = RandomUtils.nextBytes(count)
        @Expect(bytes.size, count)
    }

    @TestCase
    public func testNextBoolean() {
        // Just execute to ensure no crash
        let b = RandomUtils.nextBoolean()
        @Expect(b == true || b == false, true)
    }

    @TestCase
    public func testInvalidRanges() {
        // start == end
        @ExpectThrows[IllegalArgumentException](RandomUtils.nextLong(100, 100))
        @ExpectThrows[IllegalArgumentException](RandomUtils.nextInt(100, 100))
        @ExpectThrows[IllegalArgumentException](RandomUtils.nextDouble(1.5, 1.5))

        // start > end
        @ExpectThrows[IllegalArgumentException](RandomUtils.nextLong(100, 50))
        @ExpectThrows[IllegalArgumentException](RandomUtils.nextInt(100, 10))
        @ExpectThrows[IllegalArgumentException](RandomUtils.nextDouble(2.0, 1.0))

        // Invalid count
        @ExpectThrows[IllegalArgumentException](RandomUtils.nextBytes(-1))
    }
}
