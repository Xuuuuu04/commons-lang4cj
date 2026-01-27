package commons_lang4cj.function

public class MethodInvokers {
    private init() {}

    public static func of<R>(callable: () -> R): () -> R {
        callable
    }

    public static func of1<T, R>(callable: (T) -> R): (T) -> R {
        callable
    }
}
