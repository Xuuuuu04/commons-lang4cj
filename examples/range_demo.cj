package main

import commons_lang4cj.range.*

/**
 * Range 包使用示例
 *
 * 演示 Range<T>、CharRange 和 NumberRange 的基本用法
 */
main() {
    // 示例 1: 创建整数范围
    println("=== 示例 1: 整数范围 ===")
    let intRange = NumberRange.ofInt(10, 20)
    println("范围: ${intRange.toString()}")
    println("包含 15: ${intRange.contains(15)}")
    println("最小值: ${intRange.getMinimum()}")
    println("最大值: ${intRange.getMaximum()}")

    // 示例 2: 字符范围
    println("\n=== 示例 2: 字符范围 ===")
    let charRange = CharRange.of(r'a', r'c')
    println("字符范围: ${charRange.toString()}")
    println("包含 'b': ${charRange.contains(r'b')}")

    // 示例 3: 范围交集
    println("\n=== 示例 3: 范围交集 ===")
    let range1 = NumberRange.ofInt(10, 20)
    let range2 = NumberRange.ofInt(15, 25)
    let intersection = range1.intersectionWith(other: range2)
    if (let Some(r) <- intersection) {
        println("交集: ${r.toString()}")
    }

    // 示例 4: 范围并集
    println("\n=== 示例 4: 范围并集 ===")
    let span = range1.spanWith(other: range2)
    println("并集: ${span.toString()}")

    // 示例 5: 元素适配
    println("\n=== 示例 5: 元素适配 ===")
    let range = NumberRange.ofInt(10, 20)
    println("适配 5: ${range.fit(5)}")
    println("适配 15: ${range.fit(15)}")
    println("适配 25: ${range.fit(25)}")

    // 示例 6: 字符范围获取所有字符
    println("\n=== 示例 6: 获取所有字符 ===")
    let letters = CharRange.of(r'A', r'C')
    println("所有字符: ${letters.toString()}")
    println("字符数量: ${letters.getSize()}")

    println("\n=== 所有示例执行完毕 ===")
}
