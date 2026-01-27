package commons_lang4cj.concurrent

import commons_lang4cj.exception.*

public class ConcurrentRuntimeException <: Exception {
    public init(message: String) {
        super(message)
    }
}
