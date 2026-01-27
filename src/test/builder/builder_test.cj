package commons_lang4cj.test.builder

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.builder.*

public class Box {
    public let value: Int64
    public init(value: Int64) {
        this.value = value
    }
}

@Test
class BuilderTest {
    @TestCase
    func testBuilderInterface() {
        let b = object : Builder<Box> {
            public func build(): Box {
                Box(42)
            }
        }
        @Expect(b.build().value, 42)
    }
}

