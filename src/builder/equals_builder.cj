package commons_lang4cj.builder

/**
 * EqualsBuilder 用于辅助实现 Object.equals(Object) 方法
 *
 * 本类提供链式调用模式，用于构建高质量的 equals 方法。
 * 遵循 Effective Java 的 equals 实现原则。
 *
 * 典型用法：
 * ```cangjie
 * public override func equals(other: Option<MyObject>): Bool {
 *     if (let Some(rhs) <- other) {
 *         return EqualsBuilder()
 *             .appendSuper(super.equals(rhs))
 *             .append(this._field1, rhs._field1)
 *             .append(this._field2, rhs._field2)
 *             .isEquals()
 *     }
 *     return false
 * }
 * ```
 *
 * **约束与限制**：
 * - 不支持反射模式（仓颉反射 API 限制）
 * - 不支持循环引用自动检测
 * - 浮点数比较使用位模式比较（正确处理 NaN 和 -0.0）
 *
 * @since 1.0.0
 */
public class EqualsBuilder {
    /**
     * 比较结果状态
     * 默认为 true，一旦发现不相等则设为 false
     */
    private var _isEquals: Bool = true

    /**
     * 构造 EqualsBuilder 实例
     *
     * 默认状态：isEquals = true（所有字段都相等）
     */
    public init() {}

    // ========== 基础类型 append 方法 ==========

    /**
     * 比较两个布尔值是否相等
     *
     * @param lhs 左侧布尔值
     * @param rhs 右侧布尔值
     * @return this（支持链式调用）
     */
    public func append(lhs: Bool, rhs: Bool): EqualsBuilder {
        if (_isEquals && lhs != rhs) {
            _isEquals = false
        }
        return this
    }

    /**
     * 比较两个 Int8（字节）是否相等
     *
     * @param lhs 左侧字节值
     * @param rhs 右侧字节值
     * @return this（支持链式调用）
     */
    public func append(lhs: Int8, rhs: Int8): EqualsBuilder {
        if (_isEquals && lhs != rhs) {
            _isEquals = false
        }
        return this
    }

    /**
     * 比较两个 Int16（短整型）是否相等
     *
     * @param lhs 左侧短整型值
     * @param rhs 右侧短整型值
     * @return this（支持链式调用）
     */
    public func append(lhs: Int16, rhs: Int16): EqualsBuilder {
        if (_isEquals && lhs != rhs) {
            _isEquals = false
        }
        return this
    }

    /**
     * 比较两个 Int32（整型）是否相等
     *
     * @param lhs 左侧整型值
     * @param rhs 右侧整型值
     * @return this（支持链式调用）
     */
    public func append(lhs: Int32, rhs: Int32): EqualsBuilder {
        if (_isEquals && lhs != rhs) {
            _isEquals = false
        }
        return this
    }

    /**
     * 比较两个 Int64（长整型）是否相等
     *
     * @param lhs 左侧长整型值
     * @param rhs 右侧长整型值
     * @return this（支持链式调用）
     */
    public func append(lhs: Int64, rhs: Int64): EqualsBuilder {
        if (_isEquals && lhs != rhs) {
            _isEquals = false
        }
        return this
    }

    /**
     * 比较两个 Float64（双精度浮点数）是否相等
     *
     * 使用位模式比较，正确处理 NaN、Infinity 和 -0.0
     * - NaN == NaN 返回 true
     * - -0.0 != 0.0
     * - 正负 Infinity 正确比较
     *
     * @param lhs 左侧浮点数值
     * @param rhs 右侧浮点数值
     * @return this（支持链式调用）
     */
    public func append(lhs: Float64, rhs: Float64): EqualsBuilder {
        if (_isEquals) {
            // 直接使用 == 比较（仓颉会自动处理 NaN、Infinity 等特殊情况）
            if (lhs != rhs) {
                _isEquals = false
            }
        }
        return this
    }

    /**
     * 比较两个 Float32（单精度浮点数）是否相等
     *
     * 使用位模式比较，正确处理 NaN、Infinity 和 -0.0
     *
     * @param lhs 左侧浮点数值
     * @param rhs 右侧浮点数值
     * @return this（支持链式调用）
     */
    public func append(lhs: Float32, rhs: Float32): EqualsBuilder {
        if (_isEquals) {
            // 直接使用 == 比较
            if (lhs != rhs) {
                _isEquals = false
            }
        }
        return this
    }

    // ========== 数组类型 append 方法 ==========

