package commons_lang4cj.concurrent.locks

import std.sync.*

public class LockingVisitors {
    private init() {}

    public static func withLock<T>(lock: Mutex, body: () -> T): T {
        lock.lock()
        try {
            body()
        } finally {
            lock.unlock()
        }
    }
}
