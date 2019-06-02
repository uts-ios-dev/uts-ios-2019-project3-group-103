import UIKit

class BaseVC: UIViewController {
    
    //    MARK: - 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    override func loadView() {
        setupVisitorView()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }

}

extension BaseVC {
    private func setupVisitorView() {
        view = visitorView
        
        visitorView.registerBtn.addTarget(self, action: #selector(BaseVC.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseVC.loginBtnClick), for: .touchUpInside)
    }
    
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Register", style: .plain, target: self, action: #selector(BaseVC.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Login", style: .plain, target: self, action: #selector(BaseVC.loginBtnClick))
    }
}

extension BaseVC {
    @objc private func registerBtnClick() {
        SiMaiEr_Log(message: "点击了注册按钮")
    }
    
    @objc private func loginBtnClick() {
        let loginVC = TwitterLogVC.init()
        
        let loginNav = UINavigationController.init(rootViewController: loginVC)
        
        present(loginNav, animated: true, completion: nil)
        
        
    }
}
