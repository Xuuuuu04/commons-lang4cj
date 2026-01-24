package commons_lang4cj.mutable

/**
 * 非法参数异常
 */
public class IllegalArgumentException <: Exception {
    public init(message: String) {
        super(message)
    }

    public override func getClassName(): String {
        "IllegalArgumentException"
    }
}
