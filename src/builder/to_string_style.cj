/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package commons_lang4cj.builder

import std.collection.*

/**
 * 控制 ToStringBuilder 的字符串格式化
 *
 * ## 核心功能
 *
 * - 定义字符串输出的格式规则
 * - 支持多种预定义样式（默认、简洁、无字段名等）
 * - 可通过子类自定义格式
 *
 * ## 使用示例
 *
 * ```cangjie
 * // 使用默认样式
 * let builder = ToStringBuilder(PersonWrapper(Person("Alice", 25)))
 *     .append("name", "Alice")
 *     .append("age", 25)
 *
 * // 使用简洁样式
 * let builder = ToStringBuilder(PersonWrapper(Person("Alice", 25)), Some(ToStringStyle.SIMPLE_STYLE))
 * ```
 *
 * @since 1.0.0
 */
public abstract class ToStringStyle {
    /**
     * 默认样式：包含类名、字段名和值
     *
     * 输出示例：`Person@7f54[name=Stephen,age=29,smoker=false]`
     */
    public static func getDefaultStyle(): ToStringStyle {
        DefaultToStringStyle()
    }

    /**
     * 简洁样式：不包含类名
     *
     * 输出示例：`[name=Stephen,age=29,smoker=false]`
     */
    public static func getSimpleStyle(): ToStringStyle {
        SimpleToStringStyle()
    }

    /**
     * 短样式：类名无后缀
     *
     * 输出示例：`Person[name=Stephen,age=29,smoker=false]`
     */
    public static func getShortStyle(): ToStringStyle {
        ShortToStringStyle()
    }

    /**
     * 无字段名样式：只输出值
     *
     * 输出示例：`Person@7f54[Stephen,29,false]`
     */
    public static func getNoFieldNamesStyle(): ToStringStyle {
        NoFieldNamesToStringStyle()
    }

    // 向后兼容的常量（使用懒加载）
    public static var DEFAULT_STYLE: ToStringStyle = getDefaultStyle()
    public static var SIMPLE_STYLE: ToStringStyle = getSimpleStyle()
    public static var SHORT_STYLE: ToStringStyle = getShortStyle()
    public static var NO_FIELD_NAMES_STYLE: ToStringStyle = getNoFieldNamesStyle()

    /**
     * 是否使用类名
     */
    protected var _useClassName: Bool = true

    /**
     * 是否使用身份哈希码
     */
    protected var _useIdentityHashCode: Bool = true

    /**
     * 是否使用字段名
     */
    protected var _useFieldNames: Bool = true

    /**
     * 是否使用短类名
     */
    protected var _useShortClassName: Bool = false

    /**
     * 内容开始标记
     */
    protected var _contentStart: String = "["

    /**
     * 内容结束标记
     */
    protected var _contentEnd: String = "]"

    /**
     * 字段名和值之间的分隔符
     */
    protected var _fieldNameValueSeparator: String = "="

    /**
     * 字段之间的分隔符
     */
    protected var _fieldSeparator: String = ","

    /**
     * 数组开始标记
     */
    protected var _arrayStart: String = "{"

    /**
     * 数组结束标记
     */
    protected var _arrayEnd: String = "}"

    /**
     * 数组内容分隔符
     */
    protected var _arraySeparator: String = ","

    /**
     * null 值的文本表示
     */
    protected var _nullText: String = "<null>"

    /**
     * 大小文本开始
     */
    protected var _sizeStartText: String = "<size="

    /**
     * 大小文本结束
     */
    protected var _sizeEndText: String = ">"

    /**
     * 摘要对象开始文本
     */
    protected var _summaryObjectStartText: String = "<"

    /**
     * 摘要对象结束文本
     */
    protected var _summaryObjectEndText: String = ">"

    /**
     * 默认构造函数
     */
    protected init() {}

