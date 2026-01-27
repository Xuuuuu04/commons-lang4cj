package commons_lang4cj.builder

import std.collection.*
import std.core.ThreadLocal

public class ToStringRegistry {
    private static let _local: ThreadLocal<ArrayList<String>> = ThreadLocal<ArrayList<String>>()

    public static func keyOf(obj: ToStringObject): String {
        "${obj.getClassName()}@${obj.getIdentityHashCode()}"
    }

    private static func getList(): ArrayList<String> {
        match (_local.get()) {
            case Some(list) => list
            case None =>
                let list = ArrayList<String>()
                _local.set(Some(list))
                list
        }
    }

    public static func isRegistered(key: String): Bool {
        let list = getList()
        for (k in list) {
            if (k == key) {
                return true
            }
        }
        false
    }

    public static func register(key: String): Unit {
        getList().add(key)
    }

    public static func unregister(key: String): Unit {
        let list = getList()
        var idx = list.size - 1
        while (idx >= 0) {
            if (list[idx] == key) {
                list.remove(at: idx)
                break
            }
            idx--
        }
        if (list.size == 0) {
            _local.set(None)
        }
    }
}
