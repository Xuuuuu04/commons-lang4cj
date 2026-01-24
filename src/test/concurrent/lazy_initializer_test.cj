package commons_lang4cj.test.concurrent

import std.unittest.*
import std.sync.*
import std.time.*
import std.collection.*
import commons_lang4cj.concurrent.*

class MockInitializer <: LazyInitializer<ArrayList<Int64>> {
    public var initCount = AtomicInt64(0)

    protected override func initialize(): ArrayList<Int64> {
        initCount.fetchAdd(1)
        // 模拟耗时操作
        sleep(Duration.millisecond * 50)
        return ArrayList<Int64>([1, 2, 3])
    }
}

@Test
class LazyInitializerTest {
    @TestCase
    func testGet() {
        let initializer = MockInitializer()

        // 第一次获取
        let obj1 = initializer.get()
        @Expect(obj1.size, 3)
        @Expect(initializer.initCount.load(), 1)

        // 第二次获取
        let obj2 = initializer.get()
        @Expect(obj2.size, 3)
        @Expect(initializer.initCount.load(), 1) // 应该只初始化一次
    }

    @TestCase
    func testConcurrentGet() {
        let initializer = MockInitializer()
        // 增加并发强度到 50 个线程
        let threadCount = 50
        // 使用 Array 替代 ArrayList 避免泛型兼容性问题
        // 使用构造函数 Array<T>(size, init: (Int64)->T)
        let futures = Array<Future<Unit>>(threadCount, { _ =>
             spawn {
                let obj = initializer.get()
                if (obj.size != 3) {
                    throw Exception("Invalid object size")
                }
            }
        })

        // 等待所有线程完成
        for (fut in futures) {
            fut.get()
        }

        // 验证只初始化了一次
        @Expect(initializer.initCount.load(), 1)
    }
}
