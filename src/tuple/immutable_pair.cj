package commons_lang4cj.tuple

public struct ImmutablePair<L, R> {
    public let left: L
    public let right: R

    public init(left: L, right: R) {
        this.left = left
        this.right = right
    }

    public static func of(left: L, right: R): ImmutablePair<L, R> {
        ImmutablePair(left, right)
    }

    public func getLeft(): L {
        left
    }

    public func getRight(): R {
        right
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
