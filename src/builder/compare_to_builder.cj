package commons_lang4cj.builder

/**
 * 用于构建 compareTo 方法的辅助类
 *
 * 此类简化了 Comparable<T>.compareTo() 方法的实现，支持链式调用和短路评估。
 * 短路评估意味着一旦发现差异，后续的比较操作将被忽略。
 *
 * 典型用法：
 * ```cangjie
 * public override func compareTo(other: MyClass): Int64 {
 *     return CompareToBuilder()
 *         .append(this._field1, other._field1)
 *         .append(this._field2, other._field2)
 *         .toComparison()
 * }
 * ```
 *
 * @since 1.0.0
 */
public class CompareToBuilder {
    /** 当前的比较结果 */
    private var _comparison: Int64 = 0

    /** 构建器是否已锁定（短路机制） */
    private var _builderLocked: Bool = false

    /**
     * 构造一个新的 CompareToBuilder
     */
    public init() {}

    /**
     * 追加 Int64 类型的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Int64, rhs: Int64): CompareToBuilder {
        if (_builderLocked) {
            return this
        }
        _comparison = lhs - rhs
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Int32 类型的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Int32, rhs: Int32): CompareToBuilder {
        if (_builderLocked) {
            return this
        }
        _comparison = safeSubInt32(lhs, rhs)
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Int16 类型的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Int16, rhs: Int16): CompareToBuilder {
        if (_builderLocked) {
            return this
        }
        _comparison = safeSubInt16(lhs, rhs)
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Int8 类型的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Int8, rhs: Int8): CompareToBuilder {
        if (_builderLocked) {
            return this
        }
        _comparison = safeSubInt8(lhs, rhs)
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Float64 类型的比较
     *
     * 注意：此方法将浮点数转换为 Int64 进行比较，可能存在精度损失。
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Float64, rhs: Float64): CompareToBuilder {
        if (_builderLocked) {
            return this
        }
        if (lhs < rhs) {
            _comparison = -1
        } else if (lhs > rhs) {
            _comparison = 1
        } else {
            _comparison = 0
        }
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Float32 类型的比较
     *
     * 注意：此方法将浮点数转换为 Int64 进行比较，可能存在精度损失。
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Float32, rhs: Float32): CompareToBuilder {
        if (_builderLocked) {
            return this
        }
        if (lhs < rhs) {
            _comparison = -1
        } else if (lhs > rhs) {
            _comparison = 1
        } else {
            _comparison = 0
        }
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Bool 类型的比较
     *
     * false < true（遵循 Apache Commons Lang 语义）
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Bool, rhs: Bool): CompareToBuilder {
        if (_builderLocked) {
            return this
        }
        if (lhs == rhs) {
            _comparison = 0
        } else if (!lhs && rhs) {
            _comparison = -1  // false < true
        } else {
            _comparison = 1   // true > false
        }
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Comparable<T> 类型的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append<T>(lhs: T, rhs: T): CompareToBuilder where T <: Comparable<T> {
        if (_builderLocked) {
            return this
        }
        _comparison = orderingToInt(lhs.compare(rhs))
        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Int64> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Int64>, rhs: Option<Int64>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionInt64(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Int32> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Int32>, rhs: Option<Int32>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionInt32(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Int16> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Int16>, rhs: Option<Int16>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionInt16(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Int8> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Int8>, rhs: Option<Int8>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionInt8(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Float64> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Float64>, rhs: Option<Float64>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionFloat64(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Float32> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Float32>, rhs: Option<Float32>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionFloat32(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Bool> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null，false < true
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Bool>, rhs: Option<Bool>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionBool(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<T> 类型的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append<T>(lhs: Option<T>, rhs: Option<T>): CompareToBuilder where T <: Comparable<T> {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionComparable(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Object 的比较
     *
     * 注意：此方法使用 equals 方法进行比较。
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(_: Object, _: Object): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        // Object 类型无法直接比较，使用保守策略
        // 假设所有 Object 都不相等
        _comparison = 1

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加 Option<Object> 的比较
     *
     * 遵循 Apache Commons Lang 语义：null < non-null
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Option<Object>, rhs: Option<Object>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        _comparison = compareOptionObject(lhs, rhs)

        if (_comparison != 0) {
            _builderLocked = true
        }
        this
    }

    /**
     * 追加数组的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Array<Int64>, rhs: Array<Int64>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        // 比较长度
        if (lhs.size < rhs.size) {
            _comparison = -1
            _builderLocked = true
            return this
        } else if (lhs.size > rhs.size) {
            _comparison = 1
            _builderLocked = true
            return this
        }

        // 逐元素比较
        for (i in 0..lhs.size) {
            if (lhs[i] < rhs[i]) {
                _comparison = -1
                _builderLocked = true
                return this
            } else if (lhs[i] > rhs[i]) {
                _comparison = 1
                _builderLocked = true
                return this
            }
        }

        _comparison = 0
        this
    }

    /**
     * 追加数组的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Array<Int32>, rhs: Array<Int32>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        if (lhs.size < rhs.size) {
            _comparison = -1
            _builderLocked = true
            return this
        } else if (lhs.size > rhs.size) {
            _comparison = 1
            _builderLocked = true
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] < rhs[i]) {
                _comparison = -1
                _builderLocked = true
                return this
            } else if (lhs[i] > rhs[i]) {
                _comparison = 1
                _builderLocked = true
                return this
            }
        }

        _comparison = 0
        this
    }

    /**
     * 追加数组的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Array<Float64>, rhs: Array<Float64>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        if (lhs.size < rhs.size) {
            _comparison = -1
            _builderLocked = true
            return this
        } else if (lhs.size > rhs.size) {
            _comparison = 1
            _builderLocked = true
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] < rhs[i]) {
                _comparison = -1
                _builderLocked = true
                return this
            } else if (lhs[i] > rhs[i]) {
                _comparison = 1
                _builderLocked = true
                return this
            }
        }

        _comparison = 0
        this
    }

    /**
     * 追加数组的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Array<Float32>, rhs: Array<Float32>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        if (lhs.size < rhs.size) {
            _comparison = -1
            _builderLocked = true
            return this
        } else if (lhs.size > rhs.size) {
            _comparison = 1
            _builderLocked = true
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] < rhs[i]) {
                _comparison = -1
                _builderLocked = true
                return this
            } else if (lhs[i] > rhs[i]) {
                _comparison = 1
                _builderLocked = true
                return this
            }
        }

        _comparison = 0
        this
    }

    /**
     * 追加数组的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Array<Bool>, rhs: Array<Bool>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        if (lhs.size < rhs.size) {
            _comparison = -1
            _builderLocked = true
            return this
        } else if (lhs.size > rhs.size) {
            _comparison = 1
            _builderLocked = true
            return this
        }

        for (i in 0..lhs.size) {
            if (!lhs[i] && rhs[i]) {
                _comparison = -1
                _builderLocked = true
                return this
            } else if (lhs[i] && !rhs[i]) {
                _comparison = 1
                _builderLocked = true
                return this
            }
        }

        _comparison = 0
        this
    }

    /**
     * 追加字符串数组的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append(lhs: Array<String>, rhs: Array<String>): CompareToBuilder {
        if (_builderLocked) {
            return this
        }

        if (lhs.size < rhs.size) {
            _comparison = -1
            _builderLocked = true
            return this
        } else if (lhs.size > rhs.size) {
            _comparison = 1
            _builderLocked = true
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] < rhs[i]) {
                _comparison = -1
                _builderLocked = true
                return this
            } else if (lhs[i] > rhs[i]) {
                _comparison = 1
                _builderLocked = true
                return this
            }
        }

        _comparison = 0
        this
    }

    /**
     * 追加泛型数组的比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this，支持链式调用
     */
    public func append<T>(lhs: Array<T>, rhs: Array<T>): CompareToBuilder where T <: Comparable<T> {
        if (_builderLocked) {
            return this
        }

        if (lhs.size < rhs.size) {
            _comparison = -1
            _builderLocked = true
            return this
        } else if (lhs.size > rhs.size) {
            _comparison = 1
            _builderLocked = true
            return this
        }

        for (i in 0..lhs.size) {
            let ordering = lhs[i].compare(rhs[i])
            let cmp = if (ordering == Ordering.LT) {
                -1
            } else if (ordering == Ordering.GT) {
                1
            } else {
                0
            }
            if (cmp != 0) {
                _comparison = cmp
                _builderLocked = true
                return this
            }
        }

        _comparison = 0
        this
    }

