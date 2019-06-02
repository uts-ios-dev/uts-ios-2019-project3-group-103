import UIKit

class MainViewController: UITabBarController {
    
    //    MARK:- 懒加载属性
    private lazy var imageNames = ["tabbar_home_highlighted","tabbar_message_center_highlighted","","tabbar_discover_highlighted","tabbar_profile_highlighted"]
    
//    1.类方法
//    private lazy var composeBtn : UIButton = UIButton.creatButtonOne(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
//    2.构造函数方法
    private lazy var composeBtn : UIButton = UIButton.init(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        1.通过字符串添加控制器
//        addChildVcOne()
        
//        2.通过JSON添加控制器
//        addChildVcTwo()
        
        setupComposeButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTabbarItems()
    }
}


//    MARK:- 代码方式创建items
extension MainViewController {
    
    
    /// swift支持方法重载-法的重载：方法名称相同，但是参数不同：1.参数的类型不同 2.参数的个数不同-private 在当前文件中可以访问，其他文件不能访问
    ///
    /// - Parameters:
    ///   - childVCName: 控制器名称
    ///   - title: 控制器标题
    ///   - imageName: 控制器image
    private func addChildViewController(childVCName : String, title : String, imageName : String) {
        
        //        0.获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            SiMaiEr_Log(message: "没有获取到命名空间")
            return
        }
        
        //        1.根据字符串获取对应的Class
        guard let childVcClass = NSClassFromString(nameSpace + "." + childVCName) else {
            SiMaiEr_Log(message: "没有获取到字符串对应的Class")
            return
        }
        
        //        2.将对应的AnyObject转成控制器的类型
        guard let childType = childVcClass as? UIViewController.Type else {
            SiMaiEr_Log(message: "没有获取到对应控制器的类型")
            return
        }
        
        //        3.创建对应控制器对象
        let childVC = childType.init()
        
        //        4.设置自控制器的属性
        childVC.title = title
        childVC.tabBarItem.image = UIImage.init(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage.init(named: imageName + "_highlighted")
        
        //        5.包装导航栏控制器
        let childNav = UINavigationController.init(rootViewController: childVC)
        
        //        6.添加控制器
        addChildViewController(childNav)
        
    }
    
    
    /// 通过字符串方法动态添加控制器
    private func addChildVcOne() {
        addChildViewController(childVCName: "HomeViewController", title: "首页", imageName: "tabbar_home")
        addChildViewController(childVCName: "MessageViewController", title: "消息", imageName: "tabbar_message_center")
        addChildViewController(childVCName: "DiscoverViewController", title: "发现", imageName: "tabbar_discover")
        addChildViewController(childVCName: "ProfileViewController", title: "我", imageName: "tabbar_profile")
    }
    
    
    /// 通过JSON方法动态添加控制器
    private func addChildVcTwo() {
        //        1.获取json文件路径
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            SiMaiEr_Log(message: "没有获取到对应的文件路径")
            return
        }
        
        //        2.读取json文件中的内容
        guard let jsonData = NSData.init(contentsOfFile: jsonPath) else {
            SiMaiEr_Log(message: "没有获取到json文件中数据")
            return
        }
        
        //        3.将Data转成数组
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else {
            return
        }
        
        guard let dictArray = anyObject as? [[String : AnyObject]] else {
            return
        }
        
        //        4.遍历字典，获取对应的信息
        for dict in dictArray {
            SiMaiEr_Log(message: dict)
            
            //            4.1获取控制器对应的字符串
            guard let vcName = dict["vcName"] as? String else {
                continue
            }
            
            //            4.2获取控制器显示的title
            guard let title = dict["title"] as? String else {
                continue
            }
            
            //            4.3获取控制器显示的图标名称
            guard let imageName = dict["imageName"] as? String else {
                continue
            }
            
            //            4.4添加子控制器
            addChildViewController(childVCName: vcName, title: title, imageName: imageName)
        }
    }
    
}

//    MARK:- 设置UI界面
extension MainViewController {
    
    /// 设置发布按钮
    private func setupComposeButton() {
//        1.将composeBtn添加到tabbar中
        tabBar.addSubview(composeBtn)
        
//        2.设置属性
//        composeBtn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: .normal)
//        composeBtn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), for: .highlighted)
//        composeBtn.setImage(UIImage.init(named: "tabbar_compose_icon_add"), for: .normal)
//        composeBtn.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
//        composeBtn.sizeToFit()
        
//        3.设置位置
        composeBtn.center = CGPoint.init(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
//        4.监听发布按钮的点击
//        swift中selector有2中写法 1：selector("composeBtnClick") 2:"composeBtnClick"
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
        
    }
    
    
    /// 设置tabbar中的items
    private func setupTabbarItems() {
//        1.遍历所有的item
        for i in 0..<tabBar.items!.count {
            
//            2.获取item
            let item = tabBar.items![i]
            
//            3.如果下标值为2，则item不可以和用户交互
            if i == 2 {
                item.isEnabled = false
                continue
            }
            
//            4.设置其他item的选中时候的图片
            
            item.selectedImage = UIImage.init(named: imageNames[i] )
    }
}
    
}

//    MARK:- 事件监听
extension MainViewController {
 @objc private func composeBtnClick() {
//    1.创建发布控制器
    let composeVC = ComposeViewController()
    
//    2.创建导航控制器
    let composeNav = UINavigationController.init(rootViewController: composeVC)
    
//    3.弹出控制器
    present(composeNav, animated: true, completion: nil)
    
    
    }
}

