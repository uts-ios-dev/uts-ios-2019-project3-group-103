import UIKit

extension UIButton {
//    swift中类方法是以class开头的方法，类似于oc中+开头的方法
    class func creatButtonOne(imageName : String, bgImageName : String) -> UIButton {
        
//        1.创建Button
        let btn = UIButton()
        
//        2.设置button的属性
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: bgImageName + "highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        return btn
        
    }
    
//    convenience : 便利，使用convenience修饰的构造函数叫做便利构造函数
//    遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
//    1.遍历构造函数通常都是写在extension里面 2.遍历构造函数init前面需要加载convenience 3.在遍历构造函数中需要明确的调用self.init()
    convenience init (imageName : String, bgImageName : String) {
       self.init()
        setImage(UIImage.init(named: imageName), for: .normal)
        setImage(UIImage.init(named: imageName + "highlighted"), for: .highlighted)
        setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage.init(named: bgImageName + "highlighted"), for: .highlighted)
        sizeToFit()
    }
    
}
