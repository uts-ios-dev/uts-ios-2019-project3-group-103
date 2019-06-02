import UIKit

class PopoverAnimator: NSObject {
    
    //    MARK:- 对外暴露的属性
    var isPresented : Bool = false
    var presentedFrame : CGRect = CGRect.zero
    
    var callBack : ((_ presented : Bool) -> ())?
    
    //    MARK:- 自定义构造函数
//    注意：如果自定义了一个构造函数，但是没有对默认构造韩式init()进行重写，那么自定义的构造函数会覆盖默认的init()构造函数
    init(callBack :  @escaping (_ presented : Bool) -> ()) {
        self.callBack = callBack
    }
    
 
    

}

//    MARK:- 自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    //    1.改变弹出view的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = SiMaiErPresentationController.init(presentedViewController: presented, presenting: presented)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    //    2.自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    //    3.自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        
        return self
    }
}

//    MARK:- 弹出和消失动画的代理方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    //    动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    //    获取转场上下文：可以通过转场上下文获取弹出的view的和消失的view
    //    UITransitionContextFromViewKey : 获取消失的view
    //    UITransitionContextToViewKey ：获取弹出的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissedView(using: transitionContext)
    }
    
    /// 自定义弹出动画
    private func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        //        1.获取弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        //        2.将弹出的view添加到containView中
        transitionContext.containerView.addSubview(presentedView!)
        
        //        3.执行动画
        presentedView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        presentedView?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView?.transform = CGAffineTransform.identity
        }) { (_) in
            //            必须告诉转场上下文已经完成了动画
            transitionContext.completeTransition(true)
        }
    }
    
    /// 自定义消失动画
    private func animationForDismissedView(using transitionContext: UIViewControllerContextTransitioning) {
        //        1.获取消失的view
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        //        2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.00001)
        }) { (_) in
            dismissView?.removeFromSuperview()
            //         3.必须告诉转场上下文已经完成动画
            transitionContext.completeTransition(true)
        }
        
    }
    
}

