package commons_lang4cj.event

import std.collection.*

public class EventUtils {
    private init() {}

    public static func addEventListener<T>(support: EventListenerSupport<T>, listener: T) {
        support.addListener(listener)
    }

    public static func removeEventListener<T>(support: EventListenerSupport<T>, listener: T) {
        support.removeListener(listener)
    }
}
