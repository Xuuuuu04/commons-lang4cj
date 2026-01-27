package commons_lang4cj.utils

import std.collection.*
import commons_lang4cj.arch.*

public class ArchUtils {
    private static let ARCH_TO_PROCESSOR: HashMap<String, Processor> = HashMap<String, Processor>()
    private static var _inited: Bool = false

    private init() {}

    private static func ensureInit(): Unit {
        if (_inited) {
            return
        }
        _inited = true
        initX86_32()
        initX86_64()
        initIA64_32()
        initIA64_64()
        initPPC_32()
        initPPC_64()
        initAarch64()
        initRiscV32()
        initRiscV64()
    }

    private static func addProcessor(key: String, processor: Processor): Unit {
        if (ARCH_TO_PROCESSOR.contains(key)) {
            throw IllegalStateException("Key ${key} already exists in processor map")
        }
        ARCH_TO_PROCESSOR[key] = processor
    }

    private static func addProcessors(processor: Processor, keys: Array<String>): Unit {
        for (k in keys) {
            addProcessor(k, processor)
        }
    }

    public static func getProcessor(): Option<Processor> {
        None
    }

    public static func getProcessor(value: String): Option<Processor> {
        ensureInit()
        ARCH_TO_PROCESSOR.get(value)
    }

    private static func initAarch64(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_64, ProcessorType.AARCH_64), ["aarch64"])
    }

    private static func initIA64_32(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_32, ProcessorType.IA_64), ["ia64_32", "ia64n"])
    }

    private static func initIA64_64(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_64, ProcessorType.IA_64), ["ia64", "ia64w"])
    }

    private static func initPPC_32(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_32, ProcessorType.PPC), ["ppc", "power", "powerpc", "power_pc", "power_rs"])
    }

    private static func initPPC_64(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_64, ProcessorType.PPC), ["ppc64", "power64", "powerpc64", "power_pc64", "power_rs64"])
    }

    private static func initRiscV32(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_32, ProcessorType.RISC_V), ["riscv32"])
    }

    private static func initRiscV64(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_64, ProcessorType.RISC_V), ["riscv64"])
    }

    private static func initX86_32(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_32, ProcessorType.X86), ["x86", "i386", "i486", "i586", "i686", "pentium"])
    }

    private static func initX86_64(): Unit {
        addProcessors(Processor(ProcessorArch.BIT_64, ProcessorType.X86), ["x86_64", "amd64", "em64t", "universal"])
    }
}
