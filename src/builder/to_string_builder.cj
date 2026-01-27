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

/**
 * 协助实现 Object.toString() 方法的构建器
 *
 * ## 核心功能
 *
 * - 支持链式调用
 * - 支持所有基本类型和对象
 * - 支持数组输出
 * - 支持自定义样式
 *
 * ## 使用示例
 *
 * ```cangjie
 * class Person {
 *     let name: String
 *     let age: Int64
 *     let smoker: Bool
 *
 *     public func toString(): String {
 *         return ToStringBuilder(PersonWrapper(this))
 *             .append("name", name)
 *             .append("age", age)
 *             .append("smoker", smoker)
 *             .build()
 *     }
 * }
 * ```
 *
 * @since 1.0.0
 */
public open class ToStringBuilder {
    /**
     * 默认样式
     */
    private static var _defaultStyle: ToStringStyle = ToStringStyle.DEFAULT_STYLE

    /**
     * 获取默认样式
     */
    public static func getDefaultStyle(): ToStringStyle {
        _defaultStyle
    }

    /**
     * 设置默认样式
     */
    public static func setDefaultStyle(style: ToStringStyle): Unit {
        _defaultStyle = style
    }

    /**
     * 字符串缓冲区
     */
    protected var _buffer: StringBuilder

    /**
     * 被构建的对象
     */
    protected var _object: Option<ToStringObject>

    /**
     * 输出样式
     */
    protected var _style: ToStringStyle

    private var _registryKey: Option<String> = None

    /**
     * 使用默认样式构建对象
     *
     * @param object 要构建的对象
     */
    public init(object: Option<ToStringObject>) {
        _object = object
        _style = getDefaultStyle()
        _buffer = StringBuilder(512)
        if (let Some(obj) <- object) {
            let key = ToStringRegistry.keyOf(obj)
            ToStringRegistry.register(key)
            _registryKey = Some(key)
        }
        _style.appendStart(_buffer, object)
    }

    /**
     * 使用指定样式构建对象
     *
     * @param object 要构建的对象
     * @param style 输出样式，None 使用默认样式
     */
    public init(object: Option<ToStringObject>, style: Option<ToStringStyle>) {
        _object = object
        _style = match (style) { case Some(s) => s case None => getDefaultStyle() }
        _buffer = StringBuilder(512)
        if (let Some(obj) <- object) {
            let key = ToStringRegistry.keyOf(obj)
            ToStringRegistry.register(key)
            _registryKey = Some(key)
        }
        _style.appendStart(_buffer, object)
    }

    /**
     * 使用指定样式和缓冲区构建对象
     *
     * @param object 要构建的对象
     * @param style 输出样式，None 使用默认样式
     * @param buffer 字符串缓冲区，None 创建新缓冲区
     */
    public init(object: Option<ToStringObject>, style: Option<ToStringStyle>, buffer: Option<StringBuilder>) {
        _object = object
        _style = match (style) { case Some(s) => s case None => getDefaultStyle() }
        _buffer = match (buffer) { case Some(b) => b case None => StringBuilder(512) }
        if (let Some(obj) <- object) {
            let key = ToStringRegistry.keyOf(obj)
            ToStringRegistry.register(key)
            _registryKey = Some(key)
        }
        _style.appendStart(_buffer, object)
    }

    /**
     * 追加布尔值
     *
     * @param value 要追加的值
     * @return this
     */
    public open func append(value: Bool): ToStringBuilder {
        _style.append(_buffer, None, value)
        return this
    }

    /**
     * 追加布尔数组
     *
     * @param array 要追加的数组
     * @return this
     */
    public open func append(array: Option<Array<Bool>>): ToStringBuilder {
        _style.append(_buffer, None, array)
        return this
    }

    /**
     * 追加字节值
     *
     * @param value 要追加的值
     * @return this
     */
    public open func append(value: Int8): ToStringBuilder {
        _style.append(_buffer, None, value)
        return this
    }

    /**
     * 追加字节数组
     *
     * @param array 要追加的数组
     * @return this
     */
    public open func append(array: Option<Array<Int8>>): ToStringBuilder {
        _style.append(_buffer, None, array)
        return this
    }

