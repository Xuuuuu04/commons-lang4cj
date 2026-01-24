package commons_lang4cj.tuple

/**
 * Triple<L,M,R> - 包含三个元素的元组
 *
 * 类型参数:
 * @param L 左元素的类型
 * @param M 中间元素的类型
 * @param R 右元素的类型
 *
 * 注意: 此结构体是不可变的，所有方法都返回新实例
 */
public struct Triple<L, M, R> {
    /**
     * 左元素
     */
    public let left: L

    /**
     * 中间元素
     */
    public let middle: M

    /**
     * 右元素
     */
    public let right: R

    /**
     * 公开构造函数
     * @param left 左元素
     * @param middle 中间元素
     * @param right 右元素
     */
    public init(left: L, middle: M, right: R) {
        this.left = left
        this.middle = middle
        this.right = right
    }

    /**
     * 获取左元素
     * @return 左元素
     */
    public func getLeft(): L {
        left
    }

    /**
     * 获取中间元素
     * @return 中间元素
     */
    public func getMiddle(): M {
        middle
    }

    /**
     * 获取右元素
     * @return 右元素
     */
    public func getRight(): R {
        right
    }

    /**
     * 转换为字符串表示
     * @return 格式为 "(left, middle, right)" 的字符串
     */
    public func toString(): String {
        "(${elementToString(left)}, ${elementToString(middle)}, ${elementToString(right)})"
    }

    // 辅助方法：安全地将元素转为字符串
    private func elementToString<T>(elem: T): String {
        match (elem as ToString) {
            case Some(toStr) => toStr.toString()
            case None => "?"
        }
    }

    /**
     * 替换左元素，创建新的 Triple
     * @param newLeft 新的左元素
     * @return 新的 Triple 实例
     */
    public func withLeft(newLeft: L): Triple<L, M, R> {
        Triple(newLeft, middle, right)
    }

    /**
     * 替换中间元素，创建新的 Triple
     * @param newMiddle 新的中间元素
     * @return 新的 Triple 实例
     */
    public func withMiddle(newMiddle: M): Triple<L, M, R> {
        Triple(left, newMiddle, right)
    }

    /**
     * 替换右元素，创建新的 Triple
     * @param newRight 新的右元素
     * @return 新的 Triple 实例
     */
    public func withRight(newRight: R): Triple<L, M, R> {
        Triple(left, middle, newRight)
    }
}