    /**
     * 追加开始标记
     */
    public open func appendStart(buffer: StringBuilder, object: Option<ToStringObject>): Unit {
        if (let None <- object) {
            appendNullText(buffer, None)
            return
        }
        else if (let Some(obj) <- object) {
            buffer.append(obj.getClassName())
            if (_useIdentityHashCode) {
                buffer.append("@")
                buffer.append(obj.getIdentityHashCode())
            }
            buffer.append(_contentStart)
        }
    }

    /**
     * 追加结束标记
     */
    public open func appendEnd(buffer: StringBuilder, _: Option<ToStringObject>): Unit {
        buffer.append(_contentEnd)
    }

    /**
     * 追加布尔值
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, value: Bool): Unit {
        appendFieldStart(buffer, _fieldName)
        appendDetail(buffer, _fieldName, value)
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加布尔数组（无详情）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Bool>>): Unit {
        appendFieldStart(buffer, _fieldName)
        match (array) {
            case None => appendNullText(buffer, _fieldName)
            case Some(arr) => appendDetail(buffer, _fieldName, arr)
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加布尔数组（带详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Bool>>, fullDetail: Option<Bool>): Unit {
        appendFieldStart(buffer, _fieldName)
        if (let None <- array) {
            appendNullText(buffer, _fieldName)
        } else if (let Some(arr) <- array) {
            let showDetail = if (let Some(fd) <- fullDetail) { fd } else { false }
            if (showDetail) {
                appendDetail(buffer, _fieldName, arr)
            } else {
                appendSummary(buffer, _fieldName, arr)
            }
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加字节值
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, value: Int8): Unit {
        appendFieldStart(buffer, _fieldName)
        appendDetail(buffer, _fieldName, value)
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加字节数组（无详情）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Int8>>): Unit {
        appendFieldStart(buffer, _fieldName)
        match (array) {
            case None => appendNullText(buffer, _fieldName)
            case Some(arr) => appendDetail(buffer, _fieldName, arr)
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加字节数组（带详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Int8>>, fullDetail: Option<Bool>): Unit {
        appendFieldStart(buffer, _fieldName)
        if (let None <- array) {
            appendNullText(buffer, _fieldName)
        } else if (let Some(arr) <- array) {
            let showDetail = if (let Some(fd) <- fullDetail) { fd } else { false }
            if (showDetail) {
                appendDetail(buffer, _fieldName, arr)
            } else {
                appendSummary(buffer, _fieldName, arr)
            }
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加字符值
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, value: Rune): Unit {
        appendFieldStart(buffer, _fieldName)
        appendDetail(buffer, _fieldName, value)
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加字符数组（无详情）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Rune>>): Unit {
        appendFieldStart(buffer, _fieldName)
        match (array) {
            case None => appendNullText(buffer, _fieldName)
            case Some(arr) => appendDetail(buffer, _fieldName, arr)
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加字符数组（带详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Rune>>, fullDetail: Option<Bool>): Unit {
        appendFieldStart(buffer, _fieldName)
        if (let None <- array) {
            appendNullText(buffer, _fieldName)
        } else if (let Some(arr) <- array) {
            let showDetail = if (let Some(fd) <- fullDetail) { fd } else { false }
            if (showDetail) {
                appendDetail(buffer, _fieldName, arr)
            } else {
                appendSummary(buffer, _fieldName, arr)
            }
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加双精度值
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, value: Float64): Unit {
        appendFieldStart(buffer, _fieldName)
        appendDetail(buffer, _fieldName, value)
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加双精度数组（无详情）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Float64>>): Unit {
        appendFieldStart(buffer, _fieldName)
        match (array) {
            case None => appendNullText(buffer, _fieldName)
            case Some(arr) => appendDetail(buffer, _fieldName, arr)
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加双精度数组（带详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Float64>>, fullDetail: Option<Bool>): Unit {
        appendFieldStart(buffer, _fieldName)
        if (let None <- array) {
            appendNullText(buffer, _fieldName)
        } else if (let Some(arr) <- array) {
            let showDetail = if (let Some(fd) <- fullDetail) { fd } else { false }
            if (showDetail) {
                appendDetail(buffer, _fieldName, arr)
            } else {
                appendSummary(buffer, _fieldName, arr)
            }
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加浮点值
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, value: Float32): Unit {
        appendFieldStart(buffer, _fieldName)
        appendDetail(buffer, _fieldName, value)
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加浮点数组（无详情）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Float32>>): Unit {
        appendFieldStart(buffer, _fieldName)
        match (array) {
            case None => appendNullText(buffer, _fieldName)
            case Some(arr) => appendDetail(buffer, _fieldName, arr)
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加浮点数组（带详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Float32>>, fullDetail: Option<Bool>): Unit {
        appendFieldStart(buffer, _fieldName)
        if (let None <- array) {
            appendNullText(buffer, _fieldName)
        } else if (let Some(arr) <- array) {
            let showDetail = if (let Some(fd) <- fullDetail) { fd } else { false }
            if (showDetail) {
                appendDetail(buffer, _fieldName, arr)
            } else {
                appendSummary(buffer, _fieldName, arr)
            }
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加整数值
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, value: Int64): Unit {
        appendFieldStart(buffer, _fieldName)
        appendDetail(buffer, _fieldName, value)
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加整数数组（无详情）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Int64>>): Unit {
        appendFieldStart(buffer, _fieldName)
        match (array) {
            case None => appendNullText(buffer, _fieldName)
            case Some(arr) => appendDetail(buffer, _fieldName, arr)
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加整数数组（带详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, array: Option<Array<Int64>>, fullDetail: Option<Bool>): Unit {
        appendFieldStart(buffer, _fieldName)
        if (let None <- array) {
            appendNullText(buffer, _fieldName)
        } else if (let Some(arr) <- array) {
            let showDetail = if (let Some(fd) <- fullDetail) { fd } else { false }
            if (showDetail) {
                appendDetail(buffer, _fieldName, arr)
            } else {
                appendSummary(buffer, _fieldName, arr)
            }
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加对象值（无详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, obj: Option<ToStringObject>): Unit {
        appendFieldStart(buffer, _fieldName)
        match (obj) {
            case None => appendNullText(buffer, _fieldName)
            case Some(o) => appendDetail(buffer, _fieldName, o)
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加对象值（带详情级别）
     */
    public open func append(buffer: StringBuilder, _fieldName: Option<String>, obj: Option<ToStringObject>, fullDetail: Option<Bool>): Unit {
        appendFieldStart(buffer, _fieldName)
        if (let None <- obj) {
            appendNullText(buffer, _fieldName)
        } else if (let Some(o) <- obj) {
            let showDetail = if (let Some(fd) <- fullDetail) { fd } else { false }
            if (showDetail) {
                appendDetail(buffer, _fieldName, o)
            } else {
                appendSummary(buffer, _fieldName, o)
            }
        }
        appendFieldEnd(buffer, _fieldName)
    }

