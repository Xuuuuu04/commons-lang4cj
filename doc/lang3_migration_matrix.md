# Apache Commons Lang3 迁移矩阵（以仓库内原项目为准）

本矩阵以仓库内 Java 源码树 `commons-lang/src/main/java/org/apache/commons/lang3/**` 为“原项目事实来源”，用于追踪在 `commons-lang4cj` 中的迁移状态。

状态说明：

- ✅ 已实现：已有 CJ 实现与单测
- 🟡 计划中：尚未实现（后续批次会补齐）
- ⚠️ 子集：只实现 CJ 可支持的能力子集（会标注差异并用单测锁定）
- ⛔ 不支持：与 JVM/Java 生态强绑定，CJ 无等价语义或风险过高

## 根包 org.apache.commons.lang3

- ✅ AnnotationUtils → `commons_lang4cj.reflect.AnnotationUtils`
- ✅ AppendableJoiner → `commons_lang4cj.utils.AppendableJoiner`
- ✅ ArchUtils → `commons_lang4cj.utils.ArchUtils`
- ✅ ArrayFill → `commons_lang4cj.utils.ArrayFill`
- ✅ ArraySorter → `commons_lang4cj.utils.ArraySorter`
- ✅ ArrayUtils → `commons_lang4cj.utils.ArrayUtils`
- ✅ BitField → `commons_lang4cj.utils.BitField`
- ✅ BooleanUtils → `commons_lang4cj.utils.BooleanUtils`
- ✅ CharEncoding → `commons_lang4cj.utils.CharEncoding`
- ✅ CharSequenceUtils → `commons_lang4cj.utils.CharSequenceUtils`
- ✅ CharSet → `commons_lang4cj.utils.CharSet`
- ✅ CharSetUtils → `commons_lang4cj.utils.CharSetUtils`
- ✅ CharUtils → `commons_lang4cj.utils.CharUtils`
- ⛔ ClassLoaderUtils → `commons_lang4cj.reflect.ClassLoaderUtils`
- ⛔ ClassPathUtils → `commons_lang4cj.reflect.ClassPathUtils`
- ✅ ClassUtils → `commons_lang4cj.reflect.ClassUtils`
- ✅ Conversion → `commons_lang4cj.utils.Conversion`
- ✅ DoubleRange → `commons_lang4cj.range.DoubleRange`
- ✅ EnumUtils → `commons_lang4cj.enums.EnumUtils`
- ✅ Functions → `commons_lang4cj.utils.Functions`
- ✅ IntegerRange → `commons_lang4cj.range.IntegerRange`
- ✅ JavaVersion → `commons_lang4cj.utils.JavaVersion`
- ✅ LocaleUtils → `commons_lang4cj.utils.LocaleUtils`
- ✅ LongRange → `commons_lang4cj.range.LongRange`
- ✅ NotImplementedException → `commons_lang4cj.exception.NotImplementedException`
- ✅ NumberRange → `commons_lang4cj.range.NumberRange`
- ✅ ObjectUtils → `commons_lang4cj.utils.ObjectUtils`
- ✅ RandomStringUtils → `commons_lang4cj.random.RandomStringUtils`
- ✅ RandomUtils → `commons_lang4cj.random.RandomUtils`
- ✅ Range → `commons_lang4cj.range.Range`
- ✅ RegExUtils → `commons_lang4cj.utils.RegExUtils`
- ✅ RuntimeEnvironment → `commons_lang4cj.system.RuntimeEnvironment`
- ⛔ SerializationException → `commons_lang4cj.utils.SerializationException`
- ⛔ SerializationUtils → `commons_lang4cj.utils.SerializationUtils`
- ✅ Streams → `commons_lang4cj.stream.Streams`
- ✅ StringEscapeUtils → `commons_lang4cj.text.StringEscapeUtils`
- ✅ StringUtils → `commons_lang4cj.utils.StringUtils`
- ✅ Strings → `commons_lang4cj.utils.Strings`
- ✅ SystemProperties → `commons_lang4cj.system.SystemProperties`
- ✅ SystemUtils → `commons_lang4cj.system.SystemUtils`
- ✅ ThreadUtils → `commons_lang4cj.system.ThreadUtils`
- ✅ Validate → `commons_lang4cj.utils.Validate`

## 子包 arch

- ✅ Processor → `commons_lang4cj.arch.Processor`

## 子包 builder

