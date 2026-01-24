package commons_lang4cj.text

import commons_lang4cj.utils.StringUtils

/**
 * WordUtils 单词处理工具类
 *
 * 用于处理单词相关的字符串操作，如换行、首字母大写、提取首字母等。
 *
 * @since 1.0.0
 */
public class WordUtils {

    /**
     * 换行文本
     *
     * @param str 待处理的字符串
     * @param wrapLength 每行最大长度
     * @return 换行后的字符串
     */
    public static func wrap(str: String, wrapLength: Int64): String {
        wrap(str, wrapLength, "\n", false)
    }

    /**
     * 换行文本（自定义换行符和长单词处理）
     *
     * @param str 待处理的字符串
     * @param wrapLength 每行最大长度
     * @param newLineStr 换行符
     * @param wrapLongWords 是否强制断行长单词
     * @return 换行后的字符串
     */
    public static func wrap(str: String, wrapLength: Int64, newLineStr: String, wrapLongWords: Bool): String {
        if (StringUtils.isEmpty(str)) {
            return str
        }

        var length = wrapLength
        if (length < 1) {
            length = 1
        }

        let inputLineLength = str.size
        var offset: Int64 = 0
        var wrappedLine = StringBuilder(inputLineLength + 32)

        while (inputLineLength - offset > length) {
            // 跳过行首空格
            if (str[offset] == 32u8) {
                offset++
                continue
            }

            // 待处理的当前行片段
            let endIndex = offset + length + 1
            let safeEndIndex = if (endIndex > inputLineLength) { inputLineLength } else { endIndex }
            // 注意：str[0..safeEndIndex] 会创建一个新字符串，lastIndexOf 是基于该新字符串的索引
            // 这里的逻辑假设 lastIndexOf 返回的是绝对索引，因为新字符串是从 0 开始切分的
            let subStrToCheck = str[0..safeEndIndex]
            let spaceToWrapAt = StringUtils.lastIndexOf(subStrToCheck, " ")

            if (spaceToWrapAt >= offset) {
                // 在当前行宽度内找到了空格
                wrappedLine.append(str[offset..spaceToWrapAt])
                wrappedLine.append(newLineStr)
                offset = spaceToWrapAt + 1
            } else {
                // 当前行宽度内没有空格
                if (wrapLongWords) {
                    // 强制断行
                    wrappedLine.append(str[offset..(offset + length)])
                    wrappedLine.append(newLineStr)
                    offset += length
                } else {
                    // 不强制断行，寻找下一个空格
                    let nextSpace = StringUtils.indexOf(str, " ", offset + length)
                    if (nextSpace >= 0) {
                        wrappedLine.append(str[offset..nextSpace])
                        wrappedLine.append(newLineStr)
                        offset = nextSpace + 1
                    } else {
                        // 后面没有空格了，追加剩余所有
                        wrappedLine.append(str[offset..])
                        offset = inputLineLength
                    }
                }
            }
        }

        // 追加剩余部分
        if (offset < inputLineLength) {
            wrappedLine.append(str[offset..])
        }

        wrappedLine.toString()
    }

    /**
     * 单词首字母大写
     *
     * @param str 待处理的字符串
     * @return 首字母大写的字符串
     */
    public static func capitalize(str: String): String {
        capitalize(str, None)
    }

    /**
     * 单词首字母大写（自定义分隔符）
     *
     * @param str 待处理的字符串
     * @param delimiters 分隔符数组，如果为 None 则默认使用空白字符
     * @return 首字母大写的字符串
     */
    public static func capitalize(str: String, delimiters: Option<Array<Rune>>): String {
        if (StringUtils.isEmpty(str)) {
            return str
        }

        let delimLen = match (delimiters) {
            case Some(arr) => arr.size
            case None => -1
        }

        if (delimLen == 0) {
            return str
        }

        var buffer = StringBuilder(str.size)
        var capitalizeNext = true

        for (r in str) {
            let rune = Rune(r)
            let isDelim = isDelimiter(rune, delimiters)
            // println("DEBUG: char='${rune}', isDelim=${isDelim}, capitalizeNext=${capitalizeNext}")

            if (isDelim) {
                buffer.append(rune)
                capitalizeNext = true
            } else if (capitalizeNext) {
                buffer.append(StringUtils.upperCase(rune.toString()))
                capitalizeNext = false
            } else {
                buffer.append(rune)
            }
        }

        buffer.toString()
    }

    /**
     * 单词首字母小写
     *
     * @param str 待处理的字符串
     * @return 首字母小写的字符串
     */
    public static func uncapitalize(str: String): String {
        uncapitalize(str, None)
    }

    /**
     * 单词首字母小写（自定义分隔符）
     *
     * @param str 待处理的字符串
     * @param delimiters 分隔符数组，如果为 None 则默认使用空白字符
     * @return 首字母小写的字符串
     */
    public static func uncapitalize(str: String, delimiters: Option<Array<Rune>>): String {
        if (StringUtils.isEmpty(str)) {
            return str
        }

        let delimLen = match (delimiters) {
            case Some(arr) => arr.size
            case None => -1
        }

        if (delimLen == 0) {
            return str
        }

        var buffer = StringBuilder(str.size)
        // Bug Fix: 如果指定了分隔符，首字母不应默认处理，除非它紧跟在分隔符之后
        // 如果未指定分隔符（None），则默认视作句子开头，首字母需要处理
        var uncapitalizeNext = match (delimiters) {
            case None => true
            case Some(_) => false
        }

        for (r in str) {
            let rune = Rune(r)
            if (isDelimiter(rune, delimiters)) {
                buffer.append(rune)
                uncapitalizeNext = true
            } else if (uncapitalizeNext) {
                buffer.append(StringUtils.lowerCase(rune.toString()))
                uncapitalizeNext = false
            } else {
                buffer.append(rune)
            }
        }

        buffer.toString()
    }

    /**
     * 大小写互换
     *
     * @param str 待处理的字符串
     * @return 大小写互换后的字符串
     */
    public static func swapCase(str: String): String {
        StringUtils.swapCase(str)
    }

    /**
     * 提取首字母
     *
     * @param str 待处理的字符串
     * @return 所有单词的首字母组成的字符串
     */
    public static func initials(str: String): String {
        initials(str, None)
    }

    /**
     * 提取首字母（自定义分隔符）
     *
     * @param str 待处理的字符串
     * @param delimiters 分隔符数组
     * @return 所有单词的首字母组成的字符串
     */
    public static func initials(str: String, delimiters: Option<Array<Rune>>): String {
        if (StringUtils.isEmpty(str)) {
            return str
        }

        if (match (delimiters) { case Some(arr) => arr.size == 0 case None => false }) {
            return ""
        }

        var buffer = StringBuilder(str.size / 2 + 1)
        var lastWasGap = true

        for (r in str) {
            let rune = Rune(r)
            if (isDelimiter(rune, delimiters)) {
                lastWasGap = true
            } else if (lastWasGap) {
                buffer.append(rune)
                lastWasGap = false
            }
        }

        buffer.toString()
    }

    // 私有辅助方法
    private static func isDelimiter(rune: Rune, delimiters: Option<Array<Rune>>): Bool {
        match (delimiters) {
            case None =>
                // 默认空白字符为分隔符
                let code = UInt32(rune)
                // 简单的空白字符判断，参考 StringUtils.isWhitespaceRune
                code == 0x20 || code == 0x09 || code == 0x0A || code == 0x0D
            case Some(arr) =>
                for (d in arr) {
                    if (d == rune) {
                        return true
                    }
                }
                false
        }
    }
}
