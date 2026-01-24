package commons_lang4cj.test.time

import std.unittest.*
import std.time.*
import commons_lang4cj.time.*

@Test
public class DateUtilsTest {

    @TestCase
    public func testIsSameDay() {
        let date1 = DateTime.of(year: 2023, month: Month.October, dayOfMonth: 1, hour: 10, minute: 0, second: 0)
        let date2 = DateTime.of(year: 2023, month: Month.October, dayOfMonth: 1, hour: 23, minute: 59, second: 59)
        let date3 = DateTime.of(year: 2023, month: Month.October, dayOfMonth: 2, hour: 10, minute: 0, second: 0)
        let date4 = DateTime.of(year: 2022, month: Month.October, dayOfMonth: 1, hour: 10, minute: 0, second: 0)

        @Expect(DateUtils.isSameDay(date1, date2), true)
        @Expect(DateUtils.isSameDay(date1, date3), false)
        @Expect(DateUtils.isSameDay(date1, date4), false) // Same month/day, diff year

        // Edge case: End of year vs Start of next year
        let endOfYear = DateTime.of(year: 2023, month: Month.December, dayOfMonth: 31, hour: 23, minute: 59)
        let startOfYear = DateTime.of(year: 2024, month: Month.January, dayOfMonth: 1, hour: 0, minute: 0)
        @Expect(DateUtils.isSameDay(endOfYear, startOfYear), false)

        // Edge case: Leap day
        let leapDay1 = DateTime.of(year: 2024, month: Month.February, dayOfMonth: 29, hour: 10, minute: 0)
        let leapDay2 = DateTime.of(year: 2024, month: Month.February, dayOfMonth: 29, hour: 15, minute: 30)
        @Expect(DateUtils.isSameDay(leapDay1, leapDay2), true)
    }

    @TestCase
    public func testTruncate() {
        let date = DateTime.of(year: 2023, month: Month.October, dayOfMonth: 1, hour: 15, minute: 30, second: 45, nanosecond: 123456789)
        let truncated = DateUtils.truncate(date)

        @Expect(truncated.year, 2023)
        @Expect(truncated.month, Month.October)
        @Expect(truncated.dayOfMonth, 1)
        @Expect(truncated.hour, 0)
        @Expect(truncated.minute, 0)
        @Expect(truncated.second, 0)
        @Expect(truncated.nanosecond, 0)

        // Edge case: End of day
        let endOfDay = DateTime.of(year: 2023, month: Month.December, dayOfMonth: 31, hour: 23, minute: 59, second: 59, nanosecond: 999999999)
        let truncatedEnd = DateUtils.truncate(endOfDay)
        @Expect(truncatedEnd.year, 2023)
        @Expect(truncatedEnd.month, Month.December)
        @Expect(truncatedEnd.dayOfMonth, 31)
        @Expect(truncatedEnd.hour, 0)
        @Expect(truncatedEnd.minute, 0)
        @Expect(truncatedEnd.second, 0)
        @Expect(truncatedEnd.nanosecond, 0)

        // Edge case: Already midnight
        let midnight = DateTime.of(year: 2023, month: Month.January, dayOfMonth: 1, hour: 0, minute: 0, second: 0)
        let truncatedMidnight = DateUtils.truncate(midnight)
        @Expect(truncatedMidnight.hour, 0)
        @Expect(truncatedMidnight.minute, 0)
    }

    @TestCase
    public func testAddMonthsLoop() {
        // Loop 1 to 12 to verify month transitions
        let start = DateTime.of(year: 2023, month: Month.January, dayOfMonth: 1)

        for (i in 1..=12) {
            let next = DateUtils.addMonths(start, Int64(i))

            // i=1 -> Feb, i=2 -> Mar, ..., i=12 -> Jan (next year)
            if (i == 1) {
                @Expect(next.month, Month.February)
                @Expect(next.year, 2023)
            }
            if (i == 6) {
                @Expect(next.month, Month.July)
                @Expect(next.year, 2023)
            }
            if (i == 11) {
                @Expect(next.month, Month.December)
                @Expect(next.year, 2023)
            }
            if (i == 12) {
                @Expect(next.month, Month.January)
                @Expect(next.year, 2024)
            }
        }
    }

    @TestCase
    public func testAddMonthsNormal() {
        let date = DateTime.of(year: 2023, month: Month.January, dayOfMonth: 15)
        let newDate = DateUtils.addMonths(date, 2) // +2 months -> March

        @Expect(newDate.year, 2023)
        @Expect(newDate.month, Month.March)
        @Expect(newDate.dayOfMonth, 15)
    }

