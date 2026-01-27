package commons_lang4cj.tuple

public class MutableTriple<L, M, R> {
    public var left: L
    public var middle: M
    public var right: R

    public init(left: L, middle: M, right: R) {
        this.left = left
        this.middle = middle
        this.right = right
    }

    public static func of(left: L, middle: M, right: R): MutableTriple<L, M, R> {
        MutableTriple(left, middle, right)
    }

    public func getLeft(): L {
        left
    }

    public func getMiddle(): M {
        middle
    }

    public func getRight(): R {
        right
    }

    public func setLeft(value: L): Unit {
        left = value
    }

    public func setMiddle(value: M): Unit {
        middle = value
    }

    public func setRight(value: R): Unit {
        right = value
    }

    public func toTriple(): Triple<L, M, R> {
        Triple(left, middle, right)
    }

    public func toString(): String {
        "(${elementToString(left)}, ${elementToString(middle)}, ${elementToString(right)})"
    }

    private func elementToString<T>(elem: T): String {
        match (elem as ToString) {
            case Some(toStr) => toStr.toString()
            case None => "?"
        }
    }
}
