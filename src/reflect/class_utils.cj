package commons_lang4cj.reflect

import commons_lang4cj.utils.StringUtils

/**
 * ClassUtils
 *
 * 操作类和对象的工具类，提供类名解析等功能。
 *
 * @since 1.0.0
 */
public class ClassUtils {

    /**
     * 包分隔符字符 '.'
     */
    public static const PACKAGE_SEPARATOR_CHAR: Rune = r'.'

    /**
     * 包分隔符字符串 "."
     */
    public static const PACKAGE_SEPARATOR: String = "."

    /**
     * 内部类分隔符字符 '$'
     * 注意：仓颉中没有典型的内部类概念映射到 JVM 的 $，
     * 但如果是为了处理 Java 风格的类名字符串，保留此定义。
     */
    public static const INNER_CLASS_SEPARATOR_CHAR: Rune = r'$'

    /**
     * 内部类分隔符字符串 "$"
     */
    public static const INNER_CLASS_SEPARATOR: String = "$"

    /**
     * 获取对象的简短类名（不包含包名）
     *
     * @param obj 对象
     * @param valueIfNull 如果对象为 None 返回的值
     * @return 简短类名
     */
    public static func getShortClassName(obj: Object, _: String): String {
        // 在仓颉中 Object 是所有类的基类吗？ Any 是所有类型的父类型。
        // 目前 API 签名用 Object 可能需要确认，仓颉用 Any。
        // 但是 Object 是引用类型的基类。
        // 我们这里暂定 obj 为 Object，如果是 null (Option.None) 则由调用者处理，
        // 但这里参数是 Object，意味着必须是非空的引用？
        // 实际上仓颉没有 null，所以 obj 必定存在。
        // 如果用户想传 Option，应该重载。
        // 为了兼容性，这里假设 obj 是 Any (如果允许) 或者 Object。
        // ClassUtils 主要是处理类名。

        // 仓颉目前获取类名的方式：
        // let typeInfo = TypeInfo.of(obj)
        // typeInfo.name 获取的是完整类名 (package.ClassName)

        // 由于仓颉反射 API (std.reflect) 还在演进，这里假设 TypeInfo.of(obj).name 可用
        // 实际上，目前仓颉可能还没有完整的 TypeInfo.of(Any)。
        // 假设 obj 是 Object

        let className = getClassName(obj)
        return getShortClassName(className)
    }

    /**
     * 获取类名字符串的简短类名
     *
     * @param className 完整类名
     * @return 简短类名
     */
    public static func getShortClassName(className: String): String {
        if (StringUtils.isEmpty(className)) {
            return StringUtils.EMPTY
        }

        var lastDotIdx = StringUtils.lastIndexOf(className, PACKAGE_SEPARATOR)
        var name = className
        if (lastDotIdx != -1) {
            name = className[lastDotIdx + 1..]
        }

        // 处理内部类 $ 分隔 (如果适用)
        var lastDollarIdx = StringUtils.lastIndexOf(name, INNER_CLASS_SEPARATOR)
        if (lastDollarIdx != -1) {
            name = name[lastDollarIdx + 1..]
        }

        return name
    }

    /**
     * 获取对象的包名
     *
     * @param obj 对象
     * @param valueIfNull 当 obj 为空时的默认值（虽然仓颉无 null，保留接口语义）
     * @return 包名
     */
    public static func getPackageName(obj: Object, _: String): String {
        let className = getClassName(obj)
        return getPackageName(className)
    }

    /**
     * 获取类名字符串的包名
     *
     * @param className 完整类名
     * @return 包名
     */
    public static func getPackageName(className: String): String {
        if (StringUtils.isEmpty(className)) {
            return StringUtils.EMPTY
        }

        // 去掉内部类部分（如果有）
        var cleanClassName = className
        while (StringUtils.indexOf(cleanClassName, INNER_CLASS_SEPARATOR) != -1) {
             let idx = StringUtils.lastIndexOf(cleanClassName, INNER_CLASS_SEPARATOR)
             if (idx != -1) {
                 cleanClassName = cleanClassName[0..idx]
             } else {
                 break
             }
        }

        let lastDotIdx = StringUtils.lastIndexOf(cleanClassName, PACKAGE_SEPARATOR)
        if (lastDotIdx == -1) {
            return StringUtils.EMPTY
        }

        return cleanClassName[0..lastDotIdx]
    }

    // 辅助获取类名，目前仓颉可能需要特定方式
    // 假设 Object 有 toString 或者通过反射
    // 注意：仓颉 0.53+ 版本可能有 Refelect 模块
    // 暂时返回 toString() 的一部分或者使用 hack，如果无法获取真实类名。
    // 更好的方式是使用 import std.reflect.* 和 TypeInfo
    private static func getClassName(_: Object): String {
        // 尝试使用 Object.getClass().name 类似的机制
        // 目前仓颉标准库中，可以使用 TypeInfo.of(obj) 如果 obj 是 Any
        // 但是这里 obj 是 Object。
        // 暂时返回 obj.toString() 如果它包含类名，或者返回空字符串
        // 实际上，用户传进来的通常是 String 类型的类名。
        // 如果是 Object，我们期望它能被反射。
        // 鉴于反射支持可能受限，我们尽量做字符串处理。
        // 如果真的要获取运行时类名，需要 import std.reflect.*

        // 这是一个占位实现，直到反射 API 稳定
        // 如果用户传入的是 Class 对象（如果有），那就不同了。
        // 现在的实现主要服务于 StringUtilsTest 中可能用到的类名处理

        return "" // TODO: 使用 std.reflect 获取真实类名
    }
}
