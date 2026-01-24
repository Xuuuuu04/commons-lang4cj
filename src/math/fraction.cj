package commons_lang4cj.math

/**
 * Fraction 分数类
 *
 * 表示有理数(分数),提供精确的分数运算功能。
 * 本类是不可变的,所有运算返回新对象。
 *
 * 本类使用 Int64 存储分子分母,适合大多数常用场景。
 *
 * @since 1.1.0
 */
public class Fraction {
    // 核心字段
    private let _numerator: Int64
    private let _denominator: Int64

    // 缓存字段
    private var _hashCode: Int64 = 0
    private var _toString: String = ""
    private var _toProperString: String = ""

    // 私有构造函数
    private init(numerator: Int64, denominator: Int64) {
        _numerator = numerator
        _denominator = denominator
    }

    /**
     * 计算 Int64 的绝对值
     * 手动实现以避免溢出问题
     */
    private static func absInt64(n: Int64): Int64 {
        if (n < 0) {
            -n
        } else {
            n
        }
    }

    /**
     * 计算两个数的最大公约数
     * 使用二进制 GCD 算法 (Stein 算法)
     *
     * @param u 第一个数
     * @param v 第二个数
     * @return 最大公约数(始终为正)
     */
    private static func greatestCommonDivisor(u: Int64, v: Int64): Int64 {
        // 特殊情况: 如果有一个数为0
        if (u == 0 || v == 0) {
            return absInt64(u) + absInt64(v)
        }

        // 如果有一个数为±1,直接返回1
        if (absInt64(u) == 1 || absInt64(v) == 1) {
            return 1
        }

        // 将 u, v 转为负数(避免 Int64 最小值取反溢出)
        var uVar = if (u > 0) { -u } else { u }
        var vVar = if (v > 0) { -v } else { v }

        // B1. 找出 u 和 v 中 2 的最大幂次
        var k = 0
        while ((uVar & 1) == 0 && (vVar & 1) == 0 && k < 63) {
            uVar = uVar / 2
            vVar = vVar / 2
            k++
        }

        // B2. 初始化
        var t = if ((uVar & 1) == 1) { vVar } else { -(uVar / 2) }

        // B3-B6. 主循环
        while (t != 0) {
            // B4. 剔除 t 中的因子2
            while ((t & 1) == 0) {
                t = t / 2
            }

            // B5. 重置 max(u, v)
            if (t > 0) {
                uVar = -t
            } else {
                vVar = t
            }

            // B6. 更新 t
            t = (vVar - uVar) / 2
        }

        return -uVar * (1 << k)  // gcd = u * 2^k
    }

    // ==================== 工厂方法 ====================

    /**
     * 创建分数 Y/Z
     * 负号会被解析到分子上,分母始终为正
     *
     * @param numerator 分子
     * @param denominator 分母(不能为零)
     * @return 新的分数实例
     * @throws ArithmeticException 如果分母为零
     */
    public static func getFraction(numerator: Int64, denominator: Int64): Fraction {
        if (denominator == 0) {
            throw ArithmeticException("The denominator must not be zero")
        }

        var num = numerator
        var den = denominator

        // 规范化符号: 确保分母为正
        if (den < 0) {
            num = -num
            den = -den
        }

        return Fraction(num, den)
    }

    /**
     * 创建带分数 X Y/Z
     *
     * @param whole 整数部分
     * @param numerator 分子部分
     * @param denominator 分母(不能为零或负)
     * @return 新的分数实例
     * @throws ArithmeticException 如果分母≤0或分子<0
     */
    public static func getFraction(whole: Int64, numerator: Int64, denominator: Int64): Fraction {
        if (denominator == 0) {
            throw ArithmeticException("The denominator must not be zero")
        }
        if (denominator < 0) {
            throw ArithmeticException("The denominator must not be negative")
        }
        if (numerator < 0) {
            throw ArithmeticException("The numerator must not be negative")
        }

        let numValue = if (whole < 0) {
            whole * denominator - numerator
        } else {
            whole * denominator + numerator
        }

        return Fraction(numValue, denominator)
    }

    /**
     * 创建整数分数 X/1
     *
     * @param num 整数值
     * @return 新的分数实例
     */
    public static func getFraction(num: Int64): Fraction {
        Fraction(num, 1)
    }

