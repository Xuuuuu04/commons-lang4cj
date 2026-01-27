package commons_lang4cj.test.enums

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import commons_lang4cj.enums.EnumUtils

enum Color {
    | Red | Green | Blue
}

@Test
public class EnumUtilsTest {

    private let colorMap = HashMap<String, Color>()

    public init() {
        colorMap["Red"] = Color.Red
        colorMap["Green"] = Color.Green
        colorMap["Blue"] = Color.Blue
    }

    @TestCase
    public func testIsValidEnum() {
        @Expect(EnumUtils.isValidEnum(colorMap, "Red"), true)
        @Expect(EnumUtils.isValidEnum(colorMap, "Yellow"), false)
        @Expect(EnumUtils.isValidEnum(colorMap, ""), false)
    }

    @TestCase
    public func testIsValidEnumIgnoreCase() {
        @Expect(EnumUtils.isValidEnumIgnoreCase(colorMap, "red"), true)
        @Expect(EnumUtils.isValidEnumIgnoreCase(colorMap, "GREEN"), true)
        @Expect(EnumUtils.isValidEnumIgnoreCase(colorMap, "Yellow"), false)
        @Expect(EnumUtils.isValidEnumIgnoreCase(colorMap, ""), false)
    }

    @TestCase
    public func testGetEnum() {
        let r = EnumUtils.getEnum(colorMap, "Red")
        match (r) {
            case Some(v) => @Expect(match (v) { case Red => true; case _ => false }, true)
            case None => @Expect(false, true) // Fail
        }

        let y = EnumUtils.getEnum(colorMap, "Yellow")
        @Expect(y.isNone(), true)
    }

    @TestCase
    public func testGetEnumIgnoreCase() {
        let r = EnumUtils.getEnumIgnoreCase(colorMap, "red")
        @Expect(r.isSome(), true)

        let y = EnumUtils.getEnumIgnoreCase(colorMap, "Yellow")
        @Expect(y.isNone(), true)
    }

    @TestCase
    public func testArrayBasedLookupAndMap() {
        let values: Array<Color> = [Color.Red, Color.Green, Color.Blue]
        let nameOf = { c: Color =>
            match (c) {
                case Red => "Red"
                case Green => "Green"
                case Blue => "Blue"
            }
        }

        @Expect(EnumUtils.isValidEnum(values, "Red", nameOf), true)
        @Expect(EnumUtils.isValidEnum(values, "Yellow", nameOf), false)

        let g = EnumUtils.getEnum(values, "Green", nameOf)
        @Expect(match (g) { case Some(v) => match (v) { case Green => true; case _ => false }; case None => false }, true)

        let m = EnumUtils.getEnumMap(values, nameOf)
        @Expect(m.contains("Blue"), true)
    }

    @TestCase
    public func testGetEnumList() {
        let list = EnumUtils.getEnumList(colorMap)
        @Expect(list.size, 3)
    }
}
