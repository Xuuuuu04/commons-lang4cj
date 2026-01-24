package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

/**
 * ArrayUtils 单元测试类
 *
 * 测试覆盖所有 21 个方法，确保测试覆盖率 ≥ 90%
 *
 * @since 1.0.0
 */
@Test
class ArrayUtilsTest {
    // ========== Phase 1: 空值与长度检查测试 ==========

    @TestCase
    func testIsEmpty() {
        // 空数组
        @Expect(ArrayUtils.isEmpty(Array<Int64>()), true)

        // 非空数组
        @Expect(ArrayUtils.isEmpty([1]), false)
        @Expect(ArrayUtils.isEmpty([1, 2, 3]), false)
        @Expect(ArrayUtils.isEmpty(["a"]), false)
    }

    @TestCase
    func testIsNotEmpty() {
        // 空数组
        @Expect(ArrayUtils.isNotEmpty(Array<Int64>()), false)

        // 非空数组
        @Expect(ArrayUtils.isNotEmpty([1]), true)
        @Expect(ArrayUtils.isNotEmpty([1, 2, 3]), true)
        @Expect(ArrayUtils.isNotEmpty(["a"]), true)
    }

    @TestCase
    func testGetLength() {
        // 各种长度
        @Expect(ArrayUtils.getLength(Array<Int64>()), 0)
        @Expect(ArrayUtils.getLength([1]), 1)
        @Expect(ArrayUtils.getLength([1, 2, 3]), 3)
        @Expect(ArrayUtils.getLength([1, 2, 3, 4, 5]), 5)
    }

    // ========== Phase 2: 查询操作测试 ==========

    @TestCase
    func testIndexOf() {
        // 找到元素
        @Expect(ArrayUtils.indexOf([1, 2, 3, 2, 1], 2), 1)
        @Expect(ArrayUtils.indexOf([1, 2, 3], 1), 0)
        @Expect(ArrayUtils.indexOf([1, 2, 3], 3), 2)

        // 未找到
        @Expect(ArrayUtils.indexOf([1, 2, 3], 5), ArrayUtils.INDEX_NOT_FOUND)
        @Expect(ArrayUtils.indexOf(Array<Int64>(), 1), ArrayUtils.INDEX_NOT_FOUND)

        // 字符串数组
        @Expect(ArrayUtils.indexOf(["a", "b", "c"], "b"), 1)
        @Expect(ArrayUtils.indexOf(["a", "b", "c"], "d"), ArrayUtils.INDEX_NOT_FOUND)
    }

    @TestCase
    func testIndexOfWithStartIndex() {
        // 从指定位置开始查找
        @Expect(ArrayUtils.indexOf([1, 2, 3, 2, 1], 2, 2), 3)
        @Expect(ArrayUtils.indexOf([1, 2, 3, 2, 1], 1, 2), 4)
        @Expect(ArrayUtils.indexOf([1, 2, 3], 2, 0), 1)

        // 无效起始索引
        @Expect(ArrayUtils.indexOf([1, 2, 3], 2, -1), ArrayUtils.INDEX_NOT_FOUND)
        @Expect(ArrayUtils.indexOf([1, 2, 3], 2, 3), ArrayUtils.INDEX_NOT_FOUND)
    }

    @TestCase
    func testContains() {
        // 包含元素
        @Expect(ArrayUtils.contains([1, 2, 3, 4, 5], 3), true)
        @Expect(ArrayUtils.contains([1, 2, 3], 1), true)
        @Expect(ArrayUtils.contains(["a", "b", "c"], "b"), true)

        // 不包含
        @Expect(ArrayUtils.contains([1, 2, 3], 6), false)
        @Expect(ArrayUtils.contains(Array<Int64>(), 1), false)
        @Expect(ArrayUtils.contains(["a", "b"], "c"), false)
    }

    @TestCase
    func testLastIndexOf() {
        // 找到元素
        @Expect(ArrayUtils.lastIndexOf([1, 2, 3, 2, 1], 2), 3)
        @Expect(ArrayUtils.lastIndexOf([1, 2, 3, 2, 1], 1), 4)
        @Expect(ArrayUtils.lastIndexOf([1, 2, 3], 3), 2)

        // 未找到
        @Expect(ArrayUtils.lastIndexOf([1, 2, 3], 5), ArrayUtils.INDEX_NOT_FOUND)
        @Expect(ArrayUtils.lastIndexOf(Array<Int64>(), 1), ArrayUtils.INDEX_NOT_FOUND)

        // 单个元素
        @Expect(ArrayUtils.lastIndexOf([1], 1), 0)
    }

