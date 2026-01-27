package commons_lang4cj.system

import std.env.*

public class RuntimeEnvironment {
    private init() {}

    public static func getOsName(): String {
        match (SystemUtils.getOsName()) {
            case Some(v) => v
            case None => "Unknown"
        }
    }

    public static func getUserHome(): Option<String> {
        SystemUtils.getUserHome()
    }

    public static func getWorkingDirectory(): Option<String> {
        SystemUtils.getUserDir()
    }
}
