package commons_lang4cj.function

public class Failable {
    private init() {}

    public static func call<T>(callable: () -> T): Option<T> {
        try {
            Some(callable())
        } catch (_: Exception) {
            None
        }
    }
}
