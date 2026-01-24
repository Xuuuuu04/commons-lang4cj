package commons_lang4cj.concurrent

import std.sync.*

/**
 * 在后台线程中初始化并生成对象的辅助类。
 *
 * 使用者需要继承此类并实现 `initialize()` 方法。
 * 调用 `start()` 方法启动后台初始化。
 * 调用 `get()` 方法获取结果（如果未完成则阻塞等待）。
 */
public abstract class BackgroundInitializer<T> {
    private var _future: Option<Future<T>> = None
    private let _lock = Mutex()

    /**
     * 子类必须实现此方法以执行具体的初始化逻辑。
     * 此方法将在后台线程中运行。
     */
    protected func initialize(): T

    /**
     * 启动后台初始化任务。
     * 如果任务已经启动，则此方法不执行任何操作并返回 false。
     *
     * @return 如果成功启动新任务返回 true，否则返回 false
     */
    public func start(): Bool {
        _lock.lock()
        try {
            if (isStarted()) {
                return false
            }

            // 启动后台协程
            let fut = spawn {
                this.initialize()
            }
            this._future = Some(fut)
            return true
        } finally {
            _lock.unlock()
        }
    }

    /**
     * 获取初始化结果。
     * 如果后台任务尚未完成，此方法将阻塞直到任务完成。
     * 必须先调用 `start()` 方法。
     *
     * @return 初始化生成的对象
     * @throws Exception 如果 start() 尚未被调用
     */
    public func get(): T {
        // 获取 future 的副本以在锁外等待，避免死锁
        var futOpt: Option<Future<T>> = None
        _lock.lock()
        try {
            futOpt = this._future
        } finally {
            _lock.unlock()
        }

        match (futOpt) {
            case Some(fut) => return fut.get()
            case None => throw Exception("Cannot get result: start() method was not called")
        }
    }

    /**
     * 检查后台任务是否已启动。
     *
     * @return 如果已启动返回 true
     */
    public func isStarted(): Bool {
        _lock.lock()
        try {
            match (_future) {
                case Some(_) => true
                case None => false
            }
        } finally {
            _lock.unlock()
        }
    }
}
