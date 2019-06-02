import UIKit

class picCollectionView: UICollectionView {
    //    MARK:- 定义属性
    var picUrls : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
    }

}

//    MARK:- collectionView的数据源方法
extension picCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! picCollectionViewCell
        
//        2.给cell设置数据
        cell.picURL = picUrls[indexPath.item]
        return cell
        
    }
}

class picCollectionViewCell: UICollectionViewCell {
    //    MARK:- 定义模型属性
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage.init(named: "emty_picture"), options: [], completed: nil)
        }
    }
    
    
    
    //    MARK:- 控件的属性
    @IBOutlet weak var iconView: UIImageView!
    
}
