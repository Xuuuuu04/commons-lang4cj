package commons_lang4cj.function

public interface TriFunction<A, B, C, R> {
    func apply(a: A, b: B, c: C): R
}

