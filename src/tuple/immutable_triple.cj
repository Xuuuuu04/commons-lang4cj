package commons_lang4cj.tuple

public struct ImmutableTriple<L, M, R> {
    public let left: L
    public let middle: M
    public let right: R

    public init(left: L, middle: M, right: R) {
        this.left = left
        this.middle = middle
        this.right = right
    }

    public static func of(left: L, middle: M, right: R): ImmutableTriple<L, M, R> {
        ImmutableTriple(left, middle, right)
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
