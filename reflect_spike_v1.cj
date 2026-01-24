package commons_lang4cj

import std.reflect.*
import std.collection.*

// 定义一个测试类
class TestBean {
    public var publicField: String = "publicValue"
    private var privateField: Int64 = 123

    public func publicMethod(arg: String): String {
        return "Hello, " + arg
    }

    private func privateMethod(): String {
        return "Private"
    }
}

main() {
    println("=== Reflection Spike Start ===")

    let bean = TestBean()

    // 1. 动态获取类型信息
    println("\n[1. Type Info]")
    let typeInfo = TypeInfo.of(bean)
    println("Type Name: ${typeInfo.name}")

    // 2. 动态列出成员
    println("\n[2. List Members]")
    // 在仓颉中，目前通常通过 TypeInfo 获取成员变量和成员函数
    // 注意：具体 API 可能需要验证，这里尝试访问 properties/methods 等可能存在的 API
    // 根据知识库，TypeInfo 可能不直接暴露 members 列表，或者 API 名称不同
    // 我们先尝试最通用的方式，若编译报错则说明不支持或 API 不对

    // 尝试遍历成员变量
    // 注意：仓颉目前的反射可能比较有限，不一定支持像 Java 那样的 Class.getDeclaredFields()
    // 这里的代码是探索性的

    // 3. 动态读取字段值
    println("\n[3. Get Field Value]")
    // 尝试获取 publicField
    // 假设 API 类似于 getProperty 或 getField
    // 如果没有类似 API，这项测试将失败

    // 4. 动态调用方法
    println("\n[4. Invoke Method]")
    // 尝试调用 publicMethod

    println("=== Reflection Spike End ===")
}
