import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    //    MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedview: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourcelabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picCollectionView: picCollectionView!
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var bottomTooView: UIView!
    
    
    //    MARK:- 约束属性
    @IBOutlet weak var contentLabelWidthCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    //    MARK:- 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
//            1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
//            2.设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage.init(named: "avatar_default_small"), options: [], completed: nil)
            
//            3.设置认证图标
            verifiedview.image = viewModel.verifiedImage
            
//            4.设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            
//            5.设置会员
            vipView.image = viewModel.vipImage
            
//            6.设置时间Label
            timeLabel.text = viewModel.createAtText
            
//            7.设置微博正文
            contentLabel.text = viewModel.status?.text
            
//            8.设置来源
            if let sourceText = viewModel.sourceText {
                sourcelabel.text = "来自 " + sourceText
            }else {
                sourcelabel.text = nil
            }
            
//            9.设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
//            10.计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(count: viewModel.picUrls.count)
            picViewWidthCons.constant = picViewSize.width
            picViewHeightCons.constant = picViewSize.height
            
//            11.将picURL数据传递给picView
            picCollectionView.picUrls = viewModel.picUrls
            
//            12.设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
//                1.设置转发微博的正文
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,
                    let retweetedText = viewModel.status?.retweeted_status?.text {
                    retweetedContentLabel.text = "@" + "\(screenName): " + retweetedText
                    
//                    设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 15
                }
//                2.设置背景显示
                retweetedBgView.isHidden = false
            }else {
//                1.设置转发微博的正文
                retweetedContentLabel.text = nil
                
//                2.设置背景显示
                retweetedBgView.isHidden = true
                
//                设置没有转发正文微博距离顶部的约束
                retweetedContentLabelTopCons.constant = 0
            }
            
//            13.计算cell的高度
            if viewModel.cellHeight == 0 {
//            14.1强制布局
                layoutIfNeeded()
//            15.2获取底部工具栏的最大Y值
                viewModel.cellHeight = bottomTooView.frame.maxY
            }
        }
    }
    
    //    MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        设置微博正文的宽度约束
        contentLabelWidthCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        

        
    }
}

//    MARK:- 计算方法
extension HomeViewCell {
    private func calculatePicViewSize(count : Int) -> CGSize {
//        1.没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        
//        有配图需要修改约束值
        picViewBottomCons.constant = 10
        
//        2.取出picCollectionView对应的layout
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
       
        
//        3.单张配图
        if count == 1 {
//            1.取出图片
            let urlString = viewModel?.picUrls.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString)

            if image != nil {
//            2.设置一张图片是layout的itemSize
                layout.itemSize = CGSize.init(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
                return CGSize.init(width: ((image?.size.width)! * 2), height: ((image?.size.height)! * 2))
            }
            
        }
        
//        4.计算imageView.width-height
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
//        5.设置其他张图片是layout的itemSize
        layout.itemSize = CGSize.init(width: imageViewWH, height: imageViewWH)
        
//        6.四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize.init(width: picViewWH, height: picViewWH)
        }
        
//        7.其他张配图
//        7.1计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
//        7.2计算picView的height
        let picViewHeight = rows * imageViewWH + (rows - 1) * itemMargin
        
//        7.3计算picView的width
        let picViewWidth = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize.init(width: picViewWidth, height: picViewHeight)
    }
}
