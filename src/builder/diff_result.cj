package commons_lang4cj.builder

import std.collection.*

public class DiffResult<T> {
    private let _left: T
    private let _right: T
    private let _diffs: ArrayList<Diff>
    private let _style: Option<ToStringStyle>
    private let _toStringFormat: String

    public init(left: T, right: T, diffs: ArrayList<Diff>, style: Option<ToStringStyle>, toStringFormat: String) {
        _left = left
        _right = right
        _diffs = diffs
        _style = style
        _toStringFormat = toStringFormat
    }

    public func getLeft(): T {
        _left
    }

    public func getRight(): T {
        _right
    }

    public func getDiffs(): ArrayList<Diff> {
        _diffs
    }

    public func getNumberOfDiffs(): Int64 {
        Int64(_diffs.size)
    }

    public func toString(): String {
        toString(_style)
    }

    public func toString(style: Option<ToStringStyle>): String {
        if (_diffs.size == 0) {
            return ""
        }
        let leftStr = safeToString(_left)
        let rightStr = safeToString(_right)
        let sb = StringBuilder()
        sb.append("${leftStr} differs from ${rightStr}")
        sb.append(" ")
        sb.append("[")
        var first = true
        for (d in _diffs) {
            if (!first) {
                sb.append(", ")
            }
            first = false
            sb.append(d.toString())
        }
        sb.append("]")
        sb.toString()
    }

    private func safeToString(value: Any): String {
        match (value as ToString) {
            case Some(s) => s.toString()
            case None => "?"
        }
    }

    private func format2(_: String, a: String, b: String): String {
        "${a} differs from ${b}"
    }
}
