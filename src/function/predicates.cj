package commons_lang4cj.function

public class Predicates {
    private init() {}

    public static func alwaysTrue<T>(): (T) -> Bool {
        { _ => true }
    }

    public static func alwaysFalse<T>(): (T) -> Bool {
        { _ => false }
    }

    public static func not<T>(p: (T) -> Bool): (T) -> Bool {
        { t => !p(t) }
    }

    public static func and<T>(p1: (T) -> Bool, p2: (T) -> Bool): (T) -> Bool {
        { t => p1(t) && p2(t) }
    }

    public static func or<T>(p1: (T) -> Bool, p2: (T) -> Bool): (T) -> Bool {
        { t => p1(t) || p2(t) }
    }
}
