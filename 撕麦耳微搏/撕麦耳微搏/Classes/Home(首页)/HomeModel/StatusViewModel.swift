import UIKit

class StatusViewModel: NSObject {
//    MARK:- 定义属性
     @objc var status : Statuses?
    
    @objc var cellHeight : CGFloat = 0
    
    //    MARK:- 对数据处理的属性
    
    /// 处理来源
    @objc var sourceText : String?
    
    /// 处理创建时间
      @objc var createAtText : String?
    
    /// 处理用户认证图标
     @objc var verifiedImage : UIImage?
    
    /// 处理用户会员等级
     @objc var vipImage : UIImage?
    
    /// 处理用户头像的url
     @objc var profileURL : URL?
    
    /// 处理微博配图的数据
    @objc var picUrls : [URL] = [URL]()
    
    
    
    
    //    MARK:- 自定义构造函数
    init(status : Statuses) {
        self.status = status
//        1.对来源处理
        if let source = status.source, source != "" {
            
//        1.1获取起始位置和截取的长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
//        2.2截取字符串
            sourceText = (source as NSString).substring(with: NSRange.init(location: startIndex, length: length))
        }
        
//        2.处理时间
        if let creatAt = status.created_at {
            createAtText = NSDate.creatTimeWithString(timeString: creatAt)
        }
        
//        3.处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage.init(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage.init(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
//        4.处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage.init(named: "common_icon_membership_level\(mbrank)")
        }
        
//        5.处理用户头像的url
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL.init(string: profileURLString)
        
//        6.处理配图数据
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts {
                guard let picUrlString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picUrls.append(URL.init(string: picUrlString )!)
            }
        }
}
}