    // ========== Phase 3: 修改操作测试 ==========

    @TestCase
    func testAddElement() {
        // 添加到空数组
        let arr1: Array<Int64> = []
        let result1 = ArrayUtils.add(arr1, 1)
        @Expect(result1.size, 1)
        @Expect(result1[0], 1)

        // 添加到非空数组
        let arr2 = [1, 2, 3]
        let result2 = ArrayUtils.add(arr2, 4)
        @Expect(result2.size, 4)
        @Expect(result2[0], 1)
        @Expect(result2[3], 4)

        // 原数组不变
        @Expect(arr2.size, 3)

        // 不同类型
        let arr3 = ["a", "b"]
        let result3 = ArrayUtils.add(arr3, "c")
        @Expect(result3.size, 3)
        @Expect(result3[2], "c")
    }

    @TestCase
    func testAddAtIndex() {
        // 在开头插入
        let arr1 = [2, 3, 4]
        let result1 = ArrayUtils.add(arr1, 0, 1)
        @Expect(result1.size, 4)
        @Expect(result1[0], 1)
        @Expect(result1[3], 4)

        // 在中间插入
        let arr2 = [1, 2, 4]
        let result2 = ArrayUtils.add(arr2, 2, 3)
        @Expect(result2.size, 4)
        @Expect(result2[1], 2)
        @Expect(result2[2], 3)

        // 在末尾插入
        let arr3 = [1, 2, 3]
        let result3 = ArrayUtils.add(arr3, 3, 4)
        @Expect(result3.size, 4)
        @Expect(result3[3], 4)
    }

    @TestCase
    func testRemove() {
        // 删除中间元素（索引2）
        let arr1 = [1, 2, 3, 4]
        let result1 = ArrayUtils.remove(arr1, 2)
        @Expect(result1.size, 3)
        @Expect(result1[0], 1)
        @Expect(result1[1], 2)
        @Expect(result1[2], 4)

        // 删除第一个元素
        let arr2 = [1, 2, 3]
        let result2 = ArrayUtils.remove(arr2, 0)
        @Expect(result2.size, 2)
        @Expect(result2[0], 2)

        // 删除最后一个元素
        let arr3 = [1, 2, 3]
        let result3 = ArrayUtils.remove(arr3, 2)
        @Expect(result3.size, 2)
        @Expect(result3[0], 1)
        @Expect(result3[1], 2)
    }

    @TestCase
    func testRemoveElement() {
        // 删除存在的元素（首次出现）
        let arr1 = [1, 2, 3, 2, 1]
        let result1 = ArrayUtils.removeElement(arr1, 2)
        @Expect(result1.size, 4)
        @Expect(result1[0], 1)
        @Expect(result1[1], 3)
        @Expect(result1[2], 2)
        @Expect(result1[3], 1)

        // 删除不存在的元素
        let arr2 = [1, 2, 3]
        let result2 = ArrayUtils.removeElement(arr2, 5)
        @Expect(result2.size, 3)
        @Expect(result2[0], 1)

        // 删除字符串
        let arr3 = ["a", "b", "c", "b"]
        let result3 = ArrayUtils.removeElement(arr3, "b")
        @Expect(result3.size, 3)
        @Expect(result3[0], "a")
        @Expect(result3[1], "c")
    }

    // ========== Phase 4: 反转与排序测试 ==========

    @TestCase
    func testReverse() {
        // 基本反转
        let arr1 = [1, 2, 3, 4, 5]
        let result1 = ArrayUtils.reverse(arr1)
        @Expect(result1.size, 5)
        @Expect(result1[0], 5)
        @Expect(result1[4], 1)

        // 空数组
        let arr2: Array<Int64> = []
        let result2 = ArrayUtils.reverse(arr2)
        @Expect(result2.size, 0)

        // 单元素
        let arr3 = [1]
        let result3 = ArrayUtils.reverse(arr3)
        @Expect(result3.size, 1)
        @Expect(result3[0], 1)

        // 双元素
        let arr4 = [1, 2]
        let result4 = ArrayUtils.reverse(arr4)
        @Expect(result4[0], 2)
        @Expect(result4[1], 1)

        // 字符串数组
        let arr5 = ["a", "b", "c"]
        let result5 = ArrayUtils.reverse(arr5)
        @Expect(result5[0], "c")
        @Expect(result5[2], "a")
    }

