package commons_lang4cj.concurrent

import std.sync.*
import std.collection.*

public class BasicThreadFactory {
    private let _lock = Mutex()
    private var _counter: Int64 = 0
    private let _namePrefix: String

    public init(namePrefix: String) {
        _namePrefix = namePrefix
    }

    public func newThread<T>(task: () -> T): Future<T> {
        let _ = nextName()
        spawn { task() }
    }

    private func nextName(): String {
        _lock.lock()
        try {
            _counter += 1
            "${_namePrefix}-${_counter}"
        } finally {
            _lock.unlock()
        }
    }
}
