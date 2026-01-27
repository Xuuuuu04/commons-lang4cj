package commons_lang4cj.concurrent

import std.sync.*

public abstract class AtomicInitializer<T> {
    private let _lock = Mutex()
    private var _initialized: Bool = false
    private var _object: Option<T> = None

    public init() {}

    protected func initialize(): T

    public func get(): T {
        if (_initialized) {
            match (_object) {
                case Some(v) => return v
                case None => ()
            }
        }
        _lock.lock()
        try {
            if (_initialized) {
                match (_object) {
                    case Some(v) => return v
                    case None => ()
                }
            }
            let v = initialize()
            _object = Some(v)
            _initialized = true
            v
        } finally {
            _lock.unlock()
        }
    }
}
