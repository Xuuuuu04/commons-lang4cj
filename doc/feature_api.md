# commons-lang4cj API 参考

## 简介

commons-lang4cj 是 Apache Commons Lang 的仓颉（Cangjie）语言移植版本，提供了一套极其实用的工具类库。本文档详细介绍了 commons-lang4cj 库当前提供的所有公开 API。

## 当前提供的模块

commons-lang4cj 库当前提供以下主要模块：

1. **核心工具 (utils)**: `StringUtils`, `Strings`, `CharSequenceUtils`, `ArrayUtils`, `ArrayFill`, `ArraySorter`, `ObjectUtils`, `NumberUtils`, `BooleanUtils`, `CharUtils`, `ValidateUtils`, `CharEncoding`, `Charsets`, `CharSet`, `CharSetUtils`, `RegExUtils`, `BitField`, `AppendableJoiner`
2. **构建器 (builder)**: `Builder<T>`, `EqualsBuilder`, `HashCodeBuilder`, `ToStringBuilder`, `CompareToBuilder`
3. **可变包装 (mutable)**: `MutableInt`, `MutableLong`, `MutableDouble`, `MutableFloat`, `MutableByte`, `MutableShort`, `MutableBoolean`, `MutableObject<T>`
4. **时间日期 (time)**: `StopWatch`, `DateFormatUtils`, `DurationFormatUtils`, `DateUtils`
5. **数学计算 (math)**: `Fraction`, `IEEE754rUtils`
6. **文本处理 (text)**: `WordUtils`, `StrSubstitutor`, `StrTokenizer`, `StringEscapeUtils`, `LevenshteinDistance`
7. **并发工具 (concurrent)**: `Memoizer`, `CircuitBreaker`, `BackgroundInitializer`, `LazyInitializer`
8. **随机数生成 (random)**: `RandomStringUtils`, `RandomUtils`
9. **元组 (tuple)**: `Pair<K,V>`, `Triple<L,M,R>`
10. **范围处理 (range)**: `Range<T>`, `NumberRange`, `CharRange`
11. **枚举工具 (enums)**: `EnumUtils`
12. **反射工具 (reflect)**: `ClassUtils`, `InheritanceUtils`
13. **系统工具 (system)**: `SystemUtils`
14. **函数工具 (function)**: `TriFunction<A,B,C,R>`, `TriConsumer<A,B,C>`, `ToBooleanBiFunction<A,B>`

## Utils 包 API

### StringUtils API

StringUtils 提供了 null-safe 的字符串操作方法。

#### 空值检查

```cangjie
/**
 * 检查字符串是否为空（""）
 *
 * @param str 要检查的字符串
 * @return 如果字符串为空返回 true，否则返回 false
 */
public static func isEmpty(str: String): Bool

/**
 * 检查字符串是否不为空
 *
 * @param str 要检查的字符串
 * @return 如果字符串不为空返回 true，否则返回 false
 */
public static func isNotEmpty(str: String): Bool

/**
 * 检查字符串是否为空白（空、null 或仅包含空白字符）
 *
 * @param str 要检查的字符串
 * @return 如果字符串为空白返回 true，否则返回 false
 */
public static func isBlank(str: String): Bool

/**
 * 检查字符串是否不为空白
 *
 * @param str 要检查的字符串
 * @return 如果字符串不为空白返回 true，否则返回 false
 */
public static func isNotBlank(str: String): Bool
```

#### 截取与分割

```cangjie
/**
 * 去除字符串两端的空白字符
 *
 * @param str 要处理的字符串
 * @return 去除空白后的字符串
 */
public static func trim(str: String): String

/**
 * 去除字符串左端的空白字符
 *
 * @param str 要处理的字符串
 * @return 去除左端空白后的字符串
 */
public static func leftTrim(str: String): String

/**
 * 去除字符串右端的空白字符
 *
 * @param str 要处理的字符串
 * @return 去除右端空白后的字符串
 */
public static func rightTrim(str: String): String

/**
 * 分割字符串
 *
 * @param str 要分割的字符串
 * @param separator 分隔符
 * @return 分割后的字符串数组
 */
public static func split(str: String, separator: String): Array<String>

/**
 * 分割字符串（限制最大分割次数）
 *
 * @param str 要分割的字符串
 * @param separator 分隔符
 * @param maxSplit 最大分割次数
 * @return 分割后的字符串数组
 */
public static func split(str: String, separator: String, maxSplit: Int64): Array<String>

/**
 * 连接字符串数组为单个字符串
 *
 * @param collection 字符串集合
 * @param separator 分隔符
 * @return 连接后的字符串
 */
public static func join(collection: Array<String>, separator: String): String
```

#### 查询与比较

```cangjie
/**
 * 比较两个字符串是否相等（null-safe）
 *
 * @param str1 第一个字符串
 * @param str2 第二个字符串
 * @return 如果相等返回 true，否则返回 false
 */
public static func equals(str1: String, str2: String): Bool

/**
 * 比较两个字符串
 *
 * @param str1 第一个字符串
 * @param str2 第二个字符串
 * @return 比较结果，负数表示 str1<str2，0 表示相等，正数表示 str1>str2
 */
public static func compare(str1: String, str2: String): Int64

/**
 * 检查字符串是否包含指定子串
 *
 * @param str 要检查的字符串
 * @param searchStr 要查找的子串
 * @return 如果包含返回 true，否则返回 false
 */
public static func contains(str: String, searchStr: String): Bool

/**
 * 查找子串首次出现的位置
 *
 * @param str 要搜索的字符串
 * @param searchStr 要查找的子串
 * @return 首次出现的索引，未找到返回 -1
 */
public static func indexOf(str: String, searchStr: String): Int64

/**
 * 查找子串最后出现的位置
 *
 * @param str 要搜索的字符串
 * @param searchStr 要查找的子串
 * @return 最后出现的索引，未找到返回 -1
 */
public static func lastIndexOf(str: String, searchStr: String): Int64

/**
 * 检查字符串是否以指定前缀开头
 *
 * @param str 要检查的字符串
 * @param prefix 前缀
 * @return 如果以该前缀开头返回 true，否则返回 false
 */
public static func startsWith(str: String, prefix: String): Bool

/**
 * 检查字符串是否以指定后缀结尾
 *
 * @param str 要检查的字符串
 * @param suffix 后缀
 * @return 如果以该后缀结尾返回 true，否则返回 false
 */
public static func endsWith(str: String, suffix: String): Bool
```

#### 替换与删除

