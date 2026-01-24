package commons_lang4cj.exception

/**
 * 支持异常链的扩展异常类
 *
 * 仓颉标准库的 Exception 类不支持 cause 参数，此类添加了该功能。
 * 所有需要异常链功能的异常都应该继承此类。
 */
public open class ExtendedException <: Exception {
    /**
     * 异常原因（可能为 None）
     */
    public let cause: Option<ExtendedException>

    /**
     * 异常唯一标识符（用于循环检测）
     */
    protected var _id: UIntNative = 0

    /**
     * 全局ID计数器
     */
    protected static var _nextId: UIntNative = 1

    /**
     * 构造函数（仅消息）
     *
     * @param message 异常消息
     */
    public init(message: String) {
        super(message)
        _id = ExtendedException._nextId
        ExtendedException._nextId++
        cause = None
    }

    /**
     * 构造函数（消息 + 原因）
     *
     * @param message 异常消息
     * @param cause 异常原因
     */
    public init(message: String, cause: ExtendedException) {
        super(message)
        _id = ExtendedException._nextId
        ExtendedException._nextId++
        this.cause = Some(cause)
    }

    /**
     * 构造函数（仅原因）
     *
     * @param cause 异常原因
     */
    public init(cause: ExtendedException) {
        super(cause.message)
        _id = ExtendedException._nextId
        ExtendedException._nextId++
        this.cause = Some(cause)
    }

    /**
     * 获取异常的标识符（用于循环检测）
     */
    public func getId(): UIntNative {
        _id
    }

    /**
     * 获取异常类名
     */
    public override func getClassName(): String {
        "ExtendedException"
    }
}