    /**
     * 追加父类 toString
     */
    public open func appendSuper(buffer: StringBuilder, superToString: String): Unit {
        appendInternal(buffer, "super", superToString)
    }

    /**
     * 追加 toString
     */
    public open func appendToString(buffer: StringBuilder, toString: String): Unit {
        appendInternal(buffer, "toString", toString)
    }

    /**
     * 追加字段开始
     */
    protected func appendFieldStart(buffer: StringBuilder, fieldName: Option<String>): Unit {
        if (_useFieldNames) {
            if (let Some(name) <- fieldName) {
                buffer.append(name)
                buffer.append(_fieldNameValueSeparator)
            }
        }
    }

    /**
     * 追加字段结束
     */
    protected func appendFieldEnd(buffer: StringBuilder, _: Option<String>): Unit {
        buffer.append(_fieldSeparator)
    }

    /**
     * 追加 null 文本
     */
    protected func appendNullText(buffer: StringBuilder, _: Option<String>): Unit {
        buffer.append(_nullText)
    }

    /**
     * 追加布尔值详情
     */
    protected open func appendDetail(buffer: StringBuilder, _: Option<String>, value: Bool): Unit {
        buffer.append(value)
    }

    /**
     * 追加布尔数组详情
     */
    protected open func appendDetail(buffer: StringBuilder, _fieldName: Option<String>, array: Array<Bool>): Unit {
        buffer.append(_arrayStart)
        for ((i, item) in enumerate(array)) {
            if (i > 0) {
                buffer.append(_arraySeparator)
            }
            appendDetail(buffer, _fieldName, item)
        }
        buffer.append(_arrayEnd)
    }

