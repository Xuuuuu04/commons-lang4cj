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
    public func testGetEnumList() {
        let list = EnumUtils.getEnumList(colorMap)
        @Expect(list.size, 3)
    }
}
