import UIKit

private let EmoticonCell = "EmoticonCell"

class EmoticonViewController: UIViewController {
    //    MARK:- 定义属性
    var emoticonCallBack : (_ emoticon : Emoticon) -> ()
    
    
    //    MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()
    
    //    MARK:- 自定义构造函数
    init(emoticonCallBack : @escaping (_ emoticon : Emoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //    MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
}

//    MARK:- 设置UI界面
extension EmoticonViewController {
    private func setupUI() {
//        1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.purple
        toolBar.backgroundColor = UIColor.darkGray
        
//        2.设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar, "cView" : collectionView]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
//        3.准备collectionView
        prepareForCollectionView()
        
//        4.准备toolBar
        prepareForToolBar()
        
    }
    
    private func prepareForCollectionView() {
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
//        1.定义toolBar中titles
        let titles = ["最近","默认","emoji","撕麦耳"]
        
//        2.遍历标题，创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(itemClick(item:)))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            
        }
        
//        3设置toolBar的items数组
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
        
    }
    
    @objc private func itemClick(item : UIBarButtonItem) {
//        1.获取点击的item的tag
        let tag = item.tag
        
//        2.根据tag获取到当前组
        let indexPath = IndexPath.init(item: 0, section: tag)
        
//        3.滚动到当前对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        
    }
}

//    MARK:- collectionView的DataSource和Delegate
extension EmoticonViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonViewCell
        
//        2.给cell设置数据
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.blue
        let package = manager.packages[indexPath.section]
        let emeticon = package.emoticons[indexPath.item]
       cell.emoticon = emeticon
        
        return cell
        
    }
    
//    代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        1.取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
//        2.将点击的表情插入最近分组
        insertRecentlyEmoticon(emoticon: emoticon)
        
//        3.将表情回调给外界控制器
        emoticonCallBack(emoticon)
        
        
    }
    
    private func insertRecentlyEmoticon(emoticon : Emoticon) {
//        1.如果是空白表情或者删除按钮不需要插入
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        
//        2.删除一个表情
        if manager.packages.first!.emoticons.contains(emoticon) {
            let index = (manager.packages.first?.emoticons.index(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
            
        }else {
            manager.packages.first?.emoticons.remove(at: 16)
        }
        
//        3.将emoticon插入最近分组
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
        
    }
}

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        
//        1.计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
//        2.设置layout的属性
        itemSize = CGSize.init(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
//        3.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insertMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets.init(top: insertMargin, left: 0, bottom: insertMargin, right: 0)
        
        
    }
}
