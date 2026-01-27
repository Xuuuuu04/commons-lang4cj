package commons_lang4cj.builder

import commons_lang4cj.function.*

public abstract class AbstractSupplier<T, B, E> <: FailableSupplier<T, E> where B <: AbstractSupplier<T, B, E> {
    public init() {}

    protected func asThis(): B {
        match (this as B) {
            case Some(b) => b
            case None => throw IllegalStateException("Invalid builder type")
        }
    }
}
