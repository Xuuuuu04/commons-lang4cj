# Apache Commons Lang3 迁移矩阵（以仓库内原项目为准）

本矩阵以仓库内 Java 源码树 `commons-lang/src/main/java/org/apache/commons/lang3/**` 为“原项目事实来源”，用于追踪在 `commons-lang4cj` 中的迁移状态。

状态说明：

- ✅ 已实现：已有 CJ 实现与单测
- 🟡 计划中：尚未实现（后续批次会补齐）
- ⚠️ 子集：只实现 CJ 可支持的能力子集（会标注差异并用单测锁定）
- ⛔ 不支持：与 JVM/Java 生态强绑定，CJ 无等价语义或风险过高

## 根包 org.apache.commons.lang3

- ✅ ArrayUtils → `commons_lang4cj.utils.ArrayUtils`
- ✅ BooleanUtils → `commons_lang4cj.utils.BooleanUtils`
- ✅ CharEncoding → `commons_lang4cj.utils.CharEncoding`
- ✅ CharRange → `commons_lang4cj.range.CharRange`
- ✅ CharSet → `commons_lang4cj.utils.CharSet`
- ✅ CharSetUtils → `commons_lang4cj.utils.CharSetUtils`
- ✅ CharUtils → `commons_lang4cj.utils.CharUtils`
- ✅ ClassUtils → `commons_lang4cj.reflect.ClassUtils`
- ✅ EnumUtils → `commons_lang4cj.enums.EnumUtils`
- ✅ IEEE754rUtils → `commons_lang4cj.math.IEEE754rUtils`
- ✅ NumberRange → `commons_lang4cj.range.NumberRange`
- ✅ ObjectUtils → `commons_lang4cj.utils.ObjectUtils`
- ✅ RandomStringUtils → `commons_lang4cj.random.RandomStringUtils`
- ✅ RandomUtils → `commons_lang4cj.random.RandomUtils`
- ✅ Range → `commons_lang4cj.range.Range`
- ✅ RegExUtils → `commons_lang4cj.utils.RegExUtils`
- ✅ StringEscapeUtils → `commons_lang4cj.text.StringEscapeUtils`
- ✅ StringUtils → `commons_lang4cj.utils.StringUtils`
- ✅ SystemUtils → `commons_lang4cj.system.SystemUtils`
- ✅ Validate → `commons_lang4cj.utils.ValidateUtils`
- ✅ BitField → `commons_lang4cj.utils.BitField`

- 🟡 AnnotationUtils
- 🟡 AppendableJoiner
- 🟡 ArchUtils
- 🟡 ArrayFill
- 🟡 ArraySorter
- 🟡 CachedRandomBits
- 🟡 CharSequenceUtils
- 🟡 Charsets
- 🟡 ClassLoaderUtils
- ⛔ ClassPathUtils（classpath 语义强依赖 JVM，默认不支持）
- 🟡 Conversion
- 🟡 DoubleRange
- 🟡 Functions
- 🟡 IntegerRange
- 🟡 JavaVersion
- 🟡 LocaleUtils
- 🟡 LongRange
- 🟡 NotImplementedException
- 🟡 RuntimeEnvironment
- ⛔ SerializationException（仅在提供 SerializationUtils 时才有意义；默认不支持）
- ⛔ SerializationUtils（Java 原生序列化语义强绑定 JVM）
- ⚠️ Streams（取决于 CJ 是否有等价 Stream 生态；默认按子集或不支持处理）
- 🟡 Strings
- 🟡 SystemProperties
- 🟡 ThreadUtils

## 子包 arch

- 🟡 Processor

## 子包 builder

- ✅ CompareToBuilder
- ✅ EqualsBuilder
- ✅ HashCodeBuilder
- ✅ ToStringBuilder
- ✅ ToStringStyle（部分能力与 Java 版一致性会逐步补齐）

- 🟡 AbstractSupplier
- 🟡 Builder
- 🟡 Diff / DiffBuilder / DiffResult / Diffable
- 🟡 DiffExclude / EqualsExclude / HashCodeExclude / ToStringExclude / ToStringSummary
- 🟡 IDKey
- 🟡 MultilineRecursiveToStringStyle / RecursiveToStringStyle / StandardToStringStyle
- ⚠️ Reflection / ReflectionToStringBuilder / ReflectionDiffBuilder（受 CJ 反射限制，预计只能做能力子集）

## 子包 compare

- 🟡 ComparableUtils
- 🟡 ObjectToStringComparator

## 子包 concurrent

- ✅ BackgroundInitializer
- ✅ CircuitBreaker（当前为子集实现，后续补齐更多策略）
- ✅ LazyInitializer
- ✅ Memoizer

