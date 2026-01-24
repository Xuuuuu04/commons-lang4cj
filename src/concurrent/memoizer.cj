package commons_lang4cj.concurrent

import std.collection.concurrent.*
import std.sync.*

/**
 * 简单的缓存包装器 (Memoizer)
 * 包装一个计算函数，缓存其结果。
 * 使用 ConcurrentHashMap<K, Future<V>> 实现，避免重复计算（缓存击穿保护）。
 */
public class Memoizer<K, V> where K <: Hashable & Equatable<K> {
    private let cache = ConcurrentHashMap<K, Future<V>>()
    private let computable: (K) -> V
    private let _lock = Mutex()

    public init(computable: (K) -> V) {
        this.computable = computable
    }

    /**
     * 计算并返回结果。如果结果已缓存，直接返回；否则执行计算并缓存。
     * 线程安全，使用 Double-Check Locking 保证计算只发生一次。
     */
    public func compute(key: K): V {
        // 1. Fast Path: 先尝试获取，如果不为空直接返回
        if (let Some(f) <- cache.get(key)) {
            return waitForResult(key, f)
        }

        // 2. Slow Path: 加锁
        _lock.lock()
        var futureToWait: Future<V> = try {
            // 3. Double Check: 再次检查
            if (let Some(f) <- cache.get(key)) {
                f
            } else {
                // 4. Execute: 创建并启动任务
                let eval = spawn {
                    (computable)(key)
                }
                // 5. Cache: 放入缓存
                cache.add(key, eval)
                eval
            }
        } finally {
            _lock.unlock()
        }

        // 6. Return
        return waitForResult(key, futureToWait)
    }

    private func waitForResult(key: K, f: Future<V>): V {
        try {
            return f.get()
        } catch (e: Exception) {
            // 如果计算失败，移除缓存，以便重试
            cache.remove(key)
            throw e
        }
    }

    /**
     * 移除缓存
     */
    public func forget(key: K): Unit {
        cache.remove(key)
    }
}