    /**
     * 追加字节值详情
     */
    protected open func appendDetail(buffer: StringBuilder, _: Option<String>, value: Int8): Unit {
        buffer.append(value)
    }

    /**
     * 追加字节数组详情
     */
    protected open func appendDetail(buffer: StringBuilder, _fieldName: Option<String>, array: Array<Int8>): Unit {
        buffer.append(_arrayStart)
        for ((i, item) in enumerate(array)) {
            if (i > 0) {
                buffer.append(_arraySeparator)
            }
            appendDetail(buffer, _fieldName, item)
        }
        buffer.append(_arrayEnd)
    }

    /**
     * 追加字符值详情
     */
    protected open func appendDetail(buffer: StringBuilder, _: Option<String>, value: Rune): Unit {
        buffer.append(value)
    }

    /**
     * 追加字符数组详情
     */
    protected open func appendDetail(buffer: StringBuilder, _fieldName: Option<String>, array: Array<Rune>): Unit {
        buffer.append(_arrayStart)
        for ((i, item) in enumerate(array)) {
            if (i > 0) {
                buffer.append(_arraySeparator)
            }
            appendDetail(buffer, _fieldName, item)
        }
        buffer.append(_arrayEnd)
    }

    /**
     * 追加双精度值详情
     */
    protected open func appendDetail(buffer: StringBuilder, _: Option<String>, value: Float64): Unit {
        buffer.append(value)
    }

    /**
     * 追加双精度数组详情
     */
    protected open func appendDetail(buffer: StringBuilder, _fieldName: Option<String>, array: Array<Float64>): Unit {
        buffer.append(_arrayStart)
        for ((i, item) in enumerate(array)) {
            if (i > 0) {
                buffer.append(_arraySeparator)
            }
            appendDetail(buffer, _fieldName, item)
        }
        buffer.append(_arrayEnd)
    }

    /**
     * 追加浮点值详情
     */
    protected open func appendDetail(buffer: StringBuilder, _: Option<String>, value: Float32): Unit {
        buffer.append(value)
    }

    /**
     * 追加浮点数组详情
     */
    protected open func appendDetail(buffer: StringBuilder, _fieldName: Option<String>, array: Array<Float32>): Unit {
        buffer.append(_arrayStart)
        for ((i, item) in enumerate(array)) {
            if (i > 0) {
                buffer.append(_arraySeparator)
            }
            appendDetail(buffer, _fieldName, item)
        }
        buffer.append(_arrayEnd)
    }

    /**
     * 追加整数值详情
     */
    protected open func appendDetail(buffer: StringBuilder, _: Option<String>, value: Int64): Unit {
        buffer.append(value)
    }

    /**
     * 追加整数数组详情
     */
    protected open func appendDetail(buffer: StringBuilder, _fieldName: Option<String>, array: Array<Int64>): Unit {
        buffer.append(_arrayStart)
        for ((i, item) in enumerate(array)) {
            if (i > 0) {
                buffer.append(_arraySeparator)
            }
            appendDetail(buffer, _fieldName, item)
        }
        buffer.append(_arrayEnd)
    }

