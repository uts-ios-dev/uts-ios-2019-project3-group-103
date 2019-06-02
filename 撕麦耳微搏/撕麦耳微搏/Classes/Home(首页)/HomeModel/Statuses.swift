import UIKit

class Statuses: NSObject {

    //    MARK:- 属性
    
    /// 微博创建时间
    @objc var created_at : String? 
    
    /// 微博来源
    @objc var source : String? 
    
    /// 微博正文
    @objc var text : String?
    
    /// 微博的ID
    @objc var mid : Int = 0
    @objc var user : User?
    
    /// 微博配图
    @objc var pic_urls : [[String : String]]?
    
    /// 微博对应的转发微博
    @objc var retweeted_status : Statuses?
    
    
    //    MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
        
//        1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
//        2.将转发微博字典转成转发微博模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = Statuses(dict: retweetedStatusDict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
