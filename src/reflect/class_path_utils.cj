package commons_lang4cj.reflect

import commons_lang4cj.utils.StringUtils

public class ClassPathUtils {
    private init() {}

    public static func toFullyQualifiedName(packageName: String, className: String): String {
        if (packageName.size == 0) {
            return className
        }
        if (className.size == 0) {
            return packageName
        }
        if (StringUtils.endsWith(packageName, ".")) {
            return packageName + className
        }
        packageName + "." + className
    }
}
