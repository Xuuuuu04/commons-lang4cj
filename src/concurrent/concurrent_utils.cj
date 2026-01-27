package commons_lang4cj.concurrent

import std.sync.*

public class ConcurrentUtils {
    private init() {}

    public static func get<T>(future: Future<T>): T {
        future.get()
    }

    public static func tryGet<T>(future: Future<T>): Option<T> {
        try {
            Some(future.get())
        } catch (_: Exception) {
            None
        }
    }
}