    /**
     * 创建约简后的分数
     * 例如: getReducedFraction(2, 4) 返回 1/2
     *
     * @param numerator 分子
     * @param denominator 分母(不能为零)
     * @return 约简后的分数实例
     * @throws ArithmeticException 如果分母为零
     */
    public static func getReducedFraction(numerator: Int64, denominator: Int64): Fraction {
        if (denominator == 0) {
            throw ArithmeticException("The denominator must not be zero")
        }

        if (numerator == 0) {
            return ZERO
        }

        var num = numerator
        var den = denominator

        // 规范化符号
        if (den < 0) {
            num = -num
            den = -den
        }

        // 约简
        let gcdVal = greatestCommonDivisor(num, den)
        return Fraction(num / gcdVal, den / gcdVal)
    }

    // ==================== 查询方法 ====================

    /**
     * 获取分子
     */
    public func getNumerator(): Int64 {
        _numerator
    }

    /**
     * 获取分母
     */
    public func getDenominator(): Int64 {
        _denominator
    }

    /**
     * 获取真分数分子
     * 例如 7/4 的真分数分子是 3 (7 % 4)
     */
    public func getProperNumerator(): Int64 {
        _numerator % _denominator
    }

    /**
     * 获取带分数的整数部分
     * 例如 7/4 的整数部分是 1 (7 / 4)
     */
    public func getProperWhole(): Int64 {
        _numerator / _denominator
    }

    /**
     * 是否为零
     */
    public func isZero(): Bool {
        _numerator == 0
    }

    /**
     * 是否为正数
     */
    public func isPositive(): Bool {
        _numerator > 0
    }

    /**
     * 是否为负数
     */
    public func isNegative(): Bool {
        _numerator < 0
    }

    // ==================== 基本运算 ====================

    /**
     * 加法: this + fraction
     */
    public func add(fraction: Fraction): Fraction {
        // 零是加法单位元
        if (_numerator == 0) {
            return fraction
        }
        if (fraction._numerator == 0) {
            return this
        }

        let d1 = greatestCommonDivisor(_denominator, fraction._denominator)

        if (d1 == 1) {
            // 简单情况: (a×d + c×b) / (b×d)
            let uvp = _numerator * fraction._denominator
            let upv = fraction._numerator * _denominator
            let newNum = uvp + upv
            let newDen = _denominator * fraction._denominator
            return getReducedFraction(newNum, newDen)
        }

        // 复杂情况: 需要约简
        let uvp = _numerator * (fraction._denominator / d1)
        let upv = fraction._numerator * (_denominator / d1)
        let t = uvp + upv

        let d2 = if (t != 0) {
            greatestCommonDivisor(t, d1)
        } else {
            d1
        }

        let newNum = t / d2
        let newDen = (_denominator / d1) * (fraction._denominator / d2)
        return getReducedFraction(newNum, newDen)
    }

    /**
     * 减法: this - fraction
     */
    public func subtract(fraction: Fraction): Fraction {
        // 减法 = 加上负数
        add(fraction.negate())
    }

    /**
     * 乘法: this × fraction
     */
    public func multiplyBy(fraction: Fraction): Fraction {
        // 零乘任何数等于零
        if (_numerator == 0 || fraction._numerator == 0) {
            return ZERO
        }

        // 交叉约简以避免溢出
        let d1 = greatestCommonDivisor(_numerator, fraction._denominator)
        let d2 = greatestCommonDivisor(fraction._numerator, _denominator)

        let newNum = (_numerator / d1) * (fraction._numerator / d2)
        let newDen = (_denominator / d2) * (fraction._denominator / d1)

        return getReducedFraction(newNum, newDen)
    }

    /**
     * 除法: this ÷ fraction
     */
    public func divideBy(fraction: Fraction): Fraction {
        if (fraction._numerator == 0) {
            throw ArithmeticException("Cannot divide by zero")
        }
        return multiplyBy(fraction.invert())
    }

    /**
     * 取反: -this
     */
    public func negate(): Fraction {
        getReducedFraction(-_numerator, _denominator)
    }

