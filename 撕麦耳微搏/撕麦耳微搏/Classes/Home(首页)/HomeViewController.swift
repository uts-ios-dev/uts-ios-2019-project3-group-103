import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController  {
    //    MARK:- 懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
//    在闭包中如果使用当前对象的属性或者调用方法，也需要加self
//    两个地方需要使用self：1.如果在一个函数中出现歧义 2.在闭包中使用当前对象的属性和方法也需要加self
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator  { [weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    
    private lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    private lazy var tipLabel : UILabel = UILabel()
    
//    MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       1.没有登录设置的内容
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
        
//        2.设置导航栏的内容
        setupNavgationBar()
        
        
//        3.设置估算高度
        tableView.estimatedRowHeight = 200
        
//        4.布局headder
        setupHeaderView()
        setupFooterView()
        
//        5.设置提示的Label
        setupTipLabel()
    }
}


//    MARK:- 设置UI界面
extension HomeViewController {
    private func setupNavgationBar() {
//    1.设置左侧的Item
//        let leftBtn = UIButton()
//        leftBtn.setImage(UIImage.init(named: "navigationbar_friendattention"), for: .normal)
//        leftBtn.setImage(UIImage.init(named: "navigationbar_friendattention_highlighted"), for: .highlighted)
//        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention")
    
//    2.设置右侧的Item
//        let rightBtn = UIButton()
//        rightBtn.setImage(UIImage.init(named: "navigationbar_pop"), for: .normal)
//        rightBtn.setImage(UIImage.init(named: "navigationbar_pop_highlighted"), for: .highlighted)
//        rightBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")
        
    
//    3.设置titleView
        titleBtn.setTitle("Yuki", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    private func setupHeaderView() {
//        1.创建headerView
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNewStatuses))
        
//        2.设置header的属性
        header?.setTitle("Drop to refresh", for: .idle)
        header?.setTitle("Refresh", for: .pulling)
        header?.setTitle("Loading", for: .refreshing)
        
//        3.设置tableview的header
        tableView.mj_header = header
        
//        4.进入刷新状态
        tableView.mj_header.beginRefreshing()
        
    }
    
    private func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }

    private func setupTipLabel() {
//        1.将TipLabel添加到父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
//        2.设置TipLabel的frame
        tipLabel.frame = CGRect.init(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
//        3.设置TipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
//
    }

}

//    MARK:- 事件监听的函数
extension HomeViewController {
    @objc private func titleBtnClick(titleBtn : TitleButton) {
//        1.改变按钮的状态
        titleBtn.isSelected = !titleBtn.isSelected
        
//        2.创建弹出的控制器
        let viewC = PopowerViewController()
        
//        3.设置控制器的modal弹出样式
        viewC.modalPresentationStyle = .custom
        
//        4.设置转场的代理
        viewC.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect.init(x: 100, y: 75, width: 180, height: 250)
        
        
//        5.弹出控制器
        present(viewC, animated: true, completion: nil)
        
    }
}

//    MARK:- 请求数据
extension HomeViewController {
//    加载最新的数据
    @objc private func loadNewStatuses() {
        loadStatuses(isNewData: true)
    }
//    加载更多数据
    @objc private func loadMoreStatuses() {
        loadStatuses(isNewData: false)
    }
    
    
    
    private func loadStatuses(isNewData : Bool) {
//        1.获取since_id / max_id
        var since_id = 0
        var max_id = 0
        
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        
//        请求数据
        NetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
//            1.错误校验
            if error != nil {
                return
            }
//            2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
//            3.遍历微博对应的字典
            var tempViewModel = [StatusViewModel]()
            for statusesDict in resultArray {
                let statuses  = Statuses.init(dict: statusesDict)
                let viewmodel = StatusViewModel(status: statuses)
                tempViewModel.append(viewmodel)
        }
//            4.将数据放入到成员变量的数组中
            if isNewData {
                self.viewModels = tempViewModel + self.viewModels
            }else {
                self.viewModels += tempViewModel
            }
            
//            5.缓存图片
            self.cacheImages(viewModels: tempViewModel)
        }
    }
    private func cacheImages(viewModels : [StatusViewModel]) {
//        0.创建group
        let group = DispatchGroup()
        
//        1.缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picUrls {
                group.enter()
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                    group.leave()
                })
            }
        }
//        2.刷新表格
        group.notify(queue: DispatchQueue.main) {
//            刷新表格
            self.tableView.reloadData()
            
//            停止刷新
            self.tableView.mj_header.endRefreshing()
            SiMaiEr_Log(message: "刷新表格")
            self.tableView.mj_footer.endRefreshing()
            SiMaiEr_Log(message: "继续下拉")
            
//            显示提示的Label
            self.showTipLabel(count: viewModels.count)
        }
    }
    
//    显示提示的Label
    private func showTipLabel(count : Int) {
//        1.设置TipLabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count) 条微博"
        
//        2.执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

//    MARK:- tableView的数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        
//        2.给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        1.获取模型对象
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
        
    }
}

