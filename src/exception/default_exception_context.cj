package commons_lang4cj.exception

import std.collection.*

public class DefaultExceptionContext <: ExceptionContext {
    private let _contextValues: ArrayList<(String, Any)> = ArrayList<(String, Any)>()

    public init() {}

    public func addContextValue(label: String, value: Any): DefaultExceptionContext {
        _contextValues.add((label, value))
        this
    }

    public func setContextValue(label: String, value: Any): DefaultExceptionContext {
        var i: Int64 = 0
        while (i < Int64(_contextValues.size)) {
            let (k, _) = _contextValues[Int64(i)]
            if (k == label) {
                _contextValues.remove(at: Int64(i))
                continue
            }
            i += 1
        }
        addContextValue(label, value)
    }

    public func getContextEntries(): ArrayList<(String, Any)> {
        _contextValues
    }

    public func getContextLabels(): HashSet<String> {
        let s = HashSet<String>()
        for ((k, _) in _contextValues) {
            s.add(k)
        }
        s
    }

    public func getContextValues(label: String): ArrayList<Any> {
        let list = ArrayList<Any>()
        for ((k, v) in _contextValues) {
            if (k == label) {
                list.add(v)
            }
        }
        list
    }

    public func getFirstContextValue(label: String): Option<Any> {
        for ((k, v) in _contextValues) {
            if (k == label) {
                return Some(v)
            }
        }
        None
    }

    public func getFormattedExceptionMessage(baseMessage: Option<String>): String {
        let sb = StringBuilder(256)
        match (baseMessage) {
            case Some(m) => sb.append(m)
            case None => ()
        }
        if (_contextValues.size > 0) {
            if (sb.toString().size > 0) {
                sb.append("\n")
            }
            sb.append("Exception Context:\n")
            var idx: Int64 = 0
            for ((k, v) in _contextValues) {
                idx += 1
                sb.append("\t[")
                sb.append(idx.toString())
                sb.append(":")
                sb.append(k)
                sb.append("=")
                sb.append(safeToString(v))
                sb.append("]\n")
            }
            sb.append("---------------------------------")
        }
        sb.toString()
    }

    private func safeToString(value: Any): String {
        match (value as ToString) {
            case Some(t) => t.toString()
            case None => "?"
        }
    }
}
