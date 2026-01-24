package commons_lang4cj

import std.reflect.*

class Bean {
    public var field1: Int64 = 10
    public func method1(): Unit {}
}

main() {
    println("Probing Reflection API...")
    let b = Bean()
    let info = TypeInfo.of(b)

    match (info) {
        case ci: ClassTypeInfo =>
            println("ClassName: ${ci.name}")

            // Intentionally probing for common reflection members
            // The compiler error will reveal if they exist or suggest alternatives

            // Probe 1: Members/Properties
            // let props = ci.properties
            // let fields = ci.fields
            // let vars = ci.variables

            // Probe 2: Methods/Functions
            // let methods = ci.methods
            // let funcs = ci.functions

        case _ => println("Not a class")
    }
}
