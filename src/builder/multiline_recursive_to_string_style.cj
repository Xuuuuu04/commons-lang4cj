package commons_lang4cj.builder

public class MultilineRecursiveToStringStyle <: RecursiveToStringStyle {
    public init() {
        super()
        _contentStart = "["
        _contentEnd = "]"
        _fieldSeparator = ",\n"
    }
}
