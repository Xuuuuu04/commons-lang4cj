package commons_lang4cj.arch

import std.deriving.*

@Derive[Equatable, ToString]
public enum ProcessorArch {
    | BIT_32
    | BIT_64
}

@Derive[Equatable, ToString]
public enum ProcessorType {
    | X86
    | IA_64
    | PPC
    | AARCH_64
    | RISC_V
    | UNKNOWN
}

public class Processor {
    private let _arch: ProcessorArch
    private let _type: ProcessorType

    public init(arch: ProcessorArch, processorType: ProcessorType) {
        _arch = arch
        _type = processorType
    }

    public func getArch(): ProcessorArch {
        _arch
    }

    public func getType(): ProcessorType {
        _type
    }

    public func toString(): String {
        "${_type}:${_arch}"
    }
}
