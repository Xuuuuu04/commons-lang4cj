import commons_lang4cj.math.*

main() {
    println("=== Fraction 分数类演示 ===")

    // 创建分数
    println("\n1. 创建分数:")
    let f1 = Fraction.getFraction(1, 2)
    let f2 = Fraction.getFraction(1, 3)
    println("f1 = ${f1.toString()}")  // 1/2
    println("f2 = ${f2.toString()}")  // 1/3

    // 四则运算
    println("\n2. 四则运算:")
    let sum = f1.add(f2)
    println("1/2 + 1/3 = ${sum.toString()}")  // 5/6

    let diff = f1.subtract(f2)
    println("1/2 - 1/3 = ${diff.toString()}")  // 1/6

    let product = f1.multiplyBy(f2)
    println("1/2 × 1/3 = ${product.toString()}")  // 1/6

    let quotient = f1.divideBy(f2)
    println("(1/2) ÷ (1/3) = ${quotient.toString()}")  // 3/2

    // 特殊运算
    println("\n3. 特殊运算:")
    let neg = f1.negate()
    println("-(1/2) = ${neg.toString()}")  // -1/2

    let inv = f1.invert()
    println("(1/2)^(-1) = ${inv.toString()}")  // 2/1

    let absVal = neg.abs()
    println("|-1/2| = ${absVal.toString()}")  // 1/2

    let squared = f1.pow(2)
    println("(1/2)² = ${squared.toString()}")  // 1/4

    // 类型转换
    println("\n4. 类型转换:")
    println("1/2 as double = ${f1.toDouble()}")  // 0.5
    println("7/4 to int = ${Fraction.getFraction(7, 4).toInt()}")  // 1

    // 比较
    println("\n5. 比较:")
    println("1/2 compareTo 1/3 = ${f1.compareTo(f2)}")  // 1
    println("1/2 equals 2/4 = ${f1.equals(Fraction.getFraction(2, 4))}")  // false

    // 字符串表示
    println("\n6. 字符串表示:")
    let f3 = Fraction.getFraction(7, 4)
    println("7/4 toString = ${f3.toString()}")  // 7/4
    println("7/4 toProperString = ${f3.toProperString()}")  // 1 3/4

    // 静态常量
    println("\n7. 静态常量:")
    println("ZERO = ${Fraction.ZERO.toString()}")  // 0/1
    println("ONE = ${Fraction.ONE.toString()}")    // 1/1
    println("ONE_HALF = ${Fraction.ONE_HALF.toString()}")  // 1/2

    // 查询方法
    println("\n8. 查询方法:")
    println("7/4 isPositive = ${f3.isPositive()}")  // true
    println("7/4 isZero = ${f3.isZero()}")  // false
    println("7/4 getProperWhole = ${f3.getProperWhole()}")  // 1
    println("7/4 getProperNumerator = ${f3.getProperNumerator()}")  // 3

    println("\n=== 演示结束 ===")
}
