import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {
    //    MARK:- 定义属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
//    MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        
        
//        设置collectionView的属性
        register(UINib.init(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
//        设置collectionView的内边距
        contentInset = UIEdgeInsets.init(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }

}

extension PicPickerCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        1.创建Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        
//        2.给cell设置数据
        cell.backgroundColor = UIColor.red
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
        
    }
    
    
}
