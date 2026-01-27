package commons_lang4cj.compare

public class ComparableCheckBuilder<A> where A <: Comparable<A> {
    private let _a: Option<A>

    public init(a: Option<A>) {
        _a = a
    }

    public func between(b: A, c: A): Bool {
        betweenOrdered(b, c) || betweenOrdered(c, b)
    }

    public func betweenExclusive(b: A, c: A): Bool {
        betweenOrderedExclusive(b, c) || betweenOrderedExclusive(c, b)
    }

    private func betweenOrdered(b: A, c: A): Bool {
        greaterThanOrEqualTo(b) && lessThanOrEqualTo(c)
    }

    private func betweenOrderedExclusive(b: A, c: A): Bool {
        greaterThan(b) && lessThan(c)
    }

    public func equalTo(b: A): Bool {
        match (_a) {
            case Some(a) => a.compare(b) == Ordering.EQ
            case None => false
        }
    }

    public func greaterThan(b: A): Bool {
        match (_a) {
            case Some(a) => a.compare(b) == Ordering.GT
            case None => false
        }
    }

    public func greaterThanOrEqualTo(b: A): Bool {
        match (_a) {
            case Some(a) =>
                let o = a.compare(b)
                o == Ordering.GT || o == Ordering.EQ
            case None => false
        }
    }

    public func lessThan(b: A): Bool {
        match (_a) {
            case Some(a) => a.compare(b) == Ordering.LT
            case None => false
        }
    }

    public func lessThanOrEqualTo(b: A): Bool {
        match (_a) {
            case Some(a) =>
                let o = a.compare(b)
                o == Ordering.LT || o == Ordering.EQ
            case None => false
        }
    }
}

public class ComparableUtils {
    private init() {}

    public static func `is`<A>(a: A): ComparableCheckBuilder<A> where A <: Comparable<A> {
        ComparableCheckBuilder<A>(Some(a))
    }

    public static func `is`<A>(a: Option<A>): ComparableCheckBuilder<A> where A <: Comparable<A> {
        ComparableCheckBuilder<A>(a)
    }

    public static func between<A>(b: A, c: A): (A) -> Bool where A <: Comparable<A> {
        { a => `is`(a).between(b, c) }
    }

    public static func betweenExclusive<A>(b: A, c: A): (A) -> Bool where A <: Comparable<A> {
        { a => `is`(a).betweenExclusive(b, c) }
    }

    public static func ge<A>(b: A): (A) -> Bool where A <: Comparable<A> {
        { a => `is`(a).greaterThanOrEqualTo(b) }
    }

    public static func gt<A>(b: A): (A) -> Bool where A <: Comparable<A> {
        { a => `is`(a).greaterThan(b) }
    }

    public static func le<A>(b: A): (A) -> Bool where A <: Comparable<A> {
        { a => `is`(a).lessThanOrEqualTo(b) }
    }

    public static func lt<A>(b: A): (A) -> Bool where A <: Comparable<A> {
        { a => `is`(a).lessThan(b) }
    }
}
