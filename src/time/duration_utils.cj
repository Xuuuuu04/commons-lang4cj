package commons_lang4cj.time

import std.time.*

public class DurationUtils {
    private init() {}

    public static func toMilliseconds(duration: Duration): Int64 {
        duration.toMilliseconds()
    }

    public static func toNanoseconds(duration: Duration): Int64 {
        duration.toNanoseconds()
    }

    public static func formatDurationMillis(duration: Duration): String {
        "${duration.toMilliseconds()}ms"
    }
}
