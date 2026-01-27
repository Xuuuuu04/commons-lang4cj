package commons_lang4cj.concurrent

import std.sync.*

public class FutureTasks {
    private init() {}

    public static func run<T>(callable: () -> T): Future<T> {
        spawn { callable() }
    }
}