    @TestCase
    public func testAddMonthsCrossYear() {
        let date = DateTime.of(year: 2023, month: Month.November, dayOfMonth: 15)
        let newDate = DateUtils.addMonths(date, 3) // +3 months -> Feb 2024

        @Expect(newDate.year, 2024)
        @Expect(newDate.month, Month.February)
        @Expect(newDate.dayOfMonth, 15)
    }

    @TestCase
    public func testAddMonthsNegativeCrossYear() {
        let date = DateTime.of(year: 2023, month: Month.January, dayOfMonth: 15)
        let newDate = DateUtils.addMonths(date, -2) // -2 months -> Nov 2022

        @Expect(newDate.year, 2022)
        @Expect(newDate.month, Month.November)
        @Expect(newDate.dayOfMonth, 15)
    }

    @TestCase
    public func testAddMonthsClamp() {
        // 1月31日 + 1个月 -> 2月28日 (平年)
        let date1 = DateTime.of(year: 2023, month: Month.January, dayOfMonth: 31)
        let newDate1 = DateUtils.addMonths(date1, 1)
        @Expect(newDate1.year, 2023)
        @Expect(newDate1.month, Month.February)
        @Expect(newDate1.dayOfMonth, 28)

        // 1月31日 + 1个月 -> 2月29日 (闰年 2024)
        let date2 = DateTime.of(year: 2024, month: Month.January, dayOfMonth: 31)
        let newDate2 = DateUtils.addMonths(date2, 1)
        @Expect(newDate2.year, 2024)
        @Expect(newDate2.month, Month.February)
        @Expect(newDate2.dayOfMonth, 29)
    }

    @TestCase
    public func testAddMonthsLeapYearPingPong() {
        // Task B: 2024-01-31 -> Feb -> Mar 反复横跳
        let start = DateTime.of(year: 2024, month: Month.January, dayOfMonth: 31)

        // Step 1: Add 1 month -> 2024-02-29
        let feb = DateUtils.addMonths(start, 1)
        @Expect(feb.year, 2024)
        @Expect(feb.month, Month.February)
        @Expect(feb.dayOfMonth, 29)

        // Step 2: Add another month -> 2024-03-29 (not 31, because base was 29)
        // Standard behavior: 29th Feb + 1 Month = 29th March.
        let mar = DateUtils.addMonths(feb, 1)
        @Expect(mar.year, 2024)
        @Expect(mar.month, Month.March)
        @Expect(mar.dayOfMonth, 29)

        // Check adding 2 months directly from start
        // 2024-01-31 + 2 Months = 2024-03-31
        let marDirect = DateUtils.addMonths(start, 2)
        @Expect(marDirect.year, 2024)
        @Expect(marDirect.month, Month.March)
        @Expect(marDirect.dayOfMonth, 31)
    }

    @TestCase
    public func testAddYears() {
        let date = DateTime.of(year: 2023, month: Month.February, dayOfMonth: 28)
        let newDate = DateUtils.addYears(date, 1)
        @Expect(newDate.year, 2024)
        @Expect(newDate.month, Month.February)
        @Expect(newDate.dayOfMonth, 28)
    }

    @TestCase
    public func testAddYearsLeapToNonLeap() {
        // 2024-02-29 + 1 year -> 2025-02-28
        let date = DateTime.of(year: 2024, month: Month.February, dayOfMonth: 29)
        let newDate = DateUtils.addYears(date, 1)
        @Expect(newDate.year, 2025)
        @Expect(newDate.month, Month.February)
        @Expect(newDate.dayOfMonth, 28)

        // Reverse: 2025-02-28 - 1 year -> 2024-02-28 (Note: usually keeps day unless invalid)
        let prevDate = DateUtils.addYears(newDate, -1)
        @Expect(prevDate.year, 2024)
        @Expect(prevDate.month, Month.February)
        @Expect(prevDate.dayOfMonth, 28)
    }

    @TestCase
    public func testParseDate() {
        let patterns = ["yyyy-MM-dd", "yyyy/MM/dd", "MM-dd-yyyy"]

        // Match first pattern
        let d1 = DateUtils.parseDate("2023-10-01", patterns)
        @Expect(d1.isSome(), true)
        @Expect(d1.getOrThrow().year, 2023)
        @Expect(d1.getOrThrow().month, Month.October)
        @Expect(d1.getOrThrow().dayOfMonth, 1)

        // Match second pattern
        let d2 = DateUtils.parseDate("2023/10/01", patterns)
        @Expect(d2.isSome(), true)
        @Expect(d2.getOrThrow().year, 2023)

        // No match
        let d3 = DateUtils.parseDate("2023.10.01", patterns)
        @Expect(d3.isNone(), true)

        // Empty patterns
        let d4 = DateUtils.parseDate("2023-10-01", Array<String>())
        @Expect(d4.isNone(), true)
    }
}
