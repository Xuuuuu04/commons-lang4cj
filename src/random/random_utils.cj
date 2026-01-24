package commons_lang4cj.random

import std.random.*

/**
 * 随机数生成工具类
 * 封装了 std.random 的功能，并提供了更方便的范围随机方法
 */
public class RandomUtils {
    // 使用线程本地的 Random 实例或者每次新建（视标准库实现而定，通常建议复用）
    // 为了简单和线程安全，这里每次调用创建一个实例，或者使用标准库提供的全局方法如果存在
    // 查阅仓颉标准库，Random() 构造函数初始化一个随机数生成器

    /**
     * 生成一个随机 Int64
     *
     * @return 随机 Int64
     */
    public static func nextLong(): Int64 {
        let rng = Random()
        return rng.nextInt64()
    }

    /**
     * 生成指定范围内的随机 Int64 [start, end)
     *
     * @param startInclusive 起始值（包含）
     * @param endExclusive 结束值（不包含）
     * @return 范围内的随机数
     * @throws IllegalArgumentException 如果 startInclusive >= endExclusive
     */
    public static func nextLong(startInclusive: Int64, endExclusive: Int64): Int64 {
        if (startInclusive >= endExclusive) {
            throw IllegalArgumentException("Start value must be smaller than end value.")
        }
        let rng = Random()
        // nextInt64(limit) 生成 [0, limit)
        return startInclusive + rng.nextInt64(endExclusive - startInclusive)
    }

    /**
     * 生成一个随机 Int32
     *
     * @return 随机 Int32
     */
    public static func nextInt(): Int32 {
        let rng = Random()
        return rng.nextInt32()
    }

    /**
     * 生成指定范围内的随机 Int32 [start, end)
     *
     * @param startInclusive 起始值（包含）
     * @param endExclusive 结束值（不包含）
     * @return 范围内的随机数
     * @throws IllegalArgumentException 如果 startInclusive >= endExclusive
     */
    public static func nextInt(startInclusive: Int32, endExclusive: Int32): Int32 {
        if (startInclusive >= endExclusive) {
            throw IllegalArgumentException("Start value must be smaller than end value.")
        }
        let rng = Random()
        return startInclusive + rng.nextInt32(endExclusive - startInclusive)
    }

    /**
     * 生成一个随机 Float64 [0.0, 1.0)
     *
     * @return 随机 Float64
     */
    public static func nextDouble(): Float64 {
        let rng = Random()
        return rng.nextFloat64()
    }

    /**
     * 生成指定范围内的随机 Float64 [start, end)
     *
     * @param startInclusive 起始值（包含）
     * @param endExclusive 结束值（不包含）
     * @return 范围内的随机数
     * @throws IllegalArgumentException 如果 startInclusive >= endExclusive
     */
    public static func nextDouble(startInclusive: Float64, endExclusive: Float64): Float64 {
        if (startInclusive >= endExclusive) {
            throw IllegalArgumentException("Start value must be smaller than end value.")
        }
        let rng = Random()
        return startInclusive + ((endExclusive - startInclusive) * rng.nextFloat64())
    }

    /**
     * 生成指定长度的随机字节数组
     *
     * @param count 字节数
     * @return 随机字节数组
     * @throws IllegalArgumentException 如果 count < 0
     */
    public static func nextBytes(count: Int64): Array<Byte> {
        if (count < 0) {
            throw IllegalArgumentException("Count cannot be negative.")
        }
        let rng = Random()
        let bytes = Array<Byte>(count, repeat: 0)
        rng.nextBytes(bytes)
        return bytes
    }

    /**
     * 生成随机布尔值
     *
     * @return true 或 false
     */
    public static func nextBoolean(): Bool {
        let rng = Random()
        return rng.nextBool()
    }
}
