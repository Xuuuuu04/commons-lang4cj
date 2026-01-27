package commons_lang4cj.system

public class SystemProperties {
    private init() {}

    public static func get(key: String): Option<String> {
        let _ = key
        None
    }

    public static func getOrDefault(key: String, defaultValue: String): String {
        match (get(key)) {
            case Some(v) => v
            case None => defaultValue
        }
    }
}
