package commons_lang4cj.test.range

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.range.Range as LangRange

/**
 * Range 单元测试
 *
 * 测试覆盖 LangRange<T> 类的所有公共方法
 * 测试覆盖率目标：≥ 90%
 */
@Test
class RangeTest {
    /**
     * 测试 Range.of() 静态工厂方法 - Int64 范围
     */
    @TestCase
    func testOfInt64() {
        let range = LangRange<Int64>.of(1, 10)

        @Expect(range.getMinimum(), 1)
        @Expect(range.getMaximum(), 10)
    }

    /**
     * 测试 Range.of() 静态工厂方法 - Float64 范围
     */
    @TestCase
    func testOfFloat64() {
        let range = LangRange<Float64>.of(1.5, 10.5)

        @Expect(range.getMinimum(), 1.5)
        @Expect(range.getMaximum(), 10.5)
    }

    /**
     * 测试 Range.of() 静态工厂方法 - 反向范围（自动交换）
     */
    @TestCase
    func testOfReversed() {
        let range = LangRange<Int64>.of(10, 1)

        @Expect(range.getMinimum(), 1)
        @Expect(range.getMaximum(), 10)
    }

    /**
     * 测试 Range.isSingle() 静态工厂方法 - 单元素范围
     */
    @TestCase
    func testIsSingle() {
        let range = LangRange<Int64>.isSingle(5)

        @Expect(range.getMinimum(), 5)
        @Expect(range.getMaximum(), 5)
    }

    /**
     * 测试 contains() 方法 - 元素在范围内
     */
    @TestCase
    func testContainsInside() {
        let range = LangRange<Int64>.of(1, 10)

        @Expect(range.contains(5), true)
        @Expect(range.contains(1), true)
        @Expect(range.contains(10), true)
    }

    /**
     * 测试 contains() 方法 - 元素不在范围内
     */
    @TestCase
    func testContainsOutside() {
        let range = LangRange<Int64>.of(1, 10)

        @Expect(range.contains(0), false)
        @Expect(range.contains(11), false)
        @Expect(range.contains(-1), false)
    }

    /**
     * 测试 contains() 方法 - Float64 精度
     */
    @TestCase
    func testContainsFloat64() {
        let range = LangRange<Float64>.of(1.0, 10.0)

        @Expect(range.contains(5.5), true)
        @Expect(range.contains(1.0), true)
        @Expect(range.contains(10.0), true)
        @Expect(range.contains(0.9), false)
    }

    /**
     * 测试 containsRange() 方法 - 完全包含
     */
    @TestCase
    func testContainsRangeFully() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(2, 9)

