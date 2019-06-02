import UIKit

class Emoticon: NSObject {
    //    MARK:- 定义属性
    
    /// emoji的code
    @objc var code : String? {
        didSet {
            guard let code = code else {
                return
            }
            
//            1.创建扫描器
            let scanner = Scanner.init(string: code)
            
//            2.调用方法，扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
//            3.将value转成字符
            let c = Character.init(UnicodeScalar.init(value)!)
            
//            4.将字符转成字符串
            emojiCode = String(c)
            
        }
    }
    
    /// 普通表情对应的图片名称
    @objc var png : String? {
        didSet {
            guard let png = png else {
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    
    /// 普通表情对应的文字
    @objc var chs : String?
    
    //    MARK:- 数据处理
    @objc var pngPath : String?
    @objc var emojiCode : String?
    @objc var isRemove : Bool = false
    @objc var isEmpty : Bool = false
    
    //    MARK:- 自定义构造函数
    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    init(isRemove : Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }

}
