package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class ArrayFillSorterTest {
    @TestCase
    func testFillReturnsNewArray() {
        let original = [1, 2, 3]
        let filled = ArrayFill.fill(original, 0)
        @Expect(original[0], 1)
        @Expect(filled, [0, 0, 0])
    }

    @TestCase
    func testSorter() {
        var arr = [3, 1, 2]
        ArraySorter.sort(arr)
        @Expect(arr, [1, 2, 3])

        let sorted = ArraySorter.sorted([2, 3, 1])
        @Expect(sorted, [1, 2, 3])
    }
}