```cangjie
/**
 * 替换字符串中的所有匹配项
 *
 * @param str 原字符串
 * @param searchStr 要查找的字符串
 * @param replacement 替换字符串
 * @return 替换后的字符串
 */
public static func replace(str: String, searchStr: String, replacement: String): String

/**
 * 替换字符串中的第一个匹配项
 *
 * @param str 原字符串
 * @param searchStr 要查找的字符串
 * @param replacement 替换字符串
 * @return 替换后的字符串
 */
public static func replaceOnce(str: String, searchStr: String, replacement: String): String

/**
 * 从字符串中删除指定子串
 *
 * @param str 原字符串
 * @param removeStr 要删除的字符串
 * @return 删除后的字符串
 */
public static func remove(str: String, removeStr: String): String
```

#### 截取

```cangjie
/**
 * 截取字符串
 *
 * @param str 原字符串
 * @param start 起始位置
 * @return 截取后的字符串
 */
public static func substring(str: String, start: Int64): String

/**
 * 截取字符串（指定起止位置）
 *
 * @param str 原字符串
 * @param start 起始位置
 * @param end 结束位置
 * @return 截取后的字符串
 */
public static func substring(str: String, start: Int64, end: Int64): String

/**
 * 获取字符串左侧指定长度的子串
 *
 * @param str 原字符串
 * @param length 长度
 * @return 左侧子串
 */
public static func left(str: String, length: Int64): String

/**
 * 获取字符串右侧指定长度的子串
 *
 * @param str 原字符串
 * @param length 长度
 * @return 右侧子串
 */
public static func right(str: String, length: Int64): String

/**
 * 获取字符串中间的子串
 *
 * @param str 原字符串
 * @param pos 起始位置
 * @param length 长度
 * @return 中间子串
 */
public static func mid(str: String, pos: Int64, length: Int64): String

/**
 * 获取子串（从指定子串之前）
 *
 * @param str 原字符串
 * @param separator 分隔符
 * @return 分隔符之前的子串
 */
public static func substringBefore(str: String, separator: String): String

/**
 * 获取子串（从指定子串之后）
 *
 * @param str 原字符串
 * @param separator 分隔符
 * @return 分隔符之后的子串
 */
public static func substringAfter(str: String, separator: String): String

/**
 * 获取两个子串之间的子串
 *
 * @param str 原字符串
 * @param start 开始分隔符
 * @param end 结束分隔符
 * @return 两个分隔符之间的子串
 */
public static func substringBetween(str: String, start: String, end: String): String
```

#### 大小写转换

```cangjie
/**
 * 转换为大写
 *
 * @param str 原字符串
 * @return 大写字符串
 */
public static func upperCase(str: String): String

/**
 * 转换为小写
 *
 * @param str 原字符串
 * @return 小写字符串
 */
public static func lowerCase(str: String): String

/**
 * 首字母大写
 *
 * @param str 原字符串
 * @return 首字母大写的字符串
 */
public static func capitalize(str: String): String

/**
 * 首字母小写
 *
 * @param str 原字符串
 * @return 首字母小写的字符串
 */
public static func uncapitalize(str: String): String

/**
 * 大小写互换
 *
 * @param str 原字符串
 * @return 大小写互换后的字符串
 */
public static func swapCase(str: String): String
```

#### 填充与对齐

```cangjie
/**
 * 左填充
 *
 * @param str 原字符串
 * @param size 目标长度
 * @param padStr 填充字符串
 * @return 填充后的字符串
 */
public static func leftPad(str: String, size: Int64, padStr: String): String

/**
 * 右填充
 *
 * @param str 原字符串
 * @param size 目标长度
 * @param padStr 填充字符串
 * @return 填充后的字符串
 */
public static func rightPad(str: String, size: Int64, padStr: String): String

/**
 * 居中对齐
 *
 * @param str 原字符串
 * @param size 目标长度
 * @return 居中对齐后的字符串
 */
public static func center(str: String, size: Int64): String
```

#### 反转

```cangjie
/**
 * 反转字符串
 *
 * @param str 原字符串
 * @return 反转后的字符串
 */
public static func reverse(str: String): String

/**
 * 反转分隔字符串
 *
 * @param str 原字符串
 * @param separator 分隔符
 * @return 反转后的字符串
 */
public static func reverseDelimited(str: String, separator: String): String
```

#### 其他方法

```cangjie
/**
 * 统计子串出现次数
 *
 * @param str 原字符串
 * @param sub 要统计的子串
 * @return 出现次数
 */
public static func countMatches(str: String, sub: String): Int64

/**
 * 检查字符串是否只包含字母
 *
 * @param str 要检查的字符串
 * @return 如果只包含字母返回 true
 */
public static func isAlpha(str: String): Bool

/**
 * 检查字符串是否只包含数字
 *
 * @param str 要检查的字符串
 * @return 如果只包含数字返回 true
 */
public static func isNumeric(str: String): Bool

/**
 * 检查字符串是否只包含字母或数字
 *
 * @param str 要检查的字符串
 * @return 如果只包含字母或数字返回 true
 */
public static func isAlphanumeric(str: String): Bool

/**
 * 缩略字符串
 *
 * @param str 原字符串
 * @param maxWidth 最大宽度
 * @return 缩略后的字符串
 */
public static func abbreviate(str: String, maxWidth: Int64): String

/**
 * 旋转字符串
 *
 * @param str 原字符串
 * @param shift 旋转位数
 * @return 旋转后的字符串
 */
public static func rotate(str: String, shift: Int64): String

/**
 * 重复字符串
 *
 * @param str 原字符串
 * @param repeat 重复次数
 * @return 重复后的字符串
 */
public static func repeat(str: String, repeat: Int32): String
```

### ArrayUtils API

ArrayUtils 提供数组操作工具方法。

#### 空值与长度检查

```cangjie
/**
 * 检查数组是否为空
 *
 * @param array 要检查的数组
 * @return 如果数组为空或 null 返回 true
 */
public static func isEmpty<T>(array: Array<T>): Bool

/**
 * 检查数组是否不为空
 *
 * @param array 要检查的数组
 * @return 如果数组不为空返回 true
 */
public static func isNotEmpty<T>(array: Array<T>): Bool

/**
 * 获取数组长度
 *
 * @param array 数组
 * @return 数组长度，null 返回 0
 */
public static func getLength<T>(array: ?Array<T>): Int64
```

#### 查询操作

```cangjie
/**
 * 查找元素首次出现的位置
 *
 * @param array 数组
 * @param value 要查找的值
 * @return 首次出现的索引，未找到返回 -1
 */
public static func indexOf<T>(array: Array<T>, value: T): Int64

/**
 * 查找元素最后出现的位置
 *
 * @param array 数组
 * @param value 要查找的值
 * @return 最后出现的索引，未找到返回 -1
 */
public static func lastIndexOf<T>(array: Array<T>, value: T): Int64

/**
 * 检查数组是否包含指定元素
 *
 * @param array 数组
 * @param value 要查找的值
 * @return 如果包含返回 true
 */
public static func contains<T>(array: Array<T>, value: T): Bool
```

#### 修改操作

