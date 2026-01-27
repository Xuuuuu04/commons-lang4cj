package commons_lang4cj.event

import std.collection.*
import std.sync.*

public class EventListenerSupport<T> {
    private let _lock = Mutex()
    private let _listeners: ArrayList<T> = ArrayList<T>()

    public init() {}

    public func addListener(listener: T) {
        _lock.lock()
        try {
            _listeners.add(listener)
        } finally {
            _lock.unlock()
        }
    }

    public func removeListener(listener: T) {
        _lock.lock()
        try {
            var i: Int64 = 0
            while (i < Int64(_listeners.size)) {
                if (matchEquals(_listeners[Int64(i)] as Any, listener as Any)) {
                    _listeners.remove(at: Int64(i))
                    continue
                }
                i += 1
            }
        } finally {
            _lock.unlock()
        }
    }

    public func getListeners(): Array<T> {
        _lock.lock()
        try {
            _listeners.toArray()
        } finally {
            _lock.unlock()
        }
    }

    public func fire(event: (T) -> Unit) {
        let snapshot = getListeners()
        for (l in snapshot) {
            event(l)
        }
    }

    private func matchEquals(a: Any, b: Any): Bool {
        match (a as ToString) {
            case Some(sa) =>
                match (b as ToString) {
                    case Some(sb) => sa.toString() == sb.toString()
                    case None => false
                }
            case None => false
        }
    }
}
