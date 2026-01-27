package commons_lang4cj.concurrent

import std.sync.*

public class CallableBackgroundInitializer<T> <: BackgroundInitializer<T> {
    private let _callable: () -> T

    public init(callable: () -> T) {
        _callable = callable
    }

    protected override func initialize(): T {
        _callable()
    }
}