```cangjie
/**
 * 在数组末尾添加元素
 *
 * @param array 原数组
 * @param element 要添加的元素
 * @return 新数组
 */
public static func add<T>(array: Array<T>, element: T): Array<T>

/**
 * 在指定位置插入元素
 *
 * @param array 原数组
 * @param index 插入位置
 * @param element 要插入的元素
 * @return 新数组
 */
public static func add<T>(array: Array<T>, index: Int64, element: T): Array<T>

/**
 * 合并两个数组
 *
 * @param array1 第一个数组
 * @param array2 第二个数组
 * @return 合并后的新数组
 */
public static func addAll<T>(array1: Array<T>, array2: Array<T>): Array<T>

/**
 * 删除指定位置的元素
 *
 * @param array 原数组
 * @param index 要删除的位置
 * @return 新数组
 */
public static func remove<T>(array: Array<T>, index: Int64): Array<T>

/**
 * 删除指定元素
 *
 * @param array 原数组
 * @param element 要删除的元素
 * @return 新数组
 */
public static func removeElement<T>(array: Array<T>, element: T): Array<T>
```

#### 反转与排序

```cangjie
/**
 * 反转数组
 *
 * @param array 原数组
 * @return 反转后的新数组
 */
public static func reverse<T>(array: Array<T>): Array<T>

/**
 * 交换数组中两个位置的元素
 *
 * @param array 数组
 * @param index1 第一个位置
 * @param index2 第二个位置
 * @return 交换后的新数组
 */
public static func swap<T>(array: Array<T>, index1: Int64, index2: Int64): Array<T>
```

#### 子数组操作

```cangjie
/**
 * 获取子数组
 *
 * @param array 原数组
 * @param startIndex 起始索引
 * @param endIndex 结束索引
 * @return 子数组
 */
public static func subarray<T>(array: Array<T>, startIndex: Int64, endIndex: Int64): Array<T>
```

#### 比较操作

```cangjie
/**
 * 检查两个数组长度是否相同
 *
 * @param array1 第一个数组
 * @param array2 第二个数组
 * @return 如果长度相同返回 true
 */
public static func isSameLength<T>(array1: Array<T>, array2: Array<T>): Bool

/**
 * 检查数组是否已排序
 *
 * @param array 要检查的数组
 * @return 如果已排序返回 true
 */
public static func isSorted<T>(array: Array<T>): Bool
```

#### 转换操作

```cangjie
/**
 * 将数组转换为字符串
 *
 * @param array 数组
 * @return 字符串表示
 */
public static func toString<T>(array: Array<T>): String

/**
 * 克隆数组
 *
 * @param array 原数组
 * @return 新数组
 */
public static func clone<T>(array: Array<T>): Array<T>
```

#### 填充操作

```cangjie
/**
 * 用指定值填充数组
 *
 * @param array 数组
 * @param value 填充值
 * @return 填充后的新数组
 */
public static func fill<T>(array: Array<T>, value: T): Array<T>
```

### ObjectUtils API

ObjectUtils 提供对象操作工具方法。

#### 空值处理

```cangjie
/**
 * 检查对象是否为 null
 *
 * @param obj 要检查的对象
 * @return 如果为 null 返回 true
 */
public static func isNull(obj: ?Object): Bool

/**
 * 检查对象是否不为 null
 *
 * @param obj 要检查的对象
 * @return 如果不为 null 返回 true
 */
public static func notNull(obj: ?Object): Bool

/**
 * 如果对象为 null 则返回默认值
 *
 * @param obj 要检查的对象
 * @param defaultValue 默认值
 * @return 对象或默认值
 */
public static func defaultIfNull<T>(obj: ?T, defaultValue: T): T
```

#### 相等比较

```cangjie
/**
 * 比较两个对象是否相等（null-safe）
 *
 * @param obj1 第一个对象
 * @param obj2 第二个对象
 * @return 如果相等返回 true
 */
public static func equal(obj1: ?Object, obj2: ?Object): Bool

/**
 * 比较两个对象是否不相等
 *
 * @param obj1 第一个对象
 * @param obj2 第二个对象
 * @return 如果不相等返回 true
 */
public static func notEqual(obj1: ?Object, obj2: ?Object): Bool
```

#### 比较操作

```cangjie
/**
 * 比较两个可比较对象
 *
 * @param c1 第一个对象
 * @param c2 第二个对象
 * @return 比较结果
 */
public static func compare<T>(c1: ?T, c2: ?T): Int64 where T <: Comparable<T>

/**
 * 获取两个对象中的较小值
 *
 * @param o1 第一个对象
 * @param o2 第二个对象
 * @return 较小值
 */
public static func min<T>(o1: T, o2: T): T where T <: Comparable<T>

/**
 * 获取两个对象中的较大值
 *
 * @param o1 第一个对象
 * @param o2 第二个对象
 * @return 较大值
 */
public static func max<T>(o1: T, o2: T): T where T <: Comparable<T>
```

#### 哈希码

```cangjie
/**
 * 获取对象的哈希码（null-safe）
 *
 * @param obj 对象
 * @return 哈希码
 */
public static func hash(obj: ?Object): Int64

/**
 * 获取对象的哈希字符串
 *
 * @param obj 对象
 * @return 哈希字符串
 */
public static func hashString(obj: ?Object): String
```

#### 字符串表示

```cangjie
/**
 * 获取对象的字符串表示（null-safe）
 *
 * @param obj 对象
 * @return 字符串表示
 */
public static func toString(obj: ?Object): String

/**
 * 获取对象的身份字符串
 *
 * @param obj 对象
 * @return 身份字符串
 */
public static func identityToString(obj: Object): String
```

#### 类型检查

```cangjie
/**
 * 检查对象是否为指定类型
 *
 * @param obj 对象
 * @param typeName 类型名
 * @return 如果是指定类型返回 true
 */
public static func isType(obj: ?Object, typeName: String): Bool

/**
 * 检查对象是否为字符串
 *
 * @param obj 对象
 * @return 如果是字符串返回 true
 */
public static func isString(obj: ?Object): Bool

/**
 * 检查对象是否为 Int64
 *
 * @param obj 对象
 * @return 如果是 Int64 返回 true
 */
public static func isInt64(obj: ?Object): Bool

/**
 * 检查对象是否为 Float64
 *
 * @param obj 对象
 * @return 如果是 Float64 返回 true
 */
public static func isFloat64(obj: ?Object): Bool

/**
 * 检查对象是否为数字
 *
 * @param obj 对象
 * @return 如果是数字返回 true
 */
public static func isNumber(obj: ?Object): Bool

/**
 * 检查对象是否为数组
 *
 * @param obj 对象
 * @return 如果是数组返回 true
 */
public static func isArray(obj: ?Object): Bool

/**
 * 检查两个对象是否为同一实例
 *
 * @param obj1 第一个对象
 * @param obj2 第二个对象
 * @return 如果是同一实例返回 true
 */
public static func isSame(obj1: ?Object, obj2: ?Object): Bool
```

