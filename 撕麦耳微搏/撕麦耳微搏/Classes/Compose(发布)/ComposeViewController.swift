import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    //    MARK:- 控件属性
    @IBOutlet weak var textView: composeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    
    
//    MARK:- 懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    private lazy var images : [UIImage] = [UIImage]()
    private lazy var emoticonVC : EmoticonViewController = EmoticonViewController { [weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
    
    //    MARK:- 约束的属性
    @IBOutlet weak var toobarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeightCons: NSLayoutConstraint!
    
    
    //    MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

//        1.设置导航栏
        setupNavigationBar()
        
//        2.监听通知
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

//    MARK:- 设置UI界面
extension ComposeViewController {
    private func setupNavigationBar() {
//        1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Submit", style: .plain, target: self, action: #selector(sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
//        2.设置标题
        titleView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 0)
        navigationItem.titleView = titleView
    
    }
    
    private func setupNotifications() {
//        监听键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
//        监听添加照片的按钮点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
//        监听删除照片的按钮点击
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick(note:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}

//    MARK:- 事件监听函数
extension ComposeViewController {
    @objc private func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendItemClick() {
//        0.键盘退出
        textView.resignFirstResponder()
        
//        1.获取发送微博的微博正文
        let statusText = textView.getEmoticonString()
        
//        2.定义回调的闭包
        let finishedCallBack = {(isSuccess : Bool) -> () in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: nil)
        }
    
//        3.获取用户选中的图片
        if let image = images.first {
            NetworkTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishedCallBack)
        }else {
            NetworkTools.shareInstance.sendStatus(statusText: statusText, isSuccess: finishedCallBack)
        }
    }
    
    @objc private func keyboardWillChangeFrame(note : Notification) {
//        1.获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
//        2.获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
//        3.计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        
//        4.执行动画
        toobarBottomCons.constant = margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick() {
//        退出键盘
        textView.resignFirstResponder()
        
//        执行动画
        picPickerViewHeightCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }

    @IBAction func emojiconBtn() {
//        1.退出键盘
        textView.resignFirstResponder()
        
//        2.切换键盘
        textView.inputView = textView.inputView != nil ? nil : emoticonVC.view
        
//        3.弹出键盘
        textView.becomeFirstResponder()
    }
}

//    MARK:- 添加照片和删除照片的时间监听函数
extension ComposeViewController {
    @objc private func addPhotoClick() {
//        1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
//        2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
//        3.设置照片源
        ipc.sourceType = .photoLibrary
        
//        4.设置代理
        ipc.delegate = self
        
//        弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
        
    }
    
    @objc private func removePhotoClick(note : Notification) {
//        1.获取image对象
        guard let image = note.object as? UIImage else {
            return
        }
        
//        2.获取image对象所在下标值
        guard let index = images.index(of: image) else {
            return
        }
        
//        3.将图片从数组中删除
        images.remove(at: index)
        
//        4.重写赋值collectionView新的数组
        picPickerView.images = images
    }
    
    
}

//    MARK:- UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        1.获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
//        2.将选中的照片添加到数组中
        images.append(image)
        
//        3.将数组赋值给collectionView，让collectionView自己去展示数据
        picPickerView.images = images
        
//        4.退出选中照片控制器
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
}

//    MARK:- uiTextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