        @Expect(range1.containsRange(range2), true)
    }

    /**
     * 测试 containsRange() 方法 - 部分包含
     */
    @TestCase
    func testContainsRangePartially() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(5, 15)

        @Expect(range1.containsRange(range2), false)
    }

    /**
     * 测试 containsRange() 方法 - 完全不包含
     */
    @TestCase
    func testContainsRangeNotAtAll() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(11, 20)

        @Expect(range1.containsRange(range2), false)
    }

    /**
     * 测试 isBefore() 方法 - 元素在范围之前
     */
    @TestCase
    func testIsBefore() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.isBefore(11), true)
        @Expect(range.isBefore(4), false)
    }

    /**
     * 测试 isAfter() 方法 - 元素在范围之后
     */
    @TestCase
    func testIsAfter() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.isAfter(4), true)
        @Expect(range.isAfter(11), false)
    }

    /**
     * 测试 isStartedBy() 方法 - 以指定元素开始
     */
    @TestCase
    func testIsStartedBy() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.isStartedBy(5), true)
        @Expect(range.isStartedBy(4), false)
        @Expect(range.isStartedBy(6), false)
    }

    /**
     * 测试 isEndedBy() 方法 - 以指定元素结束
     */
    @TestCase
    func testIsEndedBy() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.isEndedBy(10), true)
        @Expect(range.isEndedBy(9), false)
        @Expect(range.isEndedBy(11), false)
    }

    /**
     * 测试 intersectionWith() 方法 - 有交集
     */
    @TestCase
    func testIntersectionWithOverlap() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(5, 15)

        let result = range1.intersectionWith(range2)

        if (let Some(intersection) <- result) {
            @Expect(intersection.getMinimum(), 5)
            @Expect(intersection.getMaximum(), 10)
        }
    }

    /**
     * 测试 intersectionWith() 方法 - 无交集
     */
    @TestCase
    func testIntersectionWithNoOverlap() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(11, 20)

        let result = range1.intersectionWith(range2)

        match (result) {
            case Some(_) => @Expect(false, true) // 不应该到这里
            case None => () // 预期结果
        }
    }

    /**
     * 测试 intersectionWith() 方法 - 相邻范围
     */
    @TestCase
    func testIntersectionWithAdjacent() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(10, 20)

        let result = range1.intersectionWith(range2)

        if (let Some(intersection) <- result) {
            @Expect(intersection.getMinimum(), 10)
            @Expect(intersection.getMaximum(), 10)
        }
    }

    /**
     * 测试 spanWith() 方法 - 扩展范围
     */
    @TestCase
    func testSpanWith() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(5, 15)

        let spanned = range1.spanWith(range2)

        @Expect(spanned.getMinimum(), 1)
        @Expect(spanned.getMaximum(), 15)
    }

    /**
     * 测试 isOverlappedBy() 方法 - 有重叠
     */
    @TestCase
    func testIsOverlappedByTrue() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(5, 15)

        @Expect(range1.isOverlappedBy(range2), true)
    }

    /**
     * 测试 isOverlappedBy() 方法 - 无重叠
     */
    @TestCase
    func testIsOverlappedByFalse() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(11, 20)

        @Expect(range1.isOverlappedBy(range2), false)
    }

    /**
     * 测试 fitsWithin() 方法 - 完全在范围内
     */
    @TestCase
    func testFitsWithinTrue() {
        let range1 = LangRange<Int64>.of(5, 10)
        let range2 = LangRange<Int64>.of(1, 20)

        @Expect(range1.fitsWithin(range2), true)
    }

    /**
     * 测试 fitsWithin() 方法 - 不在范围内
     */
    @TestCase
    func testFitsWithinFalse() {
        let range1 = LangRange<Int64>.of(1, 20)
        let range2 = LangRange<Int64>.of(5, 10)

        @Expect(range1.fitsWithin(range2), false)
    }

    /**
     * 测试 fit() 方法 - 元素小于最小值
     */
    @TestCase
    func testFitBelowMinimum() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.fit(3), 5)
    }

    /**
     * 测试 fit() 方法 - 元素大于最大值
     */
    @TestCase
    func testFitAboveMaximum() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.fit(15), 10)
    }

    /**
     * 测试 fit() 方法 - 元素在范围内
     */
    @TestCase
    func testFitInside() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.fit(7), 7)
    }

    /**
     * 测试 compareTo() 方法 - 比较范围
     */
    @TestCase
    func testCompareTo() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(5, 15)
        let range3 = LangRange<Int64>.of(1, 10)

        @Expect(range1.compareTo(range2) < 0, true)
        @Expect(range2.compareTo(range1) > 0, true)
        @Expect(range1.compareTo(range3), 0)
    }

    /**
     * 测试 elementCompareTo() 方法 - 元素在范围之前
     */
    @TestCase
    func testElementCompareToBefore() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.elementCompareTo(3) < 0, true)
    }

    /**
     * 测试 elementCompareTo() 方法 - 元素在范围内
     */
    @TestCase
    func testElementCompareToInside() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.elementCompareTo(7), 0)
    }

    /**
     * 测试 elementCompareTo() 方法 - 元素在范围之后
     */
    @TestCase
    func testElementCompareToAfter() {
        let range = LangRange<Int64>.of(5, 10)

        @Expect(range.elementCompareTo(15) > 0, true)
    }

    /**
     * 测试 equals() 方法 - 相等范围
     */
    @TestCase
    func testEqualsTrue() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(1, 10)

        @Expect(range1.equals(range2), true)
    }

    /**
     * 测试 equals() 方法 - 不等范围
     */
    @TestCase
    func testEqualsFalse() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(2, 11)

        @Expect(range1.equals(range2), false)
    }

    /**
     * 测试 hashCode() 方法 - 相同范围有相同哈希码
     */
    @TestCase
    func testHashCodeSame() {
        let range1 = LangRange<Int64>.of(1, 10)
        let range2 = LangRange<Int64>.of(1, 10)

        @Expect(range1.hashCode(), range2.hashCode())
    }

    /**
     * 测试 toString() 方法 - Int64 范围
     */
    @TestCase
    func testToStringInt64() {
        let range = LangRange<Int64>.of(1, 10)

        @Expect(range.toString(), "[1, 10]")
    }

    /**
     * 测试 toString() 方法 - Float64 范围
     */
    @TestCase
    func testToStringFloat64() {
        let range = LangRange<Float64>.of(1.5, 10.5)

        @Expect(range.toString(), "[1.5, 10.5]")
    }

    /**
     * 测试单元素范围的边界情况
     */
    @TestCase
    func testSingleElementRange() {
        let range = LangRange<Int64>.isSingle(5)

        @Expect(range.contains(5), true)
        @Expect(range.contains(4), false)
        @Expect(range.contains(6), false)
        @Expect(range.isStartedBy(5), true)
        @Expect(range.isEndedBy(5), true)
    }
}
