package commons_lang4cj.time

import std.time.*

public class TimeZones {
    private init() {}

    public static const GMT_ID: String = "GMT"
    public static const UTC_ID: String = "UTC"

    public static func getUtc(): Option<TimeZone> {
        FastTimeZone.getTimeZone(UTC_ID)
    }

    public static func getGmt(): Option<TimeZone> {
        FastTimeZone.getTimeZone(GMT_ID)
    }
}
