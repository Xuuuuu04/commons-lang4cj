package commons_lang4cj.text

import std.collection.*
import commons_lang4cj.utils.StringUtils
import commons_lang4cj.system.SystemUtils

/**
 * StrSubstitutor 字符串替换工具
 *
 * 用于替换字符串中的变量，支持 ${var} 格式。
 *
 * @since 1.0.0
 */
public class StrSubstitutor {

    private let valueMap: HashMap<String, String>
    private let prefix: String = "\${"
    private let suffix: String = "}"
    // Bug Fix: 更改转义字符为反斜杠，符合常规预期
    private let escapeChar: Rune = r'\\'

    public init(valueMap: HashMap<String, String>) {
        this.valueMap = valueMap
    }

    public init() {
        this.valueMap = HashMap<String, String>()
    }

    /**
     * 替换字符串中的变量
     *
     * @param source 源字符串
     * @return 替换后的字符串
     */
    public func replace(source: String): String {
        if (StringUtils.isEmpty(source)) {
            return source
        }

        var result = StringBuilder(source.size)
        var i: Int64 = 0
        let len = source.size

        while (i < len) {
            // 检查转义字符
            // Bug Fix: 增加转义字符处理逻辑
            // 如果遇到转义字符 (e.g. '\')，且下一个字符开始是变量前缀 (e.g. '${')，则保留前缀字面量
            let remain = source[i..]
            let firstChar = remain[0] // 获取 Rune (UInt8)

            if (Rune(firstChar) == escapeChar) {
                // 检查是否转义了前缀
                // 注意：source[i+1..] 可能越界，需检查长度
                if (i + 1 < len) {
                    let nextPart = source[(i+1)..]
                    if (StringUtils.startsWith(nextPart, prefix)) {
                        // 发现转义的变量前缀，如 "\${"
                        // 追加 "${" (前缀本身)，并跳过转义符
                        result.append(prefix)
                        i += 1 + prefix.size // 跳过 '\' 和 '${'
                        continue
                    }
                }
                // 普通转义符或未转义前缀，保留转义符
            }

            // 检查前缀
            if (StringUtils.startsWith(remain, prefix)) {
                // 找到前缀，寻找后缀
                let endPos = StringUtils.indexOf(remain, suffix)
                if (endPos != -1) {
                    // 提取变量名
                    let varName = remain[prefix.size..endPos]

                    // 查找值
                    let valueOpt = resolveVariable(varName)
                    match (valueOpt) {
                        case Some(val) => result.append(val)
                        case None =>
                            // 未找到变量，保留原样
                            result.append(prefix)
                            result.append(varName)
                            result.append(suffix)
                    }

                    i += endPos + suffix.size
                    continue
                }
            }

            // 普通字符
            // Fix: source[i] 返回 UInt8，直接 append 会追加数字字符串。
            // 使用切片追加当前字符。
            result.append(source[i..i+1])
            i++
        }

        result.toString()
    }

    /**
     * 静态替换方法
     *
     * @param source 源字符串
     * @param valueMap 变量映射
     * @return 替换后的字符串
     */
    public static func substitute(source: String, valueMap: HashMap<String, String>): String {
        let sub = StrSubstitutor(valueMap)
        sub.replace(source)
    }

    /**
     * 替换系统属性
     *
     * @param source 源字符串
     * @return 替换后的字符串
     */
    public static func replaceSystemProperties(source: String): String {
        // 由于仓颉目前获取所有系统环境变量的 API 可能受限，
        // 这里主要支持一些常见的系统属性，或者基于 SystemUtils 扩展
        let props = HashMap<String, String>()
        if (let Some(v) <- SystemUtils.getUserHome()) {
            props["user.home"] = v
        }
        if (let Some(v) <- SystemUtils.getUserDir()) {
            props["user.dir"] = v
        }
        if (let Some(v) <- SystemUtils.getJavaIoTmpDir()) {
            props["java.io.tmpdir"] = v
        }
        // OS info
        if (let Some(v) <- SystemUtils.getOsName()) {
            props["os.name"] = v
        }

        substitute(source, props)
    }

    private func resolveVariable(varName: String): Option<String> {
        valueMap.get(varName)
    }
}
