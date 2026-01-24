package commons_lang4cj.test.concurrent

import std.unittest.*
import std.unittest.testmacro.*
import std.sync.*
import std.time.*
import commons_lang4cj.concurrent.*

class MockBackgroundInitializer <: BackgroundInitializer<Int64> {
    protected override func initialize(): Int64 {
        sleep(Duration.millisecond * 100) // 模拟耗时操作
        return 42
    }
}

@Test
class BackgroundInitializerTest {
    @TestCase
    func testStartAndGet() {
        let bgInit = MockBackgroundInitializer()
        @Expect(bgInit.isStarted(), false)

        let started = bgInit.start()
        @Expect(started, true)
        @Expect(bgInit.isStarted(), true)

        let result = bgInit.get()
        @Expect(result, 42)

        // 再次启动应返回 false
        @Expect(bgInit.start(), false)
    }

    @TestCase
    func testGetWithoutStart() {
        let bgInit = MockBackgroundInitializer()
        try {
            bgInit.get()
            throw Exception("Should throw Exception")
        } catch (e: Exception) {
            @Expect(e.message, "Cannot get result: start() method was not called")
        }
    }
}
