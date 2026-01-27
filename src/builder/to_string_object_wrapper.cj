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

import std.reflect.*

/**
 * ToStringObject 的通用包装器
 *
 * 将任意类型包装为 ToStringObject，以便在 ToStringBuilder 中使用。
 * 使用泛型支持任意类型。
 */
public open class ToStringObjectWrapper<T> <: ToStringObject where T <: ToString {
    /**
     * 被包装的对象
     */
    protected let _value: T

    /**
     * 构造包装器
     */
    public init(value: T) {
        _value = value
    }

    /**
     * 获取类名
     */
    public func getClassName(): String {
        try {
            TypeInfo.of(_value).name
        } catch (e: Exception) {
            "Unknown"
        }
    }

    /**
     * 获取身份哈希码
     */
    public func getIdentityHashCode(): UInt64 {
        match (_value as Hashable) {
            case Some(h) => UInt64(h.hashCode())
            case None => 0u64
        }
    }

    /**
     * 转换为字符串
     */
    public func toString(): String {
        _value.toString()
    }
}

/**
 * 基本类型包装器（Bool）
 */
public class BoolToStringObject <: ToStringObject {
    protected let _value: Bool

    public init(value: Bool) {
        _value = value
    }

    public func getClassName(): String {
        "Bool"
    }

    public func getIdentityHashCode(): UInt64 {
        if (_value) {
            1u64
        } else {
            0u64
        }
    }

    public func toString(): String {
        "${_value}"
    }
}

/**
 * 字符串包装器
 */
public class StringToStringObject <: ToStringObject {
    protected let _value: String

    public init(value: String) {
        _value = value
    }

    public func getClassName(): String {
        "String"
    }

    public func getIdentityHashCode(): UInt64 {
        UInt64(_value.hashCode())
    }

    public func toString(): String {
        _value
    }
}
