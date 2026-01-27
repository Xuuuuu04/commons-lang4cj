package commons_lang4cj.range

public class LongRange {
    private let _range: Range<Int64>

    private init(range: Range<Int64>) {
        _range = range
    }

    public static func of(from: Int64, to: Int64): LongRange {
        LongRange(Range<Int64>.of(from, to))
    }

    public static func isSingle(element: Int64): LongRange {
        LongRange(Range<Int64>.isSingle(element))
    }

    public func getMinimum(): Int64 {
        _range.getMinimum()
    }

    public func getMaximum(): Int64 {
        _range.getMaximum()
    }

    public func contains(element: Int64): Bool {
        _range.contains(element)
    }

    public func containsRange(otherRange: LongRange): Bool {
        _range.containsRange(otherRange._range)
    }

    public func isBefore(element: Int64): Bool {
        _range.isBefore(element)
    }

    public func isAfter(element: Int64): Bool {
        _range.isAfter(element)
    }

    public func isStartedBy(element: Int64): Bool {
        _range.isStartedBy(element)
    }

    public func isEndedBy(element: Int64): Bool {
        _range.isEndedBy(element)
    }

    public func intersectionWith(other: LongRange): Option<LongRange> {
        match (_range.intersectionWith(other._range)) {
            case Some(r) => Some(LongRange(r))
            case None => None
        }
    }

    public func spanWith(other: LongRange): LongRange {
        LongRange(_range.spanWith(other._range))
    }

    public func isOverlappedBy(other: LongRange): Bool {
        _range.isOverlappedBy(other._range)
    }

    public func fitsWithin(other: LongRange): Bool {
        _range.fitsWithin(other._range)
    }

    public func fit(element: Int64): Int64 {
        _range.fit(element)
    }

    public func compareTo(other: LongRange): Int64 {
        _range.compareTo(other._range)
    }

    public func elementCompareTo(element: Int64): Int64 {
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
