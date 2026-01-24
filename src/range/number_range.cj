package commons_lang4cj.range

/**
 * 数值范围工厂类
 *
 * 提供创建常用数值类型的范围的便捷方法
 *
 * @since 1.0.0
 */
public class NumberRange {
    private init() {}

    /**
     * 创建整数范围
     *
     * @param from 起始值
     * @param to 结束值
     * @return 整数范围
     * @since 1.0.0
     */
    public static func ofInt(from: Int64, to: Int64): Range<Int64> {
        Range<Int64>.of(from, to)
    }

    /**
     * 创建浮点数范围
     *
     * @param from 起始值
     * @param to 结束值
     * @return 浮点数范围
     * @since 1.0.0
     */
    public static func ofDouble(from: Float64, to: Float64): Range<Float64> {
        Range<Float64>.of(from, to)
    }

    /**
     * 创建单精度浮点数范围
     *
     * @param from 起始值
     * @param to 结束值
     * @return 单精度浮点数范围
     * @since 1.0.0
     */
    public static func ofFloat(from: Float32, to: Float32): Range<Float32> {
        Range<Float32>.of(from, to)
    }
}
