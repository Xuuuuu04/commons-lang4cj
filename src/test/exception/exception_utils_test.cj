package commons_lang4cj.test.exception

import commons_lang4cj.exception.*
import std.unittest.*
import std.unittest.testmacro.*

/**
 * ExceptionUtils 测试类
 */
@Test
class ExceptionUtilsTest {
    /**
     * 测试获取根因异常（无 cause）
     */
    @TestCase
    func testGetRootCauseNoCause() {
        let ex = ExtendedException("No cause")
        let root = ExceptionUtils.getRootCause(ex)
        @Expect(root.getId() == ex.getId(), true)
    }

    /**
     * 测试获取根因异常（多层 cause）
     */
    @TestCase
    func testGetRootCauseMultipleCauses() {
        let root = ExtendedException("Root error")
        let middle = ExtendedException("Middle error", root)
        let top = ExtendedException("Top error", middle)

        let rootCause = ExceptionUtils.getRootCause(top)
        @Expect(rootCause.getId() == root.getId(), true)
    }

    /**
     * 测试获取直接原因
     */
    @TestCase
    func testGetCause() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Exception", cause)

        let result = ExceptionUtils.getCause(ex)
        if (let Some(c) <- result) {
            @Expect(c.getId() == cause.getId(), true)
        } else {
            @Expect(false, true)  // 不应该到达这里
        }
    }

    /**
     * 测试获取直接原因（无 cause）
     */
    @TestCase
    func testGetCauseNoCause() {
        let ex = ExtendedException("No cause")
        let result = ExceptionUtils.getCause(ex)
        @Expect(result.isNone(), true)
    }

    /**
     * 测试获取完整消息
     */
    @TestCase
    func testGetMessage() {
        let cause = ExtendedException("Cause error")
        let ex = ExtendedException("Main error", cause)

        let msg = ExceptionUtils.getMessage(ex)
        let expectedContains = "Main error"
        @Expect(msg.contains(expectedContains), true)
    }

    /**
     * 测试获取根因消息
     */
    @TestCase
    func testGetRootCauseMessage() {
        let root = ExtendedException("Root message")
        let ex = ExtendedException("Wrapper", root)

        let rootMsg = ExceptionUtils.getRootCauseMessage(ex)
        @Expect(rootMsg, "Root message")
    }

    /**
     * 测试获取异常数量
     */
    @TestCase
    func testGetThrowableCount() {
        let cause1 = ExtendedException("Cause 1")
        let cause2 = ExtendedException("Cause 2", cause1)
        let ex = ExtendedException("Main", cause2)

        let count = ExceptionUtils.getThrowableCount(ex)
        @Expect(count, 3)
    }

    /**
     * 测试获取所有异常
     */
    @TestCase
    func testGetThrowables() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Main", cause)

        let throwables = ExceptionUtils.getThrowables(ex)
        @Expect(throwables.size, 2)
    }

    /**
     * 测试获取异常列表
     * 注意：由于 ArrayList 限制，此方法已删除，使用 getThrowables 代替
     */
    @TestCase
    func testGetThrowablesAsList() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Main", cause)

        let array = ExceptionUtils.getThrowables(ex)
        @Expect(array.size, 2)
    }

    /**
     * 测试检查异常类型（精确匹配）
     */
    @TestCase
    func testHasCauseExactMatch() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Main", cause)

        let hasIt = ExceptionUtils.hasCause(ex, "ExtendedException")
        @Expect(hasIt, true)
    }

    /**
     * 测试检查异常类型（未找到）
     */
    @TestCase
    func testHasCauseNotFound() {
        let ex = ExtendedException("Main")

        let hasIt = ExceptionUtils.hasCause(ex, "SomeOtherException")
        @Expect(hasIt, false)
    }

    /**
     * 测试查找异常（找到）
     */
    @TestCase
    func testFindCauseFound() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Main", cause)

        let result = ExceptionUtils.findCause(ex, "ExtendedException")
        if (let Some(c) <- result) {
            @Expect(c.getId() == cause.getId(), true)
        } else {
            @Expect(false, true)
        }
    }

    /**
     * 测试查找异常（未找到）
     */
    @TestCase
    func testFindCauseNotFound() {
        let ex = ExtendedException("Main")

        let result = ExceptionUtils.findCause(ex, "NonExistent")
        @Expect(result.isNone(), true)
    }

    /**
     * 测试查找类型索引
     */
    @TestCase
    func testIndexOfType() {
        let ex = ExtendedException("Main")
        let index = ExceptionUtils.indexOfType(ex, "ExtendedException")
        @Expect(index, 0)
    }

    /**
     * 测试按索引获取异常
     */
    @TestCase
    func testIndexOfThrowable() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Main", cause)

        let ex0 = ExceptionUtils.indexOfThrowable(ex, 0)
        let ex1 = ExceptionUtils.indexOfThrowable(ex, 1)

        @Expect(ex0.getId() == ex.getId(), true)
        @Expect(ex1.getId() == cause.getId(), true)
    }

    /**
     * 测试按索引获取异常（越界）
     */
    @TestCase
    func testIndexOfThrowableOutOfBounds() {
        let ex = ExtendedException("Main")

        try {
            let _ = ExceptionUtils.indexOfThrowable(ex, 10)
            @Expect(false, true)  // 不应该到达这里
        } catch (e: IllegalArgumentException) {
            @Expect(true, true)  // 期望抛出异常
        }
    }

    /**
     * 测试异常总数
     */
    @TestCase
    func testThrowableCount() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Main", cause)

        let count = ExceptionUtils.throwableCount(ex)
        @Expect(count, 2)
    }

    /**
     * 测试检查是否为异常
     */
    @TestCase
    func testIsException() {
        let ex = ExtendedException("Test")
        @Expect(ExceptionUtils.isException(ex), true)
    }

    /**
     * 测试格式化异常
     */
    @TestCase
    func testFormatException() {
        let ex = ExtendedException("Test message")
        let formatted = ExceptionUtils.formatException(ex)

        @Expect(formatted.contains("ExtendedException"), true)
        @Expect(formatted.contains("Test message"), true)
    }

    /**
     * 测试格式化异常（无消息）
     */
    @TestCase
    func testFormatExceptionNoMessage() {
        let ex = ExtendedException("")
        let formatted = ExceptionUtils.formatException(ex)

        @Expect(formatted.contains("ExtendedException"), true)
    }

    /**
     * 测试获取堆栈跟踪
     */
    @TestCase
    func testGetStackTrace() {
        let ex = ExtendedException("Test")
        let stack = ExceptionUtils.getStackTrace(ex)

        @Expect(stack.size > 0, true)
    }

    /**
     * 测试循环引用检测（无循环）
     */
    @TestCase
    func testHasCycleNoCycle() {
        let cause = ExtendedException("Cause")
        let ex = ExtendedException("Main", cause)

        @Expect(ExceptionUtils.hasCycle(ex), false)
    }

    /**
     * 测试异常数组转字符串
     */
    @TestCase
    func testThrowablesToString() {
        let ex1 = ExtendedException("Error 1")
        let ex2 = ExtendedException("Error 2")

        let array = [ex1, ex2]
        let result = ExceptionUtils.throwablesToString(array)

        @Expect(result.contains("Error 1"), true)
        @Expect(result.contains("Error 2"), true)
    }

    /**
     * 测试空异常数组转字符串
     */
    @TestCase
    func testThrowablesToStringEmpty() {
        let array = Array<ExtendedException>()
        let result = ExceptionUtils.throwablesToString(array)

        @Expect(result, "")
    }
}