- ✅ AbstractSupplier → `commons_lang4cj.builder.AbstractSupplier`
- ✅ Builder → `commons_lang4cj.builder.Builder`
- ✅ CompareToBuilder → `commons_lang4cj.builder.CompareToBuilder`
- ✅ Diff → `commons_lang4cj.builder.Diff`
- ✅ DiffBuilder → `commons_lang4cj.builder.DiffBuilder`
- ✅ DiffResult → `commons_lang4cj.builder.DiffResult`
- ✅ Diffable → `commons_lang4cj.builder.Diffable`
- ✅ EqualsBuilder → `commons_lang4cj.builder.EqualsBuilder`
- ✅ HashCodeBuilder → `commons_lang4cj.builder.HashCodeBuilder`
- ✅ MultilineRecursiveToStringStyle → `commons_lang4cj.builder.MultilineRecursiveToStringStyle`
- ✅ RecursiveToStringStyle → `commons_lang4cj.builder.RecursiveToStringStyle`
- ✅ ReflectionDiffBuilder → `commons_lang4cj.builder.ReflectionDiffBuilder`
- ✅ ReflectionToStringBuilder → `commons_lang4cj.builder.ReflectionToStringBuilder`
- ✅ StandardToStringStyle → `commons_lang4cj.builder.StandardToStringStyle`
- ✅ ToStringBuilder → `commons_lang4cj.builder.ToStringBuilder`
- ✅ ToStringStyle → `commons_lang4cj.builder.ToStringStyle`

## 子包 compare

- ✅ ComparableUtils → `commons_lang4cj.compare.ComparableUtils`
- ✅ ObjectToStringComparator → `commons_lang4cj.compare.ObjectToStringComparator`

## 子包 concurrent

- ✅ AbstractCircuitBreaker → `commons_lang4cj.concurrent.AbstractCircuitBreaker`
- ✅ AbstractConcurrentInitializer → `commons_lang4cj.concurrent.AbstractConcurrentInitializer`
- ✅ AbstractFutureProxy → `commons_lang4cj.concurrent.AbstractFutureProxy`
- ✅ AtomicInitializer → `commons_lang4cj.concurrent.AtomicInitializer`
- ✅ AtomicSafeInitializer → `commons_lang4cj.concurrent.AtomicSafeInitializer`
- ✅ BackgroundInitializer → `commons_lang4cj.concurrent.BackgroundInitializer`
- ✅ BasicThreadFactory → `commons_lang4cj.concurrent.BasicThreadFactory`
- ✅ CallableBackgroundInitializer → `commons_lang4cj.concurrent.CallableBackgroundInitializer`
- ✅ CircuitBreaker → `commons_lang4cj.concurrent.CircuitBreaker`
- ✅ CircuitBreakingException → `commons_lang4cj.concurrent.CircuitBreakingException`
- ✅ Computable → `commons_lang4cj.concurrent.Computable`
- ✅ ConcurrentException → `commons_lang4cj.concurrent.ConcurrentException`
- ✅ ConcurrentInitializer → `commons_lang4cj.concurrent.ConcurrentInitializer`
- ✅ ConcurrentRuntimeException → `commons_lang4cj.concurrent.ConcurrentRuntimeException`
- ✅ ConcurrentUtils → `commons_lang4cj.concurrent.ConcurrentUtils`
- ✅ ConstantInitializer → `commons_lang4cj.concurrent.ConstantInitializer`
- ✅ EventCountCircuitBreaker → `commons_lang4cj.concurrent.EventCountCircuitBreaker`
- ✅ FutureTasks → `commons_lang4cj.concurrent.FutureTasks`
- ✅ LazyInitializer → `commons_lang4cj.concurrent.LazyInitializer`
- ✅ Memoizer → `commons_lang4cj.concurrent.Memoizer`
- ✅ MultiBackgroundInitializer → `commons_lang4cj.concurrent.MultiBackgroundInitializer`
- ✅ ThresholdCircuitBreaker → `commons_lang4cj.concurrent.ThresholdCircuitBreaker`
- ✅ TimedSemaphore → `commons_lang4cj.concurrent.TimedSemaphore`
- ✅ UncheckedExecutionException → `commons_lang4cj.concurrent.UncheckedExecutionException`
- ✅ UncheckedFuture → `commons_lang4cj.concurrent.UncheckedFuture`
- ✅ UncheckedTimeoutException → `commons_lang4cj.concurrent.UncheckedTimeoutException`

