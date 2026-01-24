package commons_lang4cj.concurrent

import std.sync.*
import std.time.*
import std.deriving.*

@Derive[Equatable, ToString]
public enum CircuitBreakerState {
    | CLOSED
    | OPEN
    | HALF_OPEN
}

/**
 * 一个简单的基于失败次数阈值的熔断器实现。
 *
 * 状态流转逻辑：
 * 1. 初始状态为 CLOSED。
 * 2. 当 incrementAndCheckState() 被调用且失败次数达到阈值时，状态变为 OPEN。
 * 3. 当处于 OPEN 状态且经过了指定的 timeout 时间后，checkState() 会将状态转换为 HALF_OPEN。
 * 4. 在 HALF_OPEN 状态下：
 *    - 如果再次失败 (incrementAndCheckState)，状态立即变为 OPEN。
 *    - 如果成功 (close)，状态变为 CLOSED。
 */
public class ThresholdCircuitBreaker {
    private let _threshold: Int64
    private let _timeout: Duration

    // 保护内部状态的锁
    private let _lock = Mutex()

    // 内部状态变量
    private var _state = CircuitBreakerState.CLOSED
    private var _failureCount: Int64 = 0
    // 记录变为 OPEN 的时间
    private var _openStartTime: DateTime = DateTime.now()

    /**
     * 创建一个新的阈值熔断器。
     *
     * @param threshold 触发熔断的失败次数阈值
     * @param timeout 熔断后尝试重置的等待时间
     */
    public init(threshold: Int64, timeout: Duration) {
        if (threshold <= 0) {
            throw IllegalArgumentException("Threshold must be greater than 0")
        }
        this._threshold = threshold
        this._timeout = timeout
    }

    /**
     * 增加失败计数并检查是否需要熔断。
     *
     * 如果当前是 CLOSED，增加计数；如果达到阈值，变为 OPEN。
     * 如果当前是 HALF_OPEN，直接变为 OPEN。
     * 如果当前是 OPEN，保持 OPEN，更新时间。
     *
     * @return 如果熔断器处于 OPEN 状态，返回 true；否则返回 false
     */
    public func incrementAndCheckState(): Bool {
        _lock.lock()
        try {
            match (_state) {
                case CircuitBreakerState.CLOSED =>
                    _failureCount++
                    if (_failureCount >= _threshold) {
                        open()
                    }
                case CircuitBreakerState.HALF_OPEN =>
                    open()
                case CircuitBreakerState.OPEN =>
                    // 已经在 OPEN 状态，保持
                    ()
            }
            return isOpen()
        } finally {
            _lock.unlock()
        }
    }

    /**
     * 检查并返回当前状态。
     * 此方法可能会触发从 OPEN 到 HALF_OPEN 的状态转换。
     */
    public func checkState(): CircuitBreakerState {
        _lock.lock()
        try {
            if (isOpen()) {
                // 检查是否超时
                let now = DateTime.now()
                let durationSinceOpen = now - _openStartTime

                if (durationSinceOpen >= _timeout) {
                    _state = CircuitBreakerState.HALF_OPEN
                }
            }
            return _state
        } finally {
            _lock.unlock()
        }
    }

    /**
     * 重置熔断器到 CLOSED 状态。
     * 应该在操作成功时调用此方法。
     */
    public func close(): Unit {
        _lock.lock()
        try {
            _state = CircuitBreakerState.CLOSED
            _failureCount = 0
        } finally {
            _lock.unlock()
        }
    }

    /**
     * 内部辅助方法：转为 OPEN 状态
     * 必须在锁内调用
     */
    private func open(): Unit {
        _state = CircuitBreakerState.OPEN
        _openStartTime = DateTime.now()
        _failureCount = 0
    }

    /**
     * 简单的状态判断辅助方法
     */
    public func isOpen(): Bool {
        _lock.lock()
        try {
            match (_state) {
                case CircuitBreakerState.OPEN => true
                case _ => false
            }
        } finally {
            _lock.unlock()
        }
    }

    public func isClosed(): Bool {
        _lock.lock()
        try {
            match (_state) {
                case CircuitBreakerState.CLOSED => true
                case _ => false
            }
        } finally {
            _lock.unlock()
        }
    }
}