#### 其他实用方法

```cangjie
/**
 * 获取第一个非 null 值
 *
 * @param values 值数组
 * @return 第一个非 null 值
 */
public static func firstNonNull<T>(values: Array<T>): T

/**
 * 要求对象非 null，否则抛出异常
 *
 * @param obj 对象
 * @return 非-null 对象
 * @throws Exception 如果对象为 null
 */
public static func requireNonNull<T>(obj: ?T): T

/**
 * 检查所有对象是否都为 null
 *
 * @param objs 对象数组
 * @return 如果都为 null 返回 true
 */
public static func allNull(objs: Array<?Object>): Bool

/**
 * 检查是否有对象为 null
 *
 * @param objs 对象数组
 * @return 如果有 null 返回 true
 */
public static func anyNull(objs: Array<?Object>): Bool

/**
 * 检查数组中是否包含 null
 *
 * @param objs 对象数组
 * @return 如果包含 null 返回 true
 */
public static func containsNull(objs: Array<?Object>): Bool

/**
 * 过滤数组中的非 null 值
 *
 * @param objs 对象数组
 * @return 非 null 值数组
 */
public static func filterNonNull<T>(objs: Array<?T>): Array<T>

/**
 * 安全类型转换
 *
 * @param obj 对象
 * @param type 目标类型
 * @return 转换后的对象或 None
 */
public static func safeCast<T>(obj: ?Object, type: Type): ?T

/**
 * 克隆对象
 *
 * @param obj 对象
 * @return 克隆对象
 */
public static func clone<T>(obj: T): T

/**
 * 比较两个可比较对象
 *
 * @param o1 第一个对象
 * @param o2 第二个对象
 * @return 比较结果
 */
public static func compareTo<T>(o1: ?T, o2: ?T): Int64 where T <: Comparable<T>
```

## Builder 包 API

### EqualsBuilder API

```cangjie
/**
 * 相等比较构建器
 */
public class EqualsBuilder {
    /**
     * 构造函数
     */
    public init()

    /**
     * 添加字段的相等比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this
     */
    public func append(lhs: ?Object, rhs: ?Object): EqualsBuilder

    /**
     * 添加超类的比较结果
     *
     * @param superEquals 超类的 equals 结果
     * @return this
     */
    public func appendSuper(superEquals: Bool): EqualsBuilder

    /**
     * 获取最终的相等比较结果
     *
     * @return 是否相等
     */
    public func isEquals(): Bool
}
```

### HashCodeBuilder API

```cangjie
/**
 * 哈希码构建器
 */
public class HashCodeBuilder {
    /**
     * 构造函数
     *
     * @param initialOddNumber 初始奇数
     * @param multiplierOddNumber 乘数奇数
     */
    public init(initialOddNumber: Int64, multiplierOddNumber: Int64)

    /**
     * 添加 Int64 字段
     *
     * @param value 字段值
     * @return this
     */
    public func append(value: Int64): HashCodeBuilder

    /**
     * 添加 Float64 字段
     *
     * @param value 字段值
     * @return this
     */
    public func append(value: Float64): HashCodeBuilder

    /**
     * 添加对象字段
     *
     * @param obj 对象
     * @return this
     */
    public func append(obj: ?Object): HashCodeBuilder

    /**
     * 添加超类的哈希码
     *
     * @param superHashCode 超类的哈希码
     * @return this
     */
    public func appendSuper(superHashCode: Int64): HashCodeBuilder

    /**
     * 获取最终的哈希码
     *
     * @return 哈希码
     */
    public func toHashCode(): Int64
}
```

### ToStringBuilder API

```cangjie
/**
 * 字符串构建器
 */
public class ToStringBuilder {
    /**
     * 构造函数
     *
     * @param obj 对象
     * @param style 样式
     */
    public init(obj: Object, style: ToStringStyle)

    /**
     * 添加 Int64 字段
     *
     * @param fieldName 字段名
     * @param value 字段值
     * @return this
     */
    public func append(fieldName: String, value: Int64): ToStringBuilder

    /**
     * 添加对象字段
     *
     * @param fieldName 字段名
     * @param value 字段值
     * @return this
     */
    public func append(fieldName: String, value: ?Object): ToStringBuilder

    /**
     * 添加字节数组字段
     *
     * @param fieldName 字段名
     * @param value 字段值
     * @return this
     */
    public func append(fieldName: String, value: Array<Byte>): ToStringBuilder

    /**
     * 添加超类的字符串表示
     *
     * @param superToString 超类的 toString 结果
     * @return this
     */
    public func appendSuper(superToString: String): ToStringBuilder

    /**
     * 获取最终的字符串表示
     *
     * @return 字符串表示
     */
    public func toString(): String
}

/**
 * ToString 样式
 */
public class ToStringStyle {
    public static val DEFAULT_STYLE: ToStringStyle
    public static val NO_FIELD_NAMES_STYLE: ToStringStyle
    public static val SHORT_PREFIX_STYLE: ToStringStyle
    public static val SIMPLE_STYLE: ToStringStyle
}
```

### CompareToBuilder API

```cangjie
/**
 * 比较构建器
 */
public class CompareToBuilder {
    /**
     * 构造函数
     */
    public init()

    /**
     * 添加 Int64 字段比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this
     */
    public func append(lhs: Int64, rhs: Int64): CompareToBuilder

    /**
     * 添加可比较对象字段比较
     *
     * @param lhs 左值
     * @param rhs 右值
     * @return this
     */
    public func append<T>(lhs: ?T, rhs: ?T): CompareToBuilder where T <: Comparable<T>

    /**
     * 添加超类的比较结果
     *
     * @param superCompare 超类的 compareTo 结果
     * @return this
     */
    public func appendSuper(superCompare: Int64): CompareToBuilder

    /**
     * 获取最终的比较结果
     *
     * @return 比较结果
     */
    public func toComparison(): Int64
}
```

## Mutable 包 API

### MutableInt API

```cangjie
/**
 * 可变 Int64 包装类
 */
public class MutableInt <: Comparable<MutableInt> {
    /**
     * 默认构造函数，值为 0
     */
    public init()

    /**
     * 构造函数
     *
     * @param value 初始值
     */
    public init(value: Int64)

    /**
     * 获取值
     *
     * @return 当前值
     */
    public func get(): Int64

    /**
     * 设置值
     *
     * @param value 新值
     */
    public func set(value: Int64): Unit

    /**
     * 加法
     *
     * @param value 要加的值
     */
    public func add(value: Int64): Unit

    /**
     * 减法
     *
     * @param value 要减的值
     */
    public func subtract(value: Int64): Unit

    /**
     * 乘法
     *
     * @param value 要乘的值
     */
    public func multiply(value: Int64): Unit

    /**
     * 除法
     *
     * @param value 要除的值
     */
    public func divide(value: Int64): Unit

    /**
     * 自增
     */
    public func increment(): Unit

    /**
     * 自减
     */
    public func decrement(): Unit

    /**
     * 比较方法
     *
     * @param other 另一个对象
     * @return 比较结果
     */
    public func compareTo(other: MutableInt): Int64

    /**
     * 字符串表示
     *
     * @return 字符串
     */
    public func toString(): String
}
```

