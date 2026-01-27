package commons_lang4cj.builder

public struct Diff {
    public let fieldName: String
    public let left: Any
    public let right: Any

    public init(fieldName: String, left: Any, right: Any) {
        this.fieldName = fieldName
        this.left = left
        this.right = right
    }

    public func getFieldName(): String {
        fieldName
    }

    public func getLeft(): Any {
        left
    }

    public func getRight(): Any {
        right
    }

    public func toString(): String {
        "[${fieldName}: ${safeToString(left)}, ${safeToString(right)}]"
    }

    private func safeToString(value: Any): String {
        match (value as ToString) {
            case Some(s) => s.toString()
            case None => "?"
        }
    }
}
