import UIKit

class EmoticonPackage: NSObject {
    @objc var emoticons : [Emoticon] = [Emoticon]()
    
    init(id : String) {
        
        super.init()
//        1.最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
//        2.根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        
//        3.根据plist文件的路径读取数据
        let array = NSArray.init(contentsOfFile: plistPath) as! [[String : String]]
        
//        4.遍历数组
        var index = 0
        
        for var dict in array {
            if let png = dict["png"] {
               dict["png"] = id + "/" + png
            }
            
            emoticons.append(Emoticon.init(dict: dict))
            index += 1
            
            if index == 17 {
//                添加删除表情
                emoticons.append(Emoticon.init(isRemove: true))
                
                index = 0
            }
        }
//        5.添加空白表情
        addEmptyEmoticon(isRecently: false)
        
    }
    
    private func addEmptyEmoticon(isRecently : Bool) {
        let count = emoticons.count % 18
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<17 {
            emoticons.append(Emoticon.init(isEmpty: true))
        }
        
        emoticons.append(Emoticon.init(isRemove: true))
        
    }
}
