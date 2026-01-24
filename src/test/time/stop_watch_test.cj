package commons_lang4cj.test.time

import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import commons_lang4cj.time.*

/**
 * StopWatch 单元测试
 *
 * 测试覆盖：
 * - 基础计时功能（start/stop/getTime）
 * - 分段计时功能（split/unsplit）
 * - 暂停/恢复功能（suspend/resume）
 * - 复位功能（reset）
 * - 状态查询（isStarted/isStopped/isSuspended/isSplit）
 * - 格式化输出（toString/toSplitString）
 * - 异常处理
 *
 * @since 1.2.0
 */
@Test
class StopWatchTest {
    /**
     * 测试基础 start/stop 功能
     */
    @TestCase
    func testBasicStartStop() {
        let sw = StopWatch.create()
        @Expect(sw.isStarted(), false)
        @Expect(sw.isStopped(), false)

        sw.start()
        @Expect(sw.isStarted(), true)
        @Expect(sw.isStopped(), false)

        sleep(Duration.millisecond * 100)
        sw.stop()

        @Expect(sw.isStopped(), true)
        let time = sw.getTime()
        @Expect(time >= 100 && time < 200, true)
    }

    /**
     * 测试重复 start() 抛出异常
     */
    @TestCase
    func testStartTwice() {
        let sw = StopWatch.create()
        sw.start()
        @ExpectThrows[IllegalStateException](sw.start())  // 应该抛出异常
    }

    /**
     * 测试未 start 就 stop() 抛出异常
     */
    @TestCase
    func testStopWithoutStart() {
        let sw = StopWatch.create()
        @ExpectThrows[IllegalStateException](sw.stop())  // 应该抛出异常
    }

    /**
     * 测试重复 stop() 抛出异常
     */
    @TestCase
    func testStopTwice() {
        let sw = StopWatch.create()
        sw.start()
        sw.stop()
        @ExpectThrows[IllegalStateException](sw.stop())  // 应该抛出异常
    }

    /**
     * 测试分段计时功能
     */
    @TestCase
    func testSplit() {
        let sw = StopWatch.create()
        sw.start()

        @Expect(sw.isSplit(), false)

        sleep(Duration.millisecond * 50)
        sw.split()

        @Expect(sw.isSplit(), true)
        let splitTime = sw.getSplitTime()
        @Expect(splitTime >= 50 && splitTime < 100, true)

        sleep(Duration.millisecond * 50)
        sw.stop()

        let totalTime = sw.getTime()
        @Expect(totalTime >= 100 && totalTime < 200, true)
        @Expect(totalTime > splitTime, true)  // 总时长应大于分段时间
    }

    /**
     * 测试多次分段
     */
    @TestCase
    func testMultipleSplits() {
        let sw = StopWatch.create()
        sw.start()

        sleep(Duration.millisecond * 50)
        sw.split()
        let split1 = sw.getSplitTime()
        @Expect(split1 >= 50 && split1 < 100, true)

        sw.unsplit()
        @Expect(sw.isSplit(), false)

        sleep(Duration.millisecond * 50)
        sw.split()
        let split2 = sw.getSplitTime()
        @Expect(split2 >= 100 && split2 < 200, true)

        @Expect(split2 > split1, true)  // 第二次分段应该更长
    }

    /**
     * 测试未分段就调用 getSplitTime() 抛出异常
     */
    @TestCase
    func testGetSplitTimeWithoutSplit() {
        let sw = StopWatch.create()
        sw.start()
        @ExpectThrows[IllegalStateException](sw.getSplitTime())  // 应该抛出异常
    }

    /**
     * 测试未分段就调用 unsplit() 抛出异常
     */
    @TestCase
    func testUnsplitWithoutSplit() {
        let sw = StopWatch.create()
        sw.start()
        @ExpectThrows[IllegalStateException](sw.unsplit())  // 应该抛出异常
    }

    /**
     * 测试暂停/恢复功能
     */
    @TestCase
    func testSuspendResume() {
        let sw = StopWatch.create()
        sw.start()

        sleep(Duration.millisecond * 50)
        sw.suspend()
        @Expect(sw.isSuspended(), true)

        sleep(Duration.millisecond * 50)  // 不计时

        sw.resume()
        @Expect(sw.isSuspended(), false)

        sleep(Duration.millisecond * 50)
        sw.stop()

        let time = sw.getTime()
        @Expect(time >= 100 && time < 150, true)  // 约 100ms，暂停期间不计时
    }

    /**
     * 测试重复 suspend() 抛出异常
     */
    @TestCase
    func testSuspendTwice() {
        let sw = StopWatch.create()
        sw.start()
        sw.suspend()
        @ExpectThrows[IllegalStateException](sw.suspend())  // 应该抛出异常
    }