## 子包 concurrent.locks

- ✅ LockingVisitors → `commons_lang4cj.concurrent.locks.LockingVisitors`

## 子包 event

- ✅ EventListenerSupport → `commons_lang4cj.event.EventListenerSupport`
- ✅ EventUtils → `commons_lang4cj.event.EventUtils`

## 子包 exception

- ✅ CloneFailedException → `commons_lang4cj.exception.CloneFailedException`
- ✅ ContextedException → `commons_lang4cj.exception.ContextedException`
- ✅ ContextedRuntimeException → `commons_lang4cj.exception.ContextedRuntimeException`
- ✅ DefaultExceptionContext → `commons_lang4cj.exception.DefaultExceptionContext`
- ✅ ExceptionContext → `commons_lang4cj.exception.ExceptionContext`
- ✅ ExceptionUtils → `commons_lang4cj.exception.ExceptionUtils`
- ✅ UncheckedException → `commons_lang4cj.exception.UncheckedException`
- ✅ UncheckedIllegalAccessException → `commons_lang4cj.exception.UncheckedIllegalAccessException`
- ✅ UncheckedInterruptedException → `commons_lang4cj.exception.UncheckedInterruptedException`
- ✅ UncheckedReflectiveOperationException → `commons_lang4cj.exception.UncheckedReflectiveOperationException`

## 子包 function

- ✅ BooleanConsumer → `commons_lang4cj.function.BooleanConsumer`
- ✅ ByteConsumer → `commons_lang4cj.function.ByteConsumer`
- ✅ ByteSupplier → `commons_lang4cj.function.ByteSupplier`
- ✅ Consumers → `commons_lang4cj.function.Consumers`
- ✅ Failable → `commons_lang4cj.function.Failable`
- ✅ FailableBiConsumer → `commons_lang4cj.function.FailableBiConsumer`
- ✅ FailableBiFunction → `commons_lang4cj.function.FailableBiFunction`
- ✅ FailableBiPredicate → `commons_lang4cj.function.FailableBiPredicate`
- ✅ FailableBooleanSupplier → `commons_lang4cj.function.FailableBooleanSupplier`
- ✅ FailableByteConsumer → `commons_lang4cj.function.FailableByteConsumer`
- ✅ FailableByteSupplier → `commons_lang4cj.function.FailableByteSupplier`
- ✅ FailableCallable → `commons_lang4cj.function.FailableCallable`
- ✅ FailableConsumer → `commons_lang4cj.function.FailableConsumer`
- ✅ FailableDoubleBinaryOperator → `commons_lang4cj.function.FailableDoubleBinaryOperator`
- ✅ FailableDoubleConsumer → `commons_lang4cj.function.FailableDoubleConsumer`
- ✅ FailableDoubleFunction → `commons_lang4cj.function.FailableDoubleFunction`
- ✅ FailableDoublePredicate → `commons_lang4cj.function.FailableDoublePredicate`
- ✅ FailableDoubleSupplier → `commons_lang4cj.function.FailableDoubleSupplier`
- ✅ FailableDoubleToIntFunction → `commons_lang4cj.function.FailableDoubleToIntFunction`
- ✅ FailableDoubleToLongFunction → `commons_lang4cj.function.FailableDoubleToLongFunction`
- ✅ FailableDoubleUnaryOperator → `commons_lang4cj.function.FailableDoubleUnaryOperator`
- ✅ FailableFunction → `commons_lang4cj.function.FailableFunction`
- ✅ FailableIntBinaryOperator → `commons_lang4cj.function.FailableIntBinaryOperator`
- ✅ FailableIntConsumer → `commons_lang4cj.function.FailableIntConsumer`
- ✅ FailableIntFunction → `commons_lang4cj.function.FailableIntFunction`
- ✅ FailableIntPredicate → `commons_lang4cj.function.FailableIntPredicate`
- ✅ FailableIntSupplier → `commons_lang4cj.function.FailableIntSupplier`
- ✅ FailableIntToDoubleFunction → `commons_lang4cj.function.FailableIntToDoubleFunction`
- ✅ FailableIntToFloatFunction → `commons_lang4cj.function.FailableIntToFloatFunction`
- ✅ FailableIntToLongFunction → `commons_lang4cj.function.FailableIntToLongFunction`
- ✅ FailableIntUnaryOperator → `commons_lang4cj.function.FailableIntUnaryOperator`
- ✅ FailableLongBinaryOperator → `commons_lang4cj.function.FailableLongBinaryOperator`
- ✅ FailableLongConsumer → `commons_lang4cj.function.FailableLongConsumer`
- ✅ FailableLongFunction → `commons_lang4cj.function.FailableLongFunction`
- ✅ FailableLongPredicate → `commons_lang4cj.function.FailableLongPredicate`
- ✅ FailableLongSupplier → `commons_lang4cj.function.FailableLongSupplier`
- ✅ FailableLongToDoubleFunction → `commons_lang4cj.function.FailableLongToDoubleFunction`
- ✅ FailableLongToIntFunction → `commons_lang4cj.function.FailableLongToIntFunction`
- ✅ FailableLongUnaryOperator → `commons_lang4cj.function.FailableLongUnaryOperator`
- ✅ FailableObjDoubleConsumer → `commons_lang4cj.function.FailableObjDoubleConsumer`
- ✅ FailableObjIntConsumer → `commons_lang4cj.function.FailableObjIntConsumer`
- ✅ FailableObjLongConsumer → `commons_lang4cj.function.FailableObjLongConsumer`
- ✅ FailablePredicate → `commons_lang4cj.function.FailablePredicate`
- ✅ FailableRunnable → `commons_lang4cj.function.FailableRunnable`
- ✅ FailableShortSupplier → `commons_lang4cj.function.FailableShortSupplier`
- ✅ FailableSupplier → `commons_lang4cj.function.FailableSupplier`
- ✅ FailableToBooleanFunction → `commons_lang4cj.function.FailableToBooleanFunction`
- ✅ FailableToDoubleBiFunction → `commons_lang4cj.function.FailableToDoubleBiFunction`
- ✅ FailableToDoubleFunction → `commons_lang4cj.function.FailableToDoubleFunction`
- ✅ FailableToIntBiFunction → `commons_lang4cj.function.FailableToIntBiFunction`
- ✅ FailableToIntFunction → `commons_lang4cj.function.FailableToIntFunction`
- ✅ FailableToLongBiFunction → `commons_lang4cj.function.FailableToLongBiFunction`
- ✅ FailableToLongFunction → `commons_lang4cj.function.FailableToLongFunction`
- ✅ Functions → `commons_lang4cj.function.Functions`
- ✅ IntToCharFunction → `commons_lang4cj.function.IntToCharFunction`
- ✅ MethodInvokers → `commons_lang4cj.function.MethodInvokers`
- ✅ Predicates → `commons_lang4cj.function.Predicates`
- ✅ Suppliers → `commons_lang4cj.function.Suppliers`
- ✅ ToBooleanBiFunction → `commons_lang4cj.function.ToBooleanBiFunction`
- ✅ TriConsumer → `commons_lang4cj.function.TriConsumer`
- ✅ TriFunction → `commons_lang4cj.function.TriFunction`

