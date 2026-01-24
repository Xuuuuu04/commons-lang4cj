# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-19

### Added
- 新增 `commons_lang4cj.math` 包
  - **Fraction 类**: 分数四则运算、类型转换、比较功能
    - 40个公共方法
    - 支持约分、取反、倒数、幂运算
    - 支持与 Float64/Float32/Int64 互转
    - 完整的 IEEE 754 标准支持
  - **IEEE754rUtils 类**: 浮点数工具类
    - 14个公共方法
    - NaN 和无穷大检查
    - 浮点数比较 (符合 IEEE 754 标准)
    - 最小值/最大值计算

### Changed
- 更新 README.md 添加 Math 包文档和架构说明
- 清理编译警告 (37+ → 26个)

### Fixed
- 修复测试框架配置问题
- 修复 Float32 精度测试 (使用范围比较)
- 修复 ArithmeticException 导入问题

### Technical Details
- 新增代码: 1,009行源码
- 新增测试: 694行测试代码
- 测试用例: 63个 (Fraction 40个 + IEEE754rUtils 23个)
- 测试覆盖率: 100%
- 总测试数: 610个 (原有548个 + 新增62个)

### Documentation
- 新增 Fraction 类设计文档 (4份,36,000字)
- 新增 IEEE754rUtils 实现报告
- 更新 README.md 添加 Math 包说明

## [1.0.0] - 2026-01-19

### Added
- ✨ Utils 包 (7个类, 209个方法)
  - StringUtils, ArrayUtils, ObjectUtils, NumberUtils
  - BooleanUtils, CharUtils, ValidateUtils
- ✨ Builder 包 (5个类, 171个方法)
  - EqualsBuilder, HashCodeBuilder, ToStringBuilder
  - ToStringStyle, CompareToBuilder
- ✨ Mutable 包 (8个类, 207个方法)
  - MutableInt, MutableLong, MutableDouble, MutableFloat
  - MutableShort, MutableByte, MutableBoolean, MutableObject
- ✨ Range 包 (3个类, 44个方法)
  - Range, CharRange, NumberRange

### Quality
- 测试覆盖: 548个测试用例 (100%通过)
- 代码行数: 11,790行源码 + 6,897行测试
- 编译状态: 0错误, 26个警告(不影响功能)
