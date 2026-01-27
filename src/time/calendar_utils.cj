package commons_lang4cj.time

import std.time.*

public class CalendarUtils {
    private init() {}

    public static func truncateToDay(date: DateTime): DateTime {
        DateUtils.truncate(date)
    }

    public static func addDays(date: DateTime, amount: Int64): DateTime {
        DateUtils.addDays(date, amount)
    }

    public static func addHours(date: DateTime, amount: Int64): DateTime {
        DateUtils.addHours(date, amount)
    }
}