    @TestCase
    func testSwap() {
        // 交换首尾
        var arr1 = [1, 2, 3, 4]
        ArrayUtils.swap(arr1, 0, 3)
        @Expect(arr1[0], 4)
        @Expect(arr1[3], 1)
        @Expect(arr1[1], 2)

        // 交换中间
        var arr2 = [1, 2, 3, 4, 5]
        ArrayUtils.swap(arr2, 1, 3)
        @Expect(arr2[1], 4)
        @Expect(arr2[3], 2)

        // 交换相同位置
        var arr3 = [1, 2, 3]
        ArrayUtils.swap(arr3, 1, 1)
        @Expect(arr3[1], 2)
    }

    // ========== Phase 5: 转换操作测试 ==========

    @TestCase
    func testToString() {
        // 空数组
        @Expect(ArrayUtils.toString(Array<Int64>()), "{}")

        // 单元素
        @Expect(ArrayUtils.toString([1]), "{1}")
        @Expect(ArrayUtils.toString(["a"]), "{a}")

        // 多元素
        @Expect(ArrayUtils.toString([1, 2, 3]), "{1, 2, 3}")

        // 字符串数组
        @Expect(ArrayUtils.toString(["a", "b", "c"]), "{a, b, c}")

        // 注意：浮点数 toString 可能有精度差异，不测试
    }

    // ========== Phase 6: 子数组操作测试 ==========

    @TestCase
    func testSubarray() {
        // 基本截取
        let arr1 = [1, 2, 3, 4, 5]
        let sub1 = ArrayUtils.subarray(arr1, 1, 4)
        @Expect(sub1.size, 3)
        @Expect(sub1[0], 2)
        @Expect(sub1[2], 4)

        // 从开头截取
        let sub2 = ArrayUtils.subarray(arr1, 0, 3)
        @Expect(sub2.size, 3)
        @Expect(sub2[0], 1)

        // 到末尾截取
        let sub3 = ArrayUtils.subarray(arr1, 2, 5)
        @Expect(sub3.size, 3)
        @Expect(sub3[2], 5)

        // 单元素
        let sub4 = ArrayUtils.subarray(arr1, 2, 3)
        @Expect(sub4.size, 1)
        @Expect(sub4[0], 3)
    }

    // ========== Phase 7: 比较操作测试 ==========

    @TestCase
    func testIsSameLength() {
        // 长度相同
        @Expect(ArrayUtils.isSameLength([1, 2, 3], [4, 5, 6]), true)
        @Expect(ArrayUtils.isSameLength(Array<Int64>(), Array<Int64>()), true)
        @Expect(ArrayUtils.isSameLength([1], [2]), true)

        // 长度不同
        @Expect(ArrayUtils.isSameLength([1, 2, 3], [1, 2]), false)
        @Expect(ArrayUtils.isSameLength([1, 2], [1, 2, 3]), false)
        @Expect(ArrayUtils.isSameLength(Array<Int64>(), [1]), false)

        // 不同类型但长度相同 - 使用类型注解
        @Expect(ArrayUtils.isSameLength<Int64>([1, 2, 3], [4, 5, 6]), true)
    }

    @TestCase
    func testIsSorted() {
        // 已排序
        @Expect(ArrayUtils.isSorted([1, 2, 3, 4, 5]), true)
        @Expect(ArrayUtils.isSorted([1]), true)
        @Expect(ArrayUtils.isSorted(Array<Int64>()), true)

        // 未排序
        @Expect(ArrayUtils.isSorted([1, 3, 2, 4]), false)
        @Expect(ArrayUtils.isSorted([5, 4, 3, 2, 1]), false)
        @Expect(ArrayUtils.isSorted([1, 2, 3, 2, 4]), false)

        // 有重复元素但已排序
        @Expect(ArrayUtils.isSorted([1, 2, 2, 3, 3]), true)

        // 字符串排序
        @Expect(ArrayUtils.isSorted(["a", "b", "c"]), true)
        @Expect(ArrayUtils.isSorted(["a", "c", "b"]), false)
    }