    /**
     * 倒数: 1/this
     */
    public func invert(): Fraction {
        if (_numerator == 0) {
            throw ArithmeticException("Cannot invert zero")
        }
        getReducedFraction(_denominator, _numerator)
    }

    // ==================== 取整与幂运算 ====================

    /**
     * 绝对值
     */
    public func abs(): Fraction {
        if (_numerator >= 0) {
            return this
        }
        return negate()
    }

    /**
     * 幂运算
     */
    public func pow(power: Int64): Fraction {
        if (power == 0) {
            return ONE
        }
        if (power == 1) {
            return this
        }

        var result = ONE
        var base = this
        var exp = power

        while (exp > 0) {
            if ((exp & 1) == 1) {
                result = result.multiplyBy(base)
            }
            base = base.multiplyBy(base)
            exp = exp / 2
        }

        result
    }

    /**
     * 取余: this mod fraction
     */
    public func remainder(fraction: Fraction): Fraction {
        let quotient = this.divideBy(fraction)
        let whole = quotient.toInt()
        let wholeFraction = getFraction(whole)
        subtract(wholeFraction.multiplyBy(fraction))
    }

    // ==================== 类型转换 ====================

    /**
     * 转换为双精度浮点数
     */
    public func toDouble(): Float64 {
        Float64(_numerator) / Float64(_denominator)
    }

    /**
     * 转换为单精度浮点数
     */
    public func toFloat(): Float32 {
        Float32(_numerator) / Float32(_denominator)
    }

    /**
     * 转换为整数(截断)
     */
    public func toInt(): Int64 {
        _numerator / _denominator
    }

    /**
     * 转换为整数(截断)
     */
    public func toIntValue(): Int64 {
        toInt()
    }

    // ==================== 比较和哈希 ====================

    /**
     * 比较大小
     * @return -1(小于) / 0(等于) / 1(大于)
     */
    public func compareTo(other: Fraction): Int64 {
        // 比较两个分数的大小
        let lhs = _numerator * other._denominator
        let rhs = other._numerator * _denominator

        if (lhs < rhs) {
            -1
        } else if (lhs > rhs) {
            1
        } else {
            0
        }
    }

    /**
     * 相等性比较
     */
    public func equals(other: Option<Fraction>): Bool {
        match (other) {
            case Some(f) => _numerator == f._numerator && _denominator == f._denominator
            case None => false
        }
    }

    /**
     * 计算哈希码
     */
    public func hashCode(): Int64 {
        if (_hashCode == 0) {
            _hashCode = (_numerator * 31) + _denominator
        }
        _hashCode
    }

    // ==================== 字符串方法 ====================

    /**
     * 转换为字符串 "a/b"
     */
    public func toString(): String {
        if (_toString.isEmpty()) {
            _toString = "${_numerator}/${_denominator}"
        }
        _toString
    }

    /**
     * 转换为带分数字符串 "W n/d"
     */
    public func toProperString(): String {
        if (_toProperString.isEmpty()) {
            if (_numerator >= _denominator) {
                let whole = _numerator / _denominator
                let remainder = _numerator % _denominator
                if (remainder == 0) {
                    _toProperString = "${whole}"
                } else {
                    _toProperString = "${whole} ${remainder}/${_denominator}"
                }
            } else {
                _toProperString = toString()
            }
        }
        _toProperString
    }

    // ==================== 静态常量 ====================

    public static var ZERO: Fraction = Fraction(0, 1)
    public static var ONE: Fraction = Fraction(1, 1)
    public static var ONE_HALF: Fraction = Fraction(1, 2)
    public static var ONE_THIRD: Fraction = Fraction(1, 3)
    public static var TWO_THIRDS: Fraction = Fraction(2, 3)
    public static var ONE_QUARTER: Fraction = Fraction(1, 4)
    public static var TWO_QUARTERS: Fraction = Fraction(2, 4)
    public static var THREE_QUARTERS: Fraction = Fraction(3, 4)
    public static var ONE_FIFTH: Fraction = Fraction(1, 5)
    public static var TWO_FIFTHS: Fraction = Fraction(2, 5)
    public static var THREE_FIFTHS: Fraction = Fraction(3, 5)
    public static var FOUR_FIFTHS: Fraction = Fraction(4, 5)
}
