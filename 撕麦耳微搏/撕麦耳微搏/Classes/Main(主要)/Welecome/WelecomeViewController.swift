import UIKit
import SDWebImage

class WelecomeViewController: UIViewController {
    
    //    MARK:- 拖线属性
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        0.设置头像
        let profileUrl = UserAccountViewModel.shareIntance.account?.avatar_large
//        ?? : 如果??前面的可选类型有值，那么将前面的可选类型进行解包并且赋值
//        如果??前面的可选类型为nil，那么直接使用??后面的值
        let url = URL.init(string: profileUrl ?? "")
        iconImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "avatar_default_big"), options: [], completed: nil)
        
//        1.改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 300
        
//        2.执行动画
//        Damping:阻力系数，阻力系数越大，弹动的效果越不明显 0_1
//        initialSpringVelocity：初始化速度
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }


    }
}
