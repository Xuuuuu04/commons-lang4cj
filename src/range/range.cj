package commons_lang4cj.range

/**
 * 不可变范围类，表示从最小值到最大值的闭区间 [minimum, maximum]
 *
 * 类型参数 T 必须实现 Comparable<T>、Hashable 和 ToString 接口
 *
 * @param T 范围元素的类型，必须实现 Comparable<T>、Hashable 和 ToString
 * @since 1.0.0
 */
public open class Range<T> where T <: Comparable<T> & Hashable & ToString {
    private let _minimum: T
    private let _maximum: T
    private var _hashCode: Int64 = 0

    private init(min: T, max: T) {
        let ordering = min.compare(max)
        if (ordering == Ordering.LT || ordering == Ordering.EQ) {
            _minimum = min
            _maximum = max
        } else {
            _minimum = max
            _maximum = min
        }
    }

    /**
     * 获取范围的最小值
     *
     * @return 范围的最小值
     * @since 1.0.0
     */
    public func getMinimum(): T {
        _minimum
    }

    /**
     * 获取范围的最大值
     *
     * @return 范围的最大值
     * @since 1.0.0
     */
    public func getMaximum(): T {
        _maximum
    }

    /**
     * 检查元素是否在范围内 [minimum, maximum]
     *
     * @param element 要检查的元素
     * @return 如果元素在范围内返回 true，否则返回 false
     * @since 1.0.0
     */
    public func contains(element: T): Bool {
        compare(element, _minimum) >= 0 && compare(element, _maximum) <= 0
    }

    /**
     * 检查当前范围是否完全包含另一个范围
     *
     * @param otherRange 要检查的范围
     * @return 如果当前范围完全包含另一个范围返回 true，否则返回 false
     * @since 1.0.0
     */
    public func containsRange(otherRange: Range<T>): Bool {
        compare(otherRange._minimum, _minimum) >= 0 && compare(otherRange._maximum, _maximum) <= 0
    }

    /**
     * 检查元素是否在范围之前（小于最小值）
     *
     * @param element 要检查的元素
     * @return 如果元素在范围之前返回 true，否则返回 false
     * @since 1.0.0
     */
    public func isBefore(element: T): Bool {
        compare(_maximum, element) < 0
    }

    /**
     * 检查元素是否在范围之后（大于最大值）
     *
     * @param element 要检查的元素
     * @return 如果元素在范围之后返回 true，否则返回 false
     * @since 1.0.0
     */
    public func isAfter(element: T): Bool {
        compare(_minimum, element) > 0
    }

    /**
     * 检查范围是否以指定元素开始
     *
     * @param element 要检查的元素
     * @return 如果范围以该元素开始返回 true，否则返回 false
     * @since 1.0.0
     */
    public func isStartedBy(element: T): Bool {
        compare(_minimum, element) == 0
    }

    /**
     * 检查范围是否以指定元素结束
     *
     * @param element 要检查的元素
     * @return 如果范围以该元素结束返回 true，否则返回 false
     * @since 1.0.0
     */
    public func isEndedBy(element: T): Bool {
        compare(_maximum, element) == 0
    }

    /**
     * 计算当前范围与另一个范围的交集
     *
     * 如果两个范围没有交集，返回 None
     *
     * @param other 另一个范围
     * @return 交集的 Option，如果没有交集返回 None
     * @since 1.0.0
     */
    public func intersectionWith(other: Range<T>): Option<Range<T>> {
        if (compare(_minimum, other._maximum) > 0 || compare(_maximum, other._minimum) < 0) {
            return None
        }

        let min = if (compare(_minimum, other._minimum) > 0) { _minimum } else { other._minimum }
        let max = if (compare(_maximum, other._maximum) < 0) { _maximum } else { other._maximum }

        return Some(Range(min, max))
    }

    /**
     * 计算当前范围与另一个范围的并集（跨度）
     *
     * 并集是从两个范围的最小值到最大值的范围
     *
     * @param other 另一个范围
     * @return 并集范围
     * @since 1.0.0
     */
    public func spanWith(other: Range<T>): Range<T> {
        let min = if (compare(_minimum, other._minimum) < 0) { _minimum } else { other._minimum }
        let max = if (compare(_maximum, other._maximum) > 0) { _maximum } else { other._maximum }

        Range(min, max)
    }

    /**
     * 检查当前范围是否与另一个范围重叠
     *
     * @param other 另一个范围
     * @return 如果两个范围重叠返回 true，否则返回 false
     * @since 1.0.0
     */
    public func isOverlappedBy(other: Range<T>): Bool {
        !(compare(_minimum, other._maximum) > 0 || compare(_maximum, other._minimum) < 0)
    }

    /**
     * 检查当前范围是否完全在另一个范围内
     *
     * @param other 另一个范围
     * @return 如果当前范围完全在另一个范围内返回 true，否则返回 false
     * @since 1.0.0
     */
    public func fitsWithin(other: Range<T>): Bool {
        compare(_minimum, other._minimum) >= 0 && compare(_maximum, other._maximum) <= 0
    }

