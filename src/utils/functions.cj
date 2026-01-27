package commons_lang4cj.utils

public class Functions {
    private init() {}

    public static func safeToString(value: Any): String {
        match (value as ToString) {
            case Some(t) => t.toString()
            case None => "?"
        }
    }
}
