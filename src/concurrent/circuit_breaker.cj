package commons_lang4cj.concurrent

import std.sync.*
import std.time.*
import std.deriving.*

@Derive[Equatable, ToString]
public enum CircuitBreakerState {
    | CLOSED
    | OPEN
    | HALF_OPEN
}

public interface CircuitBreaker {
    func checkState(): CircuitBreakerState
    func isOpen(): Bool
    func isClosed(): Bool
}

public class ThresholdCircuitBreaker <: CircuitBreaker {
    private let _threshold: Int64
    private let _timeout: Duration
    private let _lock = Mutex()
    private var _state = CircuitBreakerState.CLOSED
    private var _failureCount: Int64 = 0
    private var _openStartTime: DateTime = DateTime.now()

    public init(threshold: Int64, timeout: Duration) {
        if (threshold <= 0) {
            throw IllegalArgumentException("Threshold must be greater than 0")
        }
        _threshold = threshold
        _timeout = timeout
    }

    public func incrementAndCheckState(): Bool {
        _lock.lock()
        try {
            match (_state) {
                case CircuitBreakerState.CLOSED =>
                    _failureCount++
                    if (_failureCount >= _threshold) {
                        open()
                    }
                case CircuitBreakerState.HALF_OPEN =>
                    open()
                case CircuitBreakerState.OPEN =>
                    ()
            }
            isOpen()
        } finally {
            _lock.unlock()
        }
    }

    public func checkState(): CircuitBreakerState {
        _lock.lock()
        try {
            if (isOpen()) {
                let now = DateTime.now()
                if (now - _openStartTime >= _timeout) {
                    _state = CircuitBreakerState.HALF_OPEN
                }
            }
            _state
        } finally {
            _lock.unlock()
        }
    }

    public func close(): Unit {
        _lock.lock()
        try {
            _state = CircuitBreakerState.CLOSED
            _failureCount = 0
        } finally {
            _lock.unlock()
        }
    }

    public func isOpen(): Bool {
        _state == CircuitBreakerState.OPEN
    }

    public func isClosed(): Bool {
        _state == CircuitBreakerState.CLOSED
    }

    private func open(): Unit {
        _state = CircuitBreakerState.OPEN
        _openStartTime = DateTime.now()
    }
}
