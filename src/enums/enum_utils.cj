package commons_lang4cj.enums

import std.collection.*
import commons_lang4cj.utils.StringUtils

/**
 * EnumUtils
 *
 * 枚举工具类。
 * 由于仓颉语言枚举（enum）与 Java 枚举机制不同（仓颉 enum 是代数数据类型），
 * 且反射机制仍在演进，本工具类提供有限的支持。
 *
 * @since 1.0.0
 */
public class EnumUtils {

    /**
     * 验证枚举名是否有效
     *
     * 注意：由于无法泛型地获取仓颉 enum 的所有值，
     * 此方法目前仅作为 API 占位，或者需要用户传入验证函数/映射。
     *
     * 如果要真正实现，需要 E 实现某个包含 values() 的接口，
     * 但仓颉 enum 没有自动实现这样的接口。
     *
     * 替代方案：用户必须提供枚举值的映射 Map<String, E>
     */
    public static func isValidEnum<E>(enumMap: HashMap<String, E>, enumName: String): Bool {
        if (StringUtils.isEmpty(enumName)) {
            return false
        }
        return enumMap.contains(enumName)
    }

    /**
     * 获取枚举值
     *
     * @param enumMap 枚举名称到值的映射
     * @param enumName 枚举名称
     * @return Option<E>
     */
    public static func getEnum<E>(enumMap: HashMap<String, E>, enumName: String): Option<E> {
        if (StringUtils.isEmpty(enumName)) {
            return None
        }
        return enumMap.get(enumName)
    }

    /**
     * 获取枚举列表
     *
     * @param enumMap
     * @return List<E>
     */
    public static func getEnumList<E>(enumMap: HashMap<String, E>): ArrayList<E> {
        let list = ArrayList<E>()
        for ((_, v) in enumMap) {
            list.add(v)
        }
        return list
    }
}
