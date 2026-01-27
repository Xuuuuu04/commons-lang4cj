package commons_lang4cj.concurrent

import std.sync.*
import std.time.*

public class EventCountCircuitBreaker <: AbstractCircuitBreaker {
    private let _threshold: Int64
    private let _interval: Duration
    private var _count: Int64 = 0
    private var _intervalStart: DateTime = DateTime.now()

    public init(threshold: Int64, interval: Duration) {
        super()
        if (threshold <= 0) {
            throw IllegalArgumentException("threshold")
        }
        _threshold = threshold
        _interval = interval
    }

    public func incrementAndCheckState(): Bool {
        _lock.lock()
        try {
            rollIfNeeded()
            _count += 1
            if (_count >= _threshold) {
                open()
            }
            isOpen()
        } finally {
            _lock.unlock()
        }
    }

    public func reset(): Unit {
        _lock.lock()
        try {
            _count = 0
            _intervalStart = DateTime.now()
            close()
        } finally {
            _lock.unlock()
        }
    }

    private func rollIfNeeded() {
        let now = DateTime.now()
        let elapsed = now.toUnixTimeStamp().toMilliseconds() - _intervalStart.toUnixTimeStamp().toMilliseconds()
        if (elapsed >= _interval.toMilliseconds()) {
            _intervalStart = now
            _count = 0
            close()
        }
    }
}