其他可变包装类（MutableLong、MutableDouble、MutableFloat、MutableByte、MutableShort、MutableBoolean、MutableObject<T>）的 API 与 MutableInt 类似。

## Time 包 API

### StopWatch API

```cangjie
/**
 * 计时器
 */
public class StopWatch {
    /**
     * 创建计时器
     *
     * @return 新的计时器实例
     */
    public static func create(): StopWatch

    /**
     * 开始计时
     */
    public func start(): Unit

    /**
     * 停止计时
     */
    public func stop(): Unit

    /**
     * 重置计时器
     */
    public func reset(): Unit

    /**
     * 获取总耗时（毫秒）
     *
     * @return 毫秒数
     */
    public func getTime(): Int64

    /**
     * 开始分段计时
     */
    public func split(): Unit

    /**
     * 取消分段计时
     */
    public func unsplit(): Unit

    /**
     * 获取分段耗时（毫秒）
     *
     * @return 分段毫秒数
     */
    public func getSplitTime(): Int64

    /**
     * 获取格式化的耗时字符串
     *
     * @return 格式化字符串
     */
    public func toString(): String
}
```

### DateFormatUtils API

```cangjie
/**
 * 日期格式化工具
 */
public class DateFormatUtils {
    /**
     * 格式化日期
     *
     * @param date 日期字符串
     * @param pattern 格式模式
     * @return 格式化后的日期字符串
     */
    public static func format(date: String, pattern: String): String

    /**
     * 解析日期字符串
     *
     * @param dateStr 日期字符串
     * @param pattern 格式模式
     * @return 解析后的日期字符串
     */
    public static func parse(dateStr: String, pattern: String): String

    // 预定义格式常量
    public static val ISO_DATE_FORMAT: String  // "yyyy-MM-dd"
    public static val ISO_TIME_FORMAT: String  // "HH:mm:ss"
    public static val ISO_DATETIME_FORMAT: String  // "yyyy-MM-dd HH:mm:ss"
}
```

### DurationFormatUtils API

```cangjie
/**
 * 时长格式化工具
 */
public class DurationFormatUtils {
    /**
     * 格式化时长
     *
     * @param durationMillis 时长（毫秒）
     * @param format 格式模式
     * @return 格式化字符串
     */
    public static func formatDuration(durationMillis: Int64, format: String): String

    /**
     * 格式化时间段
     *
     * @param startMillis 开始时间（毫秒）
     * @param endMillis 结束时间（毫秒）
     * @param format 格式模式
     * @return 格式化字符串
     */
    public static func formatPeriod(startMillis: Int64, endMillis: Int64, format: String): String
}
```

### DateUtils API

```cangjie
/**
 * 日期工具
 */
public class DateUtils {
    /**
     * 日期加天数
     *
     * @param date 日期字符串
     * @param amount 天数
     * @return 新日期字符串
     */
    public static func addDays(date: String, amount: Int64): String

    /**
     * 日期加小时
     *
     * @param date 日期字符串
     * @param amount 小时数
     * @return 新日期字符串
     */
    public static func addHours(date: String, amount: Int64): String

    /**
     * 日期加分钟
     *
     * @param date 日期字符串
     * @param amount 分钟数
     * @return 新日期字符串
     */
    public static func addMinutes(date: String, amount: Int64): String

    /**
     * 检查是否为同一天
     *
     * @param date1 第一个日期
     * @param date2 第二个日期
     * @return 是否为同一天
     */
    public static func isSameDay(date1: String, date2: String): Bool

    /**
     * 截断日期到指定精度
     *
     * @param date 日期字符串
     * @param field 精度字段
     * @return 截断后的日期字符串
     */
    public static func truncate(date: String, field: String): String
}
```

## Math 包 API

### Fraction API

```cangjie
/**
 * 分数类
 */
public class Fraction <: Comparable<Fraction> {
    // ===== 工厂方法 =====

    /**
     * 创建分数
     *
     * @param numerator 分子
     * @param denominator 分母
     * @return 分数对象
     * @throws ArithmeticException 如果分母为 0
     */
    public static func getFraction(numerator: Int64, denominator: Int64): Fraction

    /**
     * 创建带分数
     *
     * @param whole 整数部分
     * @param numerator 分子
     * @param denominator 分母
     * @return 分数对象
     * @throws ArithmeticException 如果分母为 0
     */
    public static func getFraction(whole: Int64, numerator: Int64, denominator: Int64): Fraction

    /**
     * 创建约简分数
     *
     * @param numerator 分子
     * @param denominator 分母
     * @return 约简后的分数对象
     * @throws ArithmeticException 如果分母为 0
     */
    public static func getReducedFraction(numerator: Int64, denominator: Int64): Fraction

    // ===== 基本运算 =====

    /**
     * 加法
     *
     * @param fraction 另一个分数
     * @return 和
     */
    public func add(fraction: Fraction): Fraction

    /**
     * 减法
     *
     * @param fraction 另一个分数
     * @return 差
     */
    public func subtract(fraction: Fraction): Fraction

    /**
     * 乘法
     *
     * @param fraction 另一个分数
     * @return 积
     */
    public func multiplyBy(fraction: Fraction): Fraction

    /**
     * 除法
     *
     * @param fraction 另一个分数
     * @return 商
     * @throws ArithmeticException 如果除数为 0
     */
    public func divideBy(fraction: Fraction): Fraction

    /**
     * 取反
     *
     * @return 相反数
     */
    public func negate(): Fraction

    /**
     * 取倒数
     *
     * @return 倒数
     * @throws ArithmeticException 如果原分数为 0
     */
    public func invert(): Fraction

    // ===== 取整与幂运算 =====

    /**
     * 绝对值
     *
     * @return 绝对值
     */
    public func abs(): Fraction

    /**
     * 幂运算
     *
     * @param power 指数
     * @return 幂
     */
    public func pow(power: Int64): Fraction

    /**
     * 取余
     *
     * @param fraction 另一个分数
     * @return 余数
     */
    public func remainder(fraction: Fraction): Fraction

    // ===== 类型转换 =====

    /**
     * 转换为双精度浮点数
     *
     * @return 双精度浮点数
     */
    public func toDouble(): Float64

    /**
     * 转换为单精度浮点数
     *
     * @return 单精度浮点数
     */
    public func toFloat(): Float32

    /**
     * 转换为整数（截断）
     *
     * @return 整数值
     */
    public func toInt(): Int64

    /**
     * 获取真分数分子
     *
     * @return 真分数分子
     */
    public func getProperNumerator(): Int64

    /**
     * 获取带分数的整数部分
     *
     * @return 整数部分
     */
    public func getProperWhole(): Int64

    // ===== 查询方法 =====

    /**
     * 获取分子
     *
     * @return 分子
     */
    public func getNumerator(): Int64

    /**
     * 获取分母
     *
     * @return 分母
     */
    public func getDenominator(): Int64

    /**
     * 是否为零
     *
     * @return 是否为零
     */
    public func isZero(): Bool

    /**
     * 是否为正
     *
     * @return 是否为正
     */
    public func isPositive(): Bool

    /**
     * 是否为负
     *
     * @return 是否为负
     */
    public func isNegative(): Bool

    // ===== 比较与字符串 =====

    /**
     * 比较大小
     *
     * @param other 另一个分数
     * @return 比较结果，-1/0/1
     */
    public func compareTo(other: Fraction): Int64

    /**
     * 相等比较
     *
     * @param other 另一个分数
     * @return 是否相等
     */
    public func equals(other: Option<Fraction>): Bool

    /**
     * 哈希码
     *
     * @return 哈希码
     */
    public func hashCode(): Int64

    /**
     * 假分数字符串表示
     *
     * @return "a/b" 格式字符串
     */
    public func toString(): String

    /**
     * 带分数字符串表示
     *
     * @return "W n/d" 或 "n/d" 格式字符串
     */
    public func toProperString(): String

    // ===== 静态常量 =====

    public static val ZERO: Fraction           // 0/1
    public static val ONE: Fraction            // 1/1
    public static val ONE_HALF: Fraction       // 1/2
    public static val ONE_THIRD: Fraction      // 1/3
    public static val TWO_THIRDS: Fraction     // 2/3
}
```

