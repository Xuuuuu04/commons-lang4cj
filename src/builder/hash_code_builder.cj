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
 * 哈希码构建器
 *
 * 用于协助实现 Object.hashCode() 方法。遵循 Effective Java 的设计原则。
 *
 * ## 核心算法
 *
 * - 初始值：17（奇质数）
 * - 乘数：37（奇质数）
 * - 公式：`total = total * multiplier + value`
 *
 * ## 使用示例
 *
 * ```cangjie
 * class Person {
 *     let name: String
 *     let age: Int64
 *     let smoker: Bool
 *
 *     public func hashCode(): Int64 {
 *         return HashCodeBuilder()
 *             .append(name)
 *             .append(age)
 *             .append(smoker)
 *             .toHashCode()
 *     }
 * }
 * ```
 *
 * @since 1.0.0
 */
public open class HashCodeBuilder {
    /**
     * 默认初始值（用于反射）
     */
    public static const DEFAULT_INITIAL_VALUE: Int64 = 17

    /**
     * 默认乘数（用于反射）
     */
    public static const DEFAULT_MULTIPLIER_VALUE: Int64 = 37

    /**
     * 乘数常量
     */
    protected var _iConstant: Int64

    /**
     * 运行时总计值
     */
    protected var _iTotal: Int64

    /**
     * 使用硬编码常量初始化
     */
    public init() {
        _iConstant = 37
        _iTotal = 17
    }

    /**
     * 使用自定义奇数初始化
     *
     * @param initialOddNumber 初始奇数
     * @param multiplierOddNumber 乘数奇数
     * @throws IllegalArgumentException 如果参数为偶数
     */
    public init(initialOddNumber: Int64, multiplierOddNumber: Int64) {
        if (initialOddNumber % 2 == 0) {
            throw IllegalArgumentException("HashCodeBuilder requires an odd initial value")
        }
        if (multiplierOddNumber % 2 == 0) {
            throw IllegalArgumentException("HashCodeBuilder requires an odd multiplier")
        }
        _iConstant = multiplierOddNumber
        _iTotal = initialOddNumber
    }

    /**
     * 追加布尔值
     */
    public func append(value: Bool): HashCodeBuilder {
        _iTotal = _iTotal * _iConstant + (if (value) { 0 } else { 1 })
        this
    }

    /**
     * 追加布尔数组
     */
    public func append(array: Option<Array<Bool>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加字节值
     */
    public func append(value: Int8): HashCodeBuilder {
        _iTotal = _iTotal * _iConstant + (value as Int64 ?? 0)
        this
    }

    /**
     * 追加字节数组
     */
    public func append(array: Option<Array<Int8>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加字符值
     */
    public func append(value: Rune): HashCodeBuilder {
        _iTotal = _iTotal * _iConstant + (value as Int64 ?? 0)
        this
    }

    /**
     * 追加字符数组
     */
    public func append(array: Option<Array<Rune>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加双精度浮点值
     */
    public func append(value: Float64): HashCodeBuilder {
        // 简化处理：将 Float64 转换为 Int64
        _iTotal = _iTotal * _iConstant + (value as Int64 ?? 0)
        this
    }

    /**
     * 追加双精度浮点数组
     */
    public func append(array: Option<Array<Float64>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加单精度浮点值
     */
    public func append(value: Float32): HashCodeBuilder {
        // 简化处理：将 Float32 转换为 Int64
        _iTotal = _iTotal * _iConstant + (value as Int64 ?? 0)
        this
    }

    /**
     * 追加单精度浮点数组
     */
    public func append(array: Option<Array<Float32>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加整数值
     */
    public func append(value: Int64): HashCodeBuilder {
        _iTotal = _iTotal * _iConstant + value
        this
    }

    /**
     * 追加整数数组
     */
    public func append(array: Option<Array<Int64>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加长整数值
     */
    public func append(value: IntNative): HashCodeBuilder {
        let v = value as Int64 ?? 0
        _iTotal = _iTotal * _iConstant + (v ^ (v >> 32))
        this
    }

    /**
     * 追加长整数数组
     */
    public func append(array: Option<Array<IntNative>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加短整数值
     */
    public func append(value: Int16): HashCodeBuilder {
        _iTotal = _iTotal * _iConstant + (value as Int64 ?? 0)
        this
    }

    /**
     * 追加短整数数组
     */
    public func append(array: Option<Array<Int16>>): HashCodeBuilder {
        if (let Some(arr) <- array) {
            for (element in arr) {
                append(element)
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加对象（支持哈希的对象）
     */
    public func append(object: Option<Hashable>): HashCodeBuilder {
        if (let Some(obj) <- object) {
            _iTotal = _iTotal * _iConstant + obj.hashCode()
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加对象数组
     */
    public func append<T>(array: Option<Array<T>>): HashCodeBuilder where T <: Hashable {
        if (let Some(arr) <- array) {
            for (element in arr) {
                _iTotal = _iTotal * _iConstant + element.hashCode()
            }
        } else {
            _iTotal = _iTotal * _iConstant
        }
        this
    }

    /**
     * 追加父类的哈希码
     */
    public func appendSuper(superHashCode: Int64): HashCodeBuilder {
        _iTotal = _iTotal * _iConstant + superHashCode
        this
    }

    /**
     * 返回计算得到的哈希码
     */
    public func toHashCode(): Int64 {
        _iTotal
    }

    /**
     * 返回计算得到的哈希码（与 toHashCode 相同）
     */
    public func hashCode(): Int64 {
        _iTotal
    }
}
