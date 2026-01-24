package commons_lang4cj.mutable

/**
 * 数字接口
 * 提供数字类型转换的基本方法
 */
public interface Number {
    /**
     * 转换为 Int64
     */
    func toInt(): Int64

    /**
     * 转换为 Float32
     */
    func toFloat(): Float32

    /**
     * 转换为 Float64
     */
    func toDouble(): Float64
}
