package commons_lang4cj.random

import std.random.*

/**
 * RandomStringUtils 类
 * 提供随机字符串生成功能。
 */
public class RandomStringUtils {
    private static let rnd = Random()

    /**
     * 生成指定长度的随机字符串（包含字母和数字）
     * @param count 长度
     * @return String
     */
    public static func random(count: Int64): String {
        return random(count, false, false)
    }

    /**
     * 生成指定长度的随机字母字符串
     * @param count 长度
     * @return String
     */
    public static func randomAlphabetic(count: Int64): String {
        return random(count, true, false)
    }

    /**
     * 生成指定长度的随机数字字符串
     * @param count 长度
     * @return String
     */
    public static func randomNumeric(count: Int64): String {
        return random(count, false, true)
    }

    /**
     * 生成指定长度的随机字母数字字符串
     * @param count 长度
     * @return String
     */
    public static func randomAlphanumeric(count: Int64): String {
        return random(count, true, true)
    }

    /**
     * 生成随机字符串
     * @param count 长度
     * @param letters 是否包含字母
     * @param numbers 是否包含数字
     * @return String
     */
    public static func random(count: Int64, letters: Bool, numbers: Bool): String {
        if (count == 0) {
            return ""
        }

        // 计算需要的字符集大小
        var size = 0
        if (numbers) { size += 10 }
        if (letters) { size += 52 }
        if (!numbers && !letters) { size += 95 } // 32..126

        let charset = Array<UInt8>(size, repeat: 0)
        var idx = 0

        if (numbers) {
            for (i in 48..=57) {
                charset[idx] = UInt8(i)
                idx++
            }
        }
        if (letters) {
            for (i in 65..=90) {
                charset[idx] = UInt8(i)
                idx++
            }
            for (i in 97..=122) {
                charset[idx] = UInt8(i)
                idx++
            }
        }
        if (!numbers && !letters) {
            for (i in 32..=126) {
                charset[idx] = UInt8(i)
                idx++
            }
        }

        let buffer = Array<UInt8>(count, repeat: 0)
        let len = charset.size

        for (i in 0..count) {
            let r = rnd.nextInt64(len)
            buffer[i] = charset[r]
        }

        return String.fromUtf8(buffer)
    }
}
