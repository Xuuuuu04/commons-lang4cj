package commons_lang4cj.reflect

import commons_lang4cj.utils.StringUtils

public class ClassLoaderUtils {
    private init() {}

    public static func toResourceName(className: String): String {
        StringUtils.replace(className, ".", "/") + ".class"
    }
}