## 子包 math

- ✅ Fraction → `commons_lang4cj.math.Fraction`
- ✅ IEEE754rUtils → `commons_lang4cj.math.IEEE754rUtils`
- ✅ NumberUtils → `commons_lang4cj.utils.NumberUtils`

## 子包 mutable

- ✅ Mutable → `commons_lang4cj.mutable.Mutable`
- ✅ MutableBoolean → `commons_lang4cj.mutable.MutableBoolean`
- ✅ MutableByte → `commons_lang4cj.mutable.MutableByte`
- ✅ MutableDouble → `commons_lang4cj.mutable.MutableDouble`
- ✅ MutableFloat → `commons_lang4cj.mutable.MutableFloat`
- ✅ MutableInt → `commons_lang4cj.mutable.MutableInt`
- ✅ MutableLong → `commons_lang4cj.mutable.MutableLong`
- ✅ MutableObject → `commons_lang4cj.mutable.MutableObject`
- ✅ MutableShort → `commons_lang4cj.mutable.MutableShort`

## 子包 reflect

- ✅ ConstructorUtils → `commons_lang4cj.reflect.ConstructorUtils`
- ✅ FieldUtils → `commons_lang4cj.reflect.FieldUtils`
- ✅ InheritanceUtils → `commons_lang4cj.reflect.InheritanceUtils`
- ✅ MethodUtils → `commons_lang4cj.reflect.MethodUtils`
- ✅ TypeLiteral → `commons_lang4cj.reflect.TypeLiteral`
- ✅ TypeUtils → `commons_lang4cj.reflect.TypeUtils`
- ✅ Typed → `commons_lang4cj.reflect.Typed`