### IEEE754rUtils API

```cangjie
/**
 * IEEE 754r 标准浮点数工具
 */
public class IEEE754rUtils {
    /**
     * 获取较小值（处理 NaN 和无穷大）
     *
     * @param d1 第一个值
     * @param d2 第二个值
     * @return 较小值
     */
    public static func min(d1: Float64, d2: Float64): Float64

    /**
     * 获取较大值（处理 NaN 和无穷大）
     *
     * @param d1 第一个值
     * @param d2 第二个值
     * @return 较大值
     */
    public static func max(d1: Float64, d2: Float64): Float64

    /**
     * 比较两个浮点数（处理 NaN 和无穷大）
     *
     * @param d1 第一个值
     * @param d2 第二个值
     * @return 比较结果，-1/0/1
     */
    public static func compare(d1: Float64, d2: Float64): Int64
}
```

## Text 包 API

### WordUtils API

```cangjie
/**
 * 单词处理工具
 */
public class WordUtils {
    /**
     * 首字母大写
     *
     * @param str 字符串
     * @return 首字母大写的字符串
     */
    public static func capitalize(str: String): String

    /**
     * 首字母大写（自定义分隔符）
     *
     * @param str 字符串
     * @param delimiters 分隔符数组
     * @return 首字母大写的字符串
     */
    public static func capitalize(str: String, delimiters: Array<Char>): String

    /**
     * 首字母小写
     *
     * @param str 字符串
     * @return 首字母小写的字符串
     */
    public static func uncapitalize(str: String): String

    /**
     * 自动换行
     *
     * @param str 字符串
     * @param wrapLength 换行长度
     * @return 换行后的字符串
     */
    public static func wrap(str: String, wrapLength: Int64): String

    /**
     * 大小写互换
     *
     * @param str 字符串
     * @return 大小写互换后的字符串
     */
    public static func swapCase(str: String): String
}
```

### StrSubstitutor API

```cangjie
/**
 * 字符串变量替换工具
 */
public class StrSubstitutor {
    /**
     * 默认构造函数，使用 "${" 和 "}" 作为前缀和后缀
     */
    public init()

    /**
     * 构造函数（自定义前缀和后缀）
     *
     * @param prefix 前缀
     * @param suffix 后缀
     */
    public init(prefix: String, suffix: String)

    /**
     * 替换字符串中的变量（使用内部值映射）
     *
     * @param source 源字符串
     * @return 替换后的字符串
     */
    public func replace(source: String): String

    /**
     * 替换字符串中的变量（使用 HashMap）
     *
     * @param source 源字符串
     * @param valueMap 值映射
     * @return 替换后的字符串
     */
    public func replace(source: String, valueMap: HashMap<String, String>): String

    /**
     * 替换字符串中的变量（使用数组）
     *
     * @param source 源字符串
     * @param valueProps 值数组
     * @return 替换后的字符串
     */
    public func replace(source: String, valueProps: Array<(String, String)>): String
}
```

### StrTokenizer API

```cangjie
/**
 * 高级字符串分割工具
 */
public class StrTokenizer {
    /**
     * 构造函数
     *
     * @param str 字符串
     * @param separator 分隔符
     */
    public init(str: String, separator: Char)

    /**
     * 获取迭代器
     *
     * @return 迭代器
     */
    public func iterator(): Iterator<String>

    /**
     * 转换为数组
     *
     * @return 字符串数组
     */
    public func toArray(): Array<String>

    /**
     * 是否还有下一个元素
     *
     * @return 是否有下一个元素
     */
    public func hasNext(): Bool

    /**
     * 获取下一个元素
     *
     * @return 下一个字符串
     */
    public func next(): String
}
```

### StringEscapeUtils API

```cangjie
/**
 * 字符串转义工具
 */
public class StringEscapeUtils {
    /**
     * HTML 转义
     *
     * @param str 原字符串
     * @return 转义后的字符串
     */
    public static func escapeHtml(str: String): String

    /**
     * HTML 反转义
     *
     * @param str 转义字符串
     * @return 原字符串
     */
    public static func unescapeHtml(str: String): String

    /**
     * Java 转义
     *
     * @param str 原字符串
     * @return 转义后的字符串
     */
    public static func escapeJava(str: String): String

    /**
     * Java 反转义
     *
     * @param str 转义字符串
     * @return 原字符串
     */
    public static func unescapeJava(str: String): String

    /**
     * XML 转义
     *
     * @param str 原字符串
     * @return 转义后的字符串
     */
    public static func escapeXml(str: String): String

    /**
     * XML 反转义
     *
     * @param str 转义字符串
     * @return 原字符串
     */
    public static func unescapeXml(str: String): String
}
```

### LevenshteinDistance API

