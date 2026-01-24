package commons_lang4cj.utils

/**
 * ArrayUtils 数组操作工具类
 *
 * 仓颉版本的 Apache Commons Lang ArrayUtils 工具类
 * 提供数组操作的静态方法集合
 *
 * 注意：仓颉的 Array<T> 是长度不变的集合类型，因此所有修改操作（add、remove等）
 * 都会返回新的 Array，而不是在原数组上修改
 *
 * 功能包括：
 * - 空值与长度检查（IsEmpty/IsNotEmpty/GetLength）
 * - 查询操作（IndexOf/Contains/LastIndexOf）
 * - 修改操作（Add/Remove/RemoveElement）
 * - 反转与排序（Reverse/Swap）
 * - 转换操作（ToString）
 * - 子数组操作（Subarray）
 * - 比较操作（IsSameLength/IsSorted）
 * - 合并操作（AddAll）
 * - 克隆操作（Clone）
 * - 填充操作（Fill）
 *
 * @since 1.0.0
 */
public class ArrayUtils {
    /**
     * 索引未找到常量
     */
    public static const INDEX_NOT_FOUND: Int64 = -1

    // ========== Phase 1: 空值与长度检查 ==========

    /**
     * 检查数组是否为空
     *
     * 空数组定义为：长度为 0 的数组
     *
     * @param array 待检查的数组
     * @return 如果数组为空返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let arr1: Array<Int64> = []
     * let arr2 = [1, 2, 3]
     * ArrayUtils.isEmpty(arr1)  // true
     * ArrayUtils.isEmpty(arr2)  // false
     * ```
     */
    public static func isEmpty<T>(array: Array<T>): Bool {
        array.size == 0
    }

    /**
     * 检查数组是否不为空
     *
     * @param array 待检查的数组
     * @return 如果数组不为空返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let arr1: Array<Int64> = []
     * let arr2 = [1, 2, 3]
     * ArrayUtils.isNotEmpty(arr1)  // false
     * ArrayUtils.isNotEmpty(arr2)  // true
     * ```
     */
    public static func isNotEmpty<T>(array: Array<T>): Bool {
        !isEmpty(array)
    }

    /**
     * 获取数组长度
     *
     * @param array 待获取长度的数组
     * @return 数组长度
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 4, 5]
     * ArrayUtils.getLength(arr)  // 5
     * ```
     */
    public static func getLength<T>(array: Array<T>): Int64 {
        array.size
    }

    // ========== Phase 2: 查询操作 ==========

    /**
     * 查找元素在数组中首次出现的位置
     *
     * @param array 待查找的数组
     * @param valueToFind 要查找的值
     * @return 元素首次出现的索引，未找到返回 INDEX_NOT_FOUND (-1)
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 2, 1]
     * ArrayUtils.indexOf(arr, 2)  // 1
     * ArrayUtils.indexOf(arr, 5)  // -1
     * ```
     */
    public static func indexOf<T>(array: Array<T>, valueToFind: T): Int64
        where T <: Equatable<T> {
        for (i in 0..array.size) {
            if (array[i] == valueToFind) {
                return i
            }
        }
        return INDEX_NOT_FOUND
    }

    /**
     * 从指定位置开始查找元素在数组中首次出现的位置
     *
     * @param array 待查找的数组
     * @param valueToFind 要查找的值
     * @param startIndex 开始查找的位置
     * @return 元素首次出现的索引，未找到返回 INDEX_NOT_FOUND (-1)
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 2, 1]
     * ArrayUtils.indexOf(arr, 2, 2)  // 3
     * ArrayUtils.indexOf(arr, 1, 2)  // 4
     * ```
     */
    public static func indexOf<T>(array: Array<T>, valueToFind: T, startIndex: Int64): Int64
        where T <: Equatable<T> {
        if (startIndex < 0 || startIndex >= array.size) {
            return INDEX_NOT_FOUND
        }
        for (i in startIndex..array.size) {
            if (array[i] == valueToFind) {
                return i
            }
        }
        return INDEX_NOT_FOUND
    }

    /**
     * 检查数组是否包含指定元素
     *
     * @param array 待检查的数组
     * @param valueToFind 要查找的值
     * @return 如果包含返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 4, 5]
     * ArrayUtils.contains(arr, 3)  // true
     * ArrayUtils.contains(arr, 6)  // false
     * ```
     */
    public static func contains<T>(array: Array<T>, valueToFind: T): Bool
        where T <: Equatable<T> {
        indexOf(array, valueToFind) != INDEX_NOT_FOUND
    }

    /**
     * 查找元素在数组中最后出现的位置
     *
     * @param array 待查找的数组
     * @param valueToFind 要查找的值
     * @return 元素最后出现的索引，未找到返回 INDEX_NOT_FOUND (-1)
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 2, 1]
     * ArrayUtils.lastIndexOf(arr, 2)  // 3
     * ArrayUtils.lastIndexOf(arr, 1)  // 4
     * ArrayUtils.lastIndexOf(arr, 5)  // -1
     * ```
     */
    public static func lastIndexOf<T>(array: Array<T>, valueToFind: T): Int64
        where T <: Equatable<T> {
        var i = array.size - 1
        while (i >= 0) {
            if (array[i] == valueToFind) {
                return i
            }
            i--
        }
        return INDEX_NOT_FOUND
    }

