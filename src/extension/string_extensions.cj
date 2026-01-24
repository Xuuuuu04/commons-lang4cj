package commons_lang4cj.extension

import commons_lang4cj.utils.StringUtils

/**
 * StringExtensions 字符串扩展
 *
 * 为 String 类型添加实用方法
 *
 * @since 1.0.0
 */
extend String {
    /**
     * 检查是否为空白
     */
    public func isBlank(): Bool {
        StringUtils.isBlank(this)
    }

    /**
     * 首字母大写
     */
    public func capitalize(): String {
        StringUtils.capitalize(this)
    }

    /**
     * 缩略字符串
     *
     * @param maxWidth 最大宽度
     */
    public func abbreviate(maxWidth: Int64): String {
        StringUtils.abbreviate(this, maxWidth)
    }

    /**
     * 旋转字符串
     *
     * @param shift 移动位数
     */
    public func rotate(shift: Int64): String {
        StringUtils.rotate(this, shift)
    }

    /**
     * 去除首尾空白
     */
    public func trim(): String {
        StringUtils.trim(this)
    }

    /**
     * 转为大写
     */
    public func upperCase(): String {
        StringUtils.upperCase(this)
    }

    /**
     * 转为小写
     */
    public func lowerCase(): String {
        StringUtils.lowerCase(this)
    }
}
