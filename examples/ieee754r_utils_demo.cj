package commons_lang4cj

import commons_lang4cj.math.IEEE754rUtils

/**
 * IEEE754rUtils 使用示例
 *
 * 演示 IEEE754rUtils 的各种功能
 */
main() {
    println("========== IEEE754rUtils 使用示例 ==========\n")

    // 1. NaN 检查
    println("1. NaN 检查示例:")
    let nan = 0.0 / 0.0
    println("   0.0 / 0.0 是 NaN? ${IEEE754rUtils.isNaN(nan)}")
    println("   1.0 是 NaN? ${IEEE754rUtils.isNaN(1.0)}")
    println()

    // 2. 无穷大检查
    println("2. 无穷大检查示例:")
    let posInf = 1.0 / 0.0
    let negInf = -1.0 / 0.0
    println("   1.0 / 0.0 是无穷大? ${IEEE754rUtils.isInfinite(posInf)}")
    println("   -1.0 / 0.0 是无穷大? ${IEEE754rUtils.isInfinite(negInf)}")
    println("   1.0 是无穷大? ${IEEE754rUtils.isInfinite(1.0)}")
    println()

    // 3. 浮点数比较
    println("3. 浮点数比较示例:")
    let cmp1 = IEEE754rUtils.compare(1.0, 2.0)
    let cmp2 = IEEE754rUtils.compare(2.0, 1.0)
    let cmp3 = IEEE754rUtils.compare(1.0, 1.0)
    println("   compare(1.0, 2.0) = ${cmp1}")
    println("   compare(2.0, 1.0) = ${cmp2}")
    println("   compare(1.0, 1.0) = ${cmp3}")
    println()

    // 4. NaN 比较
    println("4. NaN 比较示例:")
    let cmp4 = IEEE754rUtils.compare(nan, 1.0)
    let cmp5 = IEEE754rUtils.compare(1.0, nan)
    let cmp6 = IEEE754rUtils.compare(nan, nan)
    println("   compare(NaN, 1.0) = ${cmp4} (NaN < 所有值)")
    println("   compare(1.0, NaN) = ${cmp5}")
    println("   compare(NaN, NaN) = ${cmp6} (两个 NaN 视为相等)")
    println()

    // 5. 最小值/最大值 (双参数)
    println("5. 最小值/最大值示例 (双参数):")
    let min1 = IEEE754rUtils.min(1.0, 2.0)
    let max1 = IEEE754rUtils.max(1.0, 2.0)
    println("   min(1.0, 2.0) = ${min1}")
    println("   max(1.0, 2.0) = ${max1}")
    println()

    // 6. 最小值/最大值 (含 NaN)
    println("6. 最小值/最大值示例 (含 NaN):")
    let min2 = IEEE754rUtils.min(nan, 1.0)
    let max2 = IEEE754rUtils.max(nan, 1.0)
    println("   min(NaN, 1.0) = ${min2} (NaN < 所有值)")
    println("   max(NaN, 1.0) = ${max2} (任一为 NaN 返回 NaN)")
    println()

    // 7. 最小值/最大值 (数组)
    println("7. 最小值/最大值示例 (数组):")
    let arr: Array<Float64> = [3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0, 6.0]
    let min3 = IEEE754rUtils.min(arr)
    let max3 = IEEE754rUtils.max(arr)
    println("   数组: ${arr}")
    println("   min(arr) = ${min3}")
    println("   max(arr) = ${max3}")
    println()

    // 8. Float32 示例
    println("8. Float32 示例:")
    let f1: Float32 = 1.0f32
    let f2: Float32 = 2.0f32
    let minF = IEEE754rUtils.min(f1, f2)
    let maxF = IEEE754rUtils.max(f1, f2)
    println("   min(1.0f32, 2.0f32) = ${minF}")
    println("   max(1.0f32, 2.0f32) = ${maxF}")
    println()

    println("========== 示例完成 ==========")
}
