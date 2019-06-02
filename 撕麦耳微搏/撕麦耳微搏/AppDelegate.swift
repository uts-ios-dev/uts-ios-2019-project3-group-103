import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var defaultViewController : UIViewController? {
        let isLogin = UserAccountViewModel.shareIntance.isLogin
        return isLogin ? WelecomeViewController() : UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        
//        创建window(通过代码进入)
//        window = UIWindow.init(frame: UIScreen.main.bounds)
//        window?.rootViewController = MainViewController()
//        window?.makeKeyAndVisible()
        
//        设置启动图片延迟效果
        Thread.sleep(forTimeInterval: 1.5)
        
//        创建window
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        SiMaiEr_Log(message: UserAccountViewModel.shareIntance.account?.access_token)
        return true
    }

}

func SiMaiEr_Log<T>(message : T ,file : String = #file,funcName : String = #function, lineNum : Int = #line ) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):[\(funcName)]((\(lineNum))-\(message)")
    #endif
}
