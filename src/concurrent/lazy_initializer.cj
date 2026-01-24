package commons_lang4cj.concurrent

import std.sync.*

/**
 * LazyInitializer 延迟初始化器抽象类
 *
 * 实现双重检查锁定模式，用于安全地延迟初始化对象
 *
 * @param T 初始化对象的类型
 * @since 1.0.0
 */
public abstract class LazyInitializer<T> {
    private var object: Option<T> = None
    private let mutex = Mutex()

    /**
     * 获取对象实例
     *
     * 如果对象尚未初始化，则调用 initialize() 进行初始化
     *
     * @return 对象实例
     */
    public func get(): T {
        // 第一重检查
        if (let Some(obj) <- object) {
            return obj
        }

        // 加锁
        mutex.lock()
        try {
            // 第二重检查
            if (let Some(obj) <- object) {
                return obj
            }

            // 初始化
            let obj = initialize()
            object = Some(obj)
            return obj
        } finally {
            mutex.unlock()
        }
    }

    /**
     * 初始化对象
     *
     * 子类需实现此方法以创建对象实例
     *
     * @return 创建的对象实例
     */
    protected func initialize(): T
}
