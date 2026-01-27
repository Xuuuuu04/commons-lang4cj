package commons_lang4cj.tuple

public class MutablePair<L, R> {
    public var left: L
    public var right: R

    public init(left: L, right: R) {
        this.left = left
        this.right = right
    }

    public static func of(left: L, right: R): MutablePair<L, R> {
        MutablePair(left, right)
    }

    public func getLeft(): L {
        left
    }

    public func getRight(): R {
        right
    }

    public func setLeft(value: L): Unit {
        left = value
    }

    public func setRight(value: R): Unit {
        right = value
    }

    public func toPair(): Pair<L, R> {
        Pair(left, right)
    }

    public func toString(): String {
        "(${elementToString(left)}, ${elementToString(right)})"
    }

    private func elementToString<T>(elem: T): String {
        match (elem as ToString) {
            case Some(toStr) => toStr.toString()
            case None => "?"
        }
    }
}