```cangjie
/**
 * 编辑距离计算工具
 */
public class LevenshteinDistance {
    /**
     * 计算两个字符串的编辑距离
     *
     * @param left 第一个字符串
     * @param right 第二个字符串
     * @return 编辑距离
     */
    public static func apply(left: String, right: String): Int64
}
```

## Concurrent 包 API

### Memoizer API

```cangjie
/**
 * 带缓存的函数计算器
 */
public class Memoizer<TInput, TResult> {
    /**
     * 构造函数
     *
     * @param computer 计算函数
     */
    public init(computer: (TInput) -> TResult)

    /**
     * 获取计算结果（带缓存）
     *
     * @param input 输入值
     * @return 计算结果
     */
    public func get(input: TInput): TResult
}
```

### CircuitBreaker API

```cangjie
/**
 * 熔断器
 */
public class CircuitBreaker {
    /**
     * 构造函数
     *
     * @param threshold 失败阈值
     * @param timeout 超时时间（毫秒）
     */
    public init(threshold: Int64, timeout: Int64)

    /**
     * 执行受保护的操作
     *
     * @param operation 操作函数
     * @return 操作结果，熔断器打开时返回 None
     */
    public func call<T>(operation: () -> T): ?T

    /**
     * 熔断器是否打开
     *
     * @return 是否打开
     */
    public func isOpen(): Bool

    /**
     * 关闭熔断器
     */
    public func close(): Unit

    /**
     * 打开熔断器
     */
    public func open(): Unit
}
```

### BackgroundInitializer API

```cangjie
/**
 * 后台初始化器
 */
public class BackgroundInitializer<T> {
    /**
     * 构造函数
     *
     * @param initializer 初始化函数
     */
    public init(initializer: () -> T)

    /**
     * 获取初始化结果
     *
     * @return 初始化结果，未完成时返回 None
     */
    public func get(): ?T

    /**
     * 是否已完成初始化
     *
     * @return 是否完成
     */
    public func isCompleted(): Bool
}
```

### LazyInitializer API

```cangjie
/**
 * 延迟初始化器
 */
public class LazyInitializer<T> {
    /**
     * 构造函数
     *
     * @param initializer 初始化函数
     */
    public init(initializer: () -> T)

    /**
     * 获取值（惰性初始化）
     *
     * @return 初始化后的值
     */
    public func get(): T

    /**
     * 是否已初始化
     *
     * @return 是否已初始化
     */
    public func isInitialized(): Bool
}
```

## Random 包 API

### RandomStringUtils API

```cangjie
/**
 * 随机字符串生成工具
 */
public class RandomStringUtils {
    /**
     * 生成随机字符串
     *
     * @param length 长度
     * @return 随机字符串
     */
    public static func random(length: Int32): String

    /**
     * 生成随机字母字符串
     *
     * @param length 长度
     * @return 随机字母字符串
     */
    public static func randomAlphabetic(length: Int32): String

    /**
     * 生成随机字母数字字符串
     *
     * @param length 长度
     * @return 随机字母数字字符串
     */
    public static func randomAlphanumeric(length: Int32): String

    /**
     * 生成随机数字字符串
     *
     * @param length 长度
     * @return 随机数字字符串
     */
    public static func randomNumeric(length: Int32): String
}
```

### RandomUtils API

```cangjie
/**
 * 随机数生成工具
 */
public class RandomUtils {
    /**
     * 生成随机 Int32
     *
     * @return 随机 Int32
     */
    public static func nextInt(): Int32

    /**
     * 生成随机 Int64
     *
     * @return 随机 Int64
     */
    public static func nextLong(): Int64

    /**
     * 生成随机 Float32
     *
     * @return 随机 Float32
     */
    public static func nextFloat(): Float32

    /**
     * 生成随机 Float64
     *
     * @return 随机 Float64
     */
    public static func nextDouble(): Float64
}
```

## Tuple 包 API

### Pair API

```cangjie
/**
 * 键值对
 */
public class Pair<K, V> {
    /**
     * 创建键值对
     *
     * @param left 左值（键）
     * @param right 右值（值）
     * @return 键值对
     */
    public static func of<K, V>(left: K, right: V): Pair<K, V>

    /**
     * 获取左值
     *
     * @return 左值
     */
    public func getLeft(): K

    /**
     * 获取右值
     *
     * @return 右值
     */
    public func getRight(): V

    /**
     * 字符串表示
     *
     * @return "(left, right)" 格式字符串
     */
    public func toString(): String
}
```

### Triple API

```cangjie
/**
 * 三元组
 */
public class Triple<L, M, R> {
    /**
     * 创建三元组
     *
     * @param left 左值
     * @param middle 中间值
     * @param right 右值
     * @return 三元组
     */
    public static func of<L, M, R>(left: L, middle: M, right: R): Triple<L, M, R>

    /**
     * 获取左值
     *
     * @return 左值
     */
    public func getLeft(): L

    /**
     * 获取中间值
     *
     * @return 中间值
     */
    public func getMiddle(): M

    /**
     * 获取右值
     *
     * @return 右值
     */
    public func getRight(): R

    /**
     * 字符串表示
     *
     * @return "(left, middle, right)" 格式字符串
     */
    public func toString(): String
}
```

## Range 包 API

### Range API

```cangjie
/**
 * 通用范围类
 */
public class Range<T> where T <: Comparable<T> {
    /**
     * 检查值是否在范围内
     *
     * @param value 要检查的值
     * @return 是否在范围内
     */
    public func isInRange(value: T): Bool

    /**
     * 获取最小值
     *
     * @return 最小值
     */
    public func getMinimum(): T

    /**
     * 获取最大值
     *
     * @return 最大值
     */
    public func getMaximum(): T
}
```

### NumberRange API

```cangjie
/**
 * 数值范围
 */
public class NumberRange <: Range<Int64> {
    /**
     * 创建数值范围
     *
     * @param min 最小值
     * @param max 最大值
     * @return 数值范围
     */
    public static func of(min: Int64, max: Int64): NumberRange
}
```

### CharRange API

```cangjie
/**
 * 字符范围
 */
public class CharRange <: Range<Char> {
    /**
     * 创建字符范围
     *
     * @param start 起始字符
     * @param end 结束字符
     * @return 字符范围
     */
    public static func of(start: Char, end: Char): CharRange
}
```

## 使用示例

### StringUtils 使用示例

