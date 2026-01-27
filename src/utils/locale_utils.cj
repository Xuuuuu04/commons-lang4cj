package commons_lang4cj.utils

import std.collection.*

public struct Locale {
    public let language: String
    public let country: String
    public let variant: String

    public init(language: String, country: String, variant: String) {
        this.language = language
        this.country = country
        this.variant = variant
    }

    public func toString(): String {
        if (variant.size > 0) {
            "${language}_${country}_${variant}"
        } else if (country.size > 0) {
            "${language}_${country}"
        } else {
            language
        }
    }
}

public class LocaleUtils {
    private init() {}

    public static func toLocale(str: String): Option<Locale> {
        if (str.size == 0) {
            return None
        }
        let parts = StringUtils.split(str, "_")
        if (parts.size == 1) {
            return Some(Locale(parts[0], "", ""))
        }
        if (parts.size == 2) {
            return Some(Locale(parts[0], parts[1], ""))
        }
        Some(Locale(parts[0], parts[1], parts[2]))
    }
}
