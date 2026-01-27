package commons_lang4cj.concurrent

public class ConstantInitializer<T> {
    private let _object: T

    public init(obj: T) {
        _object = obj
    }

    public func get(): T {
        _object
    }
}
