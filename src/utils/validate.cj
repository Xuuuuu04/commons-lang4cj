package commons_lang4cj.utils

public class Validate {
    private init() {}

    public static func isTrue(value: Bool): Unit {
        ValidateUtils.isTrue(value)
    }

    public static func isTrue(value: Bool, message: String): Unit {
        ValidateUtils.isTrue(value, message)
    }

    public static func isFalse(value: Bool): Unit {
        ValidateUtils.isFalse(value)
    }

    public static func isFalse(value: Bool, message: String): Unit {
        ValidateUtils.isFalse(value, message)
    }

    public static func notNull<T>(obj: Option<T>): T {
        ValidateUtils.notNull(obj)
    }

    public static func notNull<T>(obj: Option<T>, message: String): T {
        ValidateUtils.notNull(obj, message)
    }

    public static func notEmpty<T>(array: Array<T>): Array<T> {
        ValidateUtils.notEmpty(array)
    }

    public static func notEmpty(array: Array<String>): Array<String> {
        ValidateUtils.notEmpty(array)
    }

    public static func notEmpty(str: String): String {
        ValidateUtils.notEmpty(str)
    }

    public static func notBlank(str: String): String {
        ValidateUtils.notBlank(str)
    }

    public static func validIndex(index: Int64, size: Int64): Unit {
        ValidateUtils.validIndex(index, size)
    }

    public static func validIndex<T>(array: Array<T>, index: Int64): Unit {
        ValidateUtils.validIndex(array, index)
    }

    public static func exclusiveBetween(min: Int64, max: Int64, value: Int64): Unit {
        ValidateUtils.exclusiveBetween(min, max, value)
    }

    public static func inclusiveBetween(min: Int64, max: Int64, value: Int64): Unit {
        ValidateUtils.inclusiveBetween(min, max, value)
    }

    public static func isInstanceOf<T>(obj: Option<T>, typeCheck: (T) -> Bool, unused: () -> Bool): Bool {
        ValidateUtils.isInstanceOf(obj, typeCheck, unused)
    }

    public static func isInstanceOf<T, R>(obj: Option<T>, message: String, converter: (T) -> R): R {
        ValidateUtils.isInstanceOf(obj, message, converter)
    }

    public static func positive(value: Int64): Int64 {
        ValidateUtils.positive(value)
    }

    public static func positive(value: Int64, message: String): Int64 {
        ValidateUtils.positive(value, message)
    }

    public static func notNegative(value: Int64): Int64 {
        ValidateUtils.notNegative(value)
    }

    public static func notNegative(value: Int64, message: String): Int64 {
        ValidateUtils.notNegative(value, message)
    }

    public static func noNullElements<T>(array: Array<Option<T>>): Array<Option<T>> {
        ValidateUtils.noNullElements(array)
    }

    public static func noNullElements<T>(array: Array<Option<T>>, message: String): Array<Option<T>> {
        ValidateUtils.noNullElements(array, message)
    }

    public static func noEmptyElements(array: Array<String>): Array<String> {
        ValidateUtils.noEmptyElements(array)
    }

    public static func noEmptyElements(array: Array<String>, message: String): Array<String> {
        ValidateUtils.noEmptyElements(array, message)
    }

    public static func validState(expression: Bool): Unit {
        ValidateUtils.validState(expression)
    }

    public static func validState(expression: Bool, message: String): Unit {
        ValidateUtils.validState(expression, message)
    }

    public static func validStateTrue(expression: Bool): Unit {
        ValidateUtils.validStateTrue(expression)
    }

    public static func matchesPattern(str: String, pattern: String): String {
        ValidateUtils.matchesPattern(str, pattern)
    }

    public static func length(str: String, minLength: Int64, maxLength: Int64): String {
        ValidateUtils.length(str, minLength, maxLength)
    }

    public static func inclusiveBetweenComparable<T>(value: T, min: T, max: T): T where T <: Comparable<T> & ToString {
        ValidateUtils.inclusiveBetweenComparable(value, min, max)
    }

    public static func exclusiveOutside(value: Int64, min: Int64, max: Int64): Int64 {
        ValidateUtils.exclusiveOutside(value, min, max)
    }

    public static func equal<T>(obj1: T, obj2: T): Unit where T <: Equatable<T> {
        ValidateUtils.equal(obj1, obj2)
    }

    public static func notEqual<T>(obj1: T, obj2: T): Unit where T <: Equatable<T> {
        ValidateUtils.notEqual(obj1, obj2)
    }

    public static func even(value: Int64): Int64 {
        ValidateUtils.even(value)
    }

    public static func odd(value: Int64): Int64 {
        ValidateUtils.odd(value)
    }

    public static func isIn<T>(element: T, collection: Array<T>): T where T <: Equatable<T> {
        ValidateUtils.isIn(element, collection)
    }

    public static func isNotIn<T>(element: T, collection: Array<T>): T where T <: Equatable<T> {
        ValidateUtils.isNotIn(element, collection)
    }
}
