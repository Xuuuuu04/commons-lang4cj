package commons_lang4cj.tuple

import commons_lang4cj.builder.*

/**
 * Pair 相等性比较工具函数
 *
 * 类型参数:
 * @param L 左元素的类型（必须实现 Equatable）
 * @param R 右元素的类型（必须实现 Equatable）
 *
 * @param p1 第一个 Pair
 * @param p2 第二个 Pair
 * @return 如果两个 Pair 相等返回 true，否则返回 false
 */
public func pairEquals<L, R>(p1: Pair<L, R>, p2: Pair<L, R>): Bool
    where L <: Equatable<L>, R <: Equatable<R> {
    p1.left == p2.left && p1.right == p2.right
}

/**
 * Pair 哈希码计算工具函数
 *
 * 类型参数:
 * @param L 左元素的类型（必须实现 Hashable）
 * @param R 右元素的类型（必须实现 Hashable）
 *
 * @param pair 要计算的 Pair
 * @return 哈希码值
 */
public func pairHashCode<L, R>(pair: Pair<L, R>): Int64
    where L <: Hashable, R <: Hashable {
    HashCodeBuilder(17, 37)
        .append(pair.left)
        .append(pair.right)
        .toHashCode()
}

/**
 * Triple 相等性比较工具函数
 *
 * 类型参数:
 * @param L 左元素的类型（必须实现 Equatable）
 * @param M 中间元素的类型（必须实现 Equatable）
 * @param R 右元素的类型（必须实现 Equatable）
 *
 * @param t1 第一个 Triple
 * @param t2 第二个 Triple
 * @return 如果两个 Triple 相等返回 true，否则返回 false
 */
public func tripleEquals<L, M, R>(t1: Triple<L, M, R>, t2: Triple<L, M, R>): Bool
    where L <: Equatable<L>, M <: Equatable<M>, R <: Equatable<R> {
    t1.left == t2.left && t1.middle == t2.middle && t1.right == t2.right
}

/**
 * Triple 哈希码计算工具函数
 *
 * 类型参数:
 * @param L 左元素的类型（必须实现 Hashable）
 * @param M 中间元素的类型（必须实现 Hashable）
 * @param R 右元素的类型（必须实现 Hashable）
 *
 * @param triple 要计算的 Triple
 * @return 哈希码值
 */
public func tripleHashCode<L, M, R>(triple: Triple<L, M, R>): Int64
    where L <: Hashable, M <: Hashable, R <: Hashable {
    HashCodeBuilder(17, 37)
        .append(triple.left)
        .append(triple.middle)
        .append(triple.right)
        .toHashCode()
}
