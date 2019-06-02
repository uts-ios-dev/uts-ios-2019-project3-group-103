import UIKit

class EmoticonViewCell: UICollectionViewCell {
    //    MARK:- 懒加载属性
    private lazy var emoticonBtn : UIButton = UIButton()
    
    //    MARK:- 定义的属性
    var emoticon : Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            
//            1.设置emoticonBtn的内容
            emoticonBtn.setImage(UIImage.init(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
//            2.设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    //    MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//    MARK:- 设置UI界面的内容
extension EmoticonViewCell {
    private func setupUI() {
//        1.添加子控件
        contentView.addSubview(emoticonBtn)
        
//        2.设置btn的frame
        emoticonBtn.frame = contentView.bounds
        
//        3.设置btn的属性
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
    }
}
