package commons_lang4cj.builder

import std.collection.*

private func diffTryPrimitiveEquals(a: Any, b: Any): Bool {
    match (a as Int64) {
        case Some(av) =>
            match (b as Int64) {
                case Some(bv) => return av == bv
                case None => ()
            }
        case None => ()
    }
    match (a as Float64) {
        case Some(av) =>
            match (b as Float64) {
                case Some(bv) => return av == bv
                case None => ()
            }
        case None => ()
    }
    match (a as Bool) {
        case Some(av) =>
            match (b as Bool) {
                case Some(bv) => return av == bv
                case None => ()
            }
        case None => ()
    }
    match (a as String) {
        case Some(av) =>
            match (b as String) {
                case Some(bv) => return av == bv
                case None => ()
            }
        case None => ()
    }
    false
}

private func diffSafeEqualsAny(a: Any, b: Any): Bool {
    if (diffTryPrimitiveEquals(a, b)) {
        return true
    }
    match (a as ToString) {
        case Some(sa) =>
            match (b as ToString) {
                case Some(sb) => sa.toString() == sb.toString()
                case None => false
            }
        case None => false
    }
}

public class DiffBuilderConfig<T> {
    private var _left: Option<T> = None
    private var _right: Option<T> = None
    private var _style: Option<ToStringStyle> = None
    private var _testObjectsEquals: Bool = true
    private var _toStringFormat: String = "%s differs from %s"

    public init() {}

    public func setLeft(left: T): DiffBuilderConfig<T> {
        _left = Some(left)
        this
    }

    public func setRight(right: T): DiffBuilderConfig<T> {
        _right = Some(right)
        this
    }

    public func setStyle(style: ToStringStyle): DiffBuilderConfig<T> {
        _style = Some(style)
        this
    }

    public func setTestObjectsEquals(testObjectsEquals: Bool): DiffBuilderConfig<T> {
        _testObjectsEquals = testObjectsEquals
        this
    }

    public func setToStringFormat(toStringFormat: String): DiffBuilderConfig<T> {
        _toStringFormat = toStringFormat
        this
    }

    public func build(): DiffBuilder<T> {
        let l = match (_left) { case Some(v) => v case None => throw IllegalArgumentException("left") }
        let r = match (_right) { case Some(v) => v case None => throw IllegalArgumentException("right") }
        DiffBuilder(l, r, _style, _testObjectsEquals, _toStringFormat)
    }
}

public class DiffBuilder<T> {
    private let _left: T
    private let _right: T
    private let _style: Option<ToStringStyle>
    private let _testObjectsEquals: Bool
    private let _toStringFormat: String
    private let _diffs: ArrayList<Diff> = ArrayList<Diff>()
    private var _skip: Bool = false

    public init(left: T, right: T, style: Option<ToStringStyle>, testObjectsEquals: Bool, toStringFormat: String) {
        _left = left
        _right = right
        _style = style
        _testObjectsEquals = testObjectsEquals
        _toStringFormat = toStringFormat
        _skip = testObjectsEquals && diffSafeEqualsAny(left as Any, right as Any)
    }

    public static func builder<T>(): DiffBuilderConfig<T> {
        DiffBuilderConfig<T>()
    }

    public func append(fieldName: String, left: Any, right: Any): DiffBuilder<T> {
        if (_skip) {
            return this
        }
        if (!diffSafeEqualsAny(left, right)) {
            _diffs.add(Diff(fieldName, left, right))
        }
        this
    }

    public func build(): DiffResult<T> {
        DiffResult(_left, _right, _diffs, _style, _toStringFormat)
    }

}