```cangjie
import commons_lang4cj.utils.*

main() {
    // 空值检查
    let str = "  Hello World  "
    println(StringUtils.isBlank(str))  // true
    println(StringUtils.isNotBlank(str))  // false

    // 去除空白
    let trimmed = StringUtils.trim(str)
    println(trimmed)  // "Hello World"

    // 分割和连接
    let parts = StringUtils.split("a,b,c", ",")
    let joined = StringUtils.join(parts, "-")
    println(joined)  // "a-b-c"

    // 大小写转换
    println(StringUtils.upperCase("hello"))  // "HELLO"
    println(StringUtils.capitalize("world"))  // "World"

    // 查询
    println(StringUtils.contains("Hello", "ell"))  // true
    println(StringUtils.indexOf("Hello", "l"))  // 2

    // 替换
    println(StringUtils.replace("Hello World", "World", "Cangjie"))  // "Hello Cangjie"

    // 截取
    println(StringUtils.substring("Hello", 1, 3))  // "el"
    println(StringUtils.left("Hello", 2))  // "He"
    println(StringUtils.right("Hello", 3))  // "llo"

    // 反转
    println(StringUtils.reverse("Hello"))  // "olleH"

    // 填充
    println(StringUtils.leftPad("1", 3, "0"))  // "001"
    println(StringUtils.rightPad("1", 3, "0"))  // "100"
}
```

### ArrayUtils 使用示例

```cangjie
import commons_lang4cj.utils.*

main() {
    let arr1 = Array<Int64>([1, 2, 3])
    let arr2 = Array<Int64>([4, 5, 6])

    // 合并
    let merged = ArrayUtils.addAll(arr1, arr2)
    println(merged)  // [1, 2, 3, 4, 5, 6]

    // 添加
    let added = ArrayUtils.add(merged, 7)
    println(added)  // [1, 2, 3, 4, 5, 6, 7]

    // 反转
    let reversed = ArrayUtils.reverse(added)
    println(reversed)  // [7, 6, 5, 4, 3, 2, 1]

    // 查询
    println(ArrayUtils.contains(merged, 3))  // true
    println(ArrayUtils.indexOf(merged, 5))  // 4

    // 子数组
    let sub = ArrayUtils.subarray(merged, 2, 5)
    println(sub)  // [3, 4, 5]

    // 长度检查
    println(ArrayUtils.isEmpty(merged))  // false
    println(ArrayUtils.getLength(merged))  // 7
}
```

### EqualsBuilder 使用示例

```cangjie
import commons_lang4cj.builder.*

class Person {
    var name: String
    var age: Int64

    public init(name: String, age: Int64) {
        this.name = name
        this.age = age
    }

    public func equals(other: Option<Person>): Bool {
        match (other) {
            case Some(p) => EqualsBuilder()
                .append(this.name, p.name)
                .append(this.age, p.age)
                .isEquals()
            case None => false
        }
    }
}

main() {
    let p1 = Person("Alice", 30)
    let p2 = Person("Alice", 30)
    let p3 = Person("Bob", 25)

    println(p1.equals(p2))  // true
    println(p1.equals(p3))  // false
}
```

### Fraction 使用示例

```cangjie
import commons_lang4cj.math.*

main() {
    // 创建分数
    let f1 = Fraction.getFraction(1, 2)
    let f2 = Fraction.getFraction(1, 3)
    let f3 = Fraction.getFraction(3, 4)

    // 四则运算
    let sum = f1.add(f2)
    println(sum.toString())  // "5/6"

    let product = f1.multiplyBy(f2)
    println(product.toString())  // "1/6"

    let quotient = f1.divideBy(f2)
    println(quotient.toString())  // "3/2"

    // 类型转换
    println(f1.toDouble())  // 0.5
    println(f3.toDouble())  // 0.75

    // 比较
    println(f1.compareTo(f2))  // 1 (1/2 > 1/3)
    println(f1.isPositive())  // true

    // 字符串表示
    let f4 = Fraction.getFraction(7, 4)
    println(f4.toString())  // "7/4"
    println(f4.toProperString())  // "1 3/4"

    // 静态常量
    println(Fraction.ZERO.toString())  // "0/1"
    println(Fraction.ONE_HALF.toString())  // "1/2"
}
```

### StopWatch 使用示例

```cangjie
import commons_lang4cj.time.*

main() {
    let watch = StopWatch.create()

    // 基本计时
    watch.start()
    Thread.sleep(1000)
    watch.stop()
    println("耗时: ${watch.getTime()}ms")  // 耗时: 1000ms

    // 分段计时
    watch.reset()
    watch.start()
    Thread.sleep(500)
    watch.split()
    println("分段1: ${watch.getSplitTime()}ms")  // 分段1: 500ms
    Thread.sleep(300)
    println("总耗时: ${watch.getTime()}ms")  // 总耗时: 800ms

    // 格式化输出
    println(watch.toString())  // "0:00:01.000"
}
```

### StringEscapeUtils 使用示例

```cangjie
import commons_lang4cj.text.*

main() {
    let html = "<script>alert('XSS')</script>"
    let java = "Hello\nWorld\t!"

    // HTML 转义
    let escapedHtml = StringEscapeUtils.escapeHtml(html)
    println(escapedHtml)  // "&lt;script&gt;alert('XSS')&lt;/script&gt;"

    // HTML 反转义
    let unescapedHtml = StringEscapeUtils.unescapeHtml(escapedHtml)
    println(unescapedHtml)  // "<script>alert('XSS')</script>"

    // Java 转义
    let escapedJava = StringEscapeUtils.escapeJava(java)
    println(escapedJava)  // "Hello\\nWorld\\t!"

    // Java 反转义
    let unescapedJava = StringEscapeUtils.unescapeJava(escapedJava)
    println(unescapedJava)  // "Hello\nWorld\t!"
}
```

### Memoizer 使用示例

```cangjie
import commons_lang4cj.concurrent.*

main() {
    // 创建斐波那契计算函数（带缓存）
    let fib = Memoizer<Int64, Int64>{ n =>
        if (n <= 1) {
            return n
        } else {
            return fib.get(n - 1) + fib.get(n - 2)
        }
    }

    // 第一次计算（会递归计算）
    println(fib.get(10))  // 55
    println(fib.get(20))  // 6765

    // 第二次计算（从缓存读取，性能更高）
    println(fib.get(10))  // 55
}
```

### CircuitBreaker 使用示例

```cangjie
import commons_lang4cj.concurrent.*

main() {
    // 创建熔断器（5次失败后打开，10秒后半开）
    let breaker = CircuitBreaker(5, 10000)

    // 执行受保护的操作
    var successCount = 0
    for (i in 0..10) {
        let result = breaker.call<Int64>{ =>
            // 模拟操作（前3次成功，后面失败）
            if (i < 3) {
                return 42
            } else {
                throw Exception("Operation failed")
            }
        }

        match (result) {
            case Some(value) => {
                println("操作 ${i} 成功: ${value}")
                successCount++
            }
            case None => {
                println("操作 ${i} 被熔断器拒绝")
            }
        }
    }

    // 检查状态
    if (breaker.isOpen()) {
        println("熔断器已打开")
        breaker.close()  // 手动关闭
        println("熔断器已关闭")
    }
}
```

---

**文档版本**: v1.0.0
**最后更新**: 2026-01-24
**维护者**: @mumu_xsy