    /**
     * 追加对象详情
     */
    protected open func appendDetail(buffer: StringBuilder, _: Option<String>, obj: ToStringObject): Unit {
        buffer.append(obj.toString())
    }

    /**
     * 追加数组摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, array: Collection<Any>): Unit {
        buffer.append(_sizeStartText)
        buffer.append(array.size)
        buffer.append(_sizeEndText)
    }

    /**
     * 追加布尔数组摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, array: Array<Bool>): Unit {
        buffer.append(_sizeStartText)
        buffer.append(array.size)
        buffer.append(_sizeEndText)
    }

    /**
     * 追加字节数组摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, array: Array<Int8>): Unit {
        buffer.append(_sizeStartText)
        buffer.append(array.size)
        buffer.append(_sizeEndText)
    }

    /**
     * 追加字符数组摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, array: Array<Rune>): Unit {
        buffer.append(_sizeStartText)
        buffer.append(array.size)
        buffer.append(_sizeEndText)
    }

    /**
     * 追加双精度数组摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, array: Array<Float64>): Unit {
        buffer.append(_sizeStartText)
        buffer.append(array.size)
        buffer.append(_sizeEndText)
    }

    /**
     * 追加浮点数组摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, array: Array<Float32>): Unit {
        buffer.append(_sizeStartText)
        buffer.append(array.size)
        buffer.append(_sizeEndText)
    }

    /**
     * 追加整数数组摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, array: Array<Int64>): Unit {
        buffer.append(_sizeStartText)
        buffer.append(array.size)
        buffer.append(_sizeEndText)
    }

    /**
     * 追加对象摘要
     */
    protected func appendSummary(buffer: StringBuilder, _: Option<String>, obj: ToStringObject): Unit {
        buffer.append(_summaryObjectStartText)
        buffer.append(obj.getClassName())
        buffer.append("@")
        buffer.append(obj.getIdentityHashCode())
        buffer.append(_summaryObjectEndText)
    }

    /**
     * 内部追加方法
     */
    protected func appendInternal(buffer: StringBuilder, _fieldName: String, value: String): Unit {
        appendFieldStart(buffer, Some(_fieldName))
        buffer.append(value)
        appendFieldEnd(buffer, Some(_fieldName))
    }

    /**
     * 获取 null 文本
     */
    public func getNullText(): String {
        _nullText
    }

    /**
     * 获取大小文本开始
     */
    public func getSizeStartText(): String {
        _sizeStartText
    }

    /**
     * 获取大小文本结束
     */
    public func getSizeEndText(): String {
        _sizeEndText
    }

    /**
     * 获取摘要对象开始文本
     */
    public func getSummaryObjectStartText(): String {
        _summaryObjectStartText
    }

    /**
     * 获取摘要对象结束文本
     */
    public func getSummaryObjectEndText(): String {
        _summaryObjectEndText
    }
}

/**
 * 默认样式实现
 */
public class DefaultToStringStyle <: ToStringStyle {
    public init() {
        super()
    }
}

/**
 * 简洁样式实现（不使用类名和身份哈希码）
 */
public class SimpleToStringStyle <: ToStringStyle {
    public init() {
        super()
        _useClassName = false
        _useIdentityHashCode = false
        _useFieldNames = true
    }
}

/**
 * 短样式实现（使用短类名）
 */
public class ShortToStringStyle <: ToStringStyle {
    public init() {
        super()
        _useShortClassName = true
    }
}

/**
 * 无字段名样式实现
 */
public class NoFieldNamesToStringStyle <: ToStringStyle {
    public init() {
        super()
        _useFieldNames = false
    }
}

/**
 * ToStringObject 接口：所有可转换为字符串的对象
 */
public interface ToStringObject {
    func getClassName(): String
    func getIdentityHashCode(): UInt64
    func toString(): String
}
