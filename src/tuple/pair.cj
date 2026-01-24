package commons_lang4cj.tuple

/**
 * Pair<L,R> - 包含两个元素的元组
 *
 * 类型参数:
 * @param L 左元素的类型
 * @param R 右元素的类型
 *
 * 注意: 此结构体是不可变的，所有方法都返回新实例
 */
public struct Pair<L, R> {
    /**
     * 左元素
     */
    public let left: L

    /**
     * 右元素
     */
    public let right: R

    /**
     * 公开构造函数
     * @param left 左元素
     * @param right 右元素
     */
    public init(left: L, right: R) {
        this.left = left
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
     * 获取右元素
     * @return 右元素
     */
    public func getRight(): R {
        right
    }

    /**
     * 转换为字符串表示
     * @return 格式为 "(left, right)" 的字符串
     */
    public func toString(): String {
        "(${elementToString(left)}, ${elementToString(right)})"
    }

    // 辅助方法：安全地将元素转为字符串
    private func elementToString<T>(elem: T): String {
        match (elem as ToString) {
            case Some(toStr) => toStr.toString()
            case None => "?"
        }
    }

    /**
     * 替换左元素，创建新的 Pair
     * @param newLeft 新的左元素
     * @return 新的 Pair 实例
     */
    public func withLeft(newLeft: L): Pair<L, R> {
        Pair(newLeft, right)
    }

    /**
     * 替换右元素，创建新的 Pair
     * @param newRight 新的右元素
     * @return 新的 Pair 实例
     */
    public func withRight(newRight: R): Pair<L, R> {
        Pair(left, newRight)
    }
}
