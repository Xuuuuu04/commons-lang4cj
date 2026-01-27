package commons_lang4cj.exception

public class NotImplementedException <: Exception {
    public init(message: String) {
        super(message)
    }

    public override func getClassName(): String {
        "NotImplementedException"
    }
}

