package commons_lang4cj.range

public class DoubleRange {
    private let _range: Range<Float64>

    private init(range: Range<Float64>) {
        _range = range
    }

    public static func of(from: Float64, to: Float64): DoubleRange {
        DoubleRange(Range<Float64>.of(from, to))
    }

    public static func isSingle(element: Float64): DoubleRange {
        DoubleRange(Range<Float64>.isSingle(element))
    }

    public func getMinimum(): Float64 {
        _range.getMinimum()
    }

    public func getMaximum(): Float64 {
        _range.getMaximum()
    }

    public func contains(element: Float64): Bool {
        _range.contains(element)
    }

    public func containsRange(otherRange: DoubleRange): Bool {
        _range.containsRange(otherRange._range)
    }

    public func isBefore(element: Float64): Bool {
        _range.isBefore(element)
    }

    public func isAfter(element: Float64): Bool {
        _range.isAfter(element)
    }

    public func isStartedBy(element: Float64): Bool {
        _range.isStartedBy(element)
    }

    public func isEndedBy(element: Float64): Bool {
        _range.isEndedBy(element)
    }

    public func intersectionWith(other: DoubleRange): Option<DoubleRange> {
        match (_range.intersectionWith(other._range)) {
            case Some(r) => Some(DoubleRange(r))
            case None => None
        }
    }

    public func spanWith(other: DoubleRange): DoubleRange {
        DoubleRange(_range.spanWith(other._range))
    }

    public func isOverlappedBy(other: DoubleRange): Bool {
        _range.isOverlappedBy(other._range)
    }

    public func fitsWithin(other: DoubleRange): Bool {
        _range.fitsWithin(other._range)
    }

    public func fit(element: Float64): Float64 {
        _range.fit(element)
    }

    public func compareTo(other: DoubleRange): Int64 {
        _range.compareTo(other._range)
    }

    public func elementCompareTo(element: Float64): Int64 {
        _range.elementCompareTo(element)
    }

    public func equals(other: Object): Bool {
        _range.equals(other)
    }

    public func hashCode(): Int64 {
        _range.hashCode()
    }

    public func toString(): String {
        _range.toString()
    }
}