    /**
     * 重置构建器
     *
     * @return this，支持链式调用
     */
    public func reset(): CompareToBuilder {
        _comparison = 0
        _builderLocked = false
        this
    }

    /**
     * 返回比较结果
     *
     * @return 比较结果（负数表示小于，0 表示相等，正数表示大于）
     */
    public func toComparison(): Int64 {
        _comparison
    }

    // ========== 辅助方法（私有） ==========

    /**
     * 比较 Option<Int64>
     */
    private func compareOptionInt64(lhs: Option<Int64>, rhs: Option<Int64>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionInt64Some(l, rhs)
            case None => compareOptionInt64None(rhs)
        }
    }

    private func compareOptionInt64Some(l: Int64, rhs: Option<Int64>): Int64 {
        match (rhs) {
            case Some(r) => l - r
            case None => 1
        }
    }

    private func compareOptionInt64None(rhs: Option<Int64>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<Int32>
     */
    private func compareOptionInt32(lhs: Option<Int32>, rhs: Option<Int32>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionInt32Some(l, rhs)
            case None => compareOptionInt32None(rhs)
        }
    }

    private func compareOptionInt32Some(l: Int32, rhs: Option<Int32>): Int64 {
        match (rhs) {
            case Some(r) => safeSubInt32(l, r)
            case None => 1
        }
    }

    private func compareOptionInt32None(rhs: Option<Int32>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<Int16>
     */
    private func compareOptionInt16(lhs: Option<Int16>, rhs: Option<Int16>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionInt16Some(l, rhs)
            case None => compareOptionInt16None(rhs)
        }
    }

    private func compareOptionInt16Some(l: Int16, rhs: Option<Int16>): Int64 {
        match (rhs) {
            case Some(r) => safeSubInt16(l, r)
            case None => 1
        }
    }

    private func compareOptionInt16None(rhs: Option<Int16>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<Int8>
     */
    private func compareOptionInt8(lhs: Option<Int8>, rhs: Option<Int8>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionInt8Some(l, rhs)
            case None => compareOptionInt8None(rhs)
        }
    }

    private func compareOptionInt8Some(l: Int8, rhs: Option<Int8>): Int64 {
        match (rhs) {
            case Some(r) => safeSubInt8(l, r)
            case None => 1
        }
    }

    private func compareOptionInt8None(rhs: Option<Int8>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<Float64>
     */
    private func compareOptionFloat64(lhs: Option<Float64>, rhs: Option<Float64>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionFloat64Some(l, rhs)
            case None => compareOptionFloat64None(rhs)
        }
    }

    private func compareOptionFloat64Some(l: Float64, rhs: Option<Float64>): Int64 {
        match (rhs) {
            case Some(r) => compareFloats(l, r)
            case None => 1
        }
    }

    private func compareOptionFloat64None(rhs: Option<Float64>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<Float32>
     */
    private func compareOptionFloat32(lhs: Option<Float32>, rhs: Option<Float32>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionFloat32Some(l, rhs)
            case None => compareOptionFloat32None(rhs)
        }
    }

    private func compareOptionFloat32Some(l: Float32, rhs: Option<Float32>): Int64 {
        match (rhs) {
            case Some(r) => compareFloats(l, r)
            case None => 1
        }
    }

    private func compareOptionFloat32None(rhs: Option<Float32>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<Bool>
     */
    private func compareOptionBool(lhs: Option<Bool>, rhs: Option<Bool>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionBoolSome(l, rhs)
            case None => compareOptionBoolNone(rhs)
        }
    }

    private func compareOptionBoolSome(l: Bool, rhs: Option<Bool>): Int64 {
        match (rhs) {
            case Some(r) => compareBools(l, r)
            case None => 1
        }
    }

    private func compareOptionBoolNone(rhs: Option<Bool>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<T> (泛型)
     */
    private func compareOptionComparable<T>(lhs: Option<T>, rhs: Option<T>): Int64 where T <: Comparable<T> {
        match (lhs) {
            case Some(l) => compareOptionComparableSome(l, rhs)
            case None => compareOptionComparableNone(rhs)
        }
    }

    private func compareOptionComparableSome<T>(l: T, rhs: Option<T>): Int64 where T <: Comparable<T> {
        match (rhs) {
            case Some(r) => orderingToInt(l.compare(r))
            case None => 1
        }
    }

    private func compareOptionComparableNone<T>(rhs: Option<T>): Int64 where T <: Comparable<T> {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较 Option<Object>
     */
    private func compareOptionObject(lhs: Option<Object>, rhs: Option<Object>): Int64 {
        match (lhs) {
            case Some(l) => compareOptionObjectSome(l, rhs)
            case None => compareOptionObjectNone(rhs)
        }
    }

    private func compareOptionObjectSome(_: Object, rhs: Option<Object>): Int64 {
        match (rhs) {
            case Some(r) =>
                // Object 类型无法直接比较，使用保守策略
                1
            case None => 1
        }
    }

    private func compareOptionObjectNone(rhs: Option<Object>): Int64 {
        match (rhs) {
            case Some(_) => -1
            case None => 0
        }
    }

    /**
     * 比较两个浮点数
     */
    private func compareFloats(l: Float64, r: Float64): Int64 {
        if (l < r) {
            -1
        } else if (l > r) {
            1
        } else {
            0
        }
    }

    private func compareFloats(l: Float32, r: Float32): Int64 {
        if (l < r) {
            -1
        } else if (l > r) {
            1
        } else {
            0
        }
    }

    /**
     * 比较两个布尔值
     */
    private func compareBools(l: Bool, r: Bool): Int64 {
        if (l == r) {
            0
        } else if (!l && r) {
            -1
        } else {
            1
        }
    }


    /**
     * 将 Ordering 转换为 Int64
     */
    private func orderingToInt(ordering: Ordering): Int64 {
        match (ordering) {
            case Ordering.LT => -1
            case Ordering.EQ => 0
            case Ordering.GT => 1
        }
    }

    /**
     * 安全的 Int32 减法
     */
    private func safeSubInt32(l: Int32, r: Int32): Int64 {
        let l64 = l as Int64
        let r64 = r as Int64
        // as 操作符返回 Option，但这里我们知道转换是安全的
        match (l64) {
            case Some(lv) =>
                match (r64) {
                    case Some(rv) => lv - rv
                    case None => 0
                }
            case None => 0
        }
    }

    /**
     * 安全的 Int16 减法
     */
    private func safeSubInt16(l: Int16, r: Int16): Int64 {
        let l64 = l as Int64
        let r64 = r as Int64
        match (l64) {
            case Some(lv) =>
                match (r64) {
                    case Some(rv) => lv - rv
                    case None => 0
                }
            case None => 0
        }
    }

    /**
     * 安全的 Int8 减法
     */
    private func safeSubInt8(l: Int8, r: Int8): Int64 {
        let l64 = l as Int64
        let r64 = r as Int64
        match (l64) {
            case Some(lv) =>
                match (r64) {
                    case Some(rv) => lv - rv
                    case None => 0
                }
            case None => 0
        }
    }
}
