package commons_lang4cj.mutable

/**
 * 可变对象包装器，支持任意类型
 *
 * 提供对任意类型对象的可变包装，支持未初始化状态（None）。
 * 适用于需要在闭包中修改外部变量，或者需要在多个对象间共享状态的场景。
 *
 * @param T 包装的对象类型
 * @since 1.0.0
 *
 * @example
 * ```cangjie
 * let mutableObj = MutableObject<String>("Hello")
 * println(mutableObj.getValue())  // 输出: Hello
 * mutableObj.setValue("World")
 * println(mutableObj.getValue())  // 输出: World
 * ```
 */
public open class MutableObject<T> {
    /**
     * 包装的对象值，使用 Option<T> 表示可能为空
     */
    private var _value: Option<T> = None

    /**
     * 构造一个未初始化的可变对象
     *
     * 调用 getValue() 将抛出 IllegalStateException
     */
    public init() {
        _value = None
    }

    /**
     * 构造一个指定值的可变对象
     *
     * @param value 初始值
     */
    public init(value: T) {
        _value = Some(value)
    }

    /**
     * 获取当前包装的对象值
     *
     * @return 当前值
     * @throws IllegalStateException 如果值未设置
     */
    public func getValue(): T {
        match (_value) {
            case Some(v) => v
            case None => throw IllegalStateException("Value not set")
        }
    }

    /**
     * 设置新的对象值
     *
     * @param value 新值
     */
    public func setValue(value: T): Unit {
        _value = Some(value)
    }

    /**
     * 判断是否已设置值
     *
     * @return true 如果值已设置，false 如果为 None
     */
    public func isSet(): Bool {
        match (_value) {
            case Some(_) => true
            case None => false
        }
    }

    /**
     * 相等性判断
     *
     * @param obj 比较对象
     * @return true 如果值相等，false 否则
     */
    public func equals(obj: Object): Bool {
        match (obj) {
            case other: MutableObject<T> => _compareValues(_value, other._value)
            case _ => false
        }
    }

    /**
     * 比较两个 Option<T> 值是否相等
     *
     * @param v1 第一个值
     * @param v2 第二个值
     * @return true 如果相等，false 否则
     */
    private func _compareValues(v1: Option<T>, v2: Option<T>): Bool {
        match (v1) {
            case Some(val1) => compareValuesSome(val1, v2)
            case None => isNoneBoth(v1, v2)
        }
    }

    // 辅助方法：v1 是 Some 时的比较
    private func compareValuesSome(val1: T, v2: Option<T>): Bool {
        match (v2) {
            case Some(val2) => compareToString(val1, val2)
            case None => false
        }
    }

    // 辅助方法：将两个值转换为 ToString 接口后比较
    private func compareToString(v1: T, v2: T): Bool {
        let str1Opt = v1 as ToString
        match (str1Opt) {
            case Some(s1) => compareWithSecond(s1, v2)
            case None => false
        }
    }

    // 辅助方法：用第二个值进行比较
    private func compareWithSecond(s1: ToString, v2: T): Bool {
        let str2Opt = v2 as ToString
        match (str2Opt) {
            case Some(s2) => s1.toString() == s2.toString()
            case None => false
        }
    }

    // 辅助方法：v1 是 None 时检查 v2 是否也是 None
    private func isNoneBoth(_: Option<T>, v2: Option<T>): Bool {
        match (v2) {
            case Some(_) => false
            case None => true
        }
    }

    /**
     * 计算哈希码
     *
     * @return 哈希码值
     */
    public func hashCode(): Int64 {
        match (_value) {
            case Some(v) => computeHashCode(v)
            case None => 0
        }
    }

    // 辅助方法：计算值的哈希码
    private func computeHashCode(value: T): Int64 {
        match (value as Hashable) {
            case Some(hashable) => hashable.hashCode()
            case None => 0
        }
    }

    /**
     * 转为字符串表示
     *
     * @return 字符串表示
     */
    public func toString(): String {
        match (_value) {
            case Some(v) => valueToString(v)
            case None => "MutableObject[value not set]"
        }
    }

    // 辅助方法：将值转为字符串
    private func valueToString(value: T): String {
        match (value as ToString) {
            case Some(toStr) => toStr.toString()
            case None => "MutableObject[value set]"
        }
    }
}