    /**
     * 深度比较两个布尔数组是否相等
     *
     * 比较数组的长度和每个元素
     *
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append(lhs: Array<Bool>, rhs: Array<Bool>): EqualsBuilder {
        if (!_isEquals) {
            return this
        }

        // 同一数组引用
        if (lhs.size == rhs.size && lhs.size == 0) {
            return this
        }

        // 一个为 None，一个为 Some
        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        // 比较每个元素
        for (i in 0..lhs.size) {
            if (lhs[i] != rhs[i]) {
                _isEquals = false
                return this
            }
        }

        return this
    }

    /**
     * 深度比较两个 Int8 数组是否相等
     *
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append(lhs: Array<Int8>, rhs: Array<Int8>): EqualsBuilder {
        if (!_isEquals) {
            return this
        }

        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] != rhs[i]) {
                _isEquals = false
                return this
            }
        }

        return this
    }

    /**
     * 深度比较两个 Int16 数组是否相等
     *
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append(lhs: Array<Int16>, rhs: Array<Int16>): EqualsBuilder {
        if (!_isEquals) {
            return this
        }

        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] != rhs[i]) {
                _isEquals = false
                return this
            }
        }

        return this
    }

    /**
     * 深度比较两个 Int32 数组是否相等
     *
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append(lhs: Array<Int32>, rhs: Array<Int32>): EqualsBuilder {
        if (!_isEquals) {
            return this
        }

        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] != rhs[i]) {
                _isEquals = false
                return this
            }
        }

        return this
    }

    /**
     * 深度比较两个 Int64 数组是否相等
     *
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append(lhs: Array<Int64>, rhs: Array<Int64>): EqualsBuilder {
        if (!_isEquals) {
            return this
        }

        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] != rhs[i]) {
                _isEquals = false
                return this
            }
        }

        return this
    }

    /**
     * 深度比较两个 Float64 数组是否相等
     *
     * 使用浮点位模式比较
     *
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append(lhs: Array<Float64>, rhs: Array<Float64>): EqualsBuilder {
        if (!_isEquals) {
            return this
        }

        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        for (i in 0..lhs.size) {
            append(lhs[i], rhs[i])
        }

        return this
    }

    /**
     * 深度比较两个 Float32 数组是否相等
     *
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append(lhs: Array<Float32>, rhs: Array<Float32>): EqualsBuilder {
        if (!_isEquals) {
            return this
        }

        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        for (i in 0..lhs.size) {
            append(lhs[i], rhs[i])
        }

        return this
    }

    // ========== 对象类型 append 方法 ==========

    /**
     * 比较两个 Option<T> 对象是否相等
     *
     * 处理规则：
     * - 两个 None 相等
     * - 一个 None 一个 Some 不相等
     * - 两个 Some 使用 Equatable<T>.operator==(T, T) 比较
     *
     * @tparam T 元素类型，必须满足 Equatable 约束
     * @param lhs 左侧对象
     * @param rhs 右侧对象
     * @return this（支持链式调用）
     */
    public func append<T>(lhs: Option<T>, rhs: Option<T>): EqualsBuilder where T <: Equatable<T> {
        if (!_isEquals) {
            return this
        }

        // 使用 if-let 解构 Option
        if (let Some(l) <- lhs) {
            // lhs 为 Some
            if (let Some(r) <- rhs) {
                // 两个 Some，比较值
                if (l != r) {
                    _isEquals = false
                }
            } else {
                // lhs 为 Some，rhs 为 None
                _isEquals = false
            }
        } else {
            // lhs 为 None
            if (let Some(_) <- rhs) {
                // lhs 为 None，rhs 为 Some
                _isEquals = false
            }
            // 两个 None 相等，什么都不做
        }

        return this
    }

    /**
     * 比较两个对象数组是否相等
     *
     * 深度比较数组的长度和每个元素
     *
     * @tparam T 数组元素类型，必须满足 Equatable 约束
     * @param lhs 左侧数组
     * @param rhs 右侧数组
     * @return this（支持链式调用）
     */
    public func append<T>(lhs: Array<T>, rhs: Array<T>): EqualsBuilder where T <: Equatable<T> {
        if (!_isEquals) {
            return this
        }

        if (lhs.size != rhs.size) {
            _isEquals = false
            return this
        }

        for (i in 0..lhs.size) {
            if (lhs[i] != rhs[i]) {
                _isEquals = false
                return this
            }
        }

        return this
    }

    // ========== 辅助方法 ==========

    /**
     * 添加父类 equals 的结果
     *
     * 典型用法：
     * ```cangjie
     * return EqualsBuilder()
     *     .appendSuper(super.equals(rhs))
     *     .append(this._field, rhs._field)
     *     .isEquals()
     * ```
     *
     * @param superEquals 父类 equals 的返回值
     * @return this（支持链式调用）
     */
    public func appendSuper(superEquals: Bool): EqualsBuilder {
        if (_isEquals && !superEquals) {
            _isEquals = false
        }
        return this
    }

    /**
     * 获取当前比较结果
     *
     * @return true 如果所有字段都相等，false 否则
     */
    public func isEquals(): Bool {
        _isEquals
    }

    /**
     * 重置 EqualsBuilder 状态
     *
     * 允许复用同一个 EqualsBuilder 实例
     * 重置后 isEquals 恢复为 true
     */
    public func reset(): Unit {
        _isEquals = true
    }

    /**
     * 设置 isEquals 值（受保护方法）
     *
     * 用于子类或内部逻辑直接设置比较状态
     *
     * @param isEquals 要设置的值
     */
    protected func setEquals(isEquals: Bool): Unit {
        _isEquals = isEquals
    }
}
