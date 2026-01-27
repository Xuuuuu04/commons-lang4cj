package commons_lang4cj.concurrent

import std.sync.*

public abstract class AbstractFutureProxy<T> {
    public init() {}

    protected func delegate(): Future<T>

    public func get(): T {
        delegate().get()
    }
}
