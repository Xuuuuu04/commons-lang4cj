/*
 * 测试 HashCodeBuilder 功能
 */
package main

import commons_lang4cj.builder.*

main() {
    println("=== HashCodeBuilder 功能测试 ===\n")

    // 测试 1: 基本类型
    println("测试 1: 基本类型")
    let hcb1 = HashCodeBuilder(17, 37)
        .append(100)
        .append(true)
        .append(200)
    println("  append(100, true, 200): ${hcb1.toHashCode()}")

    // 测试 2: 数组
    println("\n测试 2: 数组")
    let arr: Array<Int64> = [1, 2, 3]
    let hcb2 = HashCodeBuilder().append(Some(arr))
    println("  append([1, 2, 3]): ${hcb2.toHashCode()}")

    // 测试 3: 字符串
    println("\n测试 3: 字符串")
    let hcb3 = HashCodeBuilder().append(Some("Hello"))
    println("  append(\"Hello\"): ${hcb3.toHashCode()}")

    // 测试 4: 链式调用
    println("\n测试 4: 链式调用")
    let hcb4 = HashCodeBuilder()
        .append(10 as Int8)
        .append(r'A')
        .append(3.14)
        .append(100 as Int16)
    println("  链式调用结果: ${hcb4.toHashCode()}")

    // 测试 5: 自定义初始值和乘数
    println("\n测试 5: 自定义初始值和乘数")
    let hcb5 = HashCodeBuilder(13, 19).append(50)
    println("  HashCodeBuilder(13, 19).append(50): ${hcb5.toHashCode()}")

    // 测试 6: appendSuper
    println("\n测试 6: appendSuper")
    let hcb6 = HashCodeBuilder()
        .appendSuper(12345)
        .append(67)
    println("  appendSuper(12345).append(67): ${hcb6.toHashCode()}")

    // 测试 7: 空值处理
    println("\n测试 7: 空值处理")
    let hcb7 = HashCodeBuilder()
        .append(None)          // None 数组
        .append(None)          // None 对象
        .append(100)
    println("  append(None, None, 100): ${hcb7.toHashCode()}")

    // 测试 8: 混合类型数组
    println("\n测试 8: 混合类型数组")
    let boolArr: Array<Bool> = [true, false, true]
    let hcb8 = HashCodeBuilder()
        .append(Some(boolArr))
        .append(200)
    println("  append([true, false, true], 200): ${hcb8.toHashCode()}")

    println("\n=== 所有测试完成 ===")
}
