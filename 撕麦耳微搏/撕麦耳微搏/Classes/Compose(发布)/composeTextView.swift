import UIKit
import SnapKit

class composeTextView: UITextView {
    //    MARK:- 懒加载属性
     lazy var placeHolderLabel : UILabel = UILabel()
    //    MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
}


//    MARK:- 设置UI界面
extension composeTextView {
    private func setupUI() {
//        1.添加子控件
        addSubview(placeHolderLabel)
        
//        2.设置frame
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
//        3.设置PlaceHolderLabel的属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        
//        4.设置placeHolderLabel的文字
        placeHolderLabel.text = "Say something..."
        
//        5.设置内容的内边距
        textContainerInset = UIEdgeInsets.init(top: 6, left: 7, bottom: 0, right: 7)
        
    }
}
