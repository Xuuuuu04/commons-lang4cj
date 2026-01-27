package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.*

@Test
class BitFieldTest {
    @TestCase
    func testGetAndSet() {
        let bf = BitField(0b11110000)
        @Expect(bf.getRawValue(0b10101111), 0b10100000)
        @Expect(bf.getValue(0b10101111), 0b1010)

        let setRaw = bf.setRawValue(0b00001111, 0b10100000)
        @Expect(setRaw, 0b10101111)

        let setVal = bf.setValue(0b00001111, 0b0101)
        @Expect(setVal, 0b01011111)
    }

    @TestCase
    func testFlags() {
        let bf = BitField(0b00000101)
        @Expect(bf.isSet(0b00000000), false)
        @Expect(bf.isSet(0b00000001), true)
        @Expect(bf.isAllSet(0b00000101), true)
        @Expect(bf.isAllSet(0b00000001), false)

        @Expect(bf.set(0b00000000), 0b00000101)
        @Expect(bf.clear(0b11111111), 0b11111010)
    }
}

