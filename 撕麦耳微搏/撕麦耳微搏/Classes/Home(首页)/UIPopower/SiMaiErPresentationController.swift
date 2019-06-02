import UIKit

class SiMaiErPresentationController: UIPresentationController {
    
    //    MARK:- 对外提供的属性
    var presentedFrame : CGRect = CGRect.zero
    
    
    //    MARK:- 懒加载属性
    private lazy var coverView : UIView = UIView()

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
//        1.设置弹出view的frame
        presentedView?.frame = presentedFrame
        
//        2.添加蒙版
        setupCoverView()
    }
}

//    MARK:- 设置UI界面相关
extension SiMaiErPresentationController {
    private func setupCoverView() {
//        1.添加源码
        containerView?.insertSubview(coverView, at: 0)
        
//        2.设置蒙版的属性
        coverView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.2)
        coverView.frame = (containerView?.bounds)!
        
//        3.添加手势
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(SiMaiErPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
        
    }
}

//    MARK:- 事件监听
extension SiMaiErPresentationController {
    @objc private func coverViewClick() {
        
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
