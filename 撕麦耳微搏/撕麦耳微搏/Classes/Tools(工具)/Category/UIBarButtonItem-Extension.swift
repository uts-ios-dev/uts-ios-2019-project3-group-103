import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName : String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
        
//        let btn = UIButton()
//        btn.setImage(UIImage.init(named: imageName), for: .normal)
//        btn.setImage(UIImage.init(named: imageName + "highlighted"), for: .highlighted)
//        btn.sizeToFit()
//        self.init(customView : btn)
        
    }
}
