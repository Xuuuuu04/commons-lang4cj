package commons_lang4cj.text

import std.collection.*

public abstract class StrLookup {
    public init() {}

    public open func lookup(key: String): Option<String> {
        let _ = key
        None
    }

    public static func noneLookup(): StrLookup {
        NoneStrLookup()
    }

    public static func mapLookup(map: HashMap<String, String>): StrLookup {
        MapStrLookup(map)
    }
}

private class NoneStrLookup <: StrLookup {
    public init() {
        super()
    }

    public override func lookup(_: String): Option<String> {
        None
    }
}

private class MapStrLookup <: StrLookup {
    private let _map: HashMap<String, String>

    public init(map: HashMap<String, String>) {
        super()
        _map = map
    }

    public override func lookup(key: String): Option<String> {
        _map.get(key)
    }
}
