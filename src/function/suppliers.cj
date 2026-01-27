package commons_lang4cj.function

public class Suppliers {
    private init() {}

    public static func ofInstance<T>(value: T): () -> T {
        { => value }
    }
}
