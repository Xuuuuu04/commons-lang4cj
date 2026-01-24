package commons_lang4cj.mutable

/**
 * 可变对象接口
 * 提供设置和获取值的基本方法
 */
public interface Mutable<T> {
    /**
     * 获取当前值
     */
    func getValue(): T

    /**
     * 设置新值
     */
    mut func setValue(value: T): Unit
}