    /**
     * 测试未 suspend 就 resume() 抛出异常
     */
    @TestCase
    func testResumeWithoutSuspend() {
        let sw = StopWatch.create()
        sw.start()
        @ExpectThrows[IllegalStateException](sw.resume())  // 应该抛出异常
    }

    /**
     * 测试多次暂停/恢复
     */
    @TestCase
    func testMultipleSuspendResume() {
        let sw = StopWatch.create()
        sw.start()

        sleep(Duration.millisecond * 30)
        sw.suspend()
        sleep(Duration.millisecond * 20)
        sw.resume()

        sleep(Duration.millisecond * 30)
        sw.suspend()
        sleep(Duration.millisecond * 20)
        sw.resume()

        sleep(Duration.millisecond * 30)
        sw.stop()

        let time = sw.getTime()
        @Expect(time >= 90 && time < 120, true)  // 约 90ms
    }

    /**
     * 测试复位功能
     */
    @TestCase
    func testReset() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 100)
        sw.stop()

        @Expect(sw.isStarted(), true)
        @Expect(sw.isStopped(), true)

        sw.reset()

        @Expect(sw.isStarted(), false)
        @Expect(sw.isStopped(), false)
        @Expect(sw.isSplit(), false)
        @Expect(sw.isSuspended(), false)
    }

    /**
     * 测试 getTime() 和 getNanoTime()
     */
    @TestCase
    func testGetTimeVsGetNanoTime() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 100)
        sw.stop()

        let timeMs = sw.getTime()
        let timeNs = sw.getNanoTime()

        @Expect(timeMs >= 100 && timeMs < 200, true)
        @Expect(timeNs >= 100000000 && timeNs < 200000000, true)

        // 验证纳秒和毫秒的关系
        @Expect(timeNs / 1000000, timeMs)
    }

    /**
     * 测试 getSplitNanoTime()
     */
    @TestCase
    func testGetSplitNanoTime() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 50)
        sw.split()

        let splitMs = sw.getSplitTime()
        let splitNs = sw.getSplitNanoTime()

        @Expect(splitMs >= 50 && splitMs < 100, true)
        @Expect(splitNs >= 50000000 && splitNs < 100000000, true)
        @Expect(splitNs / 1000000, splitMs)
    }

    /**
     * 测试 toString() 格式
     */
    @TestCase
    func testToString() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 1234)
        sw.stop()

        let str = sw.toString()
        // 验证格式 "HH:mm:ss.SSS"
        let parts = str.split(".")
        @Expect(parts.size, 2)

        let timeParts = parts[0].split(":")
        @Expect(timeParts.size, 3)

        // 验证总时长约为 1.234 秒
        @Expect(str.contains("00:00:01"), true)
    }

    /**
     * 测试 toSplitString() 格式
     */
    @TestCase
    func testToSplitString() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 500)
        sw.split()

        let str = sw.toSplitString()
        // 验证格式 "HH:mm:ss.SSS"
        let parts = str.split(".")
        @Expect(parts.size, 2)

        let timeParts = parts[0].split(":")
        @Expect(timeParts.size, 3)
    }

    /**
     * 测试 getStartTime() 方法
     */
    @TestCase
    func testGetStartTime() {
        let sw = StopWatch.create()
        sw.start()

        let startTime = sw.getStartTime()
        @Expect(startTime > 0, true)

        sleep(Duration.millisecond * 100)
        sw.stop()

        // 开始时间应该不变
        @Expect(startTime, sw.getStartTime())
    }

    /**
     * 测试未 start 就调用 getStartTime() 抛出异常
     */
    @TestCase
    func testGetStartTimeWithoutStart() {
        let sw = StopWatch.create()
        @ExpectThrows[IllegalStateException](sw.getStartTime())  // 应该抛出异常
    }

    /**
     * 测试长时间计时（超过 1 秒）
     */
    @TestCase
    func testLongDuration() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 1500)
        sw.stop()

        let time = sw.getTime()
        @Expect(time >= 1500 && time < 1600, true)

        let str = sw.toString()
        // 验证格式 "00:00:01.xxx"
        @Expect(str.contains("00:00:01"), true)
    }

    /**
     * 测试复位后重新开始
     */
    @TestCase
    func testResetAndRestart() {
        let sw = StopWatch.create()
        sw.start()
        sleep(Duration.millisecond * 100)
        sw.stop()

        let time1 = sw.getTime()
        @Expect(time1 >= 100 && time1 < 200, true)

        sw.reset()
        sw.start()
        sleep(Duration.millisecond * 50)
        sw.stop()

        let time2 = sw.getTime()
        @Expect(time2 >= 50 && time2 < 100, true)
        @Expect(time2 < time1, true)  // 第二次应该更短
    }
}
