package commons_lang4cj.math

/**
 * 算术异常
 * 当发生算术错误时抛出,如除以零、数值溢出等
 *
 * @since 1.1.0
 */
public class ArithmeticException <: Exception {
    public init(message: String) {
        super(message)
    }

    public override func getClassName(): String {
        "ArithmeticException"
    }
}
