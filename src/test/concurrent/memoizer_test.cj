package commons_lang4cj.test.concurrent

import std.unittest.*
import std.sync.*
import std.time.*
import std.collection.*
import commons_lang4cj.concurrent.*

@Test
public class MemoizerTest {

    @TestCase
    public func testCompute() {
        let counter = AtomicInt64(0)
        let memoizer = Memoizer<String, Int64>({ key =>
            counter.fetchAdd(1)
            return key.size
        })

        // 第一次调用
        let v1 = memoizer.compute("hello")
        @Expect(v1, 5)
        @Expect(counter.load(), 1)

        // 第二次调用，应该走缓存，counter 不变
        let v2 = memoizer.compute("hello")
        @Expect(v2, 5)
        @Expect(counter.load(), 1)

        // 不同 key
        let v3 = memoizer.compute("world")
        @Expect(v3, 5)
        @Expect(counter.load(), 2)
    }

    @TestCase
    public func testConcurrentCompute() {
        let counter = AtomicInt64(0)
        // 模拟耗时计算
        let memoizer = Memoizer<String, Int64>({ key =>
            sleep(Duration.millisecond * 100)
            counter.fetchAdd(1)
            return 42
        })

        let threads = Array<Future<Int64>>(10, { i =>
            spawn {
                memoizer.compute("concurrent")
            }
        })

        for (t in threads) {
            let res = t.get()
            @Expect(res, 42)
        }

        // 验证只计算了一次
        @Expect(counter.load(), 1)
    }

    @TestCase
    public func testExceptionHandling() {
         let memoizer = Memoizer<String, Int64>({ key =>
            if (key == "error") {
                throw IllegalArgumentException("fail")
            }
            return 0
        })

        try {
            memoizer.compute("error")
            throw Exception("Should throw exception")
        } catch (e: IllegalArgumentException) {
            // expected
        }

        // Retry should try again (and fail again, but invoke function again if we removed it)
        // Note: Our implementation removes failed futures.
         try {
            memoizer.compute("error")
            throw Exception("Should throw exception")
        } catch (e: IllegalArgumentException) {
            // expected
        }
    }
}
