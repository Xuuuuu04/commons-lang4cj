package commons_lang4cj.utils

public class Strings {
    private let _ignoreCase: Bool

    private init(ignoreCase: Bool) {
        _ignoreCase = ignoreCase
    }

    public static var CS: Strings = Strings(false)
    public static var CI: Strings = Strings(true)

    public func equals(a: String, b: String): Bool {
        if (_ignoreCase) {
            StringUtils.lowerCase(a) == StringUtils.lowerCase(b)
        } else {
            a == b
        }
    }

    public func contains(str: String, search: String): Bool {
        if (_ignoreCase) {
            StringUtils.contains(StringUtils.lowerCase(str), StringUtils.lowerCase(search))
        } else {
            StringUtils.contains(str, search)
        }
    }

    public func startsWith(str: String, prefix: String): Bool {
        if (_ignoreCase) {
            StringUtils.lowerCase(str).startsWith(StringUtils.lowerCase(prefix))
        } else {
            str.startsWith(prefix)
        }
    }

    public func endsWith(str: String, suffix: String): Bool {
        if (_ignoreCase) {
            StringUtils.lowerCase(str).endsWith(StringUtils.lowerCase(suffix))
        } else {
            str.endsWith(suffix)
        }
    }
}
