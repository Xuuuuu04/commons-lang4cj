package commons_lang4cj.exception

import std.collection.*

/**
 * 异常工具类，提供异常处理和操作的静态方法
 *
 * 该类提供了一系列静态方法用于异常链的遍历、类型检查、消息格式化等功能。
 * 注意：由于仓颉标准库的 Exception 不支持异常链，本工具类仅支持 ExtendedException。
 */
public class ExceptionUtils {
    /**
     * 获取异常链的根因异常
     *
     * @param throwable 异常对象
     * @return 根因异常，如果异常链没有 cause 则返回自身
     */
    public static func getRootCause(throwable: ExtendedException): ExtendedException {
        var rootCause = throwable
        while (let Some(cause) <- rootCause.cause) {
            rootCause = cause
        }
        rootCause
    }

    /**
     * 获取异常的直接原因
     *
     * @param throwable 异常对象
     * @return 直接原因异常，如果不存在则返回 None
     */
    public static func getCause(throwable: ExtendedException): Option<ExtendedException> {
        throwable.cause
    }

    /**
     * 获取异常的完整消息，包含整个异常链
     *
     * @param throwable 异常对象
     * @return 格式化后的完整消息
     */
    public static func getMessage(throwable: ExtendedException): String {
        let sb = StringBuilder()
        var current: Option<ExtendedException> = Some(throwable)

        while (let Some(ex) <- current) {
            if (sb.size > 0) {
                sb.append("\n  Caused by: ")
            }
            sb.append(formatException(ex))
            current = ex.cause
        }

        sb.toString()
    }

    /**
     * 获取根因异常的消息
     *
     * @param throwable 异常对象
     * @return 根因异常的消息
     */
    public static func getRootCauseMessage(throwable: ExtendedException): String {
        let rootCause = getRootCause(throwable)
        rootCause.message
    }

    /**
     * 获取异常链中的异常数量
     *
     * @param throwable 异常对象
     * @return 异常数量
     */
    public static func getThrowableCount(throwable: ExtendedException): Int64 {
        var count = 1
        var current = throwable.cause
        while (let Some(ex) <- current) {
            count++
            current = ex.cause
        }
        count
    }

    /**
     * 获取异常链中的所有异常
     *
     * @param throwable 异常对象
     * @return 包含所有异常的数组
     */
    public static func getThrowables(throwable: ExtendedException): Array<ExtendedException> {
        var count = getThrowableCount(throwable)
        var result = Array<ExtendedException>(count, { _ => throwable })

        var index = 0
        var current: Option<ExtendedException> = Some(throwable)

        while (let Some(ex) <- current) {
            result[index] = ex
            index++
            current = ex.cause
        }

        result
    }

    /**
     * 检查异常链中是否包含指定类型的异常
     *
     * @param throwable 异常对象
     * @param typeStr 异常类型字符串（支持精确匹配和后缀匹配）
     * @return 如果找到则返回 true，否则返回 false
     */
    public static func hasCause(throwable: ExtendedException, typeStr: String): Bool {
        var cause = throwable.cause
        while (let Some(c) <- cause) {
            let className = c.getClassName()
            if (className == typeStr || className.endsWith(".${typeStr}")) {
                return true
            }
            cause = c.cause
        }
        false
    }

    /**
     * 在异常链中查找指定类型的异常
     *
     * @param throwable 异常对象
     * @param typeStr 异常类型字符串
     * @return 找到的异常，如果未找到则返回 None
     */
    public static func findCause(throwable: ExtendedException, typeStr: String): Option<ExtendedException> {
        var cause = throwable.cause
        while (let Some(c) <- cause) {
            let className = c.getClassName()
            if (className == typeStr || className.endsWith(".${typeStr}")) {
                return Some(c)
            }
            cause = c.cause
        }
        None
    }

    /**
     * 查找指定类型异常在异常链中的索引位置
     *
     * @param throwable 异常对象
     * @param typeStr 异常类型字符串
     * @return 索引位置（从 0 开始），如果未找到则返回 -1
     */
    public static func indexOfType(throwable: ExtendedException, typeStr: String): Int64 {
        var index = 0
        var current: Option<ExtendedException> = Some(throwable)

        while (let Some(ex) <- current) {
            let className = ex.getClassName()
            if (className == typeStr || className.endsWith(".${typeStr}")) {
                return index
            }
            index++
            current = ex.cause
        }

        -1
    }

    /**
     * 根据索引获取异常链中的异常
     *
     * @param throwable 异常对象
     * @param index 索引位置（从 0 开始）
     * @return 指定位置的异常
     */
    public static func indexOfThrowable(throwable: ExtendedException, index: Int64): ExtendedException {
        if (index < 0) {
            throw IllegalArgumentException("Index must be >= 0")
        }

        var currentIndex = 0
        var current: Option<ExtendedException> = Some(throwable)

        while (let Some(ex) <- current) {
            if (currentIndex == index) {
                return ex
            }
            currentIndex++
            current = ex.cause
        }

        throw IllegalArgumentException("Index ${index} out of bounds")
    }

    /**
     * 获取异常链中的异常总数（与 getThrowableCount 功能相同）
     *
     * @param throwable 异常对象
     * @return 异常总数
     */
    public static func throwableCount(throwable: ExtendedException): Int64 {
        getThrowableCount(throwable)
    }

    /**
     * 包装受检异常
     * 在仓颉中所有异常都是非受检的，此方法直接返回原异常
     *
     * @param throwable 异常对象
     * @return 原异常对象
     */
    public static func checkedException(throwable: ExtendedException): ExtendedException {
        throwable
    }

    /**
     * 检查对象是否为异常类型
     *
     * @param throwable 待检查对象
     * @return 如果是异常则返回 true
     */
    public static func isException(_: ExtendedException): Bool {
        true
    }

    /**
     * 格式化单个异常为字符串
     *
     * @param throwable 异常对象
     * @return 格式化后的字符串
     */
    public static func formatException(throwable: ExtendedException): String {
        let className = throwable.getClassName()
        let msg = throwable.message
        if (msg.size > 0) {
            "${className}: ${msg}"
        } else {
            className
        }
    }

    /**
     * 获取异常的堆栈跟踪
     * 注意：仓颉标准库可能不提供堆栈跟踪，此方法返回异常的字符串表示
     *
     * @param throwable 异常对象
     * @return 堆栈跟踪字符串
     */
    public static func getStackTrace(throwable: ExtendedException): String {
        throwable.toString()
    }

    /**
     * 检测异常链中是否存在循环引用
     *
     * @param throwable 异常对象
     * @return 如果存在循环引用则返回 true
     */
    public static func hasCycle(throwable: ExtendedException): Bool {
        var visited = HashSet<UIntNative>()
        var current: Option<ExtendedException> = Some(throwable)

        while (let Some(ex) <- current) {
            let id = ex.getId()
            if (visited.contains(id)) {
                return true
            }
            visited.add(id)
            current = ex.cause
        }

        false
    }

    /**
     * 将异常数组转换为字符串
     *
     * @param throwables 异常数组
     * @return 格式化后的字符串
     */
    public static func throwablesToString(throwables: Array<ExtendedException>): String {
        if (throwables.size == 0) {
            return ""
        }

        let sb = StringBuilder()
        for (i in 0..throwables.size) {
            if (i > 0) {
                sb.append("\n  Caused by: ")
            }
            // 使用异常的 toString() 方法
            let ex = throwables[i]
            sb.append(ex.toString())
        }

        sb.toString()
    }
}