    /**
     * 追加字符值
     *
     * @param value 要追加的值
     * @return this
     */
    public open func append(value: Rune): ToStringBuilder {
        _style.append(_buffer, None, value)
        return this
    }

    /**
     * 追加字符数组
     *
     * @param array 要追加的数组
     * @return this
     */
    public open func append(array: Option<Array<Rune>>): ToStringBuilder {
        _style.append(_buffer, None, array)
        return this
    }

    /**
     * 追加双精度值
     *
     * @param value 要追加的值
     * @return this
     */
    public open func append(value: Float64): ToStringBuilder {
        _style.append(_buffer, None, value)
        return this
    }

    /**
     * 追加双精度数组
     *
     * @param array 要追加的数组
     * @return this
     */
    public open func append(array: Option<Array<Float64>>): ToStringBuilder {
        _style.append(_buffer, None, array)
        return this
    }

    /**
     * 追加浮点值
     *
     * @param value 要追加的值
     * @return this
     */
    public open func append(value: Float32): ToStringBuilder {
        _style.append(_buffer, None, value)
        return this
    }

    /**
     * 追加浮点数组
     *
     * @param array 要追加的数组
     * @return this
     */
    public open func append(array: Option<Array<Float32>>): ToStringBuilder {
        _style.append(_buffer, None, array)
        return this
    }

    /**
     * 追加整数值
     *
     * @param value 要追加的值
     * @return this
     */
    public open func append(value: Int64): ToStringBuilder {
        _style.append(_buffer, None, value)
        return this
    }

    /**
     * 追加整数数组
     *
     * @param array 要追加的数组
     * @return this
     */
    public open func append(array: Option<Array<Int64>>): ToStringBuilder {
        _style.append(_buffer, None, array)
        return this
    }

    /**
     * 追加对象值
     *
     * @param obj 要追加的对象
     * @return this
     */
    public open func append(obj: Option<ToStringObject>): ToStringBuilder {
        _style.append(_buffer, None, obj)
        return this
    }

