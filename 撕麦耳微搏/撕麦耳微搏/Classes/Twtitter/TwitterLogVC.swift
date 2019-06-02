import UIKit

class TwitterLogVC: UIViewController {
    
    //    MARK: - 控件属性
    @IBOutlet weak var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        loadPage()
    }

}

extension TwitterLogVC {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Fill", style: .plain, target: self, action: #selector(fillItemClick))
        
        title = "登录界面"
    }
    
    private func loadPage() {
        let urlString = "https://mobile.twitter.com/home"
        
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        let request = URLRequest.init(url: url)
        
        webView.loadRequest(request)
    }
    
    @objc private func closeItemClick() {
        SiMaiEr_Log(message: "用户点击了关闭按钮，取消了登录")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        SiMaiEr_Log(message: "用户点击了d填充按钮")
        
        let jsCode = "document.getElementById('username').value = '450851460@qq.com';document.getElementById('password').value='SiMaiEr1231';"
        
        webView.stringByEvaluatingJavaScript(from: jsCode)
        
        
        
        
    }
}