    /**
     * 将元素适配到范围内
     *
     * 如果元素小于最小值，返回最小值
     * 如果元素大于最大值，返回最大值
     * 否则返回元素本身
     *
     * @param element 要适配的元素
     * @return 适配后的元素
     * @since 1.0.0
     */
    public func fit(element: T): T {
        if (compare(element, _minimum) < 0) {
            _minimum
        } else if (compare(element, _maximum) > 0) {
            _maximum
        } else {
            element
        }
    }

    /**
     * 比较两个范围
     *
     * 比较规则：
     * 1. 先比较最小值，较小的范围更小
     * 2. 如果最小值相同，比较最大值，较小的范围更小
     *
     * @param other 另一个范围
     * @return -1 表示当前范围更小，0 表示相等，1 表示当前范围更大
     * @since 1.0.0
     */
    public func compareTo(other: Range<T>): Int64 {
        let result = compare(_minimum, other._minimum)
        if (result != 0) {
            return result
        }
        compare(_maximum, other._maximum)
    }

    /**
     * 比较元素与范围的关系
     *
     * 返回值：
     * - 小于 0：元素在范围之前（小于最小值）
     * - 等于 0：元素在范围内
     * - 大于 0：元素在范围之后（大于最大值）
     *
     * @param element 要比较的元素
     * @return 比较结果
     * @since 1.0.0
     */
    public func elementCompareTo(element: T): Int64 {
        if (compare(element, _minimum) < 0) {
            compare(element, _minimum)
        } else if (compare(element, _maximum) > 0) {
            compare(element, _maximum)
        } else {
            0
        }
    }

    /**
     * 判断两个范围是否相等
     *
     * 两个范围相等当且仅当它们的最小值和最大值都相等
     *
     * @param other 要比较的对象
     * @return 如果相等返回 true，否则返回 false
     * @since 1.0.0
     */
    public func equals(other: Object): Bool {
        match (other) {
            case r: Range<T> => compare(_minimum, r._minimum) == 0 && compare(_maximum, r._maximum) == 0
            case _ => false
        }
    }

    /**
     * 计算范围的哈希码
     *
     * @return 哈希码
     * @since 1.0.0
     */
    public func hashCode(): Int64 {
        if (_hashCode == 0) {
            _hashCode = hashCombine(_minimum.hashCode(), _maximum.hashCode())
        }
        _hashCode
    }

    /**
     * 返回范围的字符串表示
     *
     * 格式：[minimum, maximum]
     * 对于浮点数，会自动去除尾随零
     *
     * @return 字符串表示
     * @since 1.0.0
     */
    public func toString(): String {
        let minStr = removeTrailingZeros(_minimum.toString())
        let maxStr = removeTrailingZeros(_maximum.toString())
        "[${minStr}, ${maxStr}]"
    }

    /**
     * 去除浮点数字符串的尾随零
     *
     * @param s 原始字符串
     * @return 去除尾随零后的字符串
     */
    private func removeTrailingZeros(s: String): String {
        if (s.contains(".")) {
            var endIdx = s.size
            // 从后往前找,去除尾随的0
            while (endIdx > 0 && s.size > endIdx - 1) {
                let charCode = if (endIdx > 0) { s[endIdx - 1] } else { 0u8 }
                if (charCode != 0u8 && charCode == 48u8) { // 48 是 '0' 的 ASCII 码
                    endIdx--
                } else {
                    break
                }
            }
            // 如果最后是小数点,也去除
            if (endIdx > 0 && s.size > endIdx - 1) {
                let charCode = s[endIdx - 1]
                if (charCode == 46u8) { // 46 是 '.' 的 ASCII 码
                    endIdx--
                }
            }
            s[0..endIdx]
        } else {
            s
        }
    }

    /**
     * 比较两个元素
     *
     * @param a 第一个元素
     * @param b 第二个元素
     * @return -1 表示 a < b，0 表示 a == b，1 表示 a > b
     */
    private func compare(a: T, b: T): Int64 {
        match (a.compare(b)) {
            case Ordering.LT => -1
            case Ordering.EQ => 0
            case Ordering.GT => 1
        }
    }

    /**
     * 组合两个哈希值
     *
     * 使用简化的哈希组合算法，不依赖 rotateLeft/rotateRight
     *
     * @param h1 第一个哈希值
     * @param h2 第二个哈希值
     * @return 组合后的哈希值
     */
    private func hashCombine(h1: Int64, h2: Int64): Int64 {
        // 简化的哈希组合：使用乘法和异或
        // 31 是一个常用的质数乘数（类似 Java 的 String.hashCode）
        h1 * 31 + h2
    }

    /**
     * 创建范围
     *
     * 如果 from > to，会自动交换两个值
     *
     * @param from 起始值
     * @param to 结束值
     * @return 新的范围
     * @since 1.0.0
     */
    public static func of(from: T, to: T): Range<T> {
        Range(from, to)
    }

    /**
     * 创建单元素范围
     *
     * 单元素范围的最小值和最大值都是指定的元素
     *
     * @param element 元素
     * @return 新的范围
     * @since 1.0.0
     */
    public static func isSingle(element: T): Range<T> {
        Range(element, element)
    }
}