    // ========== Phase 8: 合并操作测试 ==========

    @TestCase
    func testAddAll() {
        // 基本合并
        let arr1 = [1, 2, 3]
        let arr2 = [4, 5, 6]
        let result1 = ArrayUtils.addAll(arr1, arr2)
        @Expect(result1.size, 6)
        @Expect(result1[0], 1)
        @Expect(result1[3], 4)
        @Expect(result1[5], 6)

        // 空数组
        let arr3: Array<Int64> = []
        let arr4 = [1, 2]
        let result2 = ArrayUtils.addAll(arr3, arr4)
        @Expect(result2.size, 2)

        // 两个空数组
        let arr5: Array<Int64> = []
        let arr6: Array<Int64> = []
        let result3 = ArrayUtils.addAll(arr5, arr6)
        @Expect(result3.size, 0)

        // 字符串数组
        let arr7 = ["a", "b"]
        let arr8 = ["c", "d"]
        let result4 = ArrayUtils.addAll(arr7, arr8)
        @Expect(result4.size, 4)
        @Expect(result4[1], "b")
        @Expect(result4[2], "c")
    }

    // ========== Phase 9: 克隆操作测试 ==========

    @TestCase
    func testClone() {
        // 基本克隆
        let arr1 = [1, 2, 3]
        let cloned1 = ArrayUtils.clone(arr1)
        @Expect(cloned1.size, 3)
        @Expect(cloned1[0], 1)
        @Expect(cloned1[2], 3)

        // 空数组
        let arr2: Array<Int64> = []
        let cloned2 = ArrayUtils.clone(arr2)
        @Expect(cloned2.size, 0)

        // 单元素
        let arr3 = [1]
        let cloned3 = ArrayUtils.clone(arr3)
        @Expect(cloned3.size, 1)
        @Expect(cloned3[0], 1)

        // 字符串数组
        let arr4 = ["a", "b", "c"]
        let cloned4 = ArrayUtils.clone(arr4)
        @Expect(cloned4.size, 3)
        @Expect(cloned4[1], "b")
    }

    // ========== Phase 10: 填充操作测试 ==========

    @TestCase
    func testFill() {
        // 填充整个数组
        var arr1 = [1, 2, 3, 4, 5]
        ArrayUtils.fill(arr1, 0)
        @Expect(arr1[0], 0)
        @Expect(arr1[2], 0)
        @Expect(arr1[4], 0)

        // 填充字符串数组
        var arr2 = ["a", "b", "c"]
        ArrayUtils.fill(arr2, "x")
        @Expect(arr2[0], "x")
        @Expect(arr2[2], "x")
    }

    @TestCase
    func testFillWithRange() {
        // 填充中间范围
        var arr1 = [1, 2, 3, 4, 5]
        ArrayUtils.fill(arr1, 0, 1, 4)
        @Expect(arr1[0], 1)
        @Expect(arr1[1], 0)
        @Expect(arr1[3], 0)
        @Expect(arr1[4], 5)

        // 填充开头
        var arr2 = [1, 2, 3, 4, 5]
        ArrayUtils.fill(arr2, 0, 0, 2)
        @Expect(arr2[0], 0)
        @Expect(arr2[1], 0)
        @Expect(arr2[2], 3)

        // 填充末尾
        var arr3 = [1, 2, 3, 4, 5]
        ArrayUtils.fill(arr3, 0, 3, 5)
        @Expect(arr3[2], 3)
        @Expect(arr3[3], 0)
        @Expect(arr3[4], 0)

        // 填充单个元素
        var arr4 = [1, 2, 3]
        ArrayUtils.fill(arr4, 0, 1, 2)
        @Expect(arr4[0], 1)
        @Expect(arr4[1], 0)
        @Expect(arr4[2], 3)
    }

    // ========== 常量测试 ==========

    @TestCase
    func testConstants() {
        @Expect(ArrayUtils.INDEX_NOT_FOUND, -1)
    }
}
