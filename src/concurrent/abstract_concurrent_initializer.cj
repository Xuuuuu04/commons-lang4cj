package commons_lang4cj.concurrent

import std.sync.*

public abstract class AbstractConcurrentInitializer<T> {
    private let _lock = Mutex()
    private var _future: Option<Future<T>> = None

    public init() {}

    protected func initialize(): T

    public func get(): T {
        let fut = ensureFuture()
        fut.get()
    }

    public func isStarted(): Bool {
        _lock.lock()
        try {
            _future.isSome()
        } finally {
            _lock.unlock()
        }
    }

    protected func ensureFuture(): Future<T> {
        _lock.lock()
        try {
            match (_future) {
                case Some(f) => return f
                case None =>
                    let f = spawn { this.initialize() }
                    _future = Some(f)
                    return f
            }
        } finally {
            _lock.unlock()
        }
    }
}
