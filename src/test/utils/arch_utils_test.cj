package commons_lang4cj.test.utils

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.utils.ArchUtils
import commons_lang4cj.arch.*

@Test
class ArchUtilsTest {
    @TestCase
    func testGetProcessorByKey() {
        let p1 = ArchUtils.getProcessor("amd64")
        @Expect(p1.isSome(), true)
        match (p1) {
            case Some(p) =>
                @Expect(p.getType().toString(), ProcessorType.X86.toString())
                @Expect(p.getArch().toString(), ProcessorArch.BIT_64.toString())
            case None => ()
        }

        let p2 = ArchUtils.getProcessor("i386")
        @Expect(p2.isSome(), true)
        match (p2) {
            case Some(p) =>
                @Expect(p.getType().toString(), ProcessorType.X86.toString())
                @Expect(p.getArch().toString(), ProcessorArch.BIT_32.toString())
            case None => ()
        }
    }
}

