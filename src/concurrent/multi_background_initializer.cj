package commons_lang4cj.concurrent

import std.collection.*
import std.sync.*

public class MultiBackgroundInitializer {
    private let _lock = Mutex()
    private let _children: HashMap<String, BackgroundInitializer<Any>> = HashMap<String, BackgroundInitializer<Any>>()

    public init() {}

    public func addInitializer(name: String, initializer: BackgroundInitializer<Any>) {
        _lock.lock()
        try {
            _children[name] = initializer
        } finally {
            _lock.unlock()
        }
    }

    public func start(): Bool {
        _lock.lock()
        try {
            for ((_, initializer) in _children) {
                initializer.start()
            }
            true
        } finally {
            _lock.unlock()
        }
    }

    public func getResults(): HashMap<String, Any> {
        let results = HashMap<String, Any>()
        _lock.lock()
        try {
            for ((k, initializer) in _children) {
                results[k] = initializer.get()
            }
        } finally {
            _lock.unlock()
        }
        results
    }
}
