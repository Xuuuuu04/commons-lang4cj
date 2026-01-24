package commons_lang4cj.text.similarity

import std.math.*

/**
 * LevenshteinDistance 编辑距离算法
 *
 * 计算两个字符串之间的编辑距离（Levenshtein distance）。
 * 编辑距离是指将一个字符串转换成另一个字符串所需的最少编辑操作次数（插入、删除或替换）。
 *
 * @since 1.0.0
 */
public class LevenshteinDistance {

    /**
     * 默认实例
     */
    private static let DEFAULT_INSTANCE = LevenshteinDistance()

    /**
     * 获取默认实例
     */
    public static func getDefaultInstance(): LevenshteinDistance {
        return DEFAULT_INSTANCE
    }

    /**
     * 计算两个字符串的编辑距离
     *
     * @param left 左字符串
     * @param right 右字符串
     * @return 编辑距离，如果任意参数为 null 则抛出异常（但在 Cangjie 中 String 不为 null，为空字符串时返回长度差）
     */
    public func apply(left: String, right: String): Int64 {
        return apply(left, right, Int64.Max)
    }

    /**
     * 计算两个字符串的编辑距离，带有阈值
     *
     * @param left 左字符串
     * @param right 右字符串
     * @param threshold 阈值，超过此值返回 -1
     * @return 编辑距离，如果超过阈值返回 -1
     */
    public func apply(left: String, right: String, threshold: Int64): Int64 {
        let n = left.size
        let m = right.size

        // 如果有一个字符串为空，直接返回另一个字符串的长度
        if (n == 0) {
            return if (m <= threshold) { m } else { -1 }
        }
        if (m == 0) {
            return if (n <= threshold) { n } else { -1 }
        }

        // 如果长度差超过阈值，直接返回 -1
        if (abs(n - m) > threshold) {
            return -1
        }

        // 优化：确保 left 是较短的字符串，减少空间复杂度
        var s = left
        var t = right
        var n_ = n
        var m_ = m

        if (n_ > m_) {
            // 交换
            let tmpStr = s
            s = t
            t = tmpStr
            let tmpLen = n_
            n_ = m_
            m_ = tmpLen
        }

        // p 存储上一行的距离值，d 存储当前行的距离值
        // 只需两行即可（或者一行数组 + 临时变量）
        // 这里使用两行数组实现，易于理解
        // p[i] 对应 distance(s[0..i], t[0..j-1])
        // d[i] 对应 distance(s[0..i], t[0..j])

        // 初始化 p，p[i] = i
        var p = Array<Int64>(n_ + 1, { i => i })
        var d = Array<Int64>(n_ + 1, repeat: 0)

        // 遍历 t 的每个字符
        for (j in 1..=m_) {
            let t_j = t[j - 1] // t 的第 j 个字符 (索引 j-1)
            d[0] = j

            var minInRow = j // 这一行的最小值

            // 遍历 s 的每个字符
            for (i in 1..=n_) {
                let s_i = s[i - 1] // s 的第 i 个字符

                var cost = 0
                if (s_i != t_j) {
                    cost = 1
                }

                // d[i] = min(d[i-1] + 1, p[i] + 1, p[i-1] + cost)
                // 插入、删除、替换

                let insert = d[i - 1] + 1
                let delete = p[i] + 1
                let substitute = p[i - 1] + cost

                d[i] = min(min(insert, delete), substitute)

                if (d[i] < minInRow) {
                    minInRow = d[i]
                }
            }

            // 如果这一行的最小值都超过了阈值，那么最终结果肯定也超过阈值
            if (minInRow > threshold) {
                return -1
            }

            // 交换 p 和 d (或者是拷贝 d 到 p)
            // Cangjie 中数组是引用类型，交换引用即可?
            // 但是 d 在下一轮循环开始时需要重用，所以拷贝比较安全，或者交换引用并重新初始化 d[0]
            // 这里为了简单，直接拷贝内容或者交换引用
            let temp = p
            p = d
            d = temp
        }

        // 循环结束后，p 存储的是最后一行的数据
        let result = p[n_]
        if (result <= threshold) {
            return result
        } else {
            return -1
        }
    }
}
