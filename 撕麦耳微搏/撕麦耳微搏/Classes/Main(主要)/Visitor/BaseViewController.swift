import UIKit

class BaseViewController: UITableViewController {
    
    //    MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    //    MARK:- 定义变量
    var isLogin : Bool = UserAccountViewModel.shareIntance.isLogin
    
    //    MARK:- 系统回调函数
    override func loadView() {
        
//        判断要加载哪一个View
        isLogin ? super.loadView() : setupVisitorView()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()

    }
}

//    MARK:- 设置UI界面


// MARK: - 设置访客视图
extension BaseViewController {
    private func setupVisitorView() {
        view = visitorView
        
//        监听访客视图中注册和登录按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
        
    }
    
    /// 设置导航栏左右的Item
    private func setupNavigationItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Register", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Login", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
}

//    MARK:- 事件监听
extension BaseViewController {
    @objc private func registerBtnClick() {
        SiMaiEr_Log(message: "用户点击了注册按钮")
    }
    
    @objc private func loginBtnClick() {
        SiMaiEr_Log(message: "用户点击了登录按钮")
        
//        1.创建授权控制器
        let oauthVC = OAuthViewController()
        
//        2.包装导航栏控制器
        let oauthNav = UINavigationController.init(rootViewController: oauthVC)
        
//        3.弹出控制器
        present(oauthNav, animated: true, completion: nil)
        
    }
}
