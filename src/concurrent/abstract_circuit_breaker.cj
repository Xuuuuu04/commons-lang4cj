package commons_lang4cj.concurrent

import std.sync.*

public abstract class AbstractCircuitBreaker <: CircuitBreaker {
    protected let _lock = Mutex()
    protected var _state: CircuitBreakerState = CircuitBreakerState.CLOSED

    public init() {}

    public override func checkState(): CircuitBreakerState {
        _lock.lock()
        try {
            _state
        } finally {
            _lock.unlock()
        }
    }

    public override func isOpen(): Bool {
        checkState() == CircuitBreakerState.OPEN
    }

    public override func isClosed(): Bool {
        checkState() == CircuitBreakerState.CLOSED
    }

    protected func open(): Unit {
        _state = CircuitBreakerState.OPEN
    }

    protected func close(): Unit {
        _state = CircuitBreakerState.CLOSED
    }
}
