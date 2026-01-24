package commons_lang4cj

import std.reflect.*
import std.collection.*

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
    println("=== Reflection Spike V3 ===")
    let bean = TestBean()
    let typeInfo = TypeInfo.of(bean)

    println("Type: ${typeInfo.name}")

    if (let Some(classInfo) <- typeInfo as ClassTypeInfo) {
         println("It is a Class.")

         // 尝试获取成员变量列表
         // 假设 API 是 variables 或 properties
         // 我们先注释掉，一个个试，或者写在一起看报错

         // Test 1: access variables
         // for (v in classInfo.variables) {
         //    println("Var: ${v.name}")
         // }

         // Test 2: access functions
         // for (f in classInfo.functions) {
         //    println("Func: ${f.name}")
         // }
    } else {
         println("Not a ClassTypeInfo")
    }
}
