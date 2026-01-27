package commons_lang4cj.function

public class Consumers {
    private init() {}

    public static func nop<T>(): (T) -> Unit {
        { _ => () }
    }
}