    // ========== Phase 3: 修改操作 ==========

    /**
     * 在数组末尾添加元素，返回新数组
     *
     * @param array 原数组
     * @param element 要添加的元素
     * @return 包含新元素的新数组
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3]
     * let newArr = ArrayUtils.add(arr, 4)  // [1, 2, 3, 4]
     * ```
     */
    public static func add<T>(array: Array<T>, element: T): Array<T> {
        let newArr = Array<T>(array.size + 1, { i =>
            if (i < array.size) {
                array[i]
            } else {
                element
            }
        })
        return newArr
    }

    /**
     * 在指定位置插入元素，返回新数组
     *
     * @param array 原数组
     * @param index 插入位置
     * @param element 要插入的元素
     * @return 包含新元素的新数组
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 4]
     * let newArr = ArrayUtils.add(arr, 2, 3)  // [1, 2, 3, 4]
     * ```
     */
    public static func add<T>(array: Array<T>, index: Int64, element: T): Array<T> {
        if (index < 0 || index > array.size) {
            throw IndexOutOfBoundsException("Index: ${index}, Size: ${array.size}")
        }
        let newArr = Array<T>(array.size + 1, { i =>
            if (i < index) {
                array[i]
            } else if (i == index) {
                element
            } else {
                array[i - 1]
            }
        })
        return newArr
    }

    /**
     * 删除指定位置的元素，返回新数组
     *
     * @param array 原数组
     * @param index 要删除的元素位置
     * @return 删除元素后的新数组
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 4]
     * let newArr = ArrayUtils.remove(arr, 2)  // [1, 2, 4]
     * ```
     */
    public static func remove<T>(array: Array<T>, index: Int64): Array<T> {
        if (index < 0 || index >= array.size) {
            throw IndexOutOfBoundsException("Index: ${index}, Size: ${array.size}")
        }
        let newSize = array.size - 1
        let newArr = Array<T>(newSize, { i =>
            if (i < index) {
                array[i]
            } else {
                array[i + 1]
            }
        })
        return newArr
    }

    /**
     * 删除数组中指定的元素（首次出现的），返回新数组
     *
     * @param array 原数组
     * @param element 要删除的元素
     * @return 删除元素后的新数组，如果未找到返回原数组
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 2, 1]
     * let newArr = ArrayUtils.removeElement(arr, 2)  // [1, 3, 2, 1]
     * ```
     */
    public static func removeElement<T>(array: Array<T>, element: T): Array<T>
        where T <: Equatable<T> {
        let index = indexOf(array, element)
        if (index == INDEX_NOT_FOUND) {
            return array
        }
        return remove(array, index)
    }

    // ========== Phase 4: 反转与排序 ==========

    /**
     * 反转数组，返回新数组
     *
     * @param array 原数组
     * @return 反转后的新数组
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 4, 5]
     * let reversed = ArrayUtils.reverse(arr)  // [5, 4, 3, 2, 1]
     * ```
     */
    public static func reverse<T>(array: Array<T>): Array<T> {
        let newArr = Array<T>(array.size, { i => array[array.size - 1 - i] })
        return newArr
    }

    /**
     * 交换数组中两个指定位置的元素
     *
     * 注意：此方法会直接修改原数组
     *
     * @param array 要交换的数组
     * @param index1 第一个元素的位置
     * @param index2 第二个元素的位置
     *
     * 示例：
     * ```cangjie
     * var arr = [1, 2, 3, 4]
     * ArrayUtils.swap(arr, 0, 3)  // arr 变为 [4, 2, 3, 1]
     * ```
     */
    public static func swap<T>(array: Array<T>, index1: Int64, index2: Int64): Unit {
        if (index1 < 0 || index1 >= array.size) {
            throw IndexOutOfBoundsException("Index1: ${index1}, Size: ${array.size}")
        }
        if (index2 < 0 || index2 >= array.size) {
            throw IndexOutOfBoundsException("Index2: ${index2}, Size: ${array.size}")
        }
        let temp = array[index1]
        array[index1] = array[index2]
        array[index2] = temp
    }

    // ========== Phase 5: 转换操作 ==========

    /**
     * 将数组转换为字符串表示
     *
     * 格式：{element1, element2, element3}
     *
     * @param array 要转换的数组
     * @return 字符串表示
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3]
     * ArrayUtils.toString(arr)  // "{1, 2, 3}"
     * ```
     */
    public static func toString<T>(array: Array<T>): String where T <: ToString {
        if (isEmpty(array)) {
            return "{}"
        }
        var result = "{"
        for (i in 0..array.size) {
            if (i > 0) {
                result += ", "
            }
            result += array[i].toString()
        }
        result += "}"
        return result
    }

    // ========== Phase 6: 子数组操作 ==========

