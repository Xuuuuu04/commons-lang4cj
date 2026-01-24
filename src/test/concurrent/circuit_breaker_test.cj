package commons_lang4cj.test.concurrent

import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import commons_lang4cj.concurrent.*

@Test
class ThresholdCircuitBreakerTest {

    @TestCase
    func testCircuitBreakerFlow() {
        // 阈值 3 次，超时 100 毫秒
        let breaker = ThresholdCircuitBreaker(3, Duration.millisecond * 100)

        // 1. 初始状态 CLOSED
        @Expect(breaker.isClosed(), true)
        @Expect(breaker.isOpen(), false)
        @Expect(breaker.checkState(), CircuitBreakerState.CLOSED)

        // 2. 累积失败次数 (1/3)
        var open = breaker.incrementAndCheckState()
        @Expect(open, false)
        @Expect(breaker.isClosed(), true)

        // 3. 累积失败次数 (2/3)
        open = breaker.incrementAndCheckState()
        @Expect(open, false)

        // 4. 触发熔断 (3/3) -> OPEN
        open = breaker.incrementAndCheckState()
        @Expect(open, true)
        @Expect(breaker.isOpen(), true)
        @Expect(breaker.checkState(), CircuitBreakerState.OPEN)

        // 5. 在 OPEN 状态下，再次失败应保持 OPEN
        open = breaker.incrementAndCheckState()
        @Expect(open, true)

        // 6. 等待超时 ( > 100ms)
        sleep(Duration.millisecond * 150)

        // 7. 检查状态 -> HALF_OPEN
        // checkState 会触发状态转换
        let state = breaker.checkState()
        @Expect(state, CircuitBreakerState.HALF_OPEN)

        // 8. HALF_OPEN -> OPEN (再次失败测试)
        // 在半开状态下，一次失败就会导致再次熔断
        open = breaker.incrementAndCheckState()
        @Expect(open, true)
        @Expect(breaker.isOpen(), true)

        // 9. 再次等待超时
        sleep(Duration.millisecond * 150)
        @Expect(breaker.checkState(), CircuitBreakerState.HALF_OPEN)

        // 10. HALF_OPEN -> CLOSED (成功恢复测试)
        breaker.close()
        @Expect(breaker.isClosed(), true)
        @Expect(breaker.checkState(), CircuitBreakerState.CLOSED)
    }

    @TestCase
    func testInvalidArgument() {
        try {
            ThresholdCircuitBreaker(0, Duration.second)
            throw Exception("Should throw IllegalArgumentException")
        } catch (e: IllegalArgumentException) {
            // expected
        }
    }
}
