package commons_lang4cj

import std.reflect.*

class TestBean {
    public var name: String = "Cangjie"
    private var age: Int64 = 1

    public func sayHello(): String {
        return "Hello"
    }
}

main() {
    println("--- Spike V2 ---")
    let bean = TestBean()

    // 1. Get TypeInfo
    // warning: function 'of' is deprecated. Use 'ClassTypeInfo.get(Object)' instead.
    // let typeInfo = TypeInfo.of(bean)
    // println("Type: ${typeInfo.name}")

    // let classInfo = ClassTypeInfo.get(bean) // Compiler might not like this if it returns Option or throws
    // Let's stick to generic TypeInfo.of first to see runtime type

    let ti = TypeInfo.of(bean)
    println("Type Name: ${ti.name}")

    match (ti) {
        case ci: ClassTypeInfo =>
            println("Is ClassTypeInfo: Yes")
            // 尝试获取成员变量 (Fields/Properties)
            // 假设 API 为 vars, variables, properties, fields
            // 尝试获取成员函数 (Methods/Functions)
            // 假设 API 为 funcs, functions, methods

            // 下面代码故意包含推测性 API，通过编译器报错来探测
            // println("properties: ${ci.properties.size}")
            // println("methods: ${ci.methods.size}")
        case _ =>
            println("Is ClassTypeInfo: No")
    }
}
