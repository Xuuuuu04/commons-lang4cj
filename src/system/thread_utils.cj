package commons_lang4cj.system

import std.time.*

private func timeSleep(duration: Duration): Unit {
    sleep(duration)
}

public class ThreadUtils {
    private init() {}

    public static func sleep(duration: Duration): Unit {
        timeSleep(duration)
    }
}