    /**
     * 追加带字段名的布尔值
     *
     * @param fieldName 字段名
     * @param value 要追加的值
     * @return this
     */
    public open func append(fieldName: String, value: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, value)
        return this
    }

    /**
     * 追加带字段名的布尔数组
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Bool>>): ToStringBuilder {
        _style.append(_buffer, fieldName, array)
        return this
    }

    /**
     * 追加带字段名的布尔数组（带详情级别）
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @param fullDetail true 显示完整详情，false 显示摘要
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Bool>>, fullDetail: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, array, fullDetail)
        return this
    }

    /**
     * 追加带字段名的字节值
     *
     * @param fieldName 字段名
     * @param value 要追加的值
     * @return this
     */
    public open func append(fieldName: String, value: Int8): ToStringBuilder {
        _style.append(_buffer, fieldName, value)
        return this
    }

    /**
     * 追加带字段名的字节数组
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Int8>>): ToStringBuilder {
        _style.append(_buffer, fieldName, array)
        return this
    }

    /**
     * 追加带字段名的字节数组（带详情级别）
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @param fullDetail true 显示完整详情，false 显示摘要
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Int8>>, fullDetail: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, array, fullDetail)
        return this
    }

    /**
     * 追加带字段名的字符值
     *
     * @param fieldName 字段名
     * @param value 要追加的值
     * @return this
     */
    public open func append(fieldName: String, value: Rune): ToStringBuilder {
        _style.append(_buffer, fieldName, value)
        return this
    }

    /**
     * 追加带字段名的字符数组
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Rune>>): ToStringBuilder {
        _style.append(_buffer, fieldName, array)
        return this
    }

    /**
     * 追加带字段名的字符数组（带详情级别）
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @param fullDetail true 显示完整详情，false 显示摘要
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Rune>>, fullDetail: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, array, fullDetail)
        return this
    }

    /**
     * 追加带字段名的双精度值
     *
     * @param fieldName 字段名
     * @param value 要追加的值
     * @return this
     */
    public open func append(fieldName: String, value: Float64): ToStringBuilder {
        _style.append(_buffer, fieldName, value)
        return this
    }

    /**
     * 追加带字段名的双精度数组
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Float64>>): ToStringBuilder {
        _style.append(_buffer, fieldName, array)
        return this
    }

    /**
     * 追加带字段名的双精度数组（带详情级别）
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @param fullDetail true 显示完整详情，false 显示摘要
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Float64>>, fullDetail: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, array, fullDetail)
        return this
    }

    /**
     * 追加带字段名的浮点值
     *
     * @param fieldName 字段名
     * @param value 要追加的值
     * @return this
     */
    public open func append(fieldName: String, value: Float32): ToStringBuilder {
        _style.append(_buffer, fieldName, value)
        return this
    }

    /**
     * 追加带字段名的浮点数组
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Float32>>): ToStringBuilder {
        _style.append(_buffer, fieldName, array)
        return this
    }

    /**
     * 追加带字段名的浮点数组（带详情级别）
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @param fullDetail true 显示完整详情，false 显示摘要
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Float32>>, fullDetail: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, array, fullDetail)
        return this
    }

    /**
     * 追加带字段名的整数值
     *
     * @param fieldName 字段名
     * @param value 要追加的值
     * @return this
     */
    public open func append(fieldName: String, value: Int64): ToStringBuilder {
        _style.append(_buffer, fieldName, value)
        return this
    }

    /**
     * 追加带字段名的整数数组
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Int64>>): ToStringBuilder {
        _style.append(_buffer, fieldName, array)
        return this
    }

    /**
     * 追加带字段名的整数数组（带详情级别）
     *
     * @param fieldName 字段名
     * @param array 要追加的数组
     * @param fullDetail true 显示完整详情，false 显示摘要
     * @return this
     */
    public open func append(fieldName: String, array: Option<Array<Int64>>, fullDetail: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, array, fullDetail)
        return this
    }

    /**
     * 追加带字段名的对象值
     *
     * @param fieldName 字段名
     * @param obj 要追加的对象
     * @return this
     */
    public open func append(fieldName: String, obj: Option<ToStringObject>): ToStringBuilder {
        _style.append(_buffer, fieldName, obj)
        return this
    }

    /**
     * 追加带字段名的对象值（带详情级别）
     *
     * @param fieldName 字段名
     * @param obj 要追加的对象
     * @param fullDetail true 显示完整详情，false 显示摘要
     * @return this
     */
    public open func append(fieldName: String, obj: Option<ToStringObject>, fullDetail: Bool): ToStringBuilder {
        _style.append(_buffer, fieldName, obj, fullDetail)
        return this
    }

    /**
     * 追加父类 toString
     *
     * @param superToString 父类的 toString 结果
     * @return this
     */
    public open func appendSuper(superToString: String): ToStringBuilder {
        if (superToString.size > 0) {
            _style.appendSuper(_buffer, superToString)
        }
        return this
    }

    /**
     * 追加另一个对象的 toString
     *
     * @param toString 另一个对象的 toString 结果
     * @return this
     */
    public open func appendToString(toString: String): ToStringBuilder {
        if (toString.size > 0) {
            _style.appendToString(_buffer, toString)
        }
        return this
    }

    /**
     * 获取被构建的对象
     */
    public func getObject(): Option<ToStringObject> {
        _object
    }

    /**
     * 获取字符串缓冲区
     */
    public func getStringBuffer(): StringBuilder {
        _buffer
    }

    /**
     * 获取输出样式
     */
    public func getStyle(): ToStringStyle {
        _style
    }

    /**
     * 构建并返回 toString 结果
     *
     * @return 构建的字符串
     */
    public open func build(): String {
        match (_object) {
            case None => _buffer.append(_style.getNullText())
            case Some(obj) => _style.appendEnd(_buffer, Some(obj))
        }
        let result = _buffer.toString()
        if (let Some(key) <- _registryKey) {
            ToStringRegistry.unregister(key)
            _registryKey = None
        }
        result
    }

    /**
     * 返回构建的字符串（与 build 相同）
     */
    public func toString(): String {
        build()
    }
}