## 子包 stream

- ✅ IntStreams → `commons_lang4cj.stream.IntStreams`
- ✅ LangCollectors → `commons_lang4cj.stream.LangCollectors`
- ✅ Streams → `commons_lang4cj.stream.Streams`

## 子包 text

- ✅ CompositeFormat → `commons_lang4cj.text.CompositeFormat`
- ✅ ExtendedMessageFormat → `commons_lang4cj.text.ExtendedMessageFormat`
- ✅ FormatFactory → `commons_lang4cj.text.FormatFactory`
- ✅ FormattableUtils → `commons_lang4cj.text.FormattableUtils`
- ✅ StrBuilder → `commons_lang4cj.text.StrBuilder`
- ✅ StrLookup → `commons_lang4cj.text.StrLookup`
- ✅ StrMatcher → `commons_lang4cj.text.StrMatcher`
- ✅ StrSubstitutor → `commons_lang4cj.text.StrSubstitutor`
- ✅ StrTokenizer → `commons_lang4cj.text.StrTokenizer`
- ✅ WordUtils → `commons_lang4cj.text.WordUtils`

## 子包 text.translate

- ✅ AggregateTranslator → `commons_lang4cj.text.translate.AggregateTranslator`
- ✅ CharSequenceTranslator → `commons_lang4cj.text.translate.CharSequenceTranslator`
- ✅ CodePointTranslator → `commons_lang4cj.text.translate.CodePointTranslator`
- ✅ EntityArrays → `commons_lang4cj.text.translate.EntityArrays`
- ✅ JavaUnicodeEscaper → `commons_lang4cj.text.translate.JavaUnicodeEscaper`
- ✅ LookupTranslator → `commons_lang4cj.text.translate.LookupTranslator`
- ✅ NumericEntityEscaper → `commons_lang4cj.text.translate.NumericEntityEscaper`
- ✅ NumericEntityUnescaper → `commons_lang4cj.text.translate.NumericEntityUnescaper`
- ✅ OctalUnescaper → `commons_lang4cj.text.translate.OctalUnescaper`
- ✅ UnicodeEscaper → `commons_lang4cj.text.translate.UnicodeEscaper`
- ✅ UnicodeUnescaper → `commons_lang4cj.text.translate.UnicodeUnescaper`
- ✅ UnicodeUnpairedSurrogateRemover → `commons_lang4cj.text.translate.UnicodeUnpairedSurrogateRemover`

## 子包 time

- ✅ CalendarUtils → `commons_lang4cj.time.CalendarUtils`
- ✅ DateFormatUtils → `commons_lang4cj.time.DateFormatUtils`
- ✅ DateParser → `commons_lang4cj.time.DateParser`
- ✅ DatePrinter → `commons_lang4cj.time.DatePrinter`
- ✅ DateUtils → `commons_lang4cj.time.DateUtils`
- ✅ DurationFormatUtils → `commons_lang4cj.time.DurationFormatUtils`
- ✅ DurationUtils → `commons_lang4cj.time.DurationUtils`
- ✅ FastDateFormat → `commons_lang4cj.time.FastDateFormat`
- ✅ FastDateParser → `commons_lang4cj.time.FastDateParser`
- ✅ FastDatePrinter → `commons_lang4cj.time.FastDatePrinter`
- ✅ FastTimeZone → `commons_lang4cj.time.FastTimeZone`
- ✅ StopWatch → `commons_lang4cj.time.StopWatch`
- ✅ TimeZones → `commons_lang4cj.time.TimeZones`

## 子包 tuple

- ✅ ImmutablePair → `commons_lang4cj.tuple.ImmutablePair`
- ✅ ImmutableTriple → `commons_lang4cj.tuple.ImmutableTriple`
- ✅ MutablePair → `commons_lang4cj.tuple.MutablePair`
- ✅ MutableTriple → `commons_lang4cj.tuple.MutableTriple`
- ✅ Pair → `commons_lang4cj.tuple.Pair`
- ✅ Triple → `commons_lang4cj.tuple.Triple`

## 子包 util

- ✅ FluentBitSet → `commons_lang4cj.util.FluentBitSet`
- ✅ IterableStringTokenizer → `commons_lang4cj.util.IterableStringTokenizer`
