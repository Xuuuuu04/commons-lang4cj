package commons_lang4cj.function

public class Functions {
    private init() {}

    public static func identity<T>(): (T) -> T {
        { t => t }
    }

    public static func constant<T>(value: T): (Any) -> T {
        { _ => value }
    }
}