    /**
     * 获取子数组
     *
     * @param array 原数组
     * @param startIndex 起始索引（包含）
     * @param endIndex 结束索引（不包含）
     * @return 子数组
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3, 4, 5]
     * let sub = ArrayUtils.subarray(arr, 1, 4)  // [2, 3, 4]
     * ```
     */
    public static func subarray<T>(array: Array<T>, startIndex: Int64, endIndex: Int64): Array<T> {
        if (startIndex < 0) {
            throw IndexOutOfBoundsException("StartIndex: ${startIndex}")
        }
        if (endIndex > array.size) {
            throw IndexOutOfBoundsException("EndIndex: ${endIndex}, Size: ${array.size}")
        }
        if (startIndex > endIndex) {
            throw IndexOutOfBoundsException("StartIndex: ${startIndex} > EndIndex: ${endIndex}")
        }
        return array[startIndex..endIndex]
    }

    // ========== Phase 7: 比较操作 ==========

    /**
     * 检查两个数组长度是否相同
     *
     * @param array1 第一个数组
     * @param array2 第二个数组
     * @return 如果长度相同返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let arr1 = [1, 2, 3]
     * let arr2 = [4, 5, 6]
     * let arr3 = [1, 2]
     * ArrayUtils.isSameLength(arr1, arr2)  // true
     * ArrayUtils.isSameLength(arr1, arr3)  // false
     * ```
     */
    public static func isSameLength<T>(array1: Array<T>, array2: Array<T>): Bool {
        array1.size == array2.size
    }

    /**
     * 检查数组是否已排序（升序）
     *
     * @param array 待检查的数组
     * @return 如果已排序返回 true，否则返回 false
     *
     * 示例：
     * ```cangjie
     * let arr1 = [1, 2, 3, 4, 5]
     * let arr2 = [1, 3, 2, 4]
     * ArrayUtils.isSorted(arr1)  // true
     * ArrayUtils.isSorted(arr2)  // false
     * ```
     */
    public static func isSorted<T>(array: Array<T>): Bool where T <: Comparable<T> {
        if (array.size <= 1) {
            return true
        }
        for (i in 0..(array.size - 1)) {
            if (array[i + 1] < array[i]) {
                return false
            }
        }
        return true
    }

    // ========== Phase 8: 合并操作 ==========

    /**
     * 合并两个数组
     *
     * @param array1 第一个数组
     * @param array2 第二个数组
     * @return 合并后的新数组
     *
     * 示例：
     * ```cangjie
     * let arr1 = [1, 2, 3]
     * let arr2 = [4, 5, 6]
     * let merged = ArrayUtils.addAll(arr1, arr2)  // [1, 2, 3, 4, 5, 6]
     * ```
     */
    public static func addAll<T>(array1: Array<T>, array2: Array<T>): Array<T> {
        let totalSize = array1.size + array2.size
        let newArr = Array<T>(totalSize, { i =>
            if (i < array1.size) {
                array1[i]
            } else {
                array2[i - array1.size]
            }
        })
        return newArr
    }

    // ========== Phase 9: 克隆操作 ==========

    /**
     * 克隆数组
     *
     * 创建数组的浅拷贝
     *
     * @param array 原数组
     * @return 数组的副本
     *
     * 示例：
     * ```cangjie
     * let arr = [1, 2, 3]
     * let cloned = ArrayUtils.clone(arr)  // [1, 2, 3]
     * ```
     */
    public static func clone<T>(array: Array<T>): Array<T> {
        let newArr = Array<T>(array.size, { i => array[i] })
        return newArr
    }

    // ========== Phase 10: 填充操作 ==========

    /**
     * 用指定值填充整个数组
     *
     * 注意：此方法会直接修改原数组
     *
     * @param array 要填充的数组
     * @param value 填充值
     *
     * 示例：
     * ```cangjie
     * var arr = [1, 2, 3, 4, 5]
     * ArrayUtils.fill(arr, 0)  // arr 变为 [0, 0, 0, 0, 0]
     * ```
     */
    public static func fill<T>(array: Array<T>, value: T): Unit {
        for (i in 0..array.size) {
            array[i] = value
        }
    }

    /**
     * 用指定值填充数组的指定范围
     *
     * 注意：此方法会直接修改原数组
     *
     * @param array 要填充的数组
     * @param value 填充值
     * @param startIndex 起始索引（包含）
     * @param endIndex 结束索引（不包含）
     *
     * 示例：
     * ```cangjie
     * var arr = [1, 2, 3, 4, 5]
     * ArrayUtils.fill(arr, 0, 1, 4)  // arr 变为 [1, 0, 0, 0, 5]
     * ```
     */
    public static func fill<T>(array: Array<T>, value: T, startIndex: Int64, endIndex: Int64): Unit {
        if (startIndex < 0 || startIndex >= array.size) {
            throw IndexOutOfBoundsException("StartIndex: ${startIndex}, Size: ${array.size}")
        }
        if (endIndex > array.size) {
            throw IndexOutOfBoundsException("EndIndex: ${endIndex}, Size: ${array.size}")
        }
        if (startIndex > endIndex) {
            throw IndexOutOfBoundsException("StartIndex: ${startIndex} > EndIndex: ${endIndex}")
        }
        for (i in startIndex..endIndex) {
            array[i] = value
        }
    }
}
