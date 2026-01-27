package commons_lang4cj.concurrent

import std.sync.*
import std.time.*

public class TimedSemaphore {
    private let _lock = Mutex()
    private let _period: Duration
    private let _limit: Int64
    private var _count: Int64 = 0
    private var _periodStart: DateTime = DateTime.now()

    public init(period: Duration, limit: Int64) {
        if (limit <= 0) {
            throw IllegalArgumentException("limit")
        }
        _period = period
        _limit = limit
    }

    public func acquire(): Bool {
        _lock.lock()
        try {
            updatePeriodIfNeeded()
            if (_count >= _limit) {
                return false
            }
            _count += 1
            return true
        } finally {
            _lock.unlock()
        }
    }

    public func getAcquireCount(): Int64 {
        _lock.lock()
        try {
            updatePeriodIfNeeded()
            _count
        } finally {
            _lock.unlock()
        }
    }

    private func updatePeriodIfNeeded() {
        let now = DateTime.now()
        let elapsed = now.toUnixTimeStamp().toMilliseconds() - _periodStart.toUnixTimeStamp().toMilliseconds()
        if (elapsed >= _period.toMilliseconds()) {
            _periodStart = now
            _count = 0
        }
    }
}
