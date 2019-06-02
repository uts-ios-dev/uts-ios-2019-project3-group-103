import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    //    MARK:- 控件属性

    @IBOutlet weak var webview: UIWebView!
    
    
//    MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

//        1.设置导航栏的内容
        setupNavigationBar()
        
//        2.加载网页
        loadPage()
        
    }
}

//    MARK:- 设置UI界面相关
extension OAuthViewController {
    private func setupNavigationBar() {
//        1.设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Close", style: .plain, target: self, action: #selector(closeItemClick))
        
//        2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Fill", style: .plain, target: self, action: #selector(fillItemClick))
        
//        3.设置标题
        title = "登录界面"
        
    }
    
    private func loadPage() {
//        1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        SiMaiEr_Log(message: urlString)
        
//        2.创建对应的NSURL
        guard let url = URL.init(string: urlString) else {
            return
        }
        
//        3.创建URLREquest
        let request = URLRequest(url:url)
        
//        4.加载request对象
        webview.loadRequest(request)
    }
    
}


//    MARK:- 事件监听
extension OAuthViewController {
    @objc private func closeItemClick() {
        SiMaiEr_Log(message: "用户点击了关闭按钮，取消了登录")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        SiMaiEr_Log(message: "用户点击了填充按钮")
        
//        1.书写js代码：javascript
        let jsCode = "document.getElementById('userId').value = '450851460@qq.com';document.getElementById('passwd').value='SiMaiEr1231';"
        
        
//        2.执行js代码
        webview.stringByEvaluatingJavaScript(from: jsCode)
    
    }
}

//    MARK:- webView的delegate方法
extension OAuthViewController : UIWebViewDelegate {
//    webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
//    webView加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
//    webView加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
//    当准备加载某一个页面时，会执行该方法
//    返回值 --> true继续加载该页面  false不会加载该页面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

//        1.获取加载网页的URL
        guard let url = request.url else {
            return true
        }

//        2.获取url中的字符串
        let urlString = url.absoluteString

//        3.判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }

//        4.将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        SiMaiEr_Log(message: urlString)
        SiMaiEr_Log(message: code)

//        5.请求accessToken
        loadAccessToken(code: code )
        
        return false
    }

}

//    MARK:- 请求数据
extension OAuthViewController {
    
    /// 请求AccessToken
    ///
    /// - Parameter code:
    private func loadAccessToken(code : String) {
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error)->() in
//            1.错误校验
            if error != nil {
                SiMaiEr_Log(message: error)
                return
            }
//            2.拿到结果
            guard let accountDict  = result else {
                SiMaiEr_Log(message: "没有获取授权后的数据")
                SiMaiEr_Log(message: result)
                return
            }
//            3.将字典转成模型
            let account = UserAccount(dict: accountDict)
            SiMaiEr_Log(message: account)
            SiMaiEr_Log(message: accountDict)
            
            self.loadUserInfo(account: account)
            
    }
    }

    
    /// 请求用户信息
    ///
    /// - Parameter account: UserAccount
    private func loadUserInfo(account : UserAccount) {
//        1.获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
//        2.获取uid
        guard let uid = account.uid else {
            return
        }
//        3.发送网络请求
        NetworkTools.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) { (result, error) in
//            1.错误校验
            if error != nil {
                SiMaiEr_Log(message: error)
                return
            }
//            2.拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
//            3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
//           4.将account对象保存
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareIntance.accountPath)
            
//            5.将account对象设置到单例对象中
            UserAccountViewModel.shareIntance.account = account
            
//            6.退出当前控制器
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelecomeViewController()
            })
            
            }
        }
        }