- 🟡 AbstractCircuitBreaker / AbstractConcurrentInitializer / AbstractFutureProxy
- 🟡 AtomicInitializer / AtomicSafeInitializer
- 🟡 BasicThreadFactory
- 🟡 CallableBackgroundInitializer
- 🟡 CircuitBreakingException
- 🟡 Computable
- 🟡 ConcurrentException / ConcurrentRuntimeException / Unchecked*Exception
- 🟡 ConcurrentInitializer / ConcurrentUtils / ConstantInitializer
- 🟡 EventCountCircuitBreaker / ThresholdCircuitBreaker
- 🟡 FutureTasks
- 🟡 MultiBackgroundInitializer
- 🟡 TimedSemaphore
- 🟡 UncheckedFuture / UncheckedFutureImpl

### concurrent.locks

- 🟡 LockingVisitors

## 子包 event

- 🟡 EventListenerSupport
- 🟡 EventUtils

## 子包 exception

- ✅ ExceptionUtils
- ✅ ExtendedException（对应 Contexted/Unchecked 体系的子集）

- 🟡 CloneFailedException
- 🟡 ContextedException / ContextedRuntimeException / DefaultExceptionContext / ExceptionContext
- 🟡 UncheckedException
- 🟡 UncheckedIllegalAccessException / UncheckedInterruptedException / UncheckedReflectiveOperationException

## 子包 function

- 🟡 BooleanConsumer / ByteConsumer / ByteSupplier / ShortSupplier / IntToCharFunction
- 🟡 TriConsumer / TriFunction / ToBooleanBiFunction
- 🟡 Consumers / Functions / Suppliers / Predicates / MethodInvokers
- ⚠️ Failable* 全家桶（会按 CJ 异常/函数类型能力裁剪实现范围）

## 子包 math

- ✅ Fraction
- ✅ IEEE754rUtils
- ✅ NumberUtils（注意：根包也有 NumberUtils.java；本库以 utils/number_utils.cj 为准）

## 子包 mutable

- ✅ Mutable / MutableBoolean / MutableByte / MutableDouble / MutableFloat / MutableInt / MutableLong / MutableObject / MutableShort

## 子包 random

- ✅ RandomStringUtils
- ✅ RandomUtils

## 子包 reflect

- ✅ ClassUtils（当前覆盖子集：类名/包名等）

- ⚠️ AccessibleObjects / MemberUtils（强依赖可访问性/反射细节）
- ⚠️ ConstructorUtils / FieldUtils / MethodUtils（受 CJ 反射限制，预计子集）
- 🟡 InheritanceUtils
- ⚠️ TypeUtils / TypeLiteral / Typed（取决于 CJ 泛型反射能力与限制）

## 子包 stream

- ⚠️ IntStreams / LangCollectors / Streams（依赖 Java Stream 生态；默认子集或不支持）

## 子包 text

- ✅ StrSubstitutor
- ✅ StrTokenizer
- ✅ StringEscapeUtils（当前为直接实现；后续可能迁移 translate 引擎以对齐更多行为）
- ✅ WordUtils

- 🟡 CompositeFormat
- 🟡 ExtendedMessageFormat
- 🟡 FormatFactory
- 🟡 FormattableUtils
- 🟡 StrBuilder
- 🟡 StrLookup
- 🟡 StrMatcher

### text.translate

- 🟡 AggregateTranslator
- 🟡 CharSequenceTranslator
- 🟡 CodePointTranslator
- 🟡 EntityArrays
- 🟡 JavaUnicodeEscaper
- 🟡 LookupTranslator
- 🟡 NumericEntityEscaper
- 🟡 NumericEntityUnescaper
- 🟡 OctalUnescaper
- 🟡 UnicodeEscaper
- 🟡 UnicodeUnescaper
- 🟡 UnicodeUnpairedSurrogateRemover

## 子包 time

- ✅ DateFormatUtils
- ✅ DateUtils
- ✅ DurationFormatUtils
- ✅ StopWatch

- 🟡 AbstractFormatCache
- 🟡 CalendarUtils
- 🟡 DateParser / DatePrinter
- 🟡 DurationUtils
- 🟡 FastDateFormat / FastDateParser / FastDatePrinter
- 🟡 FastTimeZone / GmtTimeZone / TimeZones

## 子包 tuple

- ✅ Pair / Triple / TupleUtils
- 🟡 ImmutablePair / ImmutableTriple
- 🟡 MutablePair / MutableTriple

## 子包 util

- 🟡 FluentBitSet
- 🟡 IterableStringTokenizer

