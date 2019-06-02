import UIKit

class VisitorView: UIView {

   //    MARK:- 提供快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
    
    //    MARK:- 控价的属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //    MARK:- 自定义函数
    func setupVisitorViewInfo(iconName : String, title : String) {
        iconView.image = UIImage.init(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    //    MARK:- 添加旋转动画
    func addRotationAnimation() {
//        1.创建动画
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        
//        2.设置动画属性
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = 5
        rotationAnimation.isRemovedOnCompletion = false
        
//        3.将动画添加到layer中
        rotationView.layer.add(rotationAnimation, forKey: nil)
    }
    
}
