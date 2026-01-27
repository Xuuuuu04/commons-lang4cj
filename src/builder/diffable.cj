package commons_lang4cj.builder

public interface Diffable<T> {
    func diff(obj: T): DiffResult<T>
}
