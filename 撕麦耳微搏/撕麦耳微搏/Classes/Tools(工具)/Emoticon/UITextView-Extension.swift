import UIKit

extension UITextView {
    
    /// 获取textView属性字符串，对应的表情字符串
    ///
    /// - Returns: attMStr.string
    func getEmoticonString() -> String {
//        1.获取属性字符串
        let attrMStr = NSMutableAttributedString.init(attributedString: attributedText)
        
        
        
//        2.遍历属性字符串
        let range = NSRange.init(location: 0, length: attrMStr.length)
        
        
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range , _) in
            
            if let attachment = dict[NSAttributedStringKey.init("NSAttachment")] as? EmoticonAttachment{
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
            
            
//            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
//                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
//            }
        }
        
//        3.获取字符串
        return attrMStr.string
    }
    
    /// 给textView插入表情
    ///
    /// - Parameter emoticon: emoticon
    func insertEmoticon(emoticon : Emoticon) {
//        1.空白表情
        if emoticon.isEmpty {
            return
        }
        
//        2.删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
//        3.emoji表情
        if emoticon.emojiCode != nil {
//            3.1获取光标所在的位置:UITextRange
            let textRange = selectedTextRange!
            
            
//            3.2替换emoji表情
            replace(textRange, withText: emoticon.emojiCode!)
            
            return
    }
        
//            4.普通表情：图文混排
//            4.1根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        let font = self.font!
        attachment.image = UIImage.init(contentsOfFile: emoticon.pngPath!)
        attachment.bounds = CGRect.init(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString.init(attachment: attachment)
        
//            4.2创建可变的属性字符创
        let attMStr = NSMutableAttributedString.init(attributedString: attributedText)
        
//            4.3将图片属性字符串，替换到可变属性字符串的某一个位置
//            4.3.1获取光标所在的位置
        let range = selectedRange
        
//            4.3.2替换属性字符串
        attMStr.replaceCharacters(in: range, with: attrImageStr)
        
//            显示属性字符串
        attributedText = attMStr
        
//            将文字的大小重置
        self.font = font
        
//            将光标设置回原来的位置 +1
        selectedRange = NSRange.init(location: range.location + 1, length: 0)
}
}
