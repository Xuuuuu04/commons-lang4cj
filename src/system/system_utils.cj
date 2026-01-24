package commons_lang4cj.system

import std.env.*

/**
 * SystemUtils 类
 * 提供系统相关的实用方法，如操作系统检测、用户目录获取等。
 */
public class SystemUtils {

    // Windows OS Detection
    @When[os == "Windows"]
    public static const IS_OS_WINDOWS = true
    @When[os != "Windows"]
    public static const IS_OS_WINDOWS = false

    // Linux OS Detection
    @When[os == "Linux"]
    public static const IS_OS_LINUX = true
    @When[os != "Linux"]
    public static const IS_OS_LINUX = false

    // macOS Detection
    @When[os == "macOS"]
    public static const IS_OS_MACOS = true
    @When[os != "macOS"]
    public static const IS_OS_MACOS = false

    /**
     * 获取用户主目录
     * @return Option<String> 用户主目录路径
     */
    public static func getUserHome(): Option<String> {
        try {
            return Some(getHomeDirectory().toString())
        } catch (e: Exception) {
            return None
        }
    }

    /**
     * 获取当前工作目录
     * @return Option<String> 当前工作目录路径
     */
    public static func getUserDir(): Option<String> {
        try {
            return Some(getWorkingDirectory().toString())
        } catch (e: Exception) {
            return None
        }
    }

    /**
     * 获取系统换行符
     */
    @When[os == "Windows"]
    public static const LINE_SEPARATOR = "\r\n"
    @When[os != "Windows"]
    public static const LINE_SEPARATOR = "\n"

    /**
     * 获取临时目录
     * @return Option<String> 临时目录路径
     */
    public static func getJavaIoTmpDir(): Option<String> {
        // TODO: Fix getEnv issue or find correct API for environment variables
        None
    }

    /**
     * 获取操作系统名称
     * @return Option<String> 操作系统名称
     */
    public static func getOsName(): Option<String> {
        getOsNameImpl()
    }

    @When[os == "Windows"]
    private static func getOsNameImpl(): Option<String> {
        Some("Windows")
    }

    @When[os == "Linux"]
    private static func getOsNameImpl(): Option<String> {
        Some("Linux")
    }

    @When[os == "macOS"]
    private static func getOsNameImpl(): Option<String> {
        Some("macOS")
    }

    @When[os != "Windows" && os != "Linux" && os != "macOS"]
    private static func getOsNameImpl(): Option<String> {
        Some("Unknown")
    }
}
