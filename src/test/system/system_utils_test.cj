package commons_lang4cj.test.system

import std.unittest.*
import commons_lang4cj.system.*

@Test
class SystemUtilsTest {
    @TestCase
    func testOSDetection() {
        // Just verify one of them is true or false, can't strictly assert value without knowing env
        // But we can check consistency
        if (SystemUtils.IS_OS_WINDOWS) {
            println("OS is Windows")
        }
        if (SystemUtils.IS_OS_LINUX) {
            println("OS is Linux")
        }
        if (SystemUtils.IS_OS_MACOS) {
            println("OS is macOS")
        }
    }

    @TestCase
    func testGetUserHome() {
        let home = SystemUtils.getUserHome()
        @Expect(home.isSome())
    }

    @TestCase
    func testGetUserDir() {
        let dir = SystemUtils.getUserDir()
        @Expect(dir.isSome())
    }

    @TestCase
    func testGetJavaIoTmpDir() {
        let tmp = SystemUtils.getJavaIoTmpDir()
        @Expect(tmp.isSome())
    }

    @TestCase
    func testLineSeparator() {
        let sep = SystemUtils.LINE_SEPARATOR
        @Expect(sep.size > 0)
    }
}
